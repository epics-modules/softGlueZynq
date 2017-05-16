/* Copyright (c) 2016 UChicago Argonne LLC, as Operator of Argonne
 * National Laboratory, and The Regents of the University of California, as
 * Operator of Los Alamos National Laboratory.
 * softGlueZynq is distributed subject to a Software License Agreement found
 * in the file LICENSE that is included with this distribution.
 */

/* pixelTriggerAsub - bin pixelTrigger events into 2D histograms.
 * aSub record fields:
 *  vala[]  Histogram 1
 *  valb[]  Histogram 2
 *  valc[]  Histogram 3
 *  vald[]  Histogram 4
 *  vale[]  Histogram 5
 *  valr[]  Histogram 6
 *  valg[]  Histogram 7
 *  valh    number of events
 *  vali[]  Image 1
 *  valj[]  Image 2
 *  valk[]  Image 3
 *  vall[]  Image 4
 *  valm[]  Image 5
 *  valn[]  Image 6
 *  valo[]  Image 7
 *  a       number of scaler channels
 *  b       number of X pixels
 *  c       number of Y pixels
 *  d       clear arrays
 *	e		clock rate counter1
 *	f		mode
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

volatile int pixelTriggerDebug=0;
epicsExportAddress(int, pixelTriggerDebug);

typedef struct {
	volatile epicsUInt32 *fifoAddr;
	volatile epicsUInt32 *fifoCountAddr;
	epicsUInt32 *pixels1, *pixels2, *pixels3, *pixels4, *pixels5, *pixels6, *pixels7;
	epicsUInt32 *numEvents;
	epicsUInt32 *numX, *numY, *numScalers;
	int fifoSize;
	int cleared;
} myISRDataStruct;
myISRDataStruct myISRData;

static long pixelTrigger_init(aSubRecord *pasub) {
	epicsUInt32 *a = (epicsUInt32 *)pasub->a;
	epicsUInt32 *b = (epicsUInt32 *)pasub->b;
	epicsUInt32 *c = (epicsUInt32 *)pasub->c;

	if (pixelTriggerDebug) {
		printf("pixelTrigger_init: entry\n");
	}
	myISRData.pixels1 = (epicsUInt32 *)pasub->vala;
	myISRData.pixels2 = (epicsUInt32 *)pasub->valb;
	myISRData.pixels3 = (epicsUInt32 *)pasub->valc;
	myISRData.pixels4 = (epicsUInt32 *)pasub->vald;
	myISRData.pixels5 = (epicsUInt32 *)pasub->vale;
	myISRData.pixels6 = (epicsUInt32 *)pasub->valf;
	myISRData.pixels7 = (epicsUInt32 *)pasub->valg;
	myISRData.numEvents = (epicsUInt32 *)pasub->valh;

	myISRData.numScalers = a;
	myISRData.numX = b;
	myISRData.numY = c;
	myISRData.cleared = 1;
	return(0);
}

static long pixelTrigger_do(aSubRecord *pasub) {
	int *clear = (int *)pasub->d;
	double clockRate = *((double *)pasub->e);
	int mode = *((int *)pasub->f);
	epicsUInt32 *pixels1 = (epicsUInt32 *)pasub->vala;
	epicsUInt32 *pixels2 = (epicsUInt32 *)pasub->valb;
	epicsUInt32 *pixels3 = (epicsUInt32 *)pasub->valc;
	epicsUInt32 *pixels4 = (epicsUInt32 *)pasub->vald;
	epicsUInt32 *pixels5 = (epicsUInt32 *)pasub->vale;
	epicsUInt32 *pixels6 = (epicsUInt32 *)pasub->valf;
	epicsUInt32 *pixels7 = (epicsUInt32 *)pasub->valg;
	epicsUInt32 *numEvents = (epicsUInt32 *)pasub->valh;

	/* At present, caQtDM does not have a widget to display 2D images from four byte data arrays,
	 * so we're going to have to copy to two byte arrays.
	 */
	epicsUInt16 *image1 = (epicsUInt16 *)pasub->vali;
	epicsUInt16 *image2 = (epicsUInt16 *)pasub->valj;
	epicsUInt16 *image3 = (epicsUInt16 *)pasub->valk;
	epicsUInt16 *image4 = (epicsUInt16 *)pasub->vall;
	epicsUInt16 *image5 = (epicsUInt16 *)pasub->valm;
	epicsUInt16 *image6 = (epicsUInt16 *)pasub->valn;
	epicsUInt16 *image7 = (epicsUInt16 *)pasub->valo;
	int i;
	volatile epicsUInt32 *fifoAddr = myISRData.fifoAddr;
	double time;
	epicsUInt32 max2=0, max3=0, max4=0, max5=0, max6=0, max7=0;

	if (pixelTriggerDebug) {
		printf("pixelTrigger_do: entry\n");
	}

	if (*clear) {
		/* erase pixel maps */
		for (i=0; i<pasub->nova; i++) {
			pixels1[i] = 0;
			pixels2[i] = 0;
			pixels3[i] = 0;
			pixels4[i] = 0;
			pixels5[i] = 0;
			pixels6[i] = 0;
			pixels7[i] = 0;
			*numEvents = 0;
			*fifoAddr = 0;	/* write to fifoAddr clears the FIFO */
			myISRData.cleared = 1;
		}
		*clear = 0;
	}

	if (mode==1) {
		/* prepare to normalize to data in pixels1[], which is presumed to record the time spent in the pixel. */
		for (i=0; i<pasub->nova; i++) {
			max2 = MAX(max2, pixels2[i]);
			max3 = MAX(max3, pixels3[i]);
			max4 = MAX(max4, pixels4[i]);
			max5 = MAX(max5, pixels5[i]);
			max6 = MAX(max6, pixels6[i]);
			max7 = MAX(max7, pixels7[i]);
		}
	}

	if (pixelTriggerDebug) printf("pixelTrigger_do: max2=%d, max3=%d\n", max2, max3);
	/* Copy pixel maps to displayable arrays */
	for (i=0; i<pasub->nova; i++) {
		time = pixels1[i]/clockRate;
		if (pixels1[i] > 0 && mode==1) {
			image1[i] = pixels1[i];
			image2[i] = (epicsUInt16)((65535. * pixels2[i]/time)/max2);
			image3[i] = (epicsUInt16)((65535. * pixels3[i]/time)/max3);
			image4[i] = (epicsUInt16)((65535. * pixels4[i]/time)/max4);
			image5[i] = (epicsUInt16)((65535. * pixels5[i]/time)/max5);
			image6[i] = (epicsUInt16)((65535. * pixels6[i]/time)/max6);
			image7[i] = (epicsUInt16)((65535. * pixels7[i]/time)/max7);
		} else {
			image1[i] = pixels1[i];
			image2[i] = pixels2[i];
			image3[i] = pixels3[i];
			image4[i] = pixels4[i];
			image5[i] = pixels5[i];
			image6[i] = pixels6[i];
			image7[i] = pixels7[i];
		}
	}

	return(0);
}

