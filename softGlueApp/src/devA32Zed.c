/* Copyright (c) 2016 UChicago Argonne LLC, as Operator of Argonne
 * National Laboratory, and The Regents of the University of California, as
 * Operator of Los Alamos National Laboratory.
 * softGlueZynq is distributed subject to a Software License Agreement found
 * in the file LICENSE that is included with this distribution.
 */

/* 	devA32Vme.c ---> devA32Zed.c	*/

/*To Use this device support, Include the following before iocInit */
/* devA32ZedConfig(card,a32base,nreg,iVector,iLevel)  */
/*    card    = card number                           */
/*    a32base = base address of card                  */
/*    nreg    = number of A32 registers on this card  */
/*    iVector = interrupt vector (MRD100 ONLY !!)     */
/*    iLevel  = interrupt level  (MRD100 ONLY !!)     */
/* For Example					      */
/* devA32ZedConfig(0, 0x80000000, 44, 0x3e, 5)        */


 /**********************************************************************/
 /** Brief Description of device support                              **/
 /**						    	              **/
 /** This device support allows access to any register of a ZED       **/
 /** module found in the A32/D32 ZED space. The bit field of interest **/
 /** is described in the PARM field of the INP or OUT link.           **/
 /** This allows a generic driver to be used without hard-coding      **/
 /** register numbers within the software.                            **/
 /**						    	              **/
 /** Record type     Signal #           Parm Field                    **/
 /**                                                                  **/
 /**    ai          reg_offset     lsb, width, type                   **/
 /**    ao          reg_offset     lsb, width, type                   **/
 /**    bi          reg_offset     bit #                              **/
 /**    bo          reg_offset     bit #                              **/
 /**    longin      reg_offset     lsb, width                         **/
 /**    longout     reg_offset     lsb, width                         **/
 /**    mbbi        reg_offset     lsb, width                         **/
 /**    mbbo        reg_offset     lsb, width                         **/
 /**                                                                  **/
 /** reg_offset is specified by the register number (0,1,2,3, etc)    **/
 /** Parm field must be provided, no defaults are assumed ...         **/
 /** In ai and ao type is either 0 - unipolar, 1 -bipolar             **/
 /**                                                                  **/
 /**                                                                  **/
 /**********************************************************************/

#include	<stdlib.h>
#include	<string.h>
#include	<math.h>

#include	<stddef.h>
#include	<stdio.h>
#include	<sys/types.h>

#include	<unistd.h>
#include	<sys/mman.h>
#include	<fcntl.h>
#include	<sys/stat.h>

#include	<alarm.h>
#include	<dbDefs.h>
#include	<dbAccess.h>
#include	<recGbl.h>
#include	<recSup.h>
#include	<devSup.h>
#include	<link.h>

#include	<epicsPrint.h>
#include	<epicsExport.h>
#include 	<iocsh.h>

#include	<aoRecord.h>
#include	<aiRecord.h>
#include	<boRecord.h>
#include	<biRecord.h>
#include	<longinRecord.h>
#include	<longoutRecord.h>
#include	<mbboRecord.h>
#include	<mbbiRecord.h>

#include        <subRecord.h>
#include	<waveformRecord.h>

#include	<dbScan.h>

#include 	<linux/i2c-dev.h>

#define ERROR (-1)

static long init_ai(), read_ai();
static long init_ao(), write_ao();
static long init_bi(), read_bi();
static long init_bo(), write_bo();
static long init_li(), read_li();
static long init_lo(), write_lo();
static long init_mbbi(), read_mbbi();
static long init_mbbo(), write_mbbo();
static long checkCard(), write_card(), read_card();
static long get_bi_int_info();

static long initWfRecord(struct waveformRecord*);
static long readWf(struct waveformRecord*);

static long devA32ZedReport();

int  devA32ZedDebug = 0;
epicsExportAddress(int, devA32ZedDebug);

int  OK = 0;

#define MAX_NUM_CARDS    10
#define MAX_ACTIVE_REGS  256   /* largest register number allowed */
#define MAX_ACTIVE_BITS  32   /* largest bit # expected */
#define MAX_PIXEL 1024

/* Register layout */
typedef struct a32Reg {
  unsigned long reg[MAX_ACTIVE_REGS];
} a32Reg;

typedef struct ioCard {  /* Unique for each card */
  volatile a32Reg  *base;    /* address of this card's registers */
  int               nReg;    /* Number of registers on this card */
  epicsMutexId      lock;    /* semaphore */
  IOSCANPVT         ioscanpvt; /* records to process upon interrupt */
}ioCard;

static struct ioCard cards[MAX_NUM_CARDS]; /* array of card info */

typedef struct a32ZedDpvt { /* unique for each record */
  unsigned short  reg;   /* index of register to use (determined by signal #*/
  unsigned short  lbit;  /* least significant bit of interest */
  unsigned short  nbit;  /* no of significant bits */
  unsigned short  type;  /* Type either 0 or 1 for uni, bi polar */
  unsigned long   mask;  /* mask to use ...  */
  unsigned long   pixel; /* pixel to do threshold scan on */
}a32ZedDpvt;

/* Define the dset for A32ZED */
typedef struct {
	long		number;
	DEVSUPFUN	report;		/* used by dbior */
	DEVSUPFUN	init;	
	DEVSUPFUN	init_record;	/* called 1 time for each record */
	DEVSUPFUN	get_ioint_info;	
	DEVSUPFUN	read_write;
        DEVSUPFUN       special_linconv;
} A32ZED_DSET;

