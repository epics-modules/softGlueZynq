/* drvZynq.cc

    Original Author: Marty Smith (as drvIp1k125.c)
    Modified: Tim Mooney (as drvIP_EP201.c)
	Modified: Tim Mooney for use on Xilinx Zynq 


    This is the driver for softGlue on Xilinx Zynq.

	This driver cooperates with specific FPGA firmware loaded into the zynq IP.
	The loaded FPGA firmware includes an AXI4 Lite peripheral, which makes
	registers implemented in the PL look like memory locations. Additional
	firmware connects those registers with custom components, such as AND gates,
	flip flops, etc.

<<begin not done yet
        1) fieldIO_registerSet component

           A set of seven 16-bit registers defined by 'fieldIO_registerSet'
           below.  This register set provides bit-level I/O direction and
           interrupt-generation support, and is intended primarily to
           implement field I/O registers.
<<end not done yet

        2) single 8-bit register component

		   a single 8-bit register, which has no interrupt service or bit-level
		   I/O direction.  This is just a plain 8-bit or 32-bit register, which
		   can be written to or read.  This driver doesn't know or care what the
		   register might be connected to inside the FPGA.

<<begin not done yet
   Each fieldIO_registerSet component must be initialized by a separate call to
    initIP_EP201(), because the component's sopc address must be specified at
    init time, so that the interrupt-service routine associated with the
    component can use the sopc address.  Currently, each call to initIP_EP201()
    defines a new asyn port, connects an interrupt-service routine, creates a
    message queue, and launches a thread.
<<end not done yet

	Single 8-bit register components need not have their addresses known at init
	time, because they are not associated with an interrupt service routine.  As
	a consequence, many such single-register components can be served by a
	single asyn port.  Users of this port must indicate the  register they want
	to read or write in their asynUser structure. Records do this by including
	the address in the definition of the record's OUT or INP field.  For
	example, the ADDR macro in the following field definition should be set to
	indicate (via syntax that has yet to be determined) the register's address:
	field(OUT,"@asynMask($(PORT),$(ADDR),0x2f)")

*/



/* System includes */
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>

#include	<stddef.h>
#include	<stdio.h>
#include	<sys/types.h>

#include	<unistd.h>
#include	<sys/mman.h>
#include	<fcntl.h>
#include	<sys/stat.h>

#ifdef vxWorks
extern int logMsg(char *fmt, ...);
#endif

/* EPICS includes */
#include <errlog.h>
#include <ellLib.h>
#include <devLib.h>
#include <cantProceed.h>
#include <epicsTypes.h>
#include <epicsThread.h>
#include <epicsMutex.h>
#include <epicsString.h>
#include <epicsExit.h>
#include <epicsMessageQueue.h>
#include <iocsh.h>
#include <asynDriver.h>
#include <asynDrvUser.h> /* used for setting interrupt enable to rising, falling, or both */
#include <asynUInt32Digital.h>
#include <asynInt32.h>
#include <epicsInterrupt.h>
#include <epicsExport.h>
#include "drvZynq.h"

#define STATIC static
/* #define STATIC */

volatile int drvZynqDebug = 0;
epicsExportAddress(int, drvZynqDebug);

#define MAX_MESSAGES 1000
#define MAX_PORTS 10
#define MAX_IRQ 5	/* max number of outstanding interrupt requests */


#define COMPONENTTYPE_FIELD_IO 0
#define COMPONENTTYPE_BARE_REG 1

/* drvParams */
#define INTERRUPT_EDGE			1	/* drvParam INTEDGE */
#define POLL_TIME				2	/* drvParam POLLTIME */
#define INTERRUPT_EDGE_RESET	3	/* drvParam INT_EDGE_RESET */
#define REG32					4	/* drvParam REG32 */

typedef struct {
    epicsUInt16 controlRegister;    /* control register            */
    epicsUInt16 writeDataRegister;  /* 16-bit data write/read      */
    epicsUInt16 readDataRegister;   /* Input Data Read register    */
    epicsUInt16 risingIntStatus;    /* Rising Int Status Register  */
    epicsUInt16 risingIntEnable;    /* Rising Int Enable Reg       */
    epicsUInt16 fallingIntStatus;   /* Falling Int Status Register */
    epicsUInt16 fallingIntEnable;   /* Falling Int Enable Register */
} fieldIO_registerSet;


typedef struct {
    epicsUInt16 bits;
    epicsUInt16 interruptMask;
} interruptMessage;

typedef struct {
	volatile epicsUInt32 *mem;	/* AXI mapped address */
	int AXI_Address;
	int is_fieldIO_registerSet;
    unsigned char manufacturer;
    unsigned char model;
    char *portName;
    asynUser *pasynUser;
    epicsUInt32 oldBits;
    epicsUInt32 risingMask;
    epicsUInt32 fallingMask;
    volatile fieldIO_registerSet *regs;
    double pollTime;
    epicsMessageQueueId msgQId;
    int messagesSent;
    int messagesFailed;
    asynInterface common;
	asynInterface asynDrvUser;
    asynInterface uint32D;
    asynInterface int32;
    void *interruptPvt;
    int intVector;
	epicsUInt32 interruptCount;
    epicsUInt16 disabledIntMask;    /* int enable rescinded because too many interrupts received */
} drvZynqPvt;

/*
 * Pointers to up to 12 drvZynqPvt structures -- enough for four copies of softGlue.
 * This is needed to break up init into three function calls, all of which specify carrier and slot.
 * From carrier and slot, we can get the three drvZynqPvt pointers associated with an IP_EP200 module.
 */
#define MAX_DRVPVT 12
drvZynqPvt *driverTable[MAX_DRVPVT] = {0};

/*
 * asynCommon interface
 */
STATIC void report                 	(void *drvPvt, FILE *fp, int details);
STATIC asynStatus connect          	(void *drvPvt, asynUser *pasynUser);
STATIC asynStatus disconnect       	(void *drvPvt, asynUser *pasynUser);

STATIC const struct asynCommon ZynqCommon = {
    report,
    connect,
    disconnect
};

/*
 * asynDrvUser interface
 */
STATIC asynStatus create_asynDrvUser(void *drvPvt,asynUser *pasynUser,
    const char *drvInfo, const char **pptypeName,size_t *psize);
STATIC asynStatus getType_asynDrvUser(void *drvPvt,asynUser *pasynUser,
    const char **pptypeName,size_t *psize);
STATIC asynStatus destroy_asynDrvUser(void *drvPvt,asynUser *pasynUser);
STATIC asynDrvUser drvUser = {create_asynDrvUser, getType_asynDrvUser, destroy_asynDrvUser};

/*
 * asynUInt32Digital interface - we only implement part of this interface.
 */
STATIC asynStatus readUInt32D(void *drvPvt, asynUser *pasynUser, epicsUInt32 *value, epicsUInt32 mask);
STATIC asynStatus writeUInt32D(void *drvPvt, asynUser *pasynUser, epicsUInt32 value, epicsUInt32 mask);
STATIC asynStatus setInterruptUInt32D(void *drvPvt, asynUser *pasynUser, epicsUInt32 mask, interruptReason reason);
STATIC asynStatus clearInterruptUInt32D(void *drvPvt, asynUser *pasynUser, epicsUInt32 mask);


