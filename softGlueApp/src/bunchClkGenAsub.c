/* Copyright (c) 2016 UChicago Argonne LLC, as Operator of Argonne
 * National Laboratory, and The Regents of the University of California, as
 * Operator of Los Alamos National Laboratory.
 * softGlueZynq is distributed subject to a Software License Agreement found
 * in the file LICENSE that is included with this distribution.
 */

/* clockConfigAsub - configure Xilinx clock-wizard clock frequencies
 * aSub record fields:
 * vala - actual frequency of clock 1	(softGlue register clock)
 * valb - actual frequency of clock 2	(50MHZ_CLOCK)
 * valc - actual frequency of clock 3	(20MHZ_CLOCK)
 * vald - actual frequency of clock 4	(10MHZ_CLOCK)
 * vale - actual frequency of clock 5	(fast gate&delay clock)
 * valf - actual frequency of clock 6	(fast Histo clock)
 * Tim Mooney
 */

/*
Bunch PVs:
Mt:S:NumBucketsFilledAI\(.*\)	ALIAS	XFD:NumFilledBuckets\1
Mt:S:FilledBucketsWF\(.*\)	ALIAS	S-INJ:ActiveBucketFillQueueArrayM\1
Mt:S:FillPatternWF\(.*\)	ALIAS	XFD:FilledBuckets\1
S:BeamStatusMBBI\(.*\)		ALIAS   XFD:BeamStatus\1
S:InjectingStatusMBBI\(.*\)	ALIAS   XFD:InjectingStatus\1
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
#include <epicsThread.h>
#include <iocsh.h>
/* findUioAddr(), UIO array */
#include "drvZynq.h"
#include <dbDefs.h>
#include <dbCommon.h>
#include <epicsThread.h>
#include <recSup.h>
#include <aSubRecord.h>
#include <epicsExport.h>

static volatile epicsUInt32 *localAddr_clock = NULL, *localAddr_pattern = NULL;

#define NINT(f)  (int)((f)>0 ? (f)+0.5 : (f)-0.5)

// #define MAX_M 61
// #define MAXBAD 20

// function to convert array of bunch numbers to pattern
static int* ()

static long clockConfig_init(aSubRecord *pasub) {
	int i;
	UIO_struct *pUIO = NULL;

	// find base address of 352 MHz clock
	i = findUioAddr("clk_wiz_2", 0);
	if (i >= 0) {
		pUIO = UIO[i];
		localAddr_clock = pUIO->localAddr;
	}
	i = findUioAddr("bunchClkGen_v1_0_S00_AXI", 0);
	if (i >= 0) {
		pUIO = UIO[i];
		localAddr_pattern = pUIO->localAddr;
	}
	return(0);
}