A32ZED_DSET devAiA32Zed =   {6, NULL, NULL, init_ai, NULL, read_ai,  NULL};
A32ZED_DSET devAoA32Zed =   {6, NULL, NULL, init_ao, NULL, write_ao, NULL};
A32ZED_DSET devBiA32Zed =   {5, devA32ZedReport,NULL,init_bi, get_bi_int_info, 
                             read_bi,  NULL};
A32ZED_DSET devBoA32Zed =   {5, NULL, NULL, init_bo, NULL, write_bo, NULL};
A32ZED_DSET devLiA32Zed =   {5, NULL, NULL, init_li, NULL, read_li,  NULL};
A32ZED_DSET devLoA32Zed =   {5, NULL, NULL, init_lo, NULL, write_lo, NULL};
A32ZED_DSET devMbbiA32Zed = {5, NULL, NULL, init_mbbi, NULL, read_mbbi,  NULL};
A32ZED_DSET devMbboA32Zed = {5, NULL, NULL, init_mbbo, NULL, write_mbbo, NULL};

// read 
A32ZED_DSET devWaveformA32Zed = { 6, NULL, NULL, initWfRecord, NULL, readWf,  NULL};

epicsExportAddress(dset, devAiA32Zed);
epicsExportAddress(dset, devAoA32Zed);
epicsExportAddress(dset, devBiA32Zed);
epicsExportAddress(dset, devBoA32Zed);
epicsExportAddress(dset, devLiA32Zed);
epicsExportAddress(dset, devLoA32Zed);
epicsExportAddress(dset, devMbbiA32Zed);
epicsExportAddress(dset, devMbboA32Zed);
epicsExportAddress(dset, devWaveformA32Zed);


/**************************************************************************
 **************************************************************************/
static long devA32ZedReport()
{
int             i;
int		cardNum = 0;
unsigned long   regData;

  for(cardNum=0; cardNum < MAX_NUM_CARDS; cardNum++) {
    if(cards[cardNum].base != NULL) {
      epicsPrintf("  Card #%d at %p\n", cardNum, cards[cardNum].base);
      for(i=0; i < cards[cardNum].nReg; i++) {
          regData = cards[cardNum].base->reg[i];
          epicsPrintf("    Register %d -> 0x%4.4lX (%ld)\n", i, regData, regData);
      }
    }
  }
return(0);
}


/**************************************************************************
*
* Initialization of A32/D32 Card - called in st.cmd
*
***************************************************************************/
int devA32ZedConfig(int card, char *componentName, int map, int nregs)
{
	int i, fd, match;
	FILE *uioName_fd;
	char name[100], uioFileName[100], uioDevName[100];
	int a32base;

	if ((card >= MAX_NUM_CARDS) || (card < 0)) {
		epicsPrintf("devA32ZedConfig: Invalid Card # %d \n",card);
		return(ERROR);
	}

	/* find the uio whose name matches */
	match = -1;
	for (i=0; i<6 && match==-1; i++) {
	  	sprintf(uioFileName, "/sys/class/uio/uio%d/name", i);
		uioName_fd = fopen(uioFileName, "r");
		if (uioName_fd==NULL) {
			printf("devA32ZedConfig: Failed to open '%s'\n", uioFileName);
			return(ERROR);
		}
		fgets(name, 100, uioName_fd);
		name[strlen(name)-1] = '\0'; /* strip \n */
		if (devA32ZedDebug) printf("devA32ZedConfig: uio%d.name='%s'\n", i, name);
		if (strncmp(name, componentName, strlen(componentName))==0) {
			match = i;
			if (devA32ZedDebug) printf("devA32ZedConfig: name matches, match=%d\n", match);
		}
		fclose(uioName_fd);
	}

	if (match == -1) {
		printf("devA32ZedConfig: no match; nothing done\n");
		return(ERROR);
	}

	sprintf(uioDevName, "/dev/uio%d", match);
	fd = open(uioDevName,O_RDWR|O_SYNC);
	if (fd < 0) {
		epicsPrintf("Can't open '%s'\n", uioDevName);
		return(ERROR);
	}

	/* get base address */
	sprintf(uioFileName, "/sys/class/uio/uio%d/maps/map%d/addr", match, map);
	uioName_fd = fopen(uioFileName, "r");
	if (uioName_fd==NULL) {
		printf("devA32ZedConfig: Failed to open '%s'\n", uioFileName);
		return(ERROR);
	}
	fscanf(uioName_fd, "%x", &a32base);
	if (devA32ZedDebug) printf("devA32ZedConfig: uio%d a32base=0x%x\n", match, a32base);
	fclose(uioName_fd);

	//cards[card].base = (volatile a32Reg  *) mmap(0,1024,PROT_READ|PROT_WRITE,MAP_SHARED,fd,a32base);
	//cards[card].base = (volatile a32Reg  *) mmap(0,1024,PROT_READ|PROT_WRITE,MAP_SHARED,fd,0);
	cards[card].base = (volatile a32Reg  *) mmap(0,1024,PROT_READ|PROT_WRITE,MAP_SHARED,fd,map*getpagesize());
	if (cards[card].base == NULL) {
		epicsPrintf("devA32ZedConfig: mmap A32 Address map failed for Card %d\n",card);
	}
	else {
		epicsPrintf("devA32ZedConfig: mmap A32 Address map Successful for Card %d\n",card);
		epicsPrintf("devA32ZedConfig: 0x%x mapped to %p\n", a32base, (void *)cards[card].base);
	}

	if(nregs > MAX_ACTIVE_REGS) {
		epicsPrintf("devA32ZedConfig: # of registers (%d) exceeds max\n",nregs);
		return(ERROR);
	}
	else {
		cards[card].nReg = nregs;
		cards[card].lock = epicsMutexMustCreate();
	}
 
	return(OK);
}