/* default implementations are provided by asynUInt32DigitalBase. */
STATIC struct asynUInt32Digital ZynqUInt32D = {
    writeUInt32D, /* write */
    readUInt32D,  /* read */
    setInterruptUInt32D,	/* setInterrupt (not used) */
    clearInterruptUInt32D,	/* clearInterrupt (not used) */
    NULL,         /* getInterrupt: default does nothing */
    NULL,         /* registerInterruptUser: default adds user to pollerThread's clientList. */
    NULL          /* cancelInterruptUser: default removes user from pollerThread's clientList. */
};


/*
 * asynInt32 interface 
 */

STATIC asynStatus writeInt32(void *drvPvt, asynUser *pasynUser, epicsInt32 value);
STATIC asynStatus readInt32(void *drvPvt, asynUser *pasynUser, epicsInt32 *value);
STATIC asynStatus getBounds(void *drvPvt, asynUser *pasynUser, epicsInt32 *low, epicsInt32 *high);

STATIC struct asynInt32 ZynqInt32 = {
    writeInt32, /* write */
    readInt32,  /* read */
	getBounds,	/* getBounds */
	NULL,		/* RegisterInterruptUser */
	NULL		/* cancelInterruptUser */
};

/* These are private functions */
#if 0
STATIC void pollerThread           	(drvZynqPvt *pPvt);
STATIC void intFunc                	(void *); /* Interrupt function */
#endif
STATIC void rebootCallback         	(void *);

int devMemFd = 0;
int initDevMem() {
  /* microZed Open /dev/mem to write to FPGA registers */
  if (devMemFd) return(0);
  devMemFd = open("/dev/mem",O_RDWR|O_SYNC);
  if (devMemFd < 0) {
	epicsPrintf("Can't Open /dev/mem\n");
	return(-1);
  }
  return(0);
}

/* Init one field I/O register set (one AXI4 Lite peripheral) */
int initZynqIO(const char *portName, 
	int msecPoll, int dataDir, int AXI_Address, int interruptVector,
	int risingMask, int fallingMask) {

	drvZynqPvt *pPvt;
	int status;
	char threadName[80] = "";

	pPvt = callocMustSucceed(1, sizeof(*pPvt), "initZynqIO");
	pPvt->portName = epicsStrDup(portName);
	pPvt->is_fieldIO_registerSet = 1;

	/* Default of 100 msec */
	if (msecPoll == 0) msecPoll = 100;
	pPvt->pollTime = msecPoll / 1000.;
	pPvt->msgQId = epicsMessageQueueCreate(MAX_MESSAGES, sizeof(interruptMessage));

	/* Set up ID and I/O space addresses for IP module */
	initDevMem();

	pPvt->mem = (epicsUInt32 *) mmap(0,255,PROT_READ|PROT_WRITE,MAP_SHARED,devMemFd,AXI_Address);
	if (pPvt->mem == NULL) {
		printf("initZynqIO: mmap A32 Address map failed for address 0x%X\n", AXI_Address);
	}
	else printf("initZynqIO: mmap A32 Address map successful for address 0x%X\n", AXI_Address);
	pPvt->regs = (fieldIO_registerSet *) ((char *)(pPvt->mem));

	pPvt->intVector = interruptVector;

	pPvt->manufacturer = 0;
	pPvt->model = 0;

	/* Link with higher level routines */
	pPvt->common.interfaceType = asynCommonType;
	pPvt->common.pinterface  = (void *)&ZynqCommon;
	pPvt->common.drvPvt = pPvt;

	pPvt->asynDrvUser.interfaceType = asynDrvUserType;
	pPvt->asynDrvUser.pinterface = (void *)&drvUser;
	pPvt->asynDrvUser.drvPvt = pPvt;

	pPvt->uint32D.interfaceType = asynUInt32DigitalType;
	pPvt->uint32D.pinterface  = (void *)&ZynqUInt32D;
	pPvt->uint32D.drvPvt = pPvt;

	pPvt->int32.interfaceType = asynInt32Type;
	pPvt->int32.pinterface  = (void *)&ZynqInt32;
	pPvt->int32.drvPvt = pPvt;

	status = pasynManager->registerPort(pPvt->portName,
	                                    ASYN_MULTIDEVICE, /* multiDevice, cannot block */
	                                    1, /* autoconnect */
	                                    0, /* medium priority */
	                                    0);/* default stack size */
	if (status != asynSuccess) {
		printf("initZynqIO ERROR: Can't register port\n");
		return(-1);
	}
	status = pasynManager->registerInterface(pPvt->portName,&pPvt->common);
	if (status != asynSuccess) {
		printf("initZynqIO ERROR: Can't register common.\n");
		return(-1);
	}
	status = pasynManager->registerInterface(pPvt->portName,&pPvt->asynDrvUser);
	if (status != asynSuccess){
		printf("initZynqIO ERROR: Can't register asynDrvUser.\n");
		return(-1);
	}
	status = pasynUInt32DigitalBase->initialize(pPvt->portName, &pPvt->uint32D);
	if (status != asynSuccess) {
		printf("initZynqIO ERROR: Can't register UInt32Digital.\n");
		return(-1);
	}
	pasynManager->registerInterruptSource(pPvt->portName, &pPvt->uint32D,
	                                      &pPvt->interruptPvt);

	status = pasynInt32Base->initialize(pPvt->portName,&pPvt->int32);
	if (status != asynSuccess) {
		printf("initZynqIO ERROR: Can't register Int32.\n");
		return(-1);
	}

	/* Create asynUser for asynTrace */
	pPvt->pasynUser = pasynManager->createAsynUser(0, 0);
	pPvt->pasynUser->userPvt = pPvt;

	/* Connect to device */
	status = pasynManager->connectDevice(pPvt->pasynUser, pPvt->portName, 0);
	if (status != asynSuccess) {
		printf("initZynqIO, connectDevice failed %s\n",
			pPvt->pasynUser->errorMessage);
		return(-1);
	}

	/* Set up the control register */
	pPvt->regs->controlRegister = dataDir;	/* Set Data Direction Reg Zynq */ 
	pPvt->regs->writeDataRegister = 0;		/* Clear direct-write to field I/O */  
	pPvt->risingMask = risingMask;
	pPvt->fallingMask = fallingMask;

#if 0
	/* Start the thread to poll and handle interrupt callbacks to device support */
	strcat(threadName, "Zynq");
	strcat(threadName, portName);
	epicsThreadCreate(threadName, epicsThreadPriorityHigh,
		epicsThreadGetStackSize(epicsThreadStackBig),
		(EPICSTHREADFUNC)pollerThread, pPvt);
#endif

	/* Interrupt support
	 * If risingMask, fallingMask, and intVector are zero, don't bother with interrupts, 
	 * since the user probably didn't pass this parameter to initZynqIO()
	 */
	if (pPvt->intVector || pPvt->risingMask || pPvt->fallingMask) {
	
		pPvt->regs->risingIntStatus = risingMask;
		pPvt->regs->fallingIntStatus = fallingMask;
		
		/* Enable interrupt generation in FPGA firmware */
		if (pPvt->risingMask) { 
			pPvt->regs->risingIntEnable = pPvt->risingMask;
		}
		if (pPvt->fallingMask) {  
			pPvt->regs->fallingIntEnable = pPvt->fallingMask;
		}
#if 0
		/* Associate interrupt service routine with intVector */
		if (devConnectInterruptVME(pPvt->intVector, intFunc, (void *)pPvt)) {
			printf("Zynq interrupt connect failure\n");
			return(-1);
		}
		/* Enable interrupts and set module status. */
		/* how do I do this? */
#endif
	}
	epicsAtExit(rebootCallback, pPvt);
	return(0);
}

