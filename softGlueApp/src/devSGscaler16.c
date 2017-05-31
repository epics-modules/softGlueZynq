/*******************************************************************************
devSGscaler16.c
Device-support routines for 16-channel, 32-bit scaler implemented in softGlueZynq

Original Author: Tim Mooney
Date: 5/8/2017

Experimental Physics and Industrial Control System (EPICS)

Copyright (c) 2017 UChicago Argonne LLC, as Operator of Argonne
National Laboratory, and The Regents of the University of California, as
Operator of Los Alamos National Laboratory.
softGlueZynq is distributed subject to a Software License Agreement found
in the file LICENSE that is included with this distribution.

*******************************************************************************/

#include	<epicsVersion.h>

#ifndef OK
#define OK      0
#endif

#ifndef ERROR
#define ERROR   -1
#endif

#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <sys/stat.h>

#include <stddef.h>
#include <stdlib.h>
#include <math.h>
#include <stdio.h>

#include <epicsTypes.h>
#include <iocsh.h>
#include "drvZynq.h"
#include <dbCommon.h>


#include	<epicsTimer.h>
#include	<epicsThread.h>
#include	<devLib.h>
#include	<alarm.h>
#include	<dbDefs.h>
#include	<dbAccess.h>
#include	<dbCommon.h>
#include	<dbScan.h>
#include	<dbEvent.h>
#include	<recGbl.h>
#include	<recSup.h>
#include	<devSup.h>
#include	<drvSup.h>
#include	<dbScan.h>
#include	<special.h>
#include	<callback.h>
#include	<epicsExport.h>

#include	"scalerRecord.h"
#include	"devScaler.h"

/*** Debug support ***/
#ifdef NODEBUG
#define STATIC static
#define Debug(l,FMT,V) ;
#else
#define STATIC
#define Debug(l,FMT,V) {  if(l <= devSGscaler16Debug) \
			{ printf("%s(%d):",__FILE__,__LINE__); \
			  printf(FMT,V); } }
#endif
volatile int devSGscaler16Debug = 0;
epicsExportAddress(int, devSGscaler16Debug);

static volatile epicsUInt32 *fifoAddr;
static volatile epicsUInt32 *fifoCountAddr;
static volatile epicsUInt32 *scalerPreset;
static volatile epicsUInt8 *scalerEn, *scalerClr, *scalerCnt, *scalerStop, *scalerRead, *scalerCntg;

/* device-support entry table */
STATIC long scaler_report(int level);
STATIC long scaler_init(int after);
STATIC long scaler_init_record(struct scalerRecord *psr, CALLBACK *pcallback);
#define scaler_get_ioint_info NULL
STATIC long scaler_reset(scalerRecord *psr);
STATIC long scaler_read(scalerRecord *psr, long *val);
STATIC long scaler_write_preset(scalerRecord *psr, int signal, long val);
STATIC long scaler_arm(scalerRecord *psr, int val);
STATIC long scaler_done(scalerRecord *psr);

SCALERDSET devSGscaler16 = {
	7, 
	scaler_report,
	scaler_init,
	scaler_init_record,
	scaler_get_ioint_info,
	scaler_reset,
	scaler_read,
	scaler_write_preset,
	scaler_arm,
	scaler_done
};
epicsExportAddress(dset, devSGscaler16);

STATIC int scaler_total_cards;
STATIC struct scaler_state {
	int num_channels;
	int count_in_progress; /* count in progress? */
	volatile epicsUInt8 *localAddr; /* address of this card */
	IOSCANPVT ioscanpvt;
	int done;
	int preset[MAX_SCALER_CHANNELS];
	scalerRecord *psr;
	CALLBACK *pcallback;
};

typedef struct {
	int card;
} devSGscaler16Pvt;

STATIC struct scaler_state **scaler_state = 0;


/**************************************************
* scaler_report()
***************************************************/
STATIC long scaler_report(int level)
{
	int card=0;

	if (scaler_state[card]) {
		printf("    SGscaler%-2d card %d @ %p\n",
			scaler_state[card]->num_channels,
			card, 
			scaler_state[card]->localAddr);
	}
	return (0);
}

/**************************************************
* scaler_shutdown()
***************************************************/
STATIC int scaler_shutdown()
{
	return(0);
}

/**************************************************
* scalerISR()
***************************************************/
STATIC void scalerISR()
{
	Debug(5, "%s", "scalerISR: entry\n");
	int card = 0;
	
	/* tell record support the hardware is done counting */
	scaler_state[card]->done = 1;

	/* get the record processed */
	callbackRequest(scaler_state[card]->pcallback);

	return;
}

/**************************************************
* scalerISRSetup()
***************************************************/
STATIC int scalerISRSetup(int card)
{	
	Debug(5, "scalerISRSetup: Entry, card #%d\n", card);
	if ((card+1) > scaler_total_cards) return(ERROR);
	softGlueRegisterInterruptRoutine(0x80000000, 0, scalerISR, (void *)NULL);
	Debug(5, "scalerISRSetup: Exit, card #%d\n", card);
	return (OK);
}