/**************************************************************************
 *
 * BI record interrupt routine
 *
 **************************************************************************/
static long get_bi_int_info(cmd, pbi, ppvt)
int                     cmd;
struct biRecord         *pbi;
IOSCANPVT               *ppvt;
{

   struct vmeio           *pvmeio = (struct vmeio *)(&pbi->inp.value);

   if(cards[pvmeio->card].ioscanpvt != NULL) {
       *ppvt = cards[pvmeio->card].ioscanpvt;
       return(OK);
   }
   else {
       return(ERROR);
   }
}

/**************************************************************************
 *
 * BO Initialization (Called one time for each BO MSLT card record)
 *
 **************************************************************************/
static long init_bo(pbo)
struct boRecord *pbo;
{
    long                status = 0;
    int                 card, args, bit;
    //int			link, address, parm;
    unsigned long 	rawVal = 0;
    a32ZedDpvt         *pPvt;

    if (devA32ZedDebug >= 20)
    {
	if (pbo->out.type == VME_IO)
         epicsPrintf("init_bo: card %d, regNum %d, mask %s\n", 
	   pbo->out.value.vmeio.card, pbo->out.value.vmeio.signal, pbo->out.value.vmeio.parm );
    }

    /* bo.out must be an VME_IO ??? */
    switch (pbo->out.type) {
    case (VME_IO) :
 
      if(pbo->out.value.vmeio.card > MAX_NUM_CARDS) {
	pbo->pact = 1;		/* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Card #%d exceeds max: ->%s<- \n", 
        	pbo->out.value.vmeio.card , pbo->name);
        return(ERROR);
      }

      card = pbo->out.value.vmeio.card;

      if(cards[card].base == NULL) {
	pbo->pact = 1;		/* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Card #%d not initialized: ->%s<-\n",
        	card, pbo->name);
        return(ERROR);
      }

      if (pbo->out.value.vmeio.signal >= cards[card].nReg) {
        pbo->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Signal # exceeds registers: ->%s<-\n",
                     pbo->name);
        return(ERROR);
      }

      args = sscanf(pbo->out.value.vmeio.parm, "%d", &bit);
 
      if((args != 1) || (bit >= MAX_ACTIVE_BITS)) {
        pbo->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Invalid Bit # in parm field: ->%s<-\n",
                     pbo->name);
        return(ERROR);
      }

      pbo->dpvt = (void *)calloc(1, sizeof(struct a32ZedDpvt));
      pPvt = (a32ZedDpvt *)pbo->dpvt;

      pPvt->reg =  pbo->out.value.vmeio.signal;
      pPvt->lbit = bit;
      pPvt->mask = 1 << pPvt->lbit;
      pbo->mask = pPvt->mask;

      if (read_card(card, pPvt->reg, pPvt->mask, &rawVal) == OK)
         {
         pbo->rbv = pbo->rval = rawVal;
         }
      else 
         {
         status = 2;
         }
      break;
         
    default :
	pbo->pact = 1;		/* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Illegal OUT field ->%s<- \n", pbo->name);
        status = ERROR;
    }
    return(status);
}

/**************************************************************************
 *
 * BI Initialization (Called one time for each BI record)
 *
 **************************************************************************/
static long init_bi(pbi)
struct biRecord *pbi;
{
    long                status = 0;
    int                 card, args, bit;
    unsigned long       rawVal = 0;
    a32ZedDpvt         *pPvt;
   

    /* bi.inp must be an VME_IO */
    switch (pbi->inp.type) {
    case (VME_IO) :

      if(pbi->inp.value.vmeio.card > MAX_NUM_CARDS) {
        pbi->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Card #%d exceeds max: ->%s<- \n", 
        	pbi->inp.value.vmeio.card , pbi->name);
        return(ERROR);
      }

      card = pbi->inp.value.vmeio.card;

      if(cards[card].base == NULL) {
        pbi->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Card #%d not initialized: ->%s<-\n",
        	card, pbi->name);
        return(ERROR);
      }

      if (pbi->inp.value.vmeio.signal >= cards[card].nReg) {
        pbi->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Signal #%d exceeds registers: ->%s<-\n",
                     pbi->inp.value.vmeio.signal, pbi->name);
        return(ERROR);
      }

      args = sscanf(pbi->inp.value.vmeio.parm, "%d", &bit);

      if((args != 1) || (bit >= MAX_ACTIVE_BITS)) {
        pbi->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Invalid Bit # in parm field: ->%s<-\n",
                     pbi->name);
        return(ERROR);
      }
      pbi->dpvt = (void *)calloc(1, sizeof(struct a32ZedDpvt));
      pPvt = (a32ZedDpvt *)pbi->dpvt;

      pPvt->reg =  pbi->inp.value.vmeio.signal;
      pPvt->lbit = bit;
      pPvt->mask = 1 << pPvt->lbit;
      pbi->mask = pPvt->mask;