STATIC asynStatus create_asynDrvUser(void *drvPvt,asynUser *pasynUser,
	const char *drvInfo, const char **pptypeName,size_t *psize)
{
	if (drvZynqDebug>5) printf("drvZynq:create_asynDrvUser: entry drvInfo='%s'\n", drvInfo);
	if (!drvInfo) {
		pasynUser->reason = 0;
	} else {
		if (strcmp(drvInfo, "INTEDGE") == 0) pasynUser->reason = INTERRUPT_EDGE;
		if (strcmp(drvInfo, "POLLTIME") == 0) pasynUser->reason = POLL_TIME;
		if (strcmp(drvInfo, "INT_EDGE_RESET") == 0) pasynUser->reason = INTERRUPT_EDGE_RESET;
		if (strcmp(drvInfo, "REG32") == 0) pasynUser->reason = REG32;
	}
	return(asynSuccess);
}

STATIC asynStatus getType_asynDrvUser(void *drvPvt,asynUser *pasynUser,
	const char **pptypeName,size_t *psize)
{
	printf("drvZynq:getType_asynDrvUser: entry\n");
	return(asynSuccess);
}

STATIC asynStatus destroy_asynDrvUser(void *drvPvt,asynUser *pasynUser)
{
	printf("drvZynq:destroy_asynDrvUser: entry\n");
	return(asynSuccess);
}


/* init memory mapped access to softGlue registers */
int initZynqSingleRegisterPort(const char *portName, int AXI_BaseAddress)
{
	drvZynqPvt *pPvt;
	int status;

	pPvt = callocMustSucceed(1, sizeof(*pPvt), "drvZynqPvt");
	pPvt->portName = epicsStrDup(portName);
	pPvt->is_fieldIO_registerSet = 0;

	/* Set up address */
	initDevMem();
	pPvt->mem = (epicsUInt32 *) mmap(0,255,PROT_READ|PROT_WRITE,MAP_SHARED,devMemFd,AXI_BaseAddress);
	if (pPvt->mem == NULL) {
		printf("initZynqSingleRegisterPort: mmap A32 Address map failed for address 0x%X\n", AXI_BaseAddress);
	}
	else printf("initZynqSingleRegisterPort: mmap A32 Address map successful for address 0x%X\n", AXI_BaseAddress);

	pPvt->manufacturer = 0;
	pPvt->model = 0;

	/* Link with higher level routines */
	pPvt->common.interfaceType = asynCommonType;
	pPvt->common.pinterface  = (void *)&ZynqCommon;
	pPvt->common.drvPvt = pPvt;

	pPvt->asynDrvUser.interfaceType = asynDrvUserType;
	pPvt->asynDrvUser.pinterface = (void *)&drvUser;
	pPvt->asynDrvUser.drvPvt = pPvt;

	pPvt->uint32D.interfaceType = asynUInt32DigitalType;
	pPvt->uint32D.pinterface  = (void *)&ZynqUInt32D;
	pPvt->uint32D.drvPvt = pPvt;

	pPvt->int32.interfaceType = asynInt32Type;
	pPvt->int32.pinterface  = (void *)&ZynqInt32;
	pPvt->int32.drvPvt = pPvt;

	status = pasynManager->registerPort(pPvt->portName,
	                                    ASYN_MULTIDEVICE, /* multiDevice, cannot block */
	                                    1, /* autoconnect */
	                                    0, /* medium priority */
	                                    0);/* default stack size */
	if (status != asynSuccess) {
		printf("initZynqSingleRegisterPort ERROR: Can't register port\n");
		return(-1);
	}
	status = pasynManager->registerInterface(pPvt->portName,&pPvt->common);
	if (status != asynSuccess) {
		printf("initZynqSingleRegisterPort ERROR: Can't register common.\n");
		return(-1);
	}
	status = pasynManager->registerInterface(pPvt->portName,&pPvt->asynDrvUser);
	if (status != asynSuccess){
		printf("initZynqIO ERROR: Can't register asynDrvUser.\n");
		return(-1);
	}
	status = pasynUInt32DigitalBase->initialize(pPvt->portName, &pPvt->uint32D);
	if (status != asynSuccess) {
		printf("initZynqSingleRegisterPort ERROR: Can't register UInt32Digital.\n");
		return(-1);
	}
	pasynManager->registerInterruptSource(pPvt->portName, &pPvt->uint32D,
	                                      &pPvt->interruptPvt);

	status = pasynInt32Base->initialize(pPvt->portName,&pPvt->int32);
	if (status != asynSuccess) {
		printf("initZynqSingleRegisterPort ERROR: Can't register Int32.\n");
		return(-1);
	}

	/* Create an asynUser that we can use when we want to call asynPrint, but don't
	 * have any client's asynUser to supply as an argument.
	 */
	pPvt->pasynUser = pasynManager->createAsynUser(0, 0);
	pPvt->pasynUser->userPvt = pPvt;

	/* Connect our asynUser to device */
	status = pasynManager->connectDevice(pPvt->pasynUser, pPvt->portName, 0);
	if (status != asynSuccess) {
		printf("initZynqSingleRegisterPort, connectDevice failed %s\n",
			pPvt->pasynUser->errorMessage);
		return(-1);
	}
	return(0);
}

/* Initialize IP module's FPGA from file in .bin or .bit format (haven't decided yet).
 * In Vivado, select "write Bitstream".
 * Programming the FPGA can be done manually:
 *	1.Copy bitstream file from Vivado project area:
 *		cp VivadoProjects/softGlue_1/softGlue_1.runs/impl_1/design_1_wrapper.bit .
 *	2. Convert .bit to .to bin using fpga-bit-to-bin.py:
 * 		fpga-bit-to-bin.py -f design_1_wrapper.bit design_1_wrapper.bin
 *	3. Write .bin file to FPGA:
 *		cat design_1_wrapper.bin >/dev/xdefcfg
 */
 
 /* initZynqIP() doesn't work yet. */
