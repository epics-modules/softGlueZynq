/* Copyright (c) 2016 UChicago Argonne LLC, as Operator of Argonne
 * National Laboratory, and The Regents of the University of California, as
 * Operator of Los Alamos National Laboratory.
 * softGlueZynq is distributed subject to a Software License Agreement found
 * in the file LICENSE that is included with this distribution.
 */

/* aSub support to implement readSoftGlueCounter_ISR.db
 *
 * Other code will arrange for softGlue to generate interrupts
 * described by "AXI_Address" and "risingMask".  Our job is to
 * register an interrupt-service routine with softGlue, and have it
 * ready to read values from two softGlue counters' COUNTS registers when
 * an interrupt occurs, and to write those values to arrays of 32-bit ints.
 * An aSub record will host the arrays; we'll cache the addresses of the arrays for
 * our ISR.  We'll also cache addresses for the COUNTS registers.
 * Other code will set the array index (an aSub field) to zero before starting
 * the softGlue circuit that will generate interrupts.  We'll cache the address
 * of that array index, and increment it on each write to an array element.
 * Measured CPU load (percentage of maximum) for various recording frequencies:
 *	    0	 9	(these are softGlue values.  softGlueZynq values haven't been measured yet.)
 *	  500	12
 *	 1000	13
 *	 2000	16
 *	 4000	21
 *	 8000	31
 *	16000	51
 *	20000	65
 */
#include <stddef.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <stdio.h>

#include <dbDefs.h>
#include <dbCommon.h>
#include <recSup.h>
#include <aSubRecord.h>

#include "drvZynq.h"
#include <epicsExport.h>

volatile int readSoftGlueCounter_ISRDebug=0;
epicsExportAddress(int, readSoftGlueCounter_ISRDebug);


/* custom interrupt-service routine */
typedef struct {
	epicsUInt32 *(addr[8]);
	int *UpDnCounter_1_values;
	int *UpDnCounter_2_values;
	int numValues;
	int index;
	int counter1; /* in 1..8 */
	int counter2; /* in 1..8 */
	int reset;
	int oneshot;
} rcISRDataStruct;
static rcISRDataStruct rcISRData;

static void readSoftGlueCounterISR(softGlueIntRoutineData *IRData) {
	ushort risingMask = IRData->risingMask;
	rcISRDataStruct *rcISRData = (rcISRDataStruct *)(IRData->userPvt);
	int index = rcISRData->index;
	int counter1 = rcISRData->counter1;
	int counter2 = rcISRData->counter2;
	
	unsigned short *data = (unsigned short *)(IRData->userPvt);
	int i;
	if (readSoftGlueCounter_ISRDebug>=10) {
		printf("readSoftGlueCounterISR(0x%x)\n", risingMask);
		for (i=0;i<10;i++) {
			printf("%04hx %04hx %04hx %04hx  ", data[i*8], data[i*8+1], data[i*8+2], data[i*8+3]);
			printf("%04hx %04hx %04hx %04hx\n",	data[i*8+4], data[i*8+5], data[i*8+6], data[i*8+7]);
		}
	}

	if (rcISRData->reset) {
		/* printf("readSoftGlueCounterISR: reset\n"); */
		index = 0;
		rcISRData->reset = 0;
	}
	if (index >= rcISRData->numValues) {
		if (!rcISRData->oneshot) index = 0;
	}
	if (index < rcISRData->numValues) {
		rcISRData->UpDnCounter_1_values[index] = *(rcISRData->addr[counter1-1]) ;
		rcISRData->UpDnCounter_2_values[index] = *(rcISRData->addr[counter2-1]) ;
	}
	if (readSoftGlueCounter_ISRDebug>10) {
		printf("readSoftGlueCounterISR: addr[%d]=%p\n", counter1, rcISRData->addr[counter1-1]);
		printf("readSoftGlueCounterISR: rcISRData=%p, &rcISRData->numValues=%p, &rcISRData->index=%p\n",
			rcISRData, &rcISRData->numValues, &rcISRData->index);
		printf("readSoftGlueCounterISR(0x%x) UpDnCounter_1_values=%p, UpDnCounter_2_values=%p\n", risingMask, rcISRData->UpDnCounter_1_values, rcISRData->UpDnCounter_2_values);
		printf("readSoftGlueCounterISR: UpDn[%d][%d]=%d\n", counter1, index, rcISRData->UpDnCounter_1_values[index]);
		printf("readSoftGlueCounterISR: UpDn[%d][%d]=%d\n", counter2, index, rcISRData->UpDnCounter_2_values[index]);
		printf("readSoftGlueCounterISR: numValues=%d, oneshot=%d\n", rcISRData->numValues, rcISRData->oneshot);
	}

	if (index < rcISRData->numValues) index++;
	if (index >= rcISRData->numValues) {
		if (!rcISRData->oneshot) index = 0;
	}
	rcISRData->index = index;
}

/* counter register offset addresses from softGlue_FPGARegisters.substitutions. */
static int counterOffset[10] = {
	0,
	1,
	2,
	3,
	4,
	5,
	6,
	7
};

