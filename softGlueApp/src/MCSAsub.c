/* Copyright (c) 2016 UChicago Argonne LLC, as Operator of Argonne
 * National Laboratory, and The Regents of the University of California, as
 * Operator of Los Alamos National Laboratory.
 * softGlueZynq is distributed subject to a Software License Agreement found
 * in the file LICENSE that is included with this distribution.
 */

/* MCSAsub - collect MCS events into arrays.
 * aSub record fields:
 *  vala[]  Array 1
 *  valb[]  Array 2
 *  valc[]  Array 3
 *  vald[]  Array 4
 *  vale[]  Array 5
 *  valr[]  Array 6
 *  valg[]  Array 7
 *  valh    number of events
 *  a       number of scalers
 *  d       clear arrays
 *	e		clock rate counter1
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

volatile int MCSDebug=0;
epicsExportAddress(int, MCSDebug);

typedef struct {
	volatile epicsUInt32 *fifoAddr;
	volatile epicsUInt32 *fifoCountAddr;
	epicsUInt32 *counts1, *counts2, *counts3, *counts4, *counts5, *counts6, *counts7;
	epicsUInt32 *numEvents;
	epicsUInt32 *numScalers;
	int fifoSize;
	int cleared;
	int currChannel;
	int maxChannels;
} myISRDataStruct;
myISRDataStruct myISRData;

static long MCS_init(aSubRecord *pasub) {
	epicsUInt32 *a = (epicsUInt32 *)pasub->a;

	if (MCSDebug) {
		printf("MCS_init: entry\n");
	}
	myISRData.counts1 = (epicsUInt32 *)pasub->vala;
	myISRData.counts2 = (epicsUInt32 *)pasub->valb;
	myISRData.counts3 = (epicsUInt32 *)pasub->valc;
	myISRData.counts4 = (epicsUInt32 *)pasub->vald;
	myISRData.counts5 = (epicsUInt32 *)pasub->vale;
	myISRData.counts6 = (epicsUInt32 *)pasub->valf;
	myISRData.counts7 = (epicsUInt32 *)pasub->valg;
	myISRData.numEvents = (epicsUInt32 *)pasub->valh;

	myISRData.numScalers = a;
	myISRData.cleared = 1;
	myISRData.currChannel = 0;
	myISRData.maxChannels = pasub->nova;
	return(0);
}

static long MCS_do(aSubRecord *pasub) {
	int *clear = (int *)pasub->d;
	//double clockRate = *((double *)pasub->e);
	epicsUInt32 *counts1 = (epicsUInt32 *)pasub->vala;
	epicsUInt32 *counts2 = (epicsUInt32 *)pasub->valb;
	epicsUInt32 *counts3 = (epicsUInt32 *)pasub->valc;
	epicsUInt32 *counts4 = (epicsUInt32 *)pasub->vald;
	epicsUInt32 *counts5 = (epicsUInt32 *)pasub->vale;
	epicsUInt32 *counts6 = (epicsUInt32 *)pasub->valf;
	epicsUInt32 *counts7 = (epicsUInt32 *)pasub->valg;
	epicsUInt32 *numEvents = (epicsUInt32 *)pasub->valh;

	int i;
	volatile epicsUInt32 *fifoAddr = myISRData.fifoAddr;
	//double time;

	if (MCSDebug) {
		printf("MCS_do: entry\n");
	}

	if (*clear) {
		for (i=0; i<pasub->nova; i++) {
			counts1[i] = 0;
			counts2[i] = 0;
			counts3[i] = 0;
			counts4[i] = 0;
			counts5[i] = 0;
			counts6[i] = 0;
			counts7[i] = 0;
			*numEvents = 0;
			*fifoAddr = 0;	/* write to fifoAddr clears the FIFO */
			myISRData.cleared = 1;
		}
		*clear = 0;
		myISRData.currChannel = 0;
	}

	return(0);
}

/* interrupt driven stuff */

/* When an interrupt matching conditions specified by MCSPrepare() occurs,
 * we'll get called with the bitmask that generated the interrupt, and the bit that went low or high.
 */