/***************************************************
* initialize all software and hardware
* scaler_init()
****************************************************/
STATIC long scaler_init(int after)
{
	int card;
	int i;
	UIO_struct *pUIO = NULL;
	volatile epicsUInt8 *reg8_localAddr;
 
	Debug(2,"scaler_init(): entry, after = %d\n", after);
	if (after) return(0);

	card=0;

	/* allocate scaler_state structure, array of pointers */
	if (scaler_state == NULL) {
		scaler_state = (struct scaler_state **) calloc(1, sizeof(struct scaler_state *));
		scaler_total_cards = 1;
		scaler_state[card] = (struct scaler_state *) calloc(1, sizeof(struct scaler_state));
	}

	scaler_state[card]->localAddr = 0;

	i = findUioAddr("pixelFIFO_", 0);
	if (i >= 0) {
		pUIO = UIO[i];
		fifoAddr = pUIO->localAddr;
		fifoCountAddr = fifoAddr + 1;
	}

	i = findUioAddr("softGlue_", 0);
	if (i >= 0) {
		pUIO = UIO[i];
		reg8_localAddr = (epicsUInt8 *)(pUIO->localAddr);
		scalerEn = reg8_localAddr + 228;	/* Scaler-1_EN */
		scalerClr = reg8_localAddr + 229;	/* Scaler-1_CLR */
		scalerCnt = reg8_localAddr + 281;	/* Scaler-1_CNT */
		scalerStop = reg8_localAddr + 282;	/* Scaler-1_STOP */
		scalerRead = reg8_localAddr + 230;	/* scalersToFIFO-1_CHADV */
		scalerCntg = reg8_localAddr + 83;	/* Scaler-1_CNTG */
		scaler_state[card]->localAddr = reg8_localAddr;
	}

	i = findUioAddr("softGlueReg32_", 0);
	if (i >= 0) {
		pUIO = UIO[i];
		scalerPreset = pUIO->localAddr+44;
	}
		

	/* get this card's type (8 or 16 channels?) */
	scaler_state[card]->num_channels =  16;
	Debug(3,"scaler_init: nchan = %d\n", scaler_state[card]->num_channels);
	for (i=0; i<MAX_SCALER_CHANNELS; i++) {
		scaler_state[card]->preset[i] = 0;
	}


	Debug(3,"scaler_init: Total cards = %d\n\n",scaler_total_cards);

	Debug(3, "%s", "scaler_init: scaler initialized\n");
	return(0);
}

/***************************************************
* scaler_init_record()
****************************************************/
STATIC long scaler_init_record(struct scalerRecord *psr, CALLBACK *pcallback)
{
	int card = psr->out.value.vmeio.card;
	int status;
	devSGscaler16Pvt *dpvt;

	Debug(5,"scaler_init_record: card %d\n", card);
	dpvt = (devSGscaler16Pvt *)calloc(1, sizeof(devSGscaler16Pvt));
	dpvt->card = card;
	psr->dpvt = dpvt;
	if (scaler_state == NULL) {
		recGblRecordError(S_dev_noDevSup,(void *)psr, "");
		return(S_dev_noDevSup);
	}
	scaler_state[card]->psr = psr;

	/* out must be an VME_IO */
	switch (psr->out.type)
	{
	case (VME_IO) : break;
	default:
		recGblRecordError(S_dev_badBus,(void *)psr,
			"devSGscaler16 (init_record) Illegal OUT Bus Type");
		return(S_dev_badBus);
	}

	Debug(5,"SGscaler16: card %d\n", card);

	psr->nch = scaler_state[card]->num_channels;

	/* setup interrupt handler */
	scaler_state[card]->pcallback = pcallback;
	status = scalerISRSetup(card);
	if (status) printf("scaler_init_record: scalerISRSetup returned %d", status);
	return(0);
}


/***************************************************
* scaler_reset()
****************************************************/
STATIC long scaler_reset(scalerRecord *psr)
{
	int i;
	devSGscaler16Pvt *dpvt = psr->dpvt;
	int card = dpvt->card;

	Debug(5,"scaler_reset: card %d\n", card);
	*scalerCnt = 0;
	*scalerStop = 0x20;
	*scalerStop = 0;

	/* zero local copy of scaler presets */
	for (i=0; i<MAX_SCALER_CHANNELS; i++) {
		scaler_state[card]->preset[i] = 0;
	}

	/* clear hardware-done flag */
	scaler_state[card]->done = 0;

	return(0);
}

