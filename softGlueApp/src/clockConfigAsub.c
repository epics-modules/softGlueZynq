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
/* findUioAddr(), UIO array */
#include "drvZynq.h"
#include <dbDefs.h>
#include <dbCommon.h>
#include <epicsThread.h>
#include <recSup.h>
#include <aSubRecord.h>
#include <epicsExport.h>

volatile epicsUInt32 *localAddr = NULL;

#define NINT(f)  (int)((f)>0 ? (f)+0.5 : (f)-0.5)

static long clockConfig_init(aSubRecord *pasub) {
	int i;
	UIO_struct *pUIO = NULL;

	i = findUioAddr("clk_wiz", 0);
	if (i >= 0) {
		pUIO = UIO[i];
		localAddr = pUIO->localAddr;
	}
	return(0);
}

static long clockConfig_do(aSubRecord *pasub) {
	double *vala = (double *)pasub->vala;
	double *a = (double *)pasub->a;
	double desiredFreq;
	int *b = (int *)pasub->b;	/* clock select */
	int *c = (int *)pasub->c;	/* do write */
	int *d = (int *)pasub->d;	/* debug */
	int clockConfig, div, frac, frac_enable, mult;
	double div_full, freq, baseFreq, inputFreq;
	int clockNum;
	volatile epicsUInt32 *masterConfigReg, *reg;
	
	/* input clock */
	inputFreq = 100;
	clockConfig = *(localAddr + (0x200)/4);
	div = clockConfig & 0xff;
	mult = (clockConfig>>8) & 0xff;
	frac = (clockConfig>>16) & 0x3ff;
	frac_enable = clockConfig>>26 & 0x1;
	baseFreq = (inputFreq/div)*mult;
	if (*d) printf("common: div=%d, mult=%d, frac=%d, frac_enable=%d, baseFreq=%f MHz\n",
		div, mult, frac, frac_enable, baseFreq);

	clockNum = *b;
	/* write clock */
	if (*c) {
		masterConfigReg = localAddr + 0x25C/4;
		desiredFreq = *a; 
		div_full = baseFreq/desiredFreq;
		div = (int)(div_full);
		frac = (int)((div_full - div) * 1000);
		if (*d) printf("clock %d: div=%d, frac=%d\n", clockNum, div, frac);
		reg = localAddr + (0x208 + 12*(clockNum-1))/4;
		clockConfig = (div & 0xff) + ((frac & 0x3ff)<<8) + (1<<18);
		*reg = clockConfig;
		*masterConfigReg = 7;
		*masterConfigReg = 2;
		*c = 0;
	}

	/* read clock */
	clockConfig = *(localAddr + (0x208 + 12*(clockNum-1))/4);
	div = clockConfig & 0xff;
	frac = (clockConfig>>8) & 0x3ff;
	frac_enable = (clockConfig>>18) & 0x1;
	div_full = div + frac/1000.;
	freq = baseFreq/div_full;
	if (*d) printf("clock %d: div=%d, frac=%d, frac_enable=%d, f=%f MHz\n",
		clockNum, div, frac, frac_enable, freq);
	*vala = freq;

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
