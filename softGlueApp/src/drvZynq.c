/* Copyright (c) 2016 UChicago Argonne LLC, as Operator of Argonne
 * National Laboratory, and The Regents of the University of California, as
 * Operator of Los Alamos National Laboratory.
 * softGlueZynq is distributed subject to a Software License Agreement found
 * in the file LICENSE that is included with this distribution.
 */

/* drvZynq.cc

    Original Author: Marty Smith (as drvIp1k125.c)
    Modified: Tim Mooney (as drvIP_EP201.c)
	Modified: Tim Mooney for use on Xilinx Zynq 


    This is the driver for softGlue on Xilinx Zynq.

	This driver cooperates with specific firmware loaded into the Zynq FPGA. The
	firmware includes an AXI4 Lite peripheral, which makes registers implemented
	in the FPGA look like memory locations. Additional firmware connects those
	registers with custom components, such as AND gates, flip flops, etc.

	Interrupt support: softGlue_300IO_v1_0_S_AXI_INTR.v
	0:	Global interrupt enable register (LSB)
	1:	Interrupt enable register
	2:	Interrupt status register (read only)
	3:	Interrupt acknowledgement register
	4:	Interrupt pending register (read only)
	

        1) interruptControlRegisterSet component

           A set of registers defined by 'interruptControlRegisterSet'
           below.  This register set provides interrupt support.

        2) single 8-bit register component

		   This is just a plain 8-bit or 32-bit register, which can be written
		   to or read.  This driver doesn't know or care what the register might
		   be connected to inside the FPGA.

	The interruptControlRegisterSet component is initialized by a call to
    initZynqInterrupts().  This routine defines a new asyn port, connects an
	interrupt-service routine, and launches a thread.

	Single 8-bit register components are all served by a single asyn port. 
	Users of this port must indicate the  register they want to read or write in
	their asynUser structure. Records do this by including the address in the
	definition of the record's OUT or INP field.  For example, the ADDR macro in
	the following field definition should be set to indicate (via syntax that
	has yet to be determined) the register's address:
	field(OUT,"@asynMask($(PORT),$(ADDR),0x2f)")

	Dynamic clock frequencies:
	VCO Frequency = (Input Frequency) * (CLKFBOUT_MULT)/DIVCLK_DIVIDE
	Input frequency is 50 MHz (FCLK_CLK3)
	clock config registers:
		0x43c50200	softGlue register clock (100 MHz)
		0x43c50204	sg_in045	"50MHZ_CLOCK"
		0x43c50208	sg_in046	"20MHZ_CLOCK"
		0x43c5020c	sg_in047	"10MHZ_CLOCK"
		0x43c50210	gateDelayFast, fHistoScaler	(250 MHz)
*/



/* System includes */
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>

#include <stddef.h>
#include <stdio.h>
#include <sys/types.h>

#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <sys/stat.h>

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

/* drvParams */
#define REG8					0	/* drvParam <none> */
#define INTERRUPT_EDGE			1	/* drvParam INTEDGE */
#define INTERRUPT_EDGE_RESET	2	/* drvParam INT_EDGE_RESET */
#define REG32					3	/* drvParam REG32 */

typedef struct {
    epicsUInt32 globalEnable;
    epicsUInt32 risingIntEnable;
    epicsUInt32 risingIntStatus;
    epicsUInt32 acknowledge;
    epicsUInt32 pending;
	/* These aren't in the Xilinx generated AXI component, but I might add them */
    /* epicsUInt32 fallingIntStatus; */
    /* epicsUInt32 fallingIntEnable; */
} interruptControlRegisterSet;

typedef struct {
    epicsUInt32 risingMask;
    epicsUInt32 fallingMask;
} interruptMessage;

typedef struct {
	volatile epicsUInt32 *mem;	/* AXI mapped address */
	int AXI_Address;
    char *portName;
    asynUser *pasynUser;
    epicsUInt32 oldBits;
    epicsUInt32 risingMask;
    epicsUInt32 fallingMask;
    volatile interruptControlRegisterSet *regs;
    epicsMessageQueueId msgQId;
    int messagesSent;
    int messagesFailed;
    asynInterface common;
	asynInterface asynDrvUser;
    asynInterface uint32D;
    asynInterface int32;
    void *interruptPvt;
    epicsUInt16 disabledIntMask;    /* int enable rescinded because too many interrupts received */
} drvZynqPvt;

/*
 * Pointer to drvZynqPvt structure
 */