#define BUF_SIZE 1000
#include "macLib.h"
/*#include "xdevcfg.h"*/
int initZynqIP(char *filepath)
{
	int i, maxwait, total_bytes, intLevel=0;
	short n;
	FILE *source_fd=0, *dest_fd=0;
	unsigned char buffer[BUF_SIZE], *bp;
	unsigned short *sp;
	char *filename;
	unsigned long l;

	bp = buffer;
	sp = (short *)buffer;

	/* Disable interrupt level for this module.  Otherwise we may get
	 * interrupts while the FPGA is being loaded.
	 */
	/* how do I do this? */

	filename = macEnvExpand(filepath); /* in case filepath = '$(SOFTGLUE)/...' */
	if (filename == NULL) {
		printf("initZynqIP: macEnvExpand() returned NULL.  I quit.\n");
		goto errReturn;
	}
	if ((source_fd = fopen(filename,"rb")) == NULL) {
		printf("initZynqIP: Can't open source file '%s'.\n", filename);
		free(filename); /* macEnvExpand() allocated this for us. We're done with it now. */
		goto errReturn;
	}
	free(filename); /* macEnvExpand() allocated this for us. We're done with it now. */
	if ((dest_fd = fopen("/dev/xdevcfg","ab")) == NULL) {
		printf("initZynqIP: Can't open dest file '%s'.\n", filename);
		goto errReturn;
	}

	maxwait = 0;
	total_bytes = 0;
	i = fread(bp, 1, 2, source_fd);
	n = (bp[0]<<8) + bp[1];
	if (n != 9) {
		printf("initZynqIP: '%s' doesn't look like a .bit file (0x%x, 0x%x, first short=0x%hx)\n", filepath, *bp, bp[1], n);
		goto errReturn;
	}
	/* skip over <0009> header */
	i = fread(bp, 1, n, source_fd);

	/* read <a> header */
	i = fread(bp, 1, 2, source_fd);	/* read num bytes */
	n = (bp[0]<<8) + bp[1];			/* get num bytes as n */
	printf("...%d bytes\n", n);
	fread(bp, 1, n, source_fd);	/* read n bytes */
	printf("...read %c\n", *bp);
	if (*bp != 'a') {
		printf("initZynqIP: Missing <a> header, not a bit file\n");
		goto errReturn;
	}
	i = fread(bp, 1, 2, source_fd);	/* read design name num bytes */
	n = (bp[0]<<8) + bp[1];			/* get num bytes as n */
	fread(bp, 1, n, source_fd);	/* read n bytes */
	printf("...design name = '%s'\n", bp);

	while (1) {
		i = fread(bp, 1, 1, source_fd);	/* read num bytes */
		if (feof(source_fd)) {
			printf("initZynqIP: unexpected end of file\n");
			goto errReturn;
		}
		switch (*bp) {
		case 'e':
			i = fread(bp, 1, 4, source_fd);	/* read binary data num bytes */
			l = (bp[0]<<24) + (bp[1]<<16) + (bp[2]<<8) + bp[3];		/* get num bytes as l */
			printf("...%ld bytes of bin data\n", l);
			for (i=0; i<l/4; i++) {
				fread(bp, 1, 4, source_fd);	/* read 4 bytes */
				l = (bp[3]<<24) + (bp[2]<<16) + (bp[1]<<8) + bp[0];
				if (i<16) printf("...writing 0x%x, 0x%x, 0x%x, 0x%x (0x%x)\n", bp[3], bp[2], bp[1], bp[0], l);
				fwrite(l, 1, 4, dest_fd);	/* write 4 bytes */
			}
			fclose(source_fd);
			fclose(dest_fd);
			return(0);
			break;
		case 'b':
			i = fread(bp, 1, 2, source_fd);	/* read part name num bytes */
			n = (bp[0]<<8) + bp[1];			/* get num bytes as n */
			fread(bp, 1, (int)n, source_fd);	/* read n bytes */
			printf("...part name = '%s'\n", bp);
			break;
		case 'c':
			i = fread(bp, 1, 2, source_fd);	/* read date num bytes */
			n = (bp[0]<<8) + bp[1];			/* get num bytes as n */
			fread(bp, 1, (int)n, source_fd);	/* read n bytes */
			printf("...date = '%s'\n", bp);
			break;
		case 'd':
			i = fread(bp, 1, 2, source_fd);	/* read time num bytes */
			n = (bp[0]<<8) + bp[1];			/* get num bytes as n */
			fread(bp, 1, (int)n, source_fd);	/* read n bytes */
			printf("...time = '%s'\n", bp);
			break;
		default:
			break;
		}
	}

	/* devEnableInterruptLevel(intVME,intLevel); */
	fclose(source_fd);
	return(0);

errReturn:
	/* devEnableInterruptLevel(intVME,intLevel); */
	if (source_fd) fclose(source_fd);
	if (dest_fd) fclose(dest_fd);
	return(-1);
}

/*
 * softGlueCalcSpecifiedRegister32Address - For access to a single-register component by
 * other than an EPICS record (for example, by an interrupt-service routine).
 * The AXI and word offset are specified as arguments, and we need
 * to translate that information into a memory mapped address, as calcRegister32Address()
 * would have done for an EPICS record.
 */
 #if 0
epicsUInt16 *softGlueCalcSpecifiedRegister32Address(int AXI, int addr)
{
	epicsUInt32 *mem;
	mem = AXI_baseAddresses[AXI];
	reg = (epicsUInt32 *) (mem+addr);
	return(reg);
}
#endif

/*
 * readUInt32D
 * This method provides masked read access to the readDataRegister of a
 * fieldIO_registerSet component, or to the sopc address of a single register
 * component.  
 * Note that fieldIO_registerSet components have a control register that
 * may determine what data will be available for reading.
 */
STATIC asynStatus readUInt32D(void *drvPvt, asynUser *pasynUser,
	epicsUInt32 *value, epicsUInt32 mask)
{
	drvZynqPvt *pPvt = (drvZynqPvt *)drvPvt;
	volatile epicsUInt8 *reg8=0;
	volatile epicsUInt32 *reg32=0;
	int addr;

	if (drvZynqDebug >= 5) {
		printf("drvZynq:readUInt32D: pasynUser->reason=%d\n", pasynUser->reason);
	}
	*value = 0;
	if (pPvt->is_fieldIO_registerSet) {
		if (pasynUser->reason == 0) {
			/* read data */
			if (drvZynqDebug >= 5) printf("drvZynq:readUInt32D: fieldIO reg address=%p\n", &(pPvt->regs->readDataRegister));
			*value = (epicsUInt32) (pPvt->regs->readDataRegister & mask);
		} else if (pasynUser->reason == INTERRUPT_EDGE) {
			/* read interrupt-enable edge bits.  This is a kludge.  We need to specify one of 16 I/O
			 * bits, and also to indicate which of four states applies to that bit.  To do this, we
			 * use a two bit mask, the lower bit of which specifies the I/O bit.  The four states
			 * indicate which signal edge is enabled to generate interrupts (00: no edge enabled,
			 * 01: rising edge enabled, 10: falling edge enabled, 11: both edges enabled).
			 */
			epicsUInt16 rising, falling;
			*value = 0;
			rising = (epicsUInt16) (pPvt->regs->risingIntEnable & (mask&(mask>>1)) );
			falling = (epicsUInt16) (pPvt->regs->fallingIntEnable & (mask&(mask>>1)) );
			if (rising) *value |= 1;
			if (falling) *value |= 2;
			/* Left shift the (two-bit) value so it overlaps the mask that caller gave us. */
			for (; mask && ((mask&1) == 0); mask>>=1, *value<<=1);
		} else if (pasynUser->reason == POLL_TIME) {
			*value = (epicsUInt32) pPvt->pollTime*1000;
		} else if (pasynUser->reason == INTERRUPT_EDGE_RESET) {
			*value = pPvt->disabledIntMask;
		}
	} else {
		/* Not field I/O */
		pasynManager->getAddr(pasynUser, &addr);
		if (pasynUser->reason == REG32) {
			/* 32-bit register (addr must be a word offset) */
			reg32 = (epicsUInt32 *)pPvt->mem;
			reg32 += addr;
			if (drvZynqDebug >= 5) printf("drvZynq:readUInt32D: softGlue reg32 address=%p\n", reg32);
			*value = (epicsUInt32) (*reg32 & mask);
		} else {
			/* 8-bit register (addr must be a byte offset) */
			reg8 = (epicsUInt8 *)pPvt->mem;
			reg8 += addr;
			if (drvZynqDebug >= 5) printf("drvZynq:readUInt32D: softGlue reg8 address=%p\n", reg8);
			*value = (epicsUInt32) (*reg8 & mask);
		}
	}
	asynPrint(pasynUser, ASYN_TRACEIO_DRIVER,
		"drvZynq::readUInt32D, value=0x%X, mask=0x%X\n", *value,mask);
	return(asynSuccess);
}

