/* Copyright (c) 2016 UChicago Argonne LLC, as Operator of Argonne
 * National Laboratory, and The Regents of the University of California, as
 * Operator of Los Alamos National Laboratory.
 * softGlueZynq is distributed subject to a Software License Agreement found
 * in the file LICENSE that is included with this distribution.
 */

/*  prototype softGlueZynq custom interrupt routine to histogram pixelTrigger data */

#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <sys/stat.h>

#include <epicsTypes.h>
#include <iocsh.h>
#include "drvZynq.h"
#include <epicsExport.h>

volatile int pixelTriggerDebug = 0;
epicsExportAddress(int, pixelTriggerDebug);

typedef struct {
	epicsUInt32 *fifoAddr;
	epicsUInt32 *fifoCountAddr;
	int **pixels;
	int numX, numY, numScalers;
} myISRDataStruct;
myISRDataStruct myISRData;

/* When an interrupt matching conditions specified by pixelTriggerPrepare() occurs,
 * we'll get called with the bitmask that generated the interrupt, and the bit that went low or high.
 */
void pixelTriggerRoutine(softGlueIntRoutineData *IRData) {
	epicsUInt32 risingMask = IRData->risingMask;
	epicsUInt32 wentHigh = IRData->wentHigh;
	myISRDataStruct *myISRData = (myISRDataStruct *)(IRData->userPvt);
	volatile epicsUInt32 *fifoAddr = myISRData->fifoAddr;
	volatile epicsUInt32 *fifoCountAddr = myISRData->fifoCountAddr;
	int **pixels = myISRData->pixels;
	int numX = myISRData->numX;
	int numY = myISRData->numY;
	int numScalers = myISRData->numScalers;
	int i, j, count;
	unsigned int x, y, pixelValue, scalerValue;

	if (pixelTriggerDebug) {
		printf("pixelTriggerRoutine(0x%x, 0x%x) fifoAddr=%p\n", risingMask, wentHigh, fifoAddr);
		printf("pixelTriggerRoutine: *fifoCountAddr=%d, *fifoCountAddr/(numScalers+1)=%d\n", *fifoCountAddr, *fifoCountAddr/(numScalers+1));
	}
	count = *fifoCountAddr;
	if (count >= numScalers+1) {
		for (i=0; i<count/(numScalers+1); i++) {
			pixelValue = *fifoAddr;
			x = pixelValue >> 16;
			y = pixelValue & 0xffff;
			for (j=0; j<numScalers; j++) {
				scalerValue = *fifoAddr;
				if (j==1) {
					if (pixelTriggerDebug) printf("pixelTriggerRoutine: x=%d, y=%d, scalerValue=%d\n", x, y, scalerValue);
				}
				if (j==1 && x < numX && y < numY) {
					if (pixelTriggerDebug) printf("pixelTriggerRoutine: x=%d, y=%d, scalerValue=%d\n", x, y, scalerValue);
					pixels[x][y] += scalerValue;
				}
			}
		}
		if (pixelTriggerDebug) printf("pixelTriggerRoutine: *fifoCountAddr=%d, *fifoCountAddr/(numScalers+1)=%d\n", *fifoCountAddr, *fifoCountAddr/(numScalers+1));
	}
}

/* int pixelTriggerPrepare(epicsUInt32 risingMask)
 * Mask:	bit(s) to which we want to respond (e.g., 0x1, 0x8000000)
 */
int pixelTriggerPrepare(int AXI_Address, epicsUInt32 risingMask, int numX, int numY, int numScalers) {
	int i;
	int fd;
	
	myISRData.numX = numX;
	myISRData.numY = numY;
	myISRData.numScalers = numScalers;
	myISRData.pixels = (int **)malloc(numY * sizeof (int *));
	for (i=0; i<numY; i++) {
		myISRData.pixels[i] = (int *)malloc(numX * sizeof (int));
	}

	/* Get the address of fifo register. */
	fd = open("/dev/mem",O_RDWR|O_SYNC);
	if (fd < 0) {
	  printf("Can't open /dev/mem\n");
	  return(-1);
	}
	myISRData.fifoAddr = (epicsUInt32 *) mmap(0,255,PROT_READ|PROT_WRITE,MAP_SHARED,fd,AXI_Address);
	myISRData.fifoCountAddr = myISRData.fifoAddr + 1;


	/* Tell softGlue to call pixelTriggerRoutine() when its interrupt-service routine handles an interrupt
	 * with the specified risingMask.  This also tells softGlue to not execute any output links that might
	 * also have been programmed to execute in response to this value of risingMask.
	 */
	softGlueRegisterInterruptRoutine(risingMask, 0, pixelTriggerRoutine, (void *)&myISRData);

	return(0);
}

/* int pixelTriggerPrepare(int AXI_Address, epicsUInt32 risingMask, int numX, int numY, int numScalers) */
static const iocshArg myArg1 = { "AXI_Address",	iocshArgInt};
static const iocshArg myArg2 = { "risingMask",	iocshArgInt};
static const iocshArg myArg3 = { "numX",		iocshArgInt};
static const iocshArg myArg4 = { "numY",		iocshArgInt};
static const iocshArg myArg5 = { "numScalers",	iocshArgInt};
static const iocshArg * const myArgs[5] = {&myArg1, &myArg2, &myArg3, &myArg4, &myArg5};
static const iocshFuncDef myFuncDef = {"pixelTriggerPrepare",5,myArgs};
static void myCallFunc(const iocshArgBuf *args) {
	pixelTriggerPrepare(args[0].ival, args[1].ival, args[2].ival, args[3].ival, args[4].ival);
}

void pixelTriggerRegistrar(void)
{
	iocshRegister(&myFuncDef, myCallFunc);
}

epicsExportRegistrar(pixelTriggerRegistrar);