#define MAX_DRVPVT 10
STATIC int numDriverTables=0;
STATIC drvZynqPvt *driverTable[MAX_DRVPVT] = {0};

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
    NULL,         /* registerInterruptUser: default adds user to dispatchThread's clientList. */
    NULL          /* cancelInterruptUser: default removes user from dispatchThread's clientList. */
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
STATIC void dispatchThread	(drvZynqPvt *pPvt);
STATIC void rebootCallback	(void *);

/* the following is for the original mmap() strategy, which requires us to run as root */
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

/* the following is for the generic-uio mmap() strategy, which does not require us to run as root */
int foundUIO = 0;
UIO_struct *UIO[MAX_UIO] = {0};

int findUioAddr(const char *componentName, int map) {
	int i, uio_fd, match;
	FILE *uioName_fd;
	char name[UIO_NAMELEN], uioFileName[UIO_NAMELEN], uioDevName[UIO_NAMELEN];
	volatile epicsUInt32 *addr;
	volatile epicsUInt32 *localAddr;
	UIO_struct *pUIO = NULL;
	epicsUInt32 iaddr;

	/* first, see if we've already done this */
	for (i=0; i<foundUIO; i++) {
		pUIO = UIO[i];
		if ((strncmp(pUIO->componentName, componentName, strlen(componentName))==0) &&
				(pUIO->map == map)) {
			if (drvZynqDebug) {
				printf("findUioAddr: using previously mapped UIO for component '%s', map %d, addr=%p\n",
					componentName, map, pUIO->localAddr);
			}
			return(i);
		}
	}

	/* find the uio whose name matches */
	match = -1;
	for (i=0; i<MAX_UIO && match==-1; i++) {
	  	sprintf(uioFileName, "/sys/class/uio/uio%d/name", i);
		uioName_fd = fopen(uioFileName, "r");
		if (uioName_fd==NULL) {
			printf("findUioAddr: Failed to open '%s'\n", uioFileName);
			return(-1);
		}
		fgets(name, UIO_NAMELEN-1, uioName_fd);
		name[strlen(name)-1] = '\0'; /* strip \n */
		if (drvZynqDebug>=10) printf("findUioAddr: uio%d.name='%s'\n", i, name);
		if (strncmp(name, componentName, strlen(componentName))==0) {
			match = i;
			if (drvZynqDebug) printf("findUioAddr: name matches, match=%d\n", match);
		}
		fclose(uioName_fd);
	}

	if (match == -1) {
		printf("findUioAddr: no match; nothing done\n");
		return(-1);
	}

	/* get base address, just for reporting */
	sprintf(uioFileName, "/sys/class/uio/uio%d/maps/map%d/addr", match, map);
	uioName_fd = fopen(uioFileName, "r");
	if (uioName_fd==NULL) {
		printf("findUioAddr: Failed to open '%s'\n", uioFileName);
		return(-1);
	}
	fscanf(uioName_fd, "%x", &iaddr);
	addr = (volatile epicsUInt32 *)iaddr;
	if (drvZynqDebug) printf("findUioAddr: uio%d addr=%p\n", match, (void *)addr);
	fclose(uioName_fd);

	/* Open UIO, and keep it open.  User can access mapped memory only as long as this is open. */
	sprintf(uioDevName, "/dev/uio%d", match);
	uio_fd = open(uioDevName,O_RDWR|O_SYNC);
	if (uio_fd < 0) {
		epicsPrintf("Can't open '%s'\n", uioDevName);
		return(-1);
	}

	localAddr = (volatile epicsUInt32 *) mmap(0,1024,PROT_READ|PROT_WRITE,MAP_SHARED,uio_fd,map*getpagesize());
	if (localAddr == NULL) {
		epicsPrintf("findUioAddr: mmap() failed for component '%s', map %d\n",componentName, map);
	}
	else {
		epicsPrintf("findUioAddr: mmap() succeeded for component '%s', map %d\n",componentName, map);
		epicsPrintf("findUioAddr: %p mapped to %p\n", (void *)addr, (void *)localAddr);
	}

	/* Copy everything to UIO array */
	if (foundUIO < MAX_UIO) {
		foundUIO++;
		pUIO = callocMustSucceed(1, sizeof(UIO_struct), "UIO_struct");
		UIO[foundUIO-1] = pUIO;

		strncpy(pUIO->componentName, componentName, UIO_NAMELEN-1);
		pUIO->map = map;
		strncpy(pUIO->uioDevName, uioDevName, UIO_NAMELEN-1);
		strncpy(pUIO->uioFileName, uioFileName, UIO_NAMELEN-1);
		strncpy(pUIO->uioDevName, uioDevName, UIO_NAMELEN-1);
		pUIO->addr = addr;
		pUIO->localAddr = localAddr;
		pUIO->uioName_fd = uioName_fd;
		pUIO->uio_fd = uio_fd;
	
		return(foundUIO-1);
	} else {
		return(-1);
	}
}