// Tasks in do:
// load pattern
// set phase
static long clockConfig_do(aSubRecord *pasub) {
	double *vala = (double *)pasub->vala;
	double *a = (double *)pasub->a;
	double desiredFreq;
	int *b = (int *)pasub->b;	/* clock select */
	int *c = (int *)pasub->c;	/* do write */
	int *d = (int *)pasub->d;	/* debug */
	int i, clockConfig;
	int div, frac, frac_enable, mult;
	double div_full, freq, baseFreq_0,  baseFreq_1, inputFreq_0, inputFreq_1;
	int clockNum;
	volatile epicsUInt32 *masterConfigReg, *reg;
	int Mint, Mfrac, Nint, Nfrac;
	int status0, status1;
	int badM[MAXBAD], thisBad;

	/* clk_wiz_0 input clock */
	inputFreq_0 = 100;
	clockConfig = *(localAddr_0 + (0x200)/4);
	div = clockConfig & 0xff;
	mult = (clockConfig>>8) & 0xff;
	frac = (clockConfig>>16) & 0x3ff;
	/* fractional resolution is 1/8 */
	frac = ((int)(frac*8))/8;
	frac_enable = clockConfig>>26 & 0x1;
	baseFreq_0 = (inputFreq_0/div)*mult;
	if (*d>1) printf("common: div=%d, mult=%d, frac=%d, frac_enable=%d, baseFreq_0=%f MHz\n",
		div, mult, frac, frac_enable, baseFreq_0);

	/* clk_wiz_1 input clock */
	inputFreq_1 = 20;
	clockConfig = *(localAddr_1 + (0x200)/4);
	div = clockConfig & 0xff;
	mult = (clockConfig>>8) & 0xff;
	frac = (clockConfig>>16) & 0x3ff;
	/* fractional resolution is 1/8 */
	frac = ((int)(frac*8))/8;
	frac_enable = clockConfig>>26 & 0x1;
	baseFreq_1 = (inputFreq_1/div)*mult;
	if (*d>1) printf("common: div=%d, mult=%d, frac=%d, frac_enable=%d, baseFreq_1=%f MHz\n",
		div, mult, frac, frac_enable, baseFreq_1);

	if (*d==100) {
		/* reset clk_wiz_1 to original configuration */
		masterConfigReg = localAddr_1 + 0x25C/4;
		*masterConfigReg = 7;
		*masterConfigReg = 2;
		return(0);
	}
	clockNum = *b;
	/* write clock */
	if (*c) {
		if (clockNum < 6) {
			masterConfigReg = localAddr_0 + 0x25C/4;
			desiredFreq = *a; 
			div_full = baseFreq_0/desiredFreq;
			div = (int)(div_full);
			frac = (int)((div_full - div) * 1000);
			/* Only the first clock is allowed a fractional divide */
			if (clockNum>1) frac = 0;
			if (*d>1) printf("clock %d: div=%d, frac=%d\n", clockNum, div, frac);
			reg = localAddr_0 + (0x208 + 12*(clockNum-1))/4;
			clockConfig = (div & 0xff) + ((frac & 0x3ff)<<8) + (1<<18);
			*reg = clockConfig;
			*masterConfigReg = 7;
			*masterConfigReg = 2;
			*c = 0;
		} else {
			desiredFreq = *a;
			status1 = 0;

			for (thisBad=0; thisBad<MAXBAD; thisBad++) {badM[thisBad] = 0;}
			for (thisBad=0; status1==0 && thisBad<MAXBAD; thisBad++) {

				/* get best values for clock mult and div registers */
				i = findBest(inputFreq_1, desiredFreq, &Mint, &Mfrac, &Nint, &Nfrac, *d, badM);
				if (i==0) {
					/* program input clock multiplier */
					clockConfig = *(localAddr_1 + (0x200)/4);
					div = 1;
					mult = Mint;
					frac = Mfrac;
					clockConfig = (div & 0xff) + ((mult & 0xff)<<8) + ((frac & 0x3ff)<<16) + (1<<26);
					reg = localAddr_1 + (0x200)/4;
					*reg = clockConfig;
					baseFreq_1 = (inputFreq_1/div)*(mult+frac/1000.);
	
					/* program output clock divider */
					masterConfigReg = localAddr_1 + 0x25C/4;
					div = Nint;
					frac = Nfrac;
					if (*d>1) printf("clock %d: div=%d, frac=%d\n", clockNum, div, frac);
					reg = localAddr_1 + (0x208 + 12*(clockNum-6))/4;
					clockConfig = (div & 0xff) + ((frac & 0x3ff)<<8) + (1<<18);
					*reg = clockConfig;
					*masterConfigReg = 7;
					*masterConfigReg = 2;
				}
				/* check to see if the clock generator's loop is locked (is working) */
 				epicsThreadSleep(.05);
 				status1 = *(localAddr_1+1);
				if (!status1) {
					badM[thisBad] = Mint*8 + Mfrac/125;
					if (*d>1) printf("clk_wiz_1 status1: M/8=%.3f, %d\n", (Mint*8 + Mfrac/125)/8., status1);
				}
			}



			*c = 0;
		}
	}

	/* read clock */
	if (clockNum < 6) {
		clockConfig = *(localAddr_0 + (0x208 + 12*(clockNum-1))/4);
		div = clockConfig & 0xff;
		frac = (clockConfig>>8) & 0x3ff;
		/* fractional resolution is 1/8 */
		frac = ((int)(frac*8))/8;
		frac_enable = (clockConfig>>18) & 0x1;
		div_full = div + frac/1000.;
		freq = baseFreq_0/div_full;
		if (*d>1) printf("clock %d: div=%d, frac=%d, frac_enable=%d, f=%f MHz\n",
			clockNum, div, frac, frac_enable, freq);
		*vala = freq;
	} else {
		clockConfig = *(localAddr_1 + (0x208 + 12*(clockNum-6))/4);
		div = clockConfig & 0xff;
		frac = (clockConfig>>8) & 0x3ff;
		/* fractional resolution is 1/8 */
		frac = ((int)(frac*8))/8;
		frac_enable = (clockConfig>>18) & 0x1;
		div_full = div + frac/1000.;
		freq = baseFreq_1/div_full;
		if (*d>1) printf("clock %d: div=%d, frac=%d, frac_enable=%d, f=%f MHz\n",
			clockNum, div, frac, frac_enable, freq);
		*vala = freq;
	}
	status0 = *(localAddr_0+1);
	status1 = *(localAddr_1+1);
	if (*d>1) printf("clk_wiz_1 status0=%d, status1=%d\n", status0, status1);
	return(0);
}


#include <registryFunction.h>
static registryFunctionRef clockConfigRef[] = {
	{"clockConfig_init", (REGISTRYFUNCTION)clockConfig_init},
	{"clockConfig_do", (REGISTRYFUNCTION)clockConfig_do}
};

static void clockConfigRegister(void) {
	registryFunctionRefAdd(clockConfigRef, NELEMENTS(clockConfigRef));
}
epicsExportRegistrar(clockConfigRegister);