/***************************************************
* scaler_read()
* return pointer to array of scaler values (on the card)
****************************************************/
STATIC long scaler_read(scalerRecord *psr, long *val)
{
	int i;
	devSGscaler16Pvt *dpvt = psr->dpvt;
	int card = dpvt->card;

	Debug(8,"scaler_read: card %d\n", card);
	if ((card+1) > scaler_total_cards) return(ERROR);

	/* read scalers */
	*fifoAddr = 0;	/* write to fifoAddr clears the FIFO */
	*scalerRead = 0x20;	/* transfer all 16 scalers to FIFO */
	*scalerRead = 0;

	for (i=0; i < scaler_state[card]->num_channels; i++) {
		if (i==0) {
			Debug(8,"scaler_read: input 0: preset==%d\n", scaler_state[card]->preset[i]);
			val[i] = scaler_state[card]->preset[i] - *fifoAddr;
		} else {
			val[i] = *fifoAddr;
		}
		Debug(11,"scaler_read: ...scaler=%ld\n", val[i]);
	}
	if ((*scalerCntg&0x10) == 0) {
		Debug(8,"scaler_read: scaler is done.  (*scalerCntg==0x%x)\n", *scalerCntg);
		/* scaler is done */
		if (scaler_state[card]->done == 0) {
			Debug(8,"scaler_read: setting done=%d.\n", 1);
			/* scaler_state[card]->done = 1; */
		}
	}
	return(0);
}

/***************************************************
* scaler_write_preset()
****************************************************/
STATIC long scaler_write_preset(scalerRecord *psr, int signal, long val)
{
	devSGscaler16Pvt *dpvt = psr->dpvt;
	int card = dpvt->card;
	if (signal==0) {
		Debug(8,"scaler_write_preset: ch 0.  (preset==%ld)\n", val);
		*scalerPreset = val;
		scaler_state[card]->preset[signal] = val;
	}
	if (psr->g1 == 0) {psr->g1 = 1; db_post_events(psr,&(psr->g1),DBE_VALUE);}
	if (psr->g2 == 1) {psr->g2 = 0; db_post_events(psr,&(psr->g2),DBE_VALUE);}
	if (psr->g3 == 1) {psr->g3 = 0; db_post_events(psr,&(psr->g3),DBE_VALUE);}
	if (psr->g4 == 1) {psr->g4 = 0; db_post_events(psr,&(psr->g4),DBE_VALUE);}
	if (psr->g5 == 1) {psr->g5 = 0; db_post_events(psr,&(psr->g5),DBE_VALUE);}
	if (psr->g6 == 1) {psr->g6 = 0; db_post_events(psr,&(psr->g6),DBE_VALUE);}
	if (psr->g7 == 1) {psr->g7 = 0; db_post_events(psr,&(psr->g7),DBE_VALUE);}
	if (psr->g8 == 1) {psr->g8 = 0; db_post_events(psr,&(psr->g8),DBE_VALUE);}
	if (psr->g9 == 1) {psr->g9 = 0; db_post_events(psr,&(psr->g9),DBE_VALUE);}
	if (psr->g10 == 1) {psr->g10 = 0; db_post_events(psr,&(psr->g10),DBE_VALUE);}
	if (psr->g11 == 1) {psr->g11 = 0; db_post_events(psr,&(psr->g11),DBE_VALUE);}
	if (psr->g12 == 1) {psr->g12 = 0; db_post_events(psr,&(psr->g12),DBE_VALUE);}
	if (psr->g13 == 1) {psr->g13 = 0; db_post_events(psr,&(psr->g13),DBE_VALUE);}
	if (psr->g14 == 1) {psr->g14 = 0; db_post_events(psr,&(psr->g14),DBE_VALUE);}
	if (psr->g15 == 1) {psr->g15 = 0; db_post_events(psr,&(psr->g15),DBE_VALUE);}
	if (psr->g16 == 1) {psr->g16 = 0; db_post_events(psr,&(psr->g16),DBE_VALUE);}
	return(0);
}

/***************************************************
* scaler_arm()
* Make scaler start or stop counting.
****************************************************/
STATIC long scaler_arm(scalerRecord *psr, int val)
{
	devSGscaler16Pvt *dpvt = psr->dpvt;
	int card = dpvt->card;

	Debug(5,"scaler_arm: card %d\n", card);
	Debug(5,"scaler_arm: val = %d\n", val);
	if ((card+1) > scaler_total_cards) return(ERROR);

	if (val) {
		/* clear hardware-done flag */
		scaler_state[card]->done = 0;

		/* arm scaler */
		*scalerClr = 0x20;
		*scalerClr = 0;
		*scalerStop = 0;
		/* *scalerEn = 0x20; let user do this */
		*scalerCnt = 0x20;
		*scalerCnt = 0;
	} else {
		*scalerCnt = 0;
		*scalerStop = 0x20;
		*scalerStop = 0;
		/* set hardware-done flag */
		scaler_state[card]->done = 1;
	}
	return(0);
}


/***************************************************
* scaler_done()
****************************************************/
STATIC long scaler_done(scalerRecord *psr)
{
	devSGscaler16Pvt *dpvt = psr->dpvt;
	int card = dpvt->card;
	if ((card+1) > scaler_total_cards) return(ERROR);

	if (scaler_state[card]->done) {
		/* clear hardware-done flag */
		scaler_state[card]->done = 0;
		return(1);
	} else {
		return(0);
	}
}


/* debugging function */
void scaler_show(int card)
{
	printf("scaler_show: scaler_state[card]->done = %d\n", scaler_state[card]->done);
}