/* Init interrupt-control register set (contained in AXI4 Lite peripheral) */
int initZynqInterrupts(const char *portName, const char *componentName) {

	drvZynqPvt *pPvt;
	int i, status;
	char threadName[80] = "";
	UIO_struct *pUIO = NULL;

	pPvt = callocMustSucceed(1, sizeof(*pPvt), "initZynqInterrupts");
	pPvt->portName = epicsStrDup(portName);

	pPvt->msgQId = epicsMessageQueueCreate(MAX_MESSAGES, sizeof(interruptMessage));

	i = findUioAddr("softGlue_", 1);
	if (i >= 0) {
		pUIO = UIO[i];
		pPvt->mem = pUIO->localAddr;
	} else {
		pPvt->mem = NULL;
	}
	if (pPvt->mem == NULL) {
		printf("initZynqInterrupts: mmap() failed for 'softGlue_' map 1\n");
	}
	pPvt->regs = (interruptControlRegisterSet *) ((char *)(pPvt->mem));
	if (drvZynqDebug>5) {
		printf("drvZynq:initZynqInterrupts: pPvt = %p\n", pPvt);
		printf("drvZynq:initZynqInterrupts: pPvt->regs = %p\n", pPvt->regs);
		printf("drvZynq:initZynqInterrupts: &pPvt->regs->risingIntEnable = %p\n", &pPvt->regs->risingIntEnable);
	}
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
		printf("initZynqInterrupts: ERROR: Can't register port\n");
		return(-1);
	}
	status = pasynManager->registerInterface(pPvt->portName,&pPvt->common);
	if (status != asynSuccess) {
		printf("initZynqInterrupts: ERROR: Can't register common.\n");
		return(-1);
	}
	status = pasynManager->registerInterface(pPvt->portName,&pPvt->asynDrvUser);
	if (status != asynSuccess){
		printf("initZynqInterrupts: ERROR: Can't register asynDrvUser.\n");
		return(-1);
	}
	status = pasynUInt32DigitalBase->initialize(pPvt->portName, &pPvt->uint32D);
	if (status != asynSuccess) {
		printf("initZynqInterrupts: ERROR: Can't register UInt32Digital.\n");
		return(-1);
	}
	pasynManager->registerInterruptSource(pPvt->portName, &pPvt->uint32D,
	                                      &pPvt->interruptPvt);

	status = pasynInt32Base->initialize(pPvt->portName,&pPvt->int32);
	if (status != asynSuccess) {
		printf("initZynqInterrupts: ERROR: Can't register Int32.\n");
		return(-1);
	}

	/* Create asynUser for asynTrace */
	pPvt->pasynUser = pasynManager->createAsynUser(0, 0);
	pPvt->pasynUser->userPvt = pPvt;

	/* Connect to device */
	status = pasynManager->connectDevice(pPvt->pasynUser, pPvt->portName, 0);
	if (status != asynSuccess) {
		printf("initZynqInterrupts: connectDevice failed %s\n",
			pPvt->pasynUser->errorMessage);
		return(-1);
	}

	/* Start the thread to handle interrupt callbacks to device support */
	strcat(threadName, "Zynq");
	strcat(threadName, portName);
	epicsThreadCreate(threadName, epicsThreadPriorityHigh,
		epicsThreadGetStackSize(epicsThreadStackBig),
		(EPICSTHREADFUNC)dispatchThread, pPvt);

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
int initZynqSingleRegisterPort(const char *portName, const char *componentName)
{
	drvZynqPvt *pPvt;
	int i, status;
	UIO_struct *pUIO = NULL;

	pPvt = callocMustSucceed(1, sizeof(*pPvt), "drvZynqPvt");
	driverTable[numDriverTables++] = pPvt;	/* save pointers for softGlueRegisterInterruptRoutine() */
	pPvt->portName = epicsStrDup(portName);

	/* Set up address */
	i = findUioAddr(componentName, 0);
	if (i >= 0) {
		pUIO = UIO[i];
		pPvt->mem = pUIO->localAddr;
	} else {
		pPvt->mem = NULL;
	}

	if (pPvt->mem == NULL) {
		printf("initZynqSingleRegisterPort: mmap() failed for '%s' map 0\n", componentName);
	}
	else printf("initZynqSingleRegisterPort: mmap() succeded for '%s' map 0\n", componentName);

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
		printf("initZynqInterrupts: ERROR: Can't register asynDrvUser.\n");
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

/*
 * softGlueZCalcSpecifiedRegisterAddress - For access to a single-register component by
 * other than an EPICS record (for example, by an interrupt-service routine).
 * The AXI and word offset are specified as arguments, and we need
 * to translate that information into a memory mapped address, as calcRegister32Address()
 * would have done for an EPICS record.
 */
epicsUInt32 *softGlueZCalcSpecifiedRegisterAddress(int type, int addr)
{
	drvZynqPvt *pPvt;
	epicsUInt8 *reg8;
	epicsUInt32 *reg32;
	epicsUInt32 *reg;

	if (type==0) {
		pPvt = driverTable[0];
		reg8 = (epicsUInt8 *)pPvt->mem;
		reg8 += addr;
		reg = (epicsUInt32 *)reg8;
	} else {
		pPvt = driverTable[1];
		reg32 = (epicsUInt32 *)pPvt->mem;
		reg32 += addr;
		reg = reg32;
	}
	return(reg);
}

/*
 * readUInt32D
 * This method provides masked read access to the readDataRegister of a
 * single register component.  
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
	asynPrint(pasynUser, ASYN_TRACEIO_DRIVER,
		"drvZynq::readUInt32D, value=0x%X, mask=0x%X\n", *value,mask);
	return(asynSuccess);
}

/*
 * writeUInt32D
 * This method provides bit level write access to the writeDataRegister of a
 * single register component.  Bits of 'value' that correspond to zero bits of 'mask' will
 * be ignored -- corresponding bits of the destination register will be left
 * as they were before the write operation.  
 */
STATIC asynStatus writeUInt32D(void *drvPvt, asynUser *pasynUser, epicsUInt32 value,
	epicsUInt32 mask)
{
	drvZynqPvt *pPvt = (drvZynqPvt *)drvPvt;
	volatile epicsUInt32 *reg32=0;
	volatile epicsUInt8 *reg8=0;
	int addr;

	if (drvZynqDebug >= 5) {
		printf("drvZynq:writeUInt32D: port='%s', reason=%d, pPvt=%p\n", pPvt->portName, pasynUser->reason, pPvt);
	}
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
	} else if (pasynUser->reason == REG8) {
		/* 8-bit register (addr must be a byte offset) */
		reg8 = (epicsUInt8 *)pPvt->mem;
		reg8 += addr;
		if (drvZynqDebug >= 5) printf("drvZynq:writeUInt32D: softGlue reg8 address=%p\n", reg8);
		*reg8 = (*reg8 & ~mask) | (epicsUInt8) (value & mask);
		asynPrint(pasynUser, ASYN_TRACEIO_DRIVER,
			"drvZynq::writeUInt32D, addr=%p, value=0x%X, mask=0x%X, reason=%d\n",
				reg8, value, mask, pasynUser->reason);
	} else if (pasynUser->reason == INTERRUPT_EDGE) {
		if (drvZynqDebug>5) {
			printf("drvZynq:writeUInt32D: for INTERRUPT_EDGE:  pPvt = %p\n", pPvt);
			printf("drvZynq:writeUInt32D: for INTERRUPT_EDGE: pPvt->regs = %p\n", pPvt->regs);
			printf("drvZynq:writeUInt32D: for INTERRUPT_EDGE: &pPvt->regs->risingIntEnable = %p\n", &pPvt->regs->risingIntEnable);
		}
		reg32 = (epicsUInt32 *)&pPvt->regs->risingIntEnable;
		if (drvZynqDebug >= 5) printf("drvZynq:writeUInt32D: softGlue reg32 address=%p\n", reg32);
		*reg32 = (*reg32 & ~mask) | (value & mask);
		asynPrint(pasynUser, ASYN_TRACEIO_DRIVER,
			"drvZynq::writeUInt32D, addr=%p, value=0x%X, mask=0x%X, reason=%d\n",
				reg32, value, mask, pasynUser->reason);
	} else {
		if (drvZynqDebug >= 5) printf("drvZynq:writeUInt32D: no code for reason %d\n", pasynUser->reason);
	}


	return(asynSuccess);
}