/* interrupt driven stuff */

/* When an interrupt matching conditions specified by pixelTriggerPrepare() occurs,
 * we'll get called with the bitmask that generated the interrupt, and the bit that went low or high.
 */
void pixelTriggerRoutine(softGlueIntRoutineData *IRData) {
	epicsUInt32 risingMask = IRData->risingMask;
	epicsUInt32 wentHigh = IRData->wentHigh;
	myISRDataStruct *myISRData = (myISRDataStruct *)(IRData->userPvt);
	volatile epicsUInt32 *fifoAddr = myISRData->fifoAddr;
	volatile epicsUInt32 *fifoCountAddr = myISRData->fifoCountAddr;
	epicsUInt32 *pixels1 = myISRData->pixels1;
	epicsUInt32 *pixels2 = myISRData->pixels2;
	epicsUInt32 *pixels3 = myISRData->pixels3;
	epicsUInt32 *pixels4 = myISRData->pixels4;
	epicsUInt32 *pixels5 = myISRData->pixels5;
	epicsUInt32 *pixels6 = myISRData->pixels6;
	epicsUInt32 *pixels7 = myISRData->pixels7;
	epicsUInt32 *numEvents = myISRData->numEvents;
	epicsUInt32 numX = *(myISRData->numX);
	epicsUInt32 numY = *(myISRData->numY);
	int numScalers = *(myISRData->numScalers);
	int fifoSize = myISRData->fifoSize;
	int i, count, offset, record=0;
	epicsUInt16 x, y;
	epicsUInt32 pixelValue=0, scalerValue;
	static epicsUInt32 prevPixelValue;

	if (pixelTriggerDebug>=10) {
		printf("pixelTriggerRoutine(0x%x, 0x%x) fifoAddr=%p\n", risingMask, wentHigh, fifoAddr);
		printf("pixelTriggerRoutine: *fifoCountAddr=%d, *fifoCountAddr/(numScalers+1)=%d\n", *fifoCountAddr, *fifoCountAddr/(numScalers+1));
	}
	count = *fifoCountAddr;
	while (count >= numScalers+1 && count > fifoSize/10) {
		for (i=0; i<count/(numScalers+1); i++) {

			*numEvents = *numEvents + 1;
			prevPixelValue = pixelValue;
			x = (epicsUInt16) (prevPixelValue >> 16);
			y = (epicsUInt16) (prevPixelValue & 0xffff);

			record = (x < numX) && (y < numY) && (myISRData->cleared==0);
			if (prevPixelValue == 0) record = 0;
			if (pixelTriggerDebug>=10) printf("pixelTriggerRoutine: x=%d, y=%d, record=%d\n", x, y, record);
			offset = y*numX+x;
			switch (numScalers) {
				case 7:
					scalerValue = *fifoAddr;
					if (record) *(pixels1+offset) += scalerValue;
					if (pixelTriggerDebug>=10) printf("pixelTriggerRoutine: x=%d, y=%d, scalerValue=%d\n", x, y, scalerValue);
				case 6:
					scalerValue = *fifoAddr;
					if (record) *(pixels2+offset) += scalerValue;
				case 5:
					scalerValue = *fifoAddr;
					if (record) *(pixels3+offset) += scalerValue;
				case 4:
					scalerValue = *fifoAddr;
					if (record) *(pixels4+offset) += scalerValue;
				case 3:
					scalerValue = *fifoAddr;
					if (record) *(pixels5+offset) += scalerValue;
				case 2:
					scalerValue = *fifoAddr;
					if (record) *(pixels6+offset) += scalerValue;
				case 1:
					scalerValue = *fifoAddr;
					if (record) *(pixels7+offset) += scalerValue;
					break;
				case 0:
				default:
					break;
			}
			pixelValue = *fifoAddr;
			myISRData->cleared = 0;
		}
		if (pixelTriggerDebug>=10) printf("pixelTriggerRoutine: *fifoCountAddr=%d, *fifoCountAddr/(numScalers+1)=%d\n", *fifoCountAddr, *fifoCountAddr/(numScalers+1));
		count = *fifoCountAddr;
	}
}