      if (read_card(card, pPvt->reg, pPvt->mask, &rawVal) == OK)
         {
         pbi->rval = rawVal;
         status = 0;
         }
      else
         {
         status = 2;
         }
      break;

    default :
        pbi->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Illegal INP field ->%s<- \n", pbi->name);
        status = ERROR;
    }
    return(status);
}


/**************************************************************************
 *
 * MBBO Initialization (Called one time for each MBBO record)
 *
 **************************************************************************/
static long init_mbbo(pmbbo)
struct mbboRecord   *pmbbo;
{
    long                status = 0;
    int                 card, args, bit;
    unsigned long       rawVal = 0;
    a32ZedDpvt         *pPvt;

    /* mbbo.out must be an VME_IO */
    switch (pmbbo->out.type) {
    case (VME_IO) :
      if(pmbbo->out.value.vmeio.card > MAX_NUM_CARDS) {
        pmbbo->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Card #%d exceeds max: ->%s<- \n", 
        	pmbbo->out.value.vmeio.card , pmbbo->name);
        return(ERROR);
      }

      card = pmbbo->out.value.vmeio.card;

      if(cards[card].base == NULL) {
        pmbbo->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Card #%d not initialized: ->%s<-\n",
                     card, pmbbo->name);
        return(ERROR);
      }

      if (pmbbo->out.value.vmeio.signal >= cards[card].nReg) {
        pmbbo->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Signal # exceeds registers: ->%s<-\n",
                     pmbbo->name);
        return(ERROR);
      }

      args = sscanf(pmbbo->out.value.vmeio.parm, "%d", &bit);

      if((args != 1) || (bit >= MAX_ACTIVE_BITS)) {
        pmbbo->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Invalid Bit # in parm field: ->%s<-\n",
                     pmbbo->name);
        return(ERROR);
      }

      pmbbo->dpvt = (void *)calloc(1, sizeof(struct a32ZedDpvt));
      pPvt = (a32ZedDpvt *)pmbbo->dpvt;

      pPvt->reg =  pmbbo->out.value.vmeio.signal;
      pPvt->lbit = bit;

      /* record support determined .mask from .nobt, need to adjust */
      pmbbo->shft = pPvt->lbit;
      pmbbo->mask <<= pPvt->lbit;
      pPvt->mask = pmbbo->mask;

      if (read_card(card, pPvt->reg, pPvt->mask, &rawVal) == OK)
         {
         pmbbo->rbv = pmbbo->rval = rawVal;
         status = 0;
         }
      else
         {
         status = 2;
         }
      break;

    default :
        pmbbo->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Illegal OUT field ->%s<- \n", pmbbo->name);
        status = ERROR;
    }
    return(status);
}


/**************************************************************************
 *
 * MBBI Initialization (Called one time for each MBBO record)
 *
 **************************************************************************/
static long init_mbbi(pmbbi)
struct mbbiRecord   *pmbbi;
{
    long                status = 0;
    int                 card, args, bit;
    unsigned long       rawVal = 0;
    a32ZedDpvt         *pPvt;

    /* mbbi.inp must be an VME_IO */
    switch (pmbbi->inp.type) {
    case (VME_IO) :
      if(pmbbi->inp.value.vmeio.card > MAX_NUM_CARDS) {
        pmbbi->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Card #%d exceeds max: ->%s<- \n", 
        	pmbbi->inp.value.vmeio.card , pmbbi->name);
        return(ERROR);
      }

      card = pmbbi->inp.value.vmeio.card;

      if(cards[card].base == NULL) {
        pmbbi->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Card #%d not initialized: ->%s<-\n",
                     card, pmbbi->name);
        return(ERROR);
      }

      if (pmbbi->inp.value.vmeio.signal >= cards[card].nReg) {
        pmbbi->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Signal # exceeds registers: ->%s<-\n",
                     pmbbi->name);
        return(ERROR);
      }

      args = sscanf(pmbbi->inp.value.vmeio.parm, "%d", &bit);

      if((args != 1) || (bit >= MAX_ACTIVE_BITS)) {
        pmbbi->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Invalid Bit # in parm field: ->%s<-\n",
                     pmbbi->name);
        return(ERROR);
      }

      pmbbi->dpvt = (void *)calloc(1, sizeof(struct a32ZedDpvt));
      pPvt = (a32ZedDpvt *)pmbbi->dpvt;

      pPvt->reg =  pmbbi->inp.value.vmeio.signal;
      pPvt->lbit = bit;

      /* record support determined .mask from .nobt, need to adjust */
      pmbbi->shft = pPvt->lbit;
      pmbbi->mask <<= pPvt->lbit;
      pPvt->mask = pmbbi->mask;

      if (read_card(card, pPvt->reg, pPvt->mask, &rawVal) == OK)
         {
         pmbbi->rval = rawVal;
         status = 0;
         }
      else
         {
         status = 2;
         }
      break;

    default :
        pmbbi->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Illegal INP field ->%s<- \n", pmbbi->name);
        status = ERROR;
    }
    return(status);
}


/**************************************************************************
 *
 * AI Initialization (Called one time for each AI record)
 *
 **************************************************************************/
static long init_ai(pai)
struct aiRecord   *pai;
{
    long                status = 0;
    int                 card, args, bit, numBits, twotype;
    a32ZedDpvt         *pPvt;