/*
 * writeUInt32D
 * This method provides bit level write access to the writeDataRegister of a
 * fieldIO_registerSet component, and to the sopc address of a single register
 * component.  Bits of 'value' that correspond to zero bits of 'mask' will
 * be ignored -- corresponding bits of the destination register will be left
 * as they were before the write operation.  
 * Note that fieldIO_registerSet components have a control register that
 * may determine what use will be made of the data we write.
 */
STATIC asynStatus writeUInt32D(void *drvPvt, asynUser *pasynUser, epicsUInt32 value,
	epicsUInt32 mask)
{
	drvZynqPvt *pPvt = (drvZynqPvt *)drvPvt;
	volatile epicsUInt32 *reg32=0;
	volatile epicsUInt8 *reg8=0;
	int addr;
	epicsUInt32 maskCopy;

	if (drvZynqDebug >= 5) {
		printf("drvZynq:writeUInt32D: pasynUser->reason=%d\n", pasynUser->reason);
	}
	if (pPvt->is_fieldIO_registerSet) {
		if (pasynUser->reason == 0) {
			/* write data */
			if (drvZynqDebug >= 5) printf("drvZynq:writeUInt32D: fieldIO reg32 address=%p\n", &(pPvt->regs->writeDataRegister));
			pPvt->regs->writeDataRegister = (pPvt->regs->writeDataRegister & ~mask) | (value & mask);
		} else if (pasynUser->reason == INTERRUPT_EDGE) {
			/* set interrupt-enable edge bits in the FPGA */
			/* move value from shifted position to unshifted position */
			for (maskCopy=mask; maskCopy && ((maskCopy&1) == 0); maskCopy>>=1, value>>=1);
			maskCopy = mask & (mask>>1); /* use lower bit only of two-bit mask for register write */
			pPvt->regs->risingIntEnable = (pPvt->regs->risingIntEnable & ~maskCopy);
			pPvt->regs->fallingIntEnable = (pPvt->regs->fallingIntEnable & ~maskCopy);
			switch (value) {
			case 0: /* disable interrupt from this bit */
				break;
			case 1: /* rising-edge only */
				pPvt->regs->risingIntEnable = (pPvt->regs->risingIntEnable & ~maskCopy) | maskCopy;
				break;
			case 2: /* falling-edge only */
				pPvt->regs->fallingIntEnable = (pPvt->regs->fallingIntEnable & ~maskCopy) | maskCopy;
				break;
			case 3: /* rising-edge and falling-edge */
				pPvt->regs->risingIntEnable = (pPvt->regs->risingIntEnable & ~maskCopy) | maskCopy;
				pPvt->regs->fallingIntEnable = (pPvt->regs->fallingIntEnable & ~maskCopy) | maskCopy;
				break;
			}
			pPvt->risingMask = pPvt->regs->risingIntEnable;
			pPvt->fallingMask = pPvt->regs->fallingIntEnable;
		} else if (pasynUser->reason == POLL_TIME) {
			pPvt->pollTime = value/1000.;
			if (pPvt->pollTime < .05) {
				pPvt->pollTime = .05;
				printf("drvZynq:writeUInt32D: pollTime lower limit = %d ms\n", (int)(pPvt->pollTime*1000));
			}
			if (drvZynqDebug) printf("drvZynq:writeUInt32D: pPvt->pollTime=%f s\n", pPvt->pollTime);
		}
		asynPrint(pasynUser, ASYN_TRACEIO_DRIVER,
			"drvZynq::writeUInt32D, addr=%p, value=0x%X, mask=0x%X, reason=%d\n",
				reg32, value, mask, pasynUser->reason);
	} else {
		pasynManager->getAddr(pasynUser, &addr);
		if (pasynUser->reason == REG32) {
			/* 32-bit register (addr must be a word offset) */
			reg32 = (epicsUInt32 *)pPvt->mem;
			reg32 += addr;
			if (drvZynqDebug >= 5) printf("drvZynq:writeUInt32D: softGlue reg32 address=%p\n", reg32);
			*reg32 = (*reg32 & ~mask) | (epicsUInt32) (value & mask);
			asynPrint(pasynUser, ASYN_TRACEIO_DRIVER,
				"drvZynq::writeUInt32D, addr=%p, value=0x%X, mask=0x%X, reason=%d\n",
					reg32, value, mask, pasynUser->reason);
		} else {
			/* 8-bit register (addr must be a byte offset) */
			reg8 = (epicsUInt8 *)pPvt->mem;
			reg8 += addr;
			if (drvZynqDebug >= 5) printf("drvZynq:writeUInt32D: softGlue reg8 address=%p\n", reg8);
			*reg8 = (*reg8 & ~mask) | (epicsUInt8) (value & mask);
			asynPrint(pasynUser, ASYN_TRACEIO_DRIVER,
				"drvZynq::writeUInt32D, addr=%p, value=0x%X, mask=0x%X, reason=%d\n",
					reg8, value, mask, pasynUser->reason);
		}
	}

	return(asynSuccess);
}

/*
 * readInt32
 * This method reads from the readDataRegister of a fieldIO_registerSet
 * component, or from the sopc address of a single register component.  
 * Note that fieldIO_registerSet components have a control register that
 * may determine what data will be available for reading.
 */
STATIC asynStatus readInt32(void *drvPvt, asynUser *pasynUser, epicsInt32 *value)
{
	drvZynqPvt *pPvt = (drvZynqPvt *)drvPvt;
	volatile epicsUInt32 *reg32=0;
	volatile epicsUInt8 *reg8=0;
	int addr;

	if (drvZynqDebug >= 5) {
		printf("drvZynq:readInt32: pasynUser->reason=%d\n", pasynUser->reason);
	}
	*value = 0;

	if (pasynUser->reason == 0) {
		if (pPvt->is_fieldIO_registerSet) {
			if (drvZynqDebug >= 5) printf("drvZynq:readInt32: fieldIO reg32 address=%p\n", &(pPvt->regs->readDataRegister));
			*value = (epicsUInt32) pPvt->regs->readDataRegister;
		} else {
			/* Not field I/O */
			pasynManager->getAddr(pasynUser, &addr);
			if (pasynUser->reason == REG32) {
				/* 32-bit register (addr must be a word address at a word boundary) */
				reg32 = (epicsUInt32 *)pPvt->mem;
				reg32 += addr;
				if (drvZynqDebug >= 5) printf("drvZynq:readUInt32D: softGlue reg32 address=%p\n", reg32);
				*value = (epicsUInt32) (*reg32);
			} else {
				reg8 = (epicsUInt8 *)pPvt->mem;
				reg8 += addr;
				if (drvZynqDebug >= 5) printf("drvZynq:readUInt32D: softGlue reg8 address=%p\n", reg8);
				*value = (epicsUInt32) (*reg8);
			}
		}
	} else if (pasynUser->reason == POLL_TIME) {
		*value = (epicsUInt32) (pPvt->pollTime*1000);
	} else if (pasynUser->reason == INTERRUPT_EDGE_RESET) {
		*value = pPvt->disabledIntMask;
	}

	asynPrint(pasynUser, ASYN_TRACEIO_DRIVER,
		"drvZynq::readInt32, value=0x%X\n", *value);
	return(asynSuccess);
}