/* int pixelTriggerPrepare(componentName, risingMask, fifoSize)
 * componentName: pixelFIFO_
 * risingMask:	bit(s) to which we want to respond (e.g., 0x1, 0x8000000)
 * fifoSize: length of FIFO in 32-bit words
 */
int pixelTriggerPrepare(const char *componentName, epicsUInt32 risingMask, int fifoSize) {
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


	/* Tell softGlue to call pixelTriggerRoutine() when its interrupt-service routine handles an interrupt
	 * with the specified risingMask.  This also tells softGlue to not execute any output links that might
	 * also have been programmed to execute in response to this value of risingMask.
	 */
	softGlueRegisterInterruptRoutine(risingMask, 0, pixelTriggerRoutine, (void *)&myISRData);

	return(0);
}

#include <registryFunction.h>
static registryFunctionRef pixelTriggerRef[] = {
	{"pixelTrigger_init", (REGISTRYFUNCTION)pixelTrigger_init},
	{"pixelTrigger_do", (REGISTRYFUNCTION)pixelTrigger_do}
};

static void pixelTriggerRegister(void) {
	registryFunctionRefAdd(pixelTriggerRef, NELEMENTS(pixelTriggerRef));
}


epicsExportRegistrar(pixelTriggerRegister);

/* interrupt stuff */
/* int pixelTriggerPrepare(const char *componentName, epicsUInt32 risingMask, int fifoSize) */
static const iocshArg myArg1 = { "componentName",	iocshArgString};
static const iocshArg myArg2 = { "risingMask",	iocshArgInt};
static const iocshArg myArg3 = { "fifoSize",	iocshArgInt};
static const iocshArg * const myArgs[3] = {&myArg1, &myArg2, &myArg3};
static const iocshFuncDef myFuncDef = {"pixelTriggerPrepare", 3, myArgs};
static void myCallFunc(const iocshArgBuf *args) {
	pixelTriggerPrepare(args[0].sval, args[1].ival, args[2].ival);
}

void pixelTriggerISRRegistrar(void)
{
	iocshRegister(&myFuncDef, myCallFunc);
}

epicsExportRegistrar(pixelTriggerISRRegistrar);