    /* ai.inp must be an VME_IO */
    switch (pai->inp.type) {
    case (VME_IO) :
      if(pai->inp.value.vmeio.card > MAX_NUM_CARDS) {
        pai->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Card #%d exceeds max: ->%s<- \n", 
        	pai->inp.value.vmeio.card , pai->name);
        return(ERROR);
      }

      card = pai->inp.value.vmeio.card;

      if(cards[card].base == NULL) {
        pai->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Card #%d not initialized: ->%s<-\n",
                     card, pai->name);
        return(ERROR);
      }

      if (pai->inp.value.vmeio.signal >= cards[card].nReg) {
        pai->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Signal # exceeds registers: ->%s<-\n",
                     pai->name);
        return(ERROR);
      }

      args = sscanf(pai->inp.value.vmeio.parm, "%d,%d,%d", 
      				&bit, &numBits, &twotype);

      if( (args != 3) || (bit >= MAX_ACTIVE_BITS) || (numBits <= 0) ||
         	(bit + numBits > MAX_ACTIVE_BITS) ||
         	(twotype > 1) || (twotype < 0) ) {
        pai->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf
        ("devA32Zed: Invalid Bit #/Width/Type in parm field: ->%s<-\n",
                     pai->name);
        return(ERROR);
      }

      pai->dpvt = (void *)calloc(1, sizeof(struct a32ZedDpvt));
      pPvt = (a32ZedDpvt *)pai->dpvt;

      pPvt->reg =  pai->inp.value.vmeio.signal;
      pPvt->lbit = bit;
      pPvt->nbit = numBits;
      pPvt->type = twotype;
      pPvt->mask = ((1 << (numBits)) - 1) << pPvt->lbit;

      pai->eslo = (pai->eguf - pai->egul)/(pow(2,numBits)-1);
      
/*  Shift Raw value if Bi-polar */
      if (pPvt->type ==1) 
         pai->roff = pow(2,(numBits-1));

      status = OK;

      break;
    default :
        pai->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Illegal INP field ->%s<- \n", pai->name);
        status = ERROR;
    }
    return(status);
}



/**************************************************************************
 *
 * AO Initialization (Called one time for each AO record)
 *
 **************************************************************************/
static long init_ao(pao)
struct aoRecord   *pao;
{
    long                status = 0;
    unsigned long       rawVal = 0;
    int                 card, args, bit, numBits, twotype;
    a32ZedDpvt         *pPvt;

    /* ao.out must be an VME_IO */
    switch (pao->out.type) {
    case (VME_IO) :
      if(pao->out.value.vmeio.card > MAX_NUM_CARDS) {
        pao->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Card #%d exceeds max: ->%s<- \n", 
        	pao->out.value.vmeio.card , pao->name);
        return(ERROR);
      }

      card = pao->out.value.vmeio.card;

      if(cards[card].base == NULL) {
        pao->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Card #%d not initialized: ->%s<-\n",
                     card, pao->name);
        return(ERROR);
      }

      if (pao->out.value.vmeio.signal >= cards[card].nReg) {
        pao->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Signal # exceeds registers: ->%s<-\n",
                     pao->name);
        return(ERROR);
      }

      args = sscanf(pao->out.value.vmeio.parm, "%d,%d,%d", 
      				&bit, &numBits, &twotype);

      if( (args != 3) || (bit >= MAX_ACTIVE_BITS) || (numBits <= 0) ||
         	(bit + numBits > MAX_ACTIVE_BITS) ||
         	(twotype > 1) || (twotype < 0) ) {
        epicsPrintf
        ("devA32Zed: Invalid Bit #/Width/Type in parm field: ->%s<-\n",
                     pao->name);
        return(ERROR);
      }

      pao->dpvt = (void *)calloc(1, sizeof(struct a32ZedDpvt));
      pPvt = (a32ZedDpvt *)pao->dpvt;

      pPvt->reg =  pao->out.value.vmeio.signal;
      pPvt->lbit = bit;
      pPvt->nbit = numBits;
      pPvt->type = twotype;
      pPvt->mask = ((1 << (numBits)) - 1) << pPvt->lbit;

      pao->eslo = (pao->eguf - pao->egul)/(pow(2,numBits)-1);

/*  Shift Raw value if Bi-polar */
      if (pPvt->type == 1) 
         pao->roff = pow(2,(numBits-1));

      /* Init rval to current setting */ 
      if(read_card(card,pPvt->reg,pPvt->mask,&rawVal) == OK) {
        pao->rbv = rawVal>>pPvt->lbit;

/* here is where we do the sign extensions for Bipolar.... */        
        if (pPvt->type ==1) {
           if (pao->rbv & (2<<(pPvt->nbit-2)))
               pao->rbv |= ((2<<31) - (2<<(pPvt->nbit-2)))*2 ;

	}

        pao->rval = pao->rbv;
      }

      status = OK;

      break;
    default :
        pao->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Illegal OUT field ->%s<- \n", pao->name);
        status = ERROR;
    }
    return(status);
}


/**************************************************************************
 *
 * LI Initialization (Called one time for each LI record)
 *
 **************************************************************************/
static long init_li(pli)
struct longinRecord   *pli;
{
    long                status = 0;
    int                 card, args, bit, numBits;
    a32ZedDpvt         *pPvt;

    /* li.inp must be an VME_IO */
    switch (pli->inp.type) {
    case (VME_IO) :
      if(pli->inp.value.vmeio.card > MAX_NUM_CARDS) {
        pli->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Card #%d exceeds max: ->%s<- \n", 
        	pli->inp.value.vmeio.card , pli->name);
        return(ERROR);
      }