/*
 * readInt32
 * This method reads from the readDataRegister of a single register component.  
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
	} else if (pasynUser->reason == INTERRUPT_EDGE_RESET) {
		*value = pPvt->disabledIntMask;
	}

	asynPrint(pasynUser, ASYN_TRACEIO_DRIVER,
		"drvZynq::readInt32, value=0x%X\n", *value);
	return(asynSuccess);
}

/* writeInt32
 * This method writes to the writeDataRegister of a single register component.  
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

/***********************************************************************
 * Manage a table of registered interrupt-service routines to be called
 * at interrupt level.  This is not the normal softGlue interrupt mechanism;
 * it's for interrupts that will occur at too high a frequency, or too
 * close together in time, for that mechanism to handle.
 */

/* table of registered routines for execution at interrupt level */
#define MAXROUTINES 10

typedef struct {
	epicsUInt32 risingMask;
	epicsUInt32 fallingMask;
	void (*routine)(softGlueIntRoutineData *IRData);
	softGlueIntRoutineData IRData;
} intRoutineEntry;

STATIC intRoutineEntry registeredIntRoutines[MAXROUTINES] = {{0}};
STATIC int numRegisteredIntRoutines=0;

/* Register a routine to be called when a specified
 * I/O bit (mask) generates an interrupt.
 * example invocation:
 *      void callMe(softGlueIntRoutineData *IRData);
 *		myDataType myData;
 *      softGlueRegisterInterruptRoutine(0x1, 0x0, callMe, (void *)&myData);
 */