void MCSRoutine(softGlueIntRoutineData *IRData) {
	epicsUInt32 risingMask = IRData->risingMask;
	epicsUInt32 wentHigh = IRData->wentHigh;
	myISRDataStruct *myISRData = (myISRDataStruct *)(IRData->userPvt);
	volatile epicsUInt32 *fifoAddr = myISRData->fifoAddr;
	volatile epicsUInt32 *fifoCountAddr = myISRData->fifoCountAddr;
	epicsUInt32 *counts1 = myISRData->counts1;
	epicsUInt32 *counts2 = myISRData->counts2;
	epicsUInt32 *counts3 = myISRData->counts3;
	epicsUInt32 *counts4 = myISRData->counts4;
	epicsUInt32 *counts5 = myISRData->counts5;
	epicsUInt32 *counts6 = myISRData->counts6;
	epicsUInt32 *counts7 = myISRData->counts7;
	epicsUInt32 *numEvents = myISRData->numEvents;
	int numScalers = *(myISRData->numScalers);
	int fifoSize = myISRData->fifoSize;
	int currChannel = myISRData->currChannel;
	int i, count, dummy;

	if (MCSDebug>=10) {
		printf("MCSRoutine(0x%x, 0x%x) fifoAddr=%p\n", risingMask, wentHigh, fifoAddr);
		printf("MCSRoutine: *fifoCountAddr=%d, *fifoCountAddr/(numScalers+1)=%d\n", *fifoCountAddr, *fifoCountAddr/(numScalers+1));
	}
	count = *fifoCountAddr;
	while (count >= numScalers+1 && count > fifoSize/10) {
		for (i=0; i<count/(numScalers+1); i++) {

			*numEvents = *numEvents + 1;

			switch (numScalers) {
				case 7:
					counts1[currChannel] = *fifoAddr;
				case 6:
					counts2[currChannel] = *fifoAddr;
				case 5:
					counts3[currChannel] = *fifoAddr;
				case 4:
					counts4[currChannel] = *fifoAddr;
				case 3:
					counts5[currChannel] = *fifoAddr;
				case 2:
					counts6[currChannel] = *fifoAddr;
				case 1:
					counts7[currChannel] = *fifoAddr;
					break;
				case 0:
				default:
					break;
			}
			dummy = *fifoAddr;
			if (myISRData->currChannel < myISRData->maxChannels) myISRData->currChannel++;
			myISRData->cleared = 0;
		}
		if (MCSDebug>=10) printf("MCSRoutine: *fifoCountAddr=%d, *fifoCountAddr/(numScalers+1)=%d\n", *fifoCountAddr, *fifoCountAddr/(numScalers+1));
		count = *fifoCountAddr;
	}
}

/* int MCSPrepare(componentName, risingMask, fifoSize)
 * componentName: pixelFIFO_
 * risingMask:	bit(s) to which we want to respond (e.g., 0x1, 0x8000000)
 * fifoSize: length of FIFO in 32-bit words
 */
int MCSPrepare(const char *componentName, epicsUInt32 risingMask, int fifoSize) {
	int i;
	volatile epicsUInt32 *localAddr = NULL;
	UIO_struct *pUIO = NULL;

	i = findUioAddr(componentName, 0);
	if (i >= 0) {
		pUIO = UIO[i];
		localAddr = pUIO->localAddr;
	}

	/* Get the address of fifo register. */
	myISRData.fifoAddr = localAddr;
	myISRData.fifoCountAddr = myISRData.fifoAddr + 1;
	myISRData.fifoSize = fifoSize;


	/* Tell softGlue to call MCSRoutine() when its interrupt-service routine handles an interrupt
	 * with the specified risingMask.  This also tells softGlue to not execute any output links that might
	 * also have been programmed to execute in response to this value of risingMask.
	 */
	softGlueRegisterInterruptRoutine(risingMask, 0, MCSRoutine, (void *)&myISRData);

	return(0);
}

#include <registryFunction.h>
static registryFunctionRef MCSRef[] = {
	{"MCS_init", (REGISTRYFUNCTION)MCS_init},
	{"MCS_do", (REGISTRYFUNCTION)MCS_do}
};

static void MCSRegister(void) {
	registryFunctionRefAdd(MCSRef, NELEMENTS(MCSRef));
}


epicsExportRegistrar(MCSRegister);

/* interrupt stuff */
/* int MCSPrepare(const char *componentName, epicsUInt32 risingMask, int fifoSize) */
static const iocshArg myArg1 = { "componentName",	iocshArgString};
static const iocshArg myArg2 = { "risingMask",	iocshArgInt};
static const iocshArg myArg3 = { "fifoSize",	iocshArgInt};
static const iocshArg * const myArgs[3] = {&myArg1, &myArg2, &myArg3};
static const iocshFuncDef myFuncDef = {"MCSPrepare", 3, myArgs};
static void myCallFunc(const iocshArgBuf *args) {
	MCSPrepare(args[0].sval, args[1].ival, args[2].ival);
}

void MCSISRRegistrar(void)
{
	iocshRegister(&myFuncDef, myCallFunc);
}

epicsExportRegistrar(MCSISRRegistrar);