      card = pli->inp.value.vmeio.card;

      if(cards[card].base == NULL) {
        pli->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Card #%d not initialized: ->%s<-\n",
                     card, pli->name);
        return(ERROR);
      }

      if (pli->inp.value.vmeio.signal >= cards[card].nReg) {
        pli->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Signal #%d exceeds registers: ->%s<-\n",
                     pli->inp.value.vmeio.signal, pli->name);
        return(ERROR);
      }

      args = sscanf(pli->inp.value.vmeio.parm, "%d,%d", &bit, &numBits);

      if((args != 2) || (bit >= MAX_ACTIVE_BITS) || (numBits <= 0) ||
         (bit + numBits > MAX_ACTIVE_BITS)) {
        pli->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Invalid Bit #/Width in parm field: ->%s<-\n",
                     pli->name);
        return(ERROR);
      }

      pli->dpvt = (void *)calloc(1, sizeof(struct a32ZedDpvt));
      pPvt = (a32ZedDpvt *)pli->dpvt;

      pPvt->reg =  pli->inp.value.vmeio.signal;
      pPvt->lbit = bit;
      pPvt->mask = ((1 << (numBits)) - 1) << pPvt->lbit;

      status = OK;


      break;
    default :
        pli->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Illegal INP field ->%s<- \n", pli->name);
        status = ERROR;
    }
    return(status);
}



/**************************************************************************
 *
 * Long Out Initialization (Called one time for each LO record)
 *
 **************************************************************************/
static long init_lo(plo)
struct longoutRecord   *plo;
{
    long                status = 0;
    int                 card, args, bit, numBits;
    a32ZedDpvt         *pPvt;

    /* lo.out must be an VME_IO */
    switch (plo->out.type) {
    case (VME_IO) :
      if(plo->out.value.vmeio.card > MAX_NUM_CARDS) {
        plo->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Card #%d exceeds max: ->%s<- \n", 
        	plo->out.value.vmeio.card , plo->name);
        return(ERROR);
      }

      card = plo->out.value.vmeio.card;

      if(cards[card].base == NULL) {
        plo->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Card #%d not initialized: ->%s<-\n",
                     card, plo->name);
        return(ERROR);
      }

      if (plo->out.value.vmeio.signal >= cards[card].nReg) {
        plo->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Signal #%d exceeds registers: ->%s<-\n",
                     plo->out.value.vmeio.signal, plo->name);
        return(ERROR);
      }

      args = sscanf(plo->out.value.vmeio.parm, "%d,%d", &bit, &numBits);

      if((args != 2) || (bit >= MAX_ACTIVE_BITS) || (numBits <= 0) ||
         (bit + numBits > MAX_ACTIVE_BITS)) {
        plo->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed-init_lo: Invalid Bit #/Width bit=%d, numBits=%d in parm field: ->%s<-\n",
                     bit, numBits, plo->name);
        return(ERROR);
      }


      // are one of these lines causing a segmentation fault???
      plo->dpvt = (void *)calloc(1, sizeof(struct a32ZedDpvt));
      pPvt = (a32ZedDpvt *)plo->dpvt;

      pPvt->reg =  plo->out.value.vmeio.signal;
      pPvt->lbit = bit;
      pPvt->mask = ((1 << (numBits)) - 1) << pPvt->lbit;


      status = OK;
      epicsPrintf("devA32Zed-init_lo Sucessfull  bit=%d, numBits=%d sizeof=%u\n",bit,numBits,(unsigned int)sizeof(struct a32ZedDpvt));

      break;
    default :
        plo->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Illegal OUT field ->%s<- \n", plo->name);
        status = ERROR;
    }
    return(status);
}

/**************************************************************************/
//static long initWfRecord( struct waveformRecord* pRec )
static long initWfRecord( pwf )
struct waveformRecord   *pwf;
{
    long                status = 0;
    int                 card, args;
    int			pixel;
    a32ZedDpvt         *pPvt;

    if (devA32ZedDebug >= 20)
    {
         epicsPrintf("init_waveform: card %d, signal %d, pixel %s, number elements %u\n", 
	   pwf->inp.value.vmeio.card, pwf->inp.value.vmeio.signal, pwf->inp.value.vmeio.parm, pwf->nelm );
    }



    /* waveform.inp must be a VME_IO */
    switch (pwf->inp.type) {
    case (VME_IO) :
      //pvmeio = (struct vmeio*)&(pwf->inp.value);

      if(pwf->inp.value.vmeio.card > MAX_NUM_CARDS) {
        pwf->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Card #%d exceeds max: ->%s<- \n", 
        	pwf->inp.value.vmeio.card , pwf->name);
        return(ERROR);
      }

      card = pwf->inp.value.vmeio.card;

