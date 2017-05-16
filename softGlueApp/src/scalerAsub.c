/* Copyright (c) 2016 UChicago Argonne LLC, as Operator of Argonne
 * National Laboratory, and The Regents of the University of California, as
 * Operator of Los Alamos National Laboratory.
 * softGlueZynq is distributed subject to a Software License Agreement found
 * in the file LICENSE that is included with this distribution.
 */

/* scalerAsub - read scalers from FIFO.  Test scaler operation, in preparation for
 * scalerRecord device support.
 * aSub record fields:
 *	a	cnt
 *	b	count time in clock ticks
 *  vala[] - valp[]  scaler values 1-16
 *
 * Tim Mooney
 */

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
#include <dbDefs.h>
#include <dbCommon.h>
#include <epicsThread.h>
#include <recSup.h>
#include <aSubRecord.h>
#include <epicsExport.h>

#define MAX(a,b) ((a)>(b)?(a):(b))

volatile int scalerDebug=0;
epicsExportAddress(int, scalerDebug);

static volatile epicsUInt32 *fifoAddr;
static volatile epicsUInt32 *fifoCountAddr;
static volatile epicsUInt32 *scalerPreset;
static volatile epicsUInt8 *scalerEn, *scalerClr, *scalerCnt, *scalerStop, *scalerRead;

static long scaler_init(aSubRecord *pasub) {
	epicsUInt32 *scaler1 = (epicsUInt32 *)pasub->vala;
	epicsUInt32 *scaler2 = (epicsUInt32 *)pasub->valb;
	epicsUInt32 *scaler3 = (epicsUInt32 *)pasub->valc;
	epicsUInt32 *scaler4 = (epicsUInt32 *)pasub->vald;
	epicsUInt32 *scaler5 = (epicsUInt32 *)pasub->vale;
	epicsUInt32 *scaler6 = (epicsUInt32 *)pasub->valf;
	epicsUInt32 *scaler7 = (epicsUInt32 *)pasub->valg;
	epicsUInt32 *scaler8 = (epicsUInt32 *)pasub->valh;
	epicsUInt32 *scaler9 = (epicsUInt32 *)pasub->vali;
	epicsUInt32 *scaler10 = (epicsUInt32 *)pasub->valj;
	epicsUInt32 *scaler11 = (epicsUInt32 *)pasub->valk;
	epicsUInt32 *scaler12 = (epicsUInt32 *)pasub->vall;
	epicsUInt32 *scaler13 = (epicsUInt32 *)pasub->valm;
	epicsUInt32 *scaler14 = (epicsUInt32 *)pasub->valn;
	epicsUInt32 *scaler15 = (epicsUInt32 *)pasub->valo;
	epicsUInt32 *scaler16 = (epicsUInt32 *)pasub->valp;
	int i;
	UIO_struct *pUIO = NULL;
	volatile epicsUInt8 *reg8_localAddr;

	if (scalerDebug) {
		printf("scaler_init: entry\n");
	}

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
		scalerRead = reg8_localAddr + 230;	/* PixelFIFO-1_CHADV */
	}

	i = findUioAddr("softGlueReg32_", 0);
	if (i >= 0) {
		pUIO = UIO[i];
		scalerPreset = pUIO->localAddr+44;
	}

	*scaler1 = 0;
	*scaler2 = 0;
	*scaler3 = 0;
	*scaler4 = 0;
	*scaler5 = 0;
	*scaler6 = 0;
	*scaler7 = 0;
	*scaler8 = 0;
	*scaler9 = 0;
	*scaler10 = 0;
	*scaler11 = 0;
	*scaler12 = 0;
	*scaler13 = 0;
	*scaler14 = 0;
	*scaler15 = 0;
	*scaler16 = 0;

	return(0);
}