int readSoftGlueCounter_ISRPrepare(epicsUInt32 risingMask) {
	int i;
	/* Get the address of the COUNTS registers of eight counters. */
	for (i=0; i<5; i++) {
		/* The first arg specifies which AXI component: 0 for 8-bit I/O point register, 1 for 32-bit register */
		rcISRData.addr[i] = softGlueZCalcSpecifiedRegisterAddress(1, counterOffset[i]);
		if (readSoftGlueCounter_ISRDebug) {
			printf("readSoftGlueCounter_ISRPrepare: addr[%d]=%p\n", i, rcISRData.addr[i]);
		}
	}

	if (readSoftGlueCounter_ISRDebug) {
		printf("readSoftGlueCounter_ISRPrepare: addr[0]=%p\n", rcISRData.addr[0]);
	}
	/* Tell softGlue to call readSoftGlueCounterISR() when its interrupt-service routine handles
	 * an interrupt that matches the specified mask.  This also tells softGlue to not execute any
	 * output links that might have been programmed to execute in response to this interrupt.
	 * The second arg is for fallingMask, which hasn't been implemented yet.
	 */
	softGlueRegisterInterruptRoutine(risingMask, 0, readSoftGlueCounterISR, (void *)&rcISRData);
	return(0);
}

/*
aSub variables:
a (int):	counter1 in [1..5] specifies which UpDown counter to read
b (int):	if 1, set array index to zero and set b to zero
c (int):	number of values in array
d (int):	counter2 in [1..5] specifies which UpDown counter to read
e (int):	continuous (0) or one shot (1)
vala (int):	array of values read from the softGlue counter 1
valb (int):	array index
valc (int):	array of values read from the softGlue counter 2
*/

static long readSoftGlueCounter_ISR_init(aSubRecord *pasub) {
	int *values1 = (int *) pasub->vala;
	int *values2 = (int *) pasub->valc;
	int numValues = pasub->nova;
	int *index = (int *) pasub->valb;
	int *counter1 = (int *) pasub->a;
	int *counter2 = (int *) pasub->d;
	int *oneshot = (int *) pasub->e;

	/* get the addresses of the following values in global pointers, so readSoftGlueCounterISR() can use them. */
	rcISRData.UpDnCounter_1_values = values1;
	rcISRData.UpDnCounter_2_values = values2;
	rcISRData.numValues = numValues;
	rcISRData.index = 0;
	*index = 0;
	rcISRData.counter1 = 1;
	rcISRData.counter2 = 2;
	*counter1 = 1;
	*counter2 = 2;
	rcISRData.oneshot = *oneshot;
	if (readSoftGlueCounter_ISRDebug) {
		printf("readSoftGlueCounter_ISR_init: rcISRData.UpDnCounter_1_values=%p, rcISRData.UpDnCounter_2_values=%p\n",
			rcISRData.UpDnCounter_1_values, rcISRData.UpDnCounter_2_values);
	}
	return(0);
}

static long readSoftGlueCounter_ISR(aSubRecord *pasub) {
	int *reset = (int *) pasub->b;
	int *index = (int *) pasub->valb;
	int *counter1 = (int *) pasub->a;
	int *counter2 = (int *) pasub->d;
	int *oneshot = (int *) pasub->e;
	int numValues = rcISRData.numValues;
	int i;

	*index = rcISRData.index;
	if (readSoftGlueCounter_ISRDebug) {
		printf("readSoftGlueCounter_ISR: entry: index=%d, reset=%d, counter1=%d, numValues=%d (%d), &rcISRData=%p, &rcISRData.numValues=%p\n",
			*index, *reset, *counter1, numValues, rcISRData.numValues, &rcISRData, &rcISRData.numValues);
		printf("readSoftGlueCounter_ISR: rcISRData.UpDnCounter_1_values=%p, rcISRData.UpDnCounter_2_values=%p\n",
			rcISRData.UpDnCounter_1_values, rcISRData.UpDnCounter_2_values);
	}

	rcISRData.oneshot = *oneshot;
	if (*reset) {
		rcISRData.reset = 1;
		*reset = 0;
		for (i=0; i<numValues; i++) {
			rcISRData.UpDnCounter_1_values[i] = 0;
			rcISRData.UpDnCounter_2_values[i] = 0;
		}
	}

	/* which counter should we read? */
	if (*counter1<1) *counter1 = 1;
	if (*counter1>8) *counter1 = 8;
	rcISRData.counter1 = *counter1;

	if (*counter2<1) *counter2 = 1;
	if (*counter2>8) *counter2 = 8;
	rcISRData.counter2 = *counter2;

	return(0);
}

#include <registryFunction.h>

/* register readSoftGlueCounter_ISRPrepare so it can be called from the ioc shell */
/* int readSoftGlueCounter_ISRPrepare(epicsUInt32 risingMask) */
static const iocshArg myArg1 = { "risingMask",	iocshArgInt};
static const iocshArg * const myArgs[1] = {&myArg1};
static const iocshFuncDef myFuncDef = {"readSoftGlueCounter_ISRPrepare",1,myArgs};
static void myCallFunc(const iocshArgBuf *args) {
	readSoftGlueCounter_ISRPrepare(args[0].ival);
}
void RSCsoftGlueISRRegistrar(void)
{
	iocshRegister(&myFuncDef, myCallFunc);
}
epicsExportRegistrar(RSCsoftGlueISRRegistrar);


/* register aSub routines so EPICS can connect them to the aSub record*/
static registryFunctionRef readSoftGlueCounter_ISRRef[] = {
	{"readSoftGlueCounter_ISR_init", (REGISTRYFUNCTION)readSoftGlueCounter_ISR_init},
	{"readSoftGlueCounter_ISR", (REGISTRYFUNCTION)readSoftGlueCounter_ISR},
};
static void readSoftGlueCounter_ISRRegister(void) {
	registryFunctionRefAdd(readSoftGlueCounter_ISRRef, NELEMENTS(readSoftGlueCounter_ISRRef));
}
epicsExportRegistrar(readSoftGlueCounter_ISRRegister);