      if(cards[card].base == NULL) {
        pwf->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Card #%d not initialized: ->%s<-\n",
                     card, pwf->name);
        return(ERROR);
      }

      if (pwf->inp.value.vmeio.signal >= cards[card].nReg) {
        pwf->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Signal # exceeds registers: ->%s<-\n",
                     pwf->name);
        return(ERROR);
      }

      // args = sscanf(pwf->inp.value.vmeio.parm, "%d,%d", &bit, &numBits);
      args = sscanf(pwf->inp.value.vmeio.parm, "%d", &pixel);

      // change args from 2 to 1
      if( (args != 1) || (pixel >= MAX_PIXEL) ) 
      {
        pwf->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Invalid Num Pixels in parm field: ->%s<-\n",
                     pwf->name);
        return(ERROR);
      }

      pwf->dpvt = (void *)calloc(1, sizeof(struct a32ZedDpvt));
      pPvt = (a32ZedDpvt *)pwf->dpvt;

      pPvt->reg =  pwf->inp.value.vmeio.signal;
      pPvt->pixel = pixel;


      epicsPrintf("devA32Zed: waveform config success\n");

      status = OK;

      break;
    default :
        pwf->pact = 1;          /* make sure we don't process this thing */
        epicsPrintf("devA32Zed: Illegal OUT field ->%s<- \n", pwf->name);
        status = ERROR;
    }
    return(status);
} /* initWfRecord() */



/**************************************************************************
 *
 * Perform a write operation from a BO record
 *
 **************************************************************************/
static long write_bo(pbo)
struct boRecord *pbo;
{

  unsigned long 	rawVal = 0;
  a32ZedDpvt           *pPvt = (a32ZedDpvt *)pbo->dpvt;

  if (write_card(pbo->out.value.vmeio.card, pPvt->reg, pbo->mask, pbo->rval) 
        == OK)
  {
    if(read_card(pbo->out.value.vmeio.card, pPvt->reg, pbo->mask, &rawVal) 
        == OK)
    {
      pbo->rbv = rawVal;
      return(0);
    }
  }

  /* Set an alarm for the record */
  recGblSetSevr(pbo, WRITE_ALARM, INVALID_ALARM);
  return(2);
}

/**************************************************************************
 *
 * Perform a read operation from a BI record
 *
 **************************************************************************/
static long read_bi(pbi)
struct biRecord *pbi;
{

  unsigned long       rawVal = 0;
  a32ZedDpvt           *pPvt = (a32ZedDpvt *)pbi->dpvt;

  if (read_card(pbi->inp.value.vmeio.card, pPvt->reg, pbi->mask,&rawVal) == OK)
  {
     pbi->rval = rawVal;
     return(0);
  }

  /* Set an alarm for the record */
  recGblSetSevr(pbi, READ_ALARM, INVALID_ALARM);
  return(2);
}


/**************************************************************************
 *
 * Perform a read operation from a MBBI record
 *
 **************************************************************************/
static long read_mbbi(pmbbi)
struct mbbiRecord *pmbbi;
{

  unsigned long       rawVal = 0;
  a32ZedDpvt           *pPvt = (a32ZedDpvt *)pmbbi->dpvt;

  if (read_card(pmbbi->inp.value.vmeio.card,pPvt->reg,pmbbi->mask,&rawVal) 
        == OK)
  {
     pmbbi->rval = rawVal;
     return(0);
  }

  /* Set an alarm for the record */
  recGblSetSevr(pmbbi, READ_ALARM, INVALID_ALARM);
  return(2);
}



/**************************************************************************
 *
 * Perform a write operation from a MBBO record
 *
 **************************************************************************/
static long write_mbbo(pmbbo)
struct mbboRecord *pmbbo;
{

  unsigned long         rawVal = 0;
  a32ZedDpvt           *pPvt = (a32ZedDpvt *)pmbbo->dpvt;

  if (write_card(pmbbo->out.value.vmeio.card,pPvt->reg,
                      pmbbo->mask,pmbbo->rval) == OK)
  {
    if(read_card(pmbbo->out.value.vmeio.card,pPvt->reg,pmbbo->mask,&rawVal) 
       == OK)
    {
      pmbbo->rbv = rawVal;
      return(0);
    }
  }

  /* Set an alarm for the record */
  recGblSetSevr(pmbbo, WRITE_ALARM, INVALID_ALARM);
  return(2);
}


/**************************************************************************
 *
 * Perform a read operation from a AI record
 *
 **************************************************************************/
static long read_ai(pai)
struct aiRecord *pai;
{
  unsigned long         rawVal = 0;
  a32ZedDpvt           *pPvt = (a32ZedDpvt *)pai->dpvt;

  if (read_card(pai->inp.value.vmeio.card,pPvt->reg,pPvt->mask,&rawVal) == OK)
  {
     pai->rval = rawVal>>pPvt->lbit;

/* here is where we do the sign extensions for Bipolar....    */     
        if (pPvt->type ==1) {
           if (pai->rval & (2<<(pPvt->nbit-2))) 
               pai->rval |= ((2<<31) - (2<<(pPvt->nbit-2)))*2; 

	}

     return(0);
  }

  /* Set an alarm for the record */
  recGblSetSevr(pai, READ_ALARM, INVALID_ALARM);
  return(2);

}

/**************************************************************************
 *
 * Perform a write operation from a AO record
 *
 **************************************************************************/
static long write_ao(pao)
struct aoRecord *pao;
{

  unsigned long      rawVal = 0;
  a32ZedDpvt           *pPvt = (a32ZedDpvt *)pao->dpvt;

  if (write_card(pao->out.value.vmeio.card,pPvt->reg,
                 pPvt->mask,pao->rval<<pPvt->lbit) == OK)
  {
    if(read_card(pao->out.value.vmeio.card,pPvt->reg,pPvt->mask,&rawVal)
       == OK)
    {
      pao->rbv = rawVal>>pPvt->lbit;

/* here is where we do the sign extensions for Bipolar.... */        
        if (pPvt->type ==1) {
           if (pao->rbv & (2<<(pPvt->nbit-2)))
               pao->rbv |= ((2<<31) - (2<<(pPvt->nbit-2)))*2;

	}
      
      return(0);
    }
  }