static long scaler_do(aSubRecord *pasub) {
	int *cnt = (int *)pasub->a;
	int *countTicks = (int *)pasub->b;
	static int cnt_saved = 0;
	epicsUInt32 *scaler1 = (epicsUInt32 *)pasub->vala;
	epicsUInt32 *scaler2 = (epicsUInt32 *)pasub->valb;
	epicsUInt32 *scaler3 = (epicsUInt32 *)pasub->valc;
	epicsUInt32 *scaler4 = (epicsUInt32 *)pasub->vald;
	epicsUInt32 *scaler5 = (epicsUInt32 *)pasub->vale;
	epicsUInt32 *scaler6 = (epicsUInt32 *)pasub->valf;
	epicsUInt32 *scaler7 = (epicsUInt32 *)pasub->valg;
	epicsUInt32 *scaler8 = (epicsUInt32 *)pasub->valh;
	epicsUInt32 *scaler9 = (epicsUInt32 *)pasub->vali;
	epicsUInt32 *scaler10 = (epicsUInt32 *)pasub->valj;
	epicsUInt32 *scaler11 = (epicsUInt32 *)pasub->valk;
	epicsUInt32 *scaler12 = (epicsUInt32 *)pasub->vall;
	epicsUInt32 *scaler13 = (epicsUInt32 *)pasub->valm;
	epicsUInt32 *scaler14 = (epicsUInt32 *)pasub->valn;
	epicsUInt32 *scaler15 = (epicsUInt32 *)pasub->valo;
	epicsUInt32 *scaler16 = (epicsUInt32 *)pasub->valp;
	
	if (scalerDebug) {
		printf("scaler_do: entry\n");
	}

	if (*cnt != cnt_saved) {
		/* start or stop scaler */
		cnt_saved = *cnt;
		if (*cnt) {
			if (scalerDebug) printf("scaler_do: start counting\n");
			*scalerPreset = *countTicks;
			/* Note, to write 1(0) to a softGlue 8 bit register, write 0x20 (0)*/
			*scalerClr = 0x20;
			*scalerClr = 0;
			*scalerEn = 0x20;
			*scalerStop = 0;
			*scalerCnt = 0x20;
			*scalerCnt = 0;
		} else {
			if (scalerDebug) printf("scaler_do: stop counting\n");
			*scalerCnt = 0;
			*scalerStop = 0x20;
			*scalerStop = 0;
		}
	}
	/* read scalers */
	*fifoAddr = 0;	/* write to fifoAddr clears the FIFO */
	if (scalerDebug) printf("scaler_do: cleared: FIFO count = %d\n", *fifoCountAddr);
	*scalerRead = 0x20;	/* transfer all 16 scalers to FIFO */
	*scalerRead = 0;
	if (scalerDebug) printf("scaler_do: read: FIFO count = %d\n", *fifoCountAddr);
	*scaler1 = *fifoAddr;
	if (scalerDebug) printf("scaler_do: scaler1 = %d\n", *scaler1);
	*scaler2 = *fifoAddr;
	*scaler3 = *fifoAddr;
	*scaler4 = *fifoAddr;
	*scaler5 = *fifoAddr;
	*scaler6 = *fifoAddr;
	*scaler7 = *fifoAddr;
	*scaler8 = *fifoAddr;
	*scaler9 = *fifoAddr;
	*scaler10 = *fifoAddr;
	*scaler11 = *fifoAddr;
	*scaler12 = *fifoAddr;
	*scaler13 = *fifoAddr;
	*scaler14 = *fifoAddr;
	*scaler15 = *fifoAddr;
	*scaler16 = *fifoAddr;


	return(0);
}

#include <registryFunction.h>
static registryFunctionRef scalerRef[] = {
	{"scaler_init", (REGISTRYFUNCTION)scaler_init},
	{"scaler_do", (REGISTRYFUNCTION)scaler_do}
};

static void scalerRegister(void) {
	registryFunctionRefAdd(scalerRef, NELEMENTS(scalerRef));
}

epicsExportRegistrar(scalerRegister);
