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
	int *d = (int *)pasub->d;
	epicsUInt32 *pixels1 = (epicsUInt32 *)pasub->vala;
	epicsUInt32 *pixels2 = (epicsUInt32 *)pasub->valb;
	epicsUInt32 *pixels3 = (epicsUInt32 *)pasub->valc;
	epicsUInt32 *pixels4 = (epicsUInt32 *)pasub->vald;
	epicsUInt32 *pixels5 = (epicsUInt32 *)pasub->vale;
	epicsUInt32 *pixels6 = (epicsUInt32 *)pasub->valf;
	epicsUInt32 *pixels7 = (epicsUInt32 *)pasub->valg;
	epicsUInt32 *numEvents = (epicsUInt32 *)pasub->valh;

	epicsUInt16 *image1 = (epicsUInt16 *)pasub->vali;
	epicsUInt16 *image2 = (epicsUInt16 *)pasub->valj;
	epicsUInt16 *image3 = (epicsUInt16 *)pasub->valk;
	epicsUInt16 *image4 = (epicsUInt16 *)pasub->vall;
	epicsUInt16 *image5 = (epicsUInt16 *)pasub->valm;
	epicsUInt16 *image6 = (epicsUInt16 *)pasub->valn;
	epicsUInt16 *image7 = (epicsUInt16 *)pasub->valo;
	int i;
	volatile epicsUInt32 *fifoAddr = myISRData.fifoAddr;

	if (pixelTriggerDebug) {
		printf("pixelTrigger_do: entry\n");
	}

	if (*d) {
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
		*d = 0;
	}

	for (i=0; i<pasub->nova; i++) {
		image1[i] = pixels1[i];
		image2[i] = pixels2[i];
		image3[i] = pixels3[i];
		image4[i] = pixels4[i];
		image5[i] = pixels5[i];
		image6[i] = pixels6[i];
		image7[i] = pixels7[i];
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
	epicsUInt32 pixelValue=0, prevPixelValue, scalerValue;

	if (pixelTriggerDebug) {
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
			if (pixelTriggerDebug) printf("pixelTriggerRoutine: x=%d, y=%d, record=%d\n", x, y, record);
			offset = y*numX+x;
			switch (numScalers) {
				case 7:
					scalerValue = *fifoAddr;
					if (record) *(pixels1+offset) += scalerValue;
					if (pixelTriggerDebug) printf("pixelTriggerRoutine: x=%d, y=%d, scalerValue=%d\n", x, y, scalerValue);
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
		if (pixelTriggerDebug) printf("pixelTriggerRoutine: *fifoCountAddr=%d, *fifoCountAddr/(numScalers+1)=%d\n", *fifoCountAddr, *fifoCountAddr/(numScalers+1));
		count = *fifoCountAddr;
	}
}

/* int pixelTriggerPrepare(epicsUInt32 risingMask)
 * Mask:	bit(s) to which we want to respond (e.g., 0x1, 0x8000000)
 */
int pixelTriggerPrepare(int AXI_Address, epicsUInt32 risingMask, int fifoSize) {
	int fd;
	

	/* Get the address of fifo register. */
	fd = open("/dev/mem",O_RDWR|O_SYNC);
	if (fd < 0) {
	  printf("Can't open /dev/mem\n");
	  return(-1);
	}
	myISRData.fifoAddr = (epicsUInt32 *) mmap(0,255,PROT_READ|PROT_WRITE,MAP_SHARED,fd,AXI_Address);
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
/* int pixelTriggerPrepare(int AXI_Address, epicsUInt32 risingMask, int fifoSize) */
static const iocshArg myArg1 = { "AXI_Address",	iocshArgInt};
static const iocshArg myArg2 = { "risingMask",	iocshArgInt};
static const iocshArg myArg3 = { "fifoSize",	iocshArgInt};
static const iocshArg * const myArgs[3] = {&myArg1, &myArg2, &myArg3};
static const iocshFuncDef myFuncDef = {"pixelTriggerPrepare", 3, myArgs};
static void myCallFunc(const iocshArgBuf *args) {
	pixelTriggerPrepare(args[0].ival, args[1].ival, args[2].ival);
}

void pixelTriggerISRRegistrar(void)
{
	iocshRegister(&myFuncDef, myCallFunc);
}

epicsExportRegistrar(pixelTriggerISRRegistrar);