/* writeInt32
 * This method writes to the writeDataRegister of a fieldIO_registerSet
 * component, and to the sopc address of a single register component.  
 * Note that fieldIO_registerSet components have a control register that
 * may determine what use will be made of the data we write.
 */
STATIC asynStatus writeInt32(void *drvPvt, asynUser *pasynUser, epicsInt32 value)
{
	drvZynqPvt *pPvt = (drvZynqPvt *)drvPvt;
	volatile epicsUInt32 *reg32=0;
	volatile epicsUInt8 *reg8=0;
	int addr;

	if (drvZynqDebug >= 5) {
		printf("drvZynq:writeInt32: pasynUser->reason=%d\n", pasynUser->reason);
	}
	if (pasynUser->reason == 0) {
		if (pPvt->is_fieldIO_registerSet) {
			if (drvZynqDebug >= 5) printf("drvZynq:writeInt32: fieldIO reg32 address=%p\n", &(pPvt->regs->writeDataRegister));
			pPvt->regs->writeDataRegister = (epicsUInt32) value;
		} else {
			pasynManager->getAddr(pasynUser, &addr);
			if (pasynUser->reason == REG32) {
				/* 32-bit register (addr must be a word offset) */
				reg32 = (epicsUInt32 *)pPvt->mem;
				reg32 += addr;
				if (drvZynqDebug >= 5) printf("drvZynq:writeUInt32D: softGlue reg32 address=%p\n", reg32);
				*reg32 = (epicsUInt32) (value);
				asynPrint(pasynUser, ASYN_TRACEIO_DRIVER,
					"drvZynq::writeUInt32D, addr=%p, value=0x%X, reason=%d\n",
						reg32, value, pasynUser->reason);
			} else {
				/* 8-bit register (addr must be a byte offset) */
				reg8 = (epicsUInt8 *)pPvt->mem;
				reg8 += addr;
				if (drvZynqDebug >= 5) printf("drvZynq:writeUInt32D: softGlue reg8 address=%p\n", reg8);
				reg8 = (epicsUInt8 *)pPvt->mem + addr;
				asynPrint(pasynUser, ASYN_TRACEIO_DRIVER,
					"drvZynq::writeUInt32D, addr=%p, value=0x%X, reason=%d\n",
						reg8, value, pasynUser->reason);
			}
		}
	} else if (pasynUser->reason == POLL_TIME) {
			pPvt->pollTime = value/1000;
	}

	asynPrint(pasynUser, ASYN_TRACEIO_DRIVER,
		"drvZynq::writeInt32, value=0x%X, reason=%d\n",value, pasynUser->reason);
	return(asynSuccess);
}

STATIC asynStatus getBounds(void *drvPvt, asynUser *pasynUser, epicsInt32 *low, epicsInt32 *high)
{
	const char *portName;
	asynStatus status;
	int        addr;

	status = pasynManager->getPortName(pasynUser,&portName);
	if (status!=asynSuccess) return status;
	status = pasynManager->getAddr(pasynUser,&addr);
	if (status!=asynSuccess) return status;
	*low = 0;
	*high = 0xffff;
	asynPrint(pasynUser,ASYN_TRACE_FLOW,
		"%s %d getBounds setting low=high=0\n",portName,addr);
	return(asynSuccess);
}

#if 0
/***********************************************************************
 * Manage a table of registered interrupt-service routines to be called
 * at interrupt level.  This is not the normal softGlue interrupt mechanism;
 * it's for interrupts that will occur at too high a frequency, or too
 * close together in time, for that mechanism to handle.
 */

/* table of registered routines for execution at interrupt level */
#define MAXROUTINES 10

typedef struct {
	epicsUInt16 carrier;
	epicsUInt16 slot;
	epicsUInt16 mask;
	int sopcAddress;
	volatile fieldIO_registerSet *regs;
	void (*routine)(softGlueIntRoutineData *IRData);
	softGlueIntRoutineData IRData;
} intRoutineEntry;

intRoutineEntry registeredIntRoutines[MAXROUTINES] = {{0}};
int numRegisteredIntRoutines=0;

/* Register a routine to be called at interrupt level when a specified
 * I/O bit (addr/mask) from a specified carrier/slot generates an interrupt.
 * example invocation:
 *      void callMe(softGlueIntRoutineData *IRData);
 *		myDataType myData;
 *      softGlueRegisterInterruptRoutine(0, 0, 0x800000, 0x0, callMe, (void *)&myData);
 */
int softGlueRegisterInterruptRoutine(epicsUInt16 carrier, epicsUInt16 slot, int sopcAddress, epicsUInt16 mask,
	void (*routine)(softGlueIntRoutineData *IRData), void *userPvt) {
	int i;
	drvZynqPvt *pPvt;

	if (numRegisteredIntRoutines >= MAXROUTINES-1) return(-1);
	registeredIntRoutines[numRegisteredIntRoutines].carrier = carrier;
	registeredIntRoutines[numRegisteredIntRoutines].slot = slot;
	registeredIntRoutines[numRegisteredIntRoutines].sopcAddress = sopcAddress;
	registeredIntRoutines[numRegisteredIntRoutines].mask = mask;
	registeredIntRoutines[numRegisteredIntRoutines].routine = routine;
	registeredIntRoutines[numRegisteredIntRoutines].IRData.userPvt = userPvt;

	/* Go through driverTable for all drvZynqPvt pointers assoc with this carrier/slot. */
	for (i=0; i<MAX_DRVPVT; i++) {
		pPvt = driverTable[i];
		if (pPvt && (pPvt->carrier == carrier) && (pPvt->slot == slot) && (pPvt->sopcAddress == sopcAddress)) {
			registeredIntRoutines[numRegisteredIntRoutines].regs = pPvt->regs;
		}
	}
	if (drvZynqDebug>5) printf("softGlueRegisterInterruptRoutine: #%d, carrier=%d, slot=%d, sopcAddress=0x%x, mask=0x%x, regs=%p",
		numRegisteredIntRoutines, carrier, slot, sopcAddress, mask, registeredIntRoutines[numRegisteredIntRoutines].regs);
	numRegisteredIntRoutines++;
	return(0);
}

/***********************************************************************/
/*
 * This is the interrupt-service routine associated with the interrupt
 * vector pPvt->intVector supplied in the drvPvt structure.
 * On interrupt, we check to see if the interrupt could have come from
 * the fieldIO_registerSet named in caller's drvPvt.  If so, we collect
 * information, and send a message to pollerThread().
 */