  /* Set an alarm for the record */
  recGblSetSevr(pao, WRITE_ALARM, INVALID_ALARM);
  return(2);
}

/**************************************************************************
 *
 * Perform a read operation from a LI record
 *
 **************************************************************************/
static long read_li(pli)
struct longinRecord *pli;
{

  unsigned long         rawVal = 0;
  a32ZedDpvt           *pPvt = (a32ZedDpvt *)pli->dpvt;

  if (read_card(pli->inp.value.vmeio.card,pPvt->reg,pPvt->mask,&rawVal) == OK)
  {
     pli->val = rawVal>>pPvt->lbit;
     pli->udf = 0;
     return(0);
  }

  /* Set an alarm for the record */
  recGblSetSevr(pli, READ_ALARM, INVALID_ALARM);
  return(2);

}

/**************************************************************************
 *
 * Perform a write operation from a LO record
 *
 **************************************************************************/
static long write_lo(plo)
struct longoutRecord *plo;
{

  a32ZedDpvt           *pPvt = (a32ZedDpvt *)plo->dpvt;

  if (write_card(plo->out.value.vmeio.card,pPvt->reg,
                 pPvt->mask,plo->val<<pPvt->lbit) == OK)
  {
      return(0);
  }

  /* Set an alarm for the record */
  recGblSetSevr(plo, WRITE_ALARM, INVALID_ALARM);
  return(2);
}

/**************************************************************************
 *
 * Raw read a bitfield from the card
 *
 **************************************************************************/
static long read_card(card, reg, mask, value)
short           card;  
unsigned short  reg;
unsigned long   mask;   /* created in init_bo() */
unsigned long  *value; /* the value to return from the card */
{
  if (checkCard(card) == ERROR)
    return(ERROR);

  *value = cards[card].base->reg[reg] & mask;

  if (devA32ZedDebug >= 20)
    epicsPrintf("devA32Zed: read 0x%4.4lX from card %d\n", *value, card);

  return(OK);
}



/**************************************************************************
 *
 * Write a bitfield to the card retaining the states of the other bits
 *
 **************************************************************************/
static long write_card(card, reg, mask, value)
short           card;
unsigned short  reg;
unsigned long   mask;
unsigned long   value;
{
  if (checkCard(card) == ERROR)
    return(ERROR);

  epicsMutexMustLock(cards[card].lock);
  cards[card].base->reg[reg] = ((cards[card].base->reg[reg] & ~mask) | 
                              (value & mask));
  epicsMutexUnlock(cards[card].lock);

  if (devA32ZedDebug >= 15)
    epicsPrintf("devA32Zed: wrote 0x%4.4lX to card %d at reg %d, input value = %lu mask = %lu \n",
            cards[card].base->reg[reg], card, reg, value, mask);

  return(0);
}

/*************************************************************************/
static long readWf( pwf )
struct waveformRecord   *pwf;
{
	int signal;
	int ii;
	unsigned long * wf_buf;

	if (checkCard(pwf->inp.value.vmeio.card) == ERROR) return(ERROR);

	signal =  pwf->inp.value.vmeio.signal;
	if (signal == 0) {
		epicsPrintf("Got to readWf signal = 0.\n");
	} else if (signal == 1) {
		epicsPrintf("Got to readWf signal = 1\n");
      
		wf_buf = pwf->bptr;
		for (ii=0; ii<pwf->nelm; ii++) {
			wf_buf[ii] = 0;
		}
	}

	pwf->nord = pwf->nelm;		// Device support must set this value when it completes, will update waveform

	return(0);

} /* readWf() */

/**************************************************************************
 *
 * Make sure card number is valid
 *
 **************************************************************************/
static long checkCard(card)
short   card;
{
  if ((card >= MAX_NUM_CARDS) || (cards[card].base == NULL))
    return(ERROR);
  else
    return(OK);
}



/*******************************/
/* Information needed by iocsh */
// int devA32ZedConfig(int card, char *componentName, int map, int nregs)
static const iocshArg zedconfigArg0 = {"Card being configured", iocshArgInt};
static const iocshArg zedconfigArg1 = {"component name", iocshArgString};
static const iocshArg zedconfigArg2 = {"map number", iocshArgInt};
static const iocshArg zedconfigArg3 = {"number registers", iocshArgInt};
static const iocshArg * const zedconfigArgs[4] =
	{&zedconfigArg0, &zedconfigArg1, &zedconfigArg2, &zedconfigArg3};

static const iocshFuncDef configZedFuncDef = {"devA32ZedConfig", 4, zedconfigArgs};
static const iocshFuncDef reportZedFuncDef = {"devA32ZedReport", 0, NULL};

// Wrappers with args
static void configZedCallFunc(const iocshArgBuf *args) 
{
    devA32ZedConfig(args[0].ival, args[1].sval, args[2].ival, args[3].ival);
}
static void reportZedCallFunc(const iocshArgBuf *args)
{
    devA32ZedReport();
}

/* Registration routine, runs at startup */
static void ZedRegister(void) 
{
    iocshRegister(&configZedFuncDef, configZedCallFunc);
    iocshRegister(&reportZedFuncDef, reportZedCallFunc);
    // more func?
}
epicsExportRegistrar(ZedRegister);