int softGlueRegisterInterruptRoutine(epicsUInt32 risingMask, epicsUInt32 fallingMask,
	void (*routine)(softGlueIntRoutineData *IRData), void *userPvt) {

	if (numRegisteredIntRoutines >= MAXROUTINES-1) return(-1);
	registeredIntRoutines[numRegisteredIntRoutines].risingMask = risingMask;
	registeredIntRoutines[numRegisteredIntRoutines].fallingMask = fallingMask;
	registeredIntRoutines[numRegisteredIntRoutines].routine = routine;
	registeredIntRoutines[numRegisteredIntRoutines].IRData.userPvt = userPvt;

	if (drvZynqDebug>5) printf("softGlueRegisterInterruptRoutine: #%d, risingMask=0x%x, fallingMask=0x%x",
	  numRegisteredIntRoutines, risingMask, fallingMask);
	numRegisteredIntRoutines++;
	return(0);
}

/* This function runs in a separate thread.  It waits for an interrupt. */
volatile int drvZynqISRState = 0;
epicsExportAddress(int, drvZynqISRState);

STATIC void dispatchThread(drvZynqPvt *pPvt)
{
	epicsUInt32 risingMask=0, fallingMask=0;
	ELLLIST *pclientList;
	interruptNode *pnode;
	asynUInt32DigitalInterrupt *pUInt32D;
	int handled;

	int pending = 0;
	int reenable = 1;
	int i, uio_fd;
	volatile epicsUInt32 *localAddr;
	UIO_struct *pUIO = NULL;

	/* initialize interrupt infrastructure */
	drvZynqISRState = 0;

	/* Make sure we have UIO */
	uio_fd = 0;

	i = findUioAddr("softGlue_", 0);
	if (i >= 0) {
		pUIO = UIO[i];
		localAddr = pUIO->localAddr;
		uio_fd = pUIO->uio_fd;
	} else {
		localAddr = NULL;
		uio_fd = 0;
	}


	if (localAddr == 0) {
		printf("drvZynq:dispatchThread: findUioAddr() failed\n");
		return;
	}

	if (uio_fd == 0) {
		printf("drvZynq:dispatchThread: uio_fd==0\n");
		return;
	}

	drvZynqISRState = 1;

/*** SHOULD USE LOCALADDR? ***/
	/* enable interrupt generation in FPGA */
	pPvt->regs->globalEnable = 1;
	//pPvt->regs->risingIntEnable = 0xffffffff;
	while(1) {

		/*  Enable interrupts */
		drvZynqISRState = 2;
		if (drvZynqDebug) printf("drvZynq:dispatchThread: enabling interrupts\n");
		write(uio_fd, (void *)&reenable, sizeof(int));

		drvZynqISRState = 3;
		/*  Wait for an interrupt */
		if (drvZynqDebug) printf("drvZynq:dispatchThread: calling read(uio_fd...)\n");
		i = read(uio_fd, (void *)&pending,sizeof(int));
		if (drvZynqDebug) printf("drvZynq:dispatchThread: read(uio_fd...) returned %d\n", i);

		drvZynqISRState = 4;
		/* Respond to interrupt */
		if (drvZynqDebug) {
			printf("drvZynq:dispatchThread: responding to interrupt\n");
			printf("\trisingIntStatus=0x%x, risingIntEnable=0x%x\n", pPvt->regs->risingIntStatus, pPvt->regs->risingIntEnable);
			// printf("\tfallingIntStatus=0x%x, fallingIntEnable=0x%x\n", pPvt->regs->fallingIntStatus, pPvt->regs->fallingIntEnable);
		}

		risingMask = pPvt->regs->risingIntStatus & pPvt->regs->risingIntEnable;
		//fallingMask = pPvt->regs->fallingIntStatus & pPvt->regs->fallingIntEnable;

		asynPrint(pPvt->pasynUser, ASYN_TRACE_FLOW,
			"drvZynq:dispatchThread, got interrupt for port %s\n", pPvt->portName);
		asynPrint(pPvt->pasynUser, ASYN_TRACEIO_DRIVER,
			"drvZynq:dispatchThread, risingMask=%x\n", risingMask);


		/* Go through registeredIntRoutines[] for a registered interrupt-level service routine. If one is found,
		 * call it and mark the interrupt as "handled", so we don't queue any EPICS processing that
		 * might also be attached to the interrupt.  (The whole purpose of this mechanism is to
		 * handle interrupts at intervals EPICS would not be able to meet.) */
		for (i=0, handled=0; i<numRegisteredIntRoutines; i++) {
			if ((risingMask & registeredIntRoutines[i].risingMask) || (fallingMask & registeredIntRoutines[i].fallingMask)) {
				if (drvZynqDebug>5) printf("intFunc: calling registered interrupt routine %p\n", registeredIntRoutines[i].routine);
				registeredIntRoutines[i].IRData.risingMask = risingMask;
				//registeredIntRoutines[i].IRData.fallingMask = fallingMask;
				//registeredIntRoutines[i].IRData.wentLow = pPvt->regs->fallingIntStatus & pPvt->regs->fallingIntEnable;
				registeredIntRoutines[i].IRData.wentHigh = pPvt->regs->risingIntStatus & pPvt->regs->risingIntEnable;
				registeredIntRoutines[i].routine(&(registeredIntRoutines[i].IRData));
				handled = 1;
			}
		}


		drvZynqISRState = 5;
		if (!handled) {
			drvZynqISRState = 6;
			if (drvZynqDebug)
				printf("drvZynq:dispatchThread: IntMask=0x%x\n", risingMask);

			/*
			 * Process any records that (1) have registered with registerInterruptUser, and (2) that have a mask
			 * value that includes this bit.
			 */
			if (risingMask) {
				pasynManager->interruptStart(pPvt->interruptPvt, &pclientList);
				pnode = (interruptNode *)ellFirst(pclientList);
				while (pnode) {
					pUInt32D = pnode->drvPvt;
					if ((pUInt32D->mask & risingMask) && (pUInt32D->pasynUser->reason == 0)) {
						asynPrint(pPvt->pasynUser, ASYN_TRACE_FLOW, "drvZynq:dispatchThread, calling client %p"
							" mask=%x, callback=%p\n", pUInt32D, pUInt32D->mask, pUInt32D->callback);
						pUInt32D->callback(pUInt32D->userPvt, pUInt32D->pasynUser, pUInt32D->mask & risingMask);
						if (drvZynqDebug) {
							printf("drvZynq:dispatchThread: calling client %p\n", pUInt32D);
						}
					}
					pnode = (interruptNode *)ellNext(&pnode->node);
				}
				pasynManager->interruptEnd(pPvt->interruptPvt);
			}

			drvZynqISRState = 7;
			/* If intFunc disabled any interrupt bits, cause them to show their new states. */
			if (pPvt->disabledIntMask) {
				epicsUInt32 maskBit;
				if (drvZynqDebug)
					printf("drvZynq:dispatchThread: disabledIntMask=0x%x\n", pPvt->disabledIntMask);
				pasynManager->interruptStart(pPvt->interruptPvt, &pclientList);
				pnode = (interruptNode *)ellFirst(pclientList);
				while (pnode) {
					pUInt32D = pnode->drvPvt;
					if (pUInt32D->pasynUser->reason == INTERRUPT_EDGE_RESET) {
						if (drvZynqDebug>10) printf("drvZynq:dispatchThread: reason == INTERRUPT_EDGE_RESET,mask=0x%x\n", pUInt32D->mask);
						/* The lower bit of pUInt32D->mask is the bit we're actually controlling.  pUInt32D->mask has
						 * the next higher bit also set as part of a kludge to represent states of both falling- and
						 * rising-edge enables, while still indicating the controlled bit.
						 */
						maskBit = pUInt32D->mask & ((pUInt32D->mask)>>1);
						if (maskBit & pPvt->disabledIntMask) {
							asynPrint(pPvt->pasynUser, ASYN_TRACE_FLOW, "drvZynq:dispatchThread, calling client %p"
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

		drvZynqISRState = 8;
		/* Clear the interrupt bits we handled (should handle more than one simultaneously asserted interrupt bit) */
		pPvt->regs->acknowledge = pPvt->regs->risingIntStatus;
	}
}

int debugISR(int dummy)
{
	int pending = 0;
	int reenable = 1;
	int uio_fd;
	FILE *uioName_fd;
	char name[100];

	/* Make sure we have UIO */
	uioName_fd = fopen("/sys/class/uio/uio0/name", "r");
	if (uioName_fd==NULL) {
		printf("drvZynq:dispatchThread: Failed to open /sys/class/uio/uio0/name\n");
		return(0);
	}
	fgets(name, 100, uioName_fd);
	if (drvZynqDebug) printf("drvZynq:debugISR: uio0.name='%s'\n", name);
	fclose(uioName_fd);

	uio_fd = open("/dev/uio0", O_RDWR);

	while(1) {

		/*  Enable interrupts */
		if (drvZynqDebug) printf("drvZynq:dispatchThread: enabling interrupts\n");
		write(uio_fd, (void *)&reenable, sizeof(int));

		/*  Wait for an interrupt */
		if (drvZynqDebug) printf("drvZynq:dispatchThread: calling read(uio_fd...)\n");
		read(uio_fd, (void *)&pending,sizeof(int));
		if (drvZynqDebug) printf("drvZynq:dispatchThread: read returned. pending=%d\n", pending);
	}
	return(0);
}	

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
		/* pPvt->regs->fallingIntEnable = 0; */
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
		fprintf(fp, "  controlRegister=0x%x\n", pPvt->regs->globalEnable);
		fprintf(fp, "  risingIntEnable=0x%x\n", pPvt->regs->risingIntEnable);
		fprintf(fp, "  risingMask=0x%x\n", pPvt->risingMask);
		/* fprintf(fp, "  fallingMask=0x%x\n", pPvt->fallingMask); */
		/* fprintf(fp, "  fallingIntEnable=0x%x\n", pPvt->regs->fallingIntEnable); */
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

/* test speed of reading from FPGA register */
int testReadSpeed(int numReads) {
	volatile epicsUInt32 *mem = NULL;
	epicsUInt32 reg32=0, first, last;
	int i;
	epicsTimeStamp  timeStart, timeEnd;
	UIO_struct *pUIO = NULL;

	i = findUioAddr("softGlue_", 0);
	if (i >= 0) {
		pUIO = UIO[i];
		mem = pUIO->localAddr;
	}

	epicsTimeGetCurrent(&timeStart);
	first = *mem;
	for (i=0; i<numReads; i++) {
		reg32 = *mem;
	}
	last = reg32;
	epicsTimeGetCurrent(&timeEnd);
	printf("elapsed time = %.5f s (%d, %d)\n\n",
		epicsTimeDiffInSeconds(&timeEnd, &timeStart), first, last);
	return(0);
}

/* test user I/O interrupt */
int testUIO(epicsUInt32 AXI_Address, int numInts) {
	int pending = 0;
	int reenable = 1;
	int i, uio_fd;
	volatile epicsUInt32 *mem = NULL;
	volatile epicsUInt32 *mem_enable, *m_status, *m_ack, *m_pending;
	UIO_struct *pUIO = NULL;

	i = findUioAddr("softGlue_", 1);
	if (i >= 0) {
		pUIO = UIO[i];
		mem = pUIO->localAddr;
		uio_fd = pUIO->uio_fd;
	}
	if (mem==NULL) {
	  printf("Can't map interrupt-control registers\n");
	  return(0);
	}

	mem_enable = (epicsUInt32 *)mem;
	mem_enable += 1;
	*mem_enable = 0xffffffff;

	m_status = (epicsUInt32 *)mem;
	m_status += 2;	 /* interrupt-status register */
	m_ack = (epicsUInt32 *)mem;
	m_ack += 3;  /* address to write to to acknowledge interrupt */
	m_pending = (epicsUInt32 *)mem;
	m_pending += 4;	 /* interrupt-pending register */
	/* printf("testUIO: mem=0x%x, m_status=0x%x, m_ack=0x%x\n", mem, m_status, m_ack); */

	uio_fd = open("/dev/uio0", O_RDWR);
	printf("testUIO: enabling interrupts\n");
	write(uio_fd, (void *)&reenable, sizeof(int));
	for (i=0; i<numInts; i++) {
		printf("testUIO: calling read(uio_fd...)\n");
		read(uio_fd, (void *)&pending,sizeof(int));
		printf("testUIO: read(uio_fd...) returned\n");
		printf("testUIO: (before ack) *m_status=0x%x, *m_pending=0x%x\n", *m_status, *m_pending);
		/* acknowledge interrupt (all of them, if more than one) */
		*m_ack = *m_status; 
		printf("testUIO: (after ack) *m_status=0x%x, *m_pending=0x%x\n", *m_status, *m_pending);

		write(uio_fd, (void *)&reenable, sizeof(int));
	}
	return(0);
}

/*** iocsh functions ***/
/* int testUIO(epicsUInt32 addr, int numReads) */
STATIC const iocshArg testUIOArg0 = { "address", iocshArgInt};
STATIC const iocshArg testUIOArg1 = { "numReads",	iocshArgInt};

STATIC const iocshArg * const testUIOArgs[2] = {&testUIOArg0, &testUIOArg1};
STATIC const iocshFuncDef testUIOFuncDef = {"testUIO",2,testUIOArgs};
STATIC void testUIOCallFunc(const iocshArgBuf *args) {
	testUIO(args[0].ival, args[1].ival);
}

/* int testReadSpeed(int numReads) */
STATIC const iocshArg testReadSpeedArg0 = { "numReads",	iocshArgInt};

STATIC const iocshArg * const testReadSpeedArgs[1] = {&testReadSpeedArg0};
STATIC const iocshFuncDef testReadSpeedFuncDef = {"testReadSpeed",1,testReadSpeedArgs};
STATIC void testReadSpeedCallFunc(const iocshArgBuf *args) {
	testReadSpeed(args[0].ival);
}

/* int initZynqInterrupts(const char *portName, const char *componentName)
 */
STATIC const iocshArg initZynqInterruptsArg0 = { "Port Name",				iocshArgString};
STATIC const iocshArg initZynqInterruptsArg1 = { "componentName",			iocshArgString};
STATIC const iocshArg * const initZynqInterruptsArgs[2] = {&initZynqInterruptsArg0, &initZynqInterruptsArg1};
STATIC const iocshFuncDef initZynqInterruptsFuncDef = {"initZynqInterrupts",2,initZynqInterruptsArgs};
STATIC void initZynqInterruptsCallFunc(const iocshArgBuf *args) {
	initZynqInterrupts(args[0].sval, args[1].sval);
}

/* int initZynqSingleRegisterPort(const char *portName, const char *componentName) */
STATIC const iocshArg initSRArg0 = { "Port name",			iocshArgString};
STATIC const iocshArg initSRArg1 = { "componentName",		iocshArgString};
STATIC const iocshArg * const initSRArgs[2] = {&initSRArg0, &initSRArg1};
STATIC const iocshFuncDef initSRFuncDef = {"initZynqSingleRegisterPort",2,initSRArgs};
STATIC void initSRCallFunc(const iocshArgBuf *args) {
	initZynqSingleRegisterPort(args[0].sval, args[1].sval);
}

/* int debugISR(int dummy) */
STATIC const iocshArg debugISRArg0 = { "dummy",			iocshArgInt};
STATIC const iocshArg * const debugISRArgs[1] = {&debugISRArg0};
STATIC const iocshFuncDef debugISRFuncDef = {"debugISR",1,debugISRArgs};
STATIC void debugISRCallFunc(const iocshArgBuf *args) {
	debugISR(args[0].ival);
}

void ZynqRegister(void)
{
	iocshRegister(&initZynqInterruptsFuncDef,initZynqInterruptsCallFunc);
	iocshRegister(&initSRFuncDef,initSRCallFunc);
	iocshRegister(&testReadSpeedFuncDef,testReadSpeedCallFunc);
	iocshRegister(&testUIOFuncDef,testUIOCallFunc);
	iocshRegister(&debugISRFuncDef,debugISRCallFunc);
}

epicsExportRegistrar(ZynqRegister);