STATIC void intFunc(void *drvPvt)
{
	drvZynqPvt *pPvt = (drvZynqPvt *)drvPvt;
	epicsUInt16 pendingLow, pendingHigh;
	interruptMessage msg;
	int i, handled;

	/* Make sure interrupt is from this hardware.  Otherwise just leave. */
	if (pPvt->regs->risingIntStatus || pPvt->regs->fallingIntStatus) {
#ifdef vxWorks
		if (drvZynqDebug) {
			logMsg("fallingIntStatus=0x%x, risingIntStatus=0x%x\n", pPvt->regs->fallingIntStatus, pPvt->regs->risingIntStatus);
			logMsg("fallingIntEnable=0x%x, risingIntEnable=0x%x\n", pPvt->regs->fallingIntEnable, pPvt->regs->risingIntEnable);
		}
#endif
		pendingLow = pPvt->regs->fallingIntStatus;
		pendingHigh = pPvt->regs->risingIntStatus;
		msg.interruptMask = (pendingLow & pPvt->regs->fallingIntEnable);
		msg.interruptMask |= (pendingHigh & pPvt->regs->risingIntEnable);

		/* Read the current input */
		msg.bits = pPvt->regs->readDataRegister;
#ifdef vxWorks
		if (drvZynqDebug) logMsg("interruptMask=0x%x\n", msg.interruptMask);
#endif

		/* Go through registeredIntRoutines[] for a registered interrupt-level service routine. If one is found,
		 * call it and mark the interrupt as "handled", so we don't queue any EPICS processing that
		 * might also be attached to the interrupt.  (The whole purpose of this mechanism is to
		 * handle interrupts at intervals EPICS would not be able to meet.) */
		for (i=0, handled=0; i<numRegisteredIntRoutines; i++) {
			if ((registeredIntRoutines[i].regs == pPvt->regs) && (msg.interruptMask & registeredIntRoutines[i].mask)) {
#ifdef vxWorks
				if (drvZynqDebug>5) logMsg("intFunc: calling registered interrupt routine %p\n", registeredIntRoutines[i].routine);
#endif
				registeredIntRoutines[i].IRData.mask = msg.interruptMask;
				registeredIntRoutines[i].IRData.wentLow = pendingLow & pPvt->regs->fallingIntEnable;
				registeredIntRoutines[i].IRData.wentHigh = pendingHigh & pPvt->regs->risingIntEnable;
				registeredIntRoutines[i].routine(&(registeredIntRoutines[i].IRData));
				handled = 1;
			}
		}

		if (!handled) {
			if (epicsMessageQueueTrySend(pPvt->msgQId, &msg, sizeof(msg)) == 0)
				pPvt->messagesSent++;
			else
				pPvt->messagesFailed++;

			/* If too many interrupts have been received, disable the offending bits. */
			if (++(pPvt->interruptCount) > MAX_IRQ) {
				pPvt->regs->risingIntEnable &= ~pendingHigh;
				pPvt->regs->fallingIntEnable &= ~pendingLow;
				pPvt->disabledIntMask = pendingHigh | pendingLow;
#ifdef vxWorks
				if (drvZynqDebug) logMsg("intFunc: disabledIntMask=0x%x\n", pPvt->disabledIntMask);
#endif
			}
		}

		/* Clear the interrupt bits we handled */
		pPvt->regs->risingIntStatus = pendingHigh;
		pPvt->regs->fallingIntStatus = pendingLow;

		/* Generate dummy read cycle for PPC */
		pendingHigh = pPvt->regs->risingIntStatus;

	}
}


/* This function runs in a separate thread.  It waits for the poll
 * time, or an interrupt, whichever comes first.  If the bits read from
 * the Zynq have changed then it does callbacks to all clients that
 * have registered with registerInterruptUser
 */

STATIC void pollerThread(drvZynqPvt *pPvt)
{
	epicsUInt32 newBits32=0;
	epicsUInt16 newBits=0, changedBits=0, interruptMask=0;
	interruptMessage msg;
	ELLLIST *pclientList;
	interruptNode *pnode;
	asynUInt32DigitalInterrupt *pUInt32D;
	int hardware = 0;

	while(1) {
		/*  Wait for an interrupt or for the poll time, whichever comes first */
		if (epicsMessageQueueReceiveWithTimeout(pPvt->msgQId, 
			                                    &msg, sizeof(msg), 
			                                    pPvt->pollTime) == -1) {
			/* The wait timed out, so there was no interrupt, so we need
			 * to read the bits.  If there was an interrupt the bits got
			 * set in the interrupt routine
			 */
			readUInt32D(pPvt, pPvt->pasynUser, &newBits32, 0xffff);
			newBits = newBits32;
			hardware = 0;
			interruptMask = 0;
		} else {
			newBits = msg.bits;
			interruptMask = msg.interruptMask;
			pPvt->interruptCount--;
			if (drvZynqDebug > 5)
				printf("drvZynq:pollerThread: intCount=%d\n", pPvt->interruptCount);
			asynPrint(pPvt->pasynUser, ASYN_TRACE_FLOW,
				"drvZynq:pollerThread, got interrupt for port %s\n", pPvt->portName);
			hardware = 1;
		}
		asynPrint(pPvt->pasynUser, ASYN_TRACEIO_DRIVER,
			"drvZynq:pollerThread, bits=%x\n", newBits);

		/* We detect change both from interruptMask (which only works for
		 * hardware interrupts) and changedBits, which works for polling */
		if (drvZynqDebug) printf("drvZynq:pollerThread: new=0x%x, old=0x%x\n", newBits, pPvt->oldBits);
		if (hardware==0) {
			changedBits = newBits ^ pPvt->oldBits;
			interruptMask = interruptMask & changedBits;
		}
		if (drvZynqDebug)
			printf("drvZynq:pollerThread: hardware=%d, IntMask=0x%x\n", hardware, interruptMask);
		pPvt->oldBits = newBits;

		/*
		 * Process any records that (1) have registered with registerInterruptUser, and (2) that have a mask
		 * value that includes this bit.
		 */
		if (interruptMask) {
			pasynManager->interruptStart(pPvt->interruptPvt, &pclientList);
			pnode = (interruptNode *)ellFirst(pclientList);
			while (pnode) {
				pUInt32D = pnode->drvPvt;
				if ((pUInt32D->mask & interruptMask) && (pUInt32D->pasynUser->reason == 0)) {
					asynPrint(pPvt->pasynUser, ASYN_TRACE_FLOW, "drvZynq:pollerThread, calling client %p"
						" mask=%x, callback=%p\n", pUInt32D, pUInt32D->mask, pUInt32D->callback);
					pUInt32D->callback(pUInt32D->userPvt, pUInt32D->pasynUser, pUInt32D->mask & newBits);
					if (drvZynqDebug) {
						printf("drvZynq:pollerThread: calling client %p\n", pUInt32D);
					}
				}
				pnode = (interruptNode *)ellNext(&pnode->node);
			}
			pasynManager->interruptEnd(pPvt->interruptPvt);
		}
		/* If intFunc disabled any interrupt bits, cause them to show their new states. */
		if (pPvt->disabledIntMask) {
			epicsUInt32 maskBit;
			if (drvZynqDebug)
				printf("drvZynq:pollerThread: disabledIntMask=0x%x\n", pPvt->disabledIntMask);
			pasynManager->interruptStart(pPvt->interruptPvt, &pclientList);
			pnode = (interruptNode *)ellFirst(pclientList);
			while (pnode) {
				pUInt32D = pnode->drvPvt;
				if (pUInt32D->pasynUser->reason == INTERRUPT_EDGE_RESET) {
					if (drvZynqDebug>10) printf("drvZynq:pollerThread: reason == INTERRUPT_EDGE_RESET,mask=0x%x\n", pUInt32D->mask);
					/* The lower bit of pUInt32D->mask is the bit we're actually controlling.  pUInt32D->mask has
					 * the next higher bit also set as part of a kludge to represent states of both falling- and
					 * rising-edge enables, while still indicating the controlled bit.
					 */
					maskBit = pUInt32D->mask & ((pUInt32D->mask)>>1);
					if (maskBit & pPvt->disabledIntMask) {
						asynPrint(pPvt->pasynUser, ASYN_TRACE_FLOW, "drvZynq:pollerThread, calling client %p"
							" mask=%x, callback=%p\n", pUInt32D, pUInt32D->mask, pUInt32D->callback);
						/* Process the record that will show the user we disabled this bit's interrupt capability. */
						pUInt32D->callback(pUInt32D->userPvt, pUInt32D->pasynUser, pUInt32D->mask);
					}
				}
				pnode = (interruptNode *)ellNext(&pnode->node);
			}
			pasynManager->interruptEnd(pPvt->interruptPvt);
			pPvt->disabledIntMask = 0;
		}
	}
}
#endif /* 0 */

/* I don't know what these two functions are for.  I'm just including them because an example did. */
STATIC asynStatus setInterruptUInt32D(void *drvPvt, asynUser *pasynUser, epicsUInt32 mask,
	interruptReason reason)
{
	printf("drvZynq:setInterruptUInt32D: entry mask=%d, reason=%d\n", mask, reason);
	return(0);
}

STATIC asynStatus clearInterruptUInt32D(void *drvPvt, asynUser *pasynUser, epicsUInt32 mask)
{
	printf("drvZynq:clearInterruptUInt32D: entry mask=%d\n", mask);
	return(0);
}

STATIC void rebootCallback(void *drvPvt)
{
	drvZynqPvt *pPvt = (drvZynqPvt *)drvPvt;
	int key = epicsInterruptLock();

	/* Disable interrupts first so no interrupts during reboot */
	if (pPvt->regs) {
		pPvt->regs->risingIntEnable = 0;
		pPvt->regs->fallingIntEnable = 0;
	}
	epicsInterruptUnlock(key);
}

/* asynCommon routines */

/* Report  parameters */
STATIC void report(void *drvPvt, FILE *fp, int details)
{
	drvZynqPvt *pPvt = (drvZynqPvt *)drvPvt;
	interruptNode *pnode;
	ELLLIST *pclientList;

	fprintf(fp, "drvZynq %s: connected at base address %p\n",
		pPvt->portName, pPvt->regs);
	if (details >= 1) {
		fprintf(fp, "  controlRegister=0x%x\n", pPvt->regs->controlRegister);
		fprintf(fp, "  risingMask=0x%x\n", pPvt->risingMask);
		fprintf(fp, "  risingIntEnable=0x%x\n", pPvt->regs->risingIntEnable);
		fprintf(fp, "  fallingMask=0x%x\n", pPvt->fallingMask);
		fprintf(fp, "  fallingIntEnable=0x%x\n", pPvt->regs->fallingIntEnable);
		fprintf(fp, "  messages sent OK=%d; send failed (queue full)=%d\n",
			pPvt->messagesSent, pPvt->messagesFailed);
		pasynManager->interruptStart(pPvt->interruptPvt, &pclientList);
		pnode = (interruptNode *)ellFirst(pclientList);
		while (pnode) {
			asynUInt32DigitalInterrupt *pUInt32D = pnode->drvPvt;
			fprintf(fp, "  uint32Digital callback client address=%p, mask=%x\n",
				pUInt32D->callback, pUInt32D->mask);
			pnode = (interruptNode *)ellNext(&pnode->node);
		}
		pasynManager->interruptEnd(pPvt->interruptPvt);
	 }
}

/* Connect */
STATIC asynStatus connect(void *drvPvt, asynUser *pasynUser)
{
	pasynManager->exceptionConnect(pasynUser);
	return(asynSuccess);
}

/* Connect */
STATIC asynStatus disconnect(void *drvPvt, asynUser *pasynUser)
{
	pasynManager->exceptionDisconnect(pasynUser);
	return(asynSuccess);
}

/*** iocsh functions ***/

/* int initZynqIO(const char *portName, 
 *			int msecPoll, int dataDir, int sopcOffset, int interruptVector,
 *			int risingMask, int fallingMask)
 */
STATIC const iocshArg initZynqIOArg0 = { "Port Name",				iocshArgString};
STATIC const iocshArg initZynqIOArg1 = { "msecPoll",				iocshArgInt};
STATIC const iocshArg initZynqIOArg2 = { "Data Dir Reg",			iocshArgInt};
STATIC const iocshArg initZynqIOArg3 = { "AXI_Address",				iocshArgInt};
STATIC const iocshArg initZynqIOArg4 = { "Interrupt Vector",		iocshArgInt};
STATIC const iocshArg initZynqIOArg5 = { "Rising Edge Mask",		iocshArgInt};
STATIC const iocshArg initZynqIOArg6 = { "Falling Edge Mask",	iocshArgInt};
STATIC const iocshArg * const initZynqIOArgs[7] = {&initZynqIOArg0, &initZynqIOArg1, &initZynqIOArg2,
	&initZynqIOArg3, &initZynqIOArg4, &initZynqIOArg5, &initZynqIOArg6};
STATIC const iocshFuncDef initZynqIOFuncDef = {"initZynqIO",7,initZynqIOArgs};
STATIC void initZynqIOCallFunc(const iocshArgBuf *args) {
	initZynqIO(args[0].sval, args[1].ival, args[2].ival, args[3].ival, args[4].ival, args[5].ival,
	            args[6].ival);
}

/* int initZynqSingleRegisterPort(const char *portName, int AXI_BaseAddress) */
STATIC const iocshArg initSRArg0 = { "Port name",			iocshArgString};
STATIC const iocshArg initSRArg1 = { "AXI base address",	iocshArgInt};
STATIC const iocshArg * const initSRArgs[2] = {&initSRArg0, &initSRArg1};
STATIC const iocshFuncDef initSRFuncDef = {"initZynqSingleRegisterPort",2,initSRArgs};
STATIC void initSRCallFunc(const iocshArgBuf *args) {
	initZynqSingleRegisterPort(args[0].sval, args[1].ival);
}

/* int initZynqIP(char filename) */
STATIC const iocshArg initZynqIPArg1 = { "Filename",	iocshArgString};
STATIC const iocshArg * const initZynqIPArgs[1] = {&initZynqIPArg1};
STATIC const iocshFuncDef initZynqIPFuncDef = {"initZynqIP",1,initZynqIPArgs};
STATIC void initZynqIPCallFunc(const iocshArgBuf *args) {
	initZynqIP(args[0].sval);
}


void ZynqRegister(void)
{
	iocshRegister(&initZynqIOFuncDef,initZynqIOCallFunc);
	iocshRegister(&initSRFuncDef,initSRCallFunc);
	iocshRegister(&initZynqIPFuncDef,initZynqIPCallFunc);
}

epicsExportRegistrar(ZynqRegister);

