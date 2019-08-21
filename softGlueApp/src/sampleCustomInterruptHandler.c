/* Copyright (c) 2016 UChicago Argonne LLC, as Operator of Argonne
 * National Laboratory, and The Regents of the University of California, as
 * Operator of Los Alamos National Laboratory.
 * softGlueZynq is distributed subject to a Software License Agreement found
 * in the file LICENSE that is included with this distribution.
 */

/* Demonstrate softGlue custom interrupt routine to write new values to DivByN-3_N
 */

#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <sys/stat.h>

#include <epicsTypes.h>
#include <iocsh.h>
#include "drvZynq.h"
#include <epicsExport.h>

typedef struct {
	epicsUInt32 *addr;
	int *DivByN_values;
	int numValues;
	int thisValue;
} myISRDataStruct;
myISRDataStruct myISRData;

#define MAX_VALUES 1000
static int sampleCustomInterruptValues[MAX_VALUES];

/* When an interrupt matching conditions specified by sampleCustomInterruptPrepare() occurs,
 * we'll get called with the bitmask that generated the interrupt, and the bit that went low or high.
 */
void sampleCustomInterruptRoutine(softGlueIntRoutineData *IRData) {
	epicsUInt32 risingMask = IRData->risingMask;
	/*epicsUInt32 fallingMask = IRData->fallingMask;*/
	myISRDataStruct *myISRData = (myISRDataStruct *)(IRData->userPvt);
	volatile epicsUInt32 *addr = myISRData->addr;
	volatile epicsUInt8 *addr8 = (epicsUInt8 *)myISRData->addr;
	int *DivByN_values = myISRData->DivByN_values;
	int numValues = myISRData->numValues;
	int *thisValue = &(myISRData->thisValue);

	//printf("sampleCustomInterruptRoutine(0x%x) wentLow=0x%x, wentHigh=0x%x\n", risingMask, IRData->wentLow, IRData->wentHigh);
	//printf("sampleCustomInterruptRoutine(0x%x) div[%d]=%d\n", risingMask, *thisValue, DivByN_values[*thisValue]);
	//printf("sampleCustomInterruptRoutine(0x%x) addr=%p\n", risingMask, addr);
	//*addr = (DivByN_values[*thisValue]);
	//if (++(*thisValue) >= numValues) (*thisValue) = 0;
	
	/* write a pulse to it */
	*addr8 = 0x20;
	*addr8 = 0x00;
	//if (*addr8) {
	//	*addr8 = 0x00;
	//} else {
	//	*addr8 = 0x20;
	//}
}

/* int sampleCustomInterruptPrepare(epicsUInt32 risingMask, epicsUInt32 fallingMask)
 * *Mask:	bit(s) to which we want to respond (e.g., 0x1, 0x8000000)
 */
int sampleCustomInterruptPrepare(epicsUInt32 risingMask, epicsUInt32 fallingMask) {
	int i;
	
	myISRData.numValues = MAX_VALUES;
	myISRData.thisValue = 0;
	myISRData.DivByN_values = sampleCustomInterruptValues;

	/* Get the address of BUFFER-4_IN.
	 * The address 123 is from softGlue_FPGAContent.substitutions.
	 * We want to write to bit 5.
	 */
	myISRData.addr = softGlueZCalcSpecifiedRegisterAddress(0, 123);

	/* Get the address of the divByN N register.
	 * The address 38 is from softGlue_FPGARegisters.substitutions.
	 * It's the DivByN-3_N register to which we want to write.
	 */
	//myISRData.addr = softGlueZCalcSpecifiedRegisterAddress(1, 38);

	/* Tell softGlue to call sampleCustomInterruptRoutine() when its interrupt-service routine handles an interrupt
	 * from the specified carrier, slot, sopcAddress (I/O register), and bit (mask).  This also
	 * tells softGlue to not execute any output links that might also have been programmed to
	 * execute in response to this interrupt.
	 */
	softGlueRegisterInterruptRoutine(risingMask, fallingMask, sampleCustomInterruptRoutine,
		(void *)&myISRData);

	/* prepare example data for sampleCustomInterruptRoutine() */
	sampleCustomInterruptValues[0] = 10;
	for (i=1; i<MAX_VALUES; i++) {
		sampleCustomInterruptValues[i] = sampleCustomInterruptValues[i-1] + (i>MAX_VALUES/2 ? -1 : 1);
	}
	return(0);
}

/* int sampleCustomInterruptPrepare(epicsUInt32 risingMask, epicsUInt32 fallingMask) */
static const iocshArg myArg1 = { "risingMask",  iocshArgInt};
static const iocshArg myArg2 = { "fallingMask", 	iocshArgInt};
static const iocshArg * const myArgs[2] = {&myArg1, &myArg2};
static const iocshFuncDef myFuncDef = {"sampleCustomInterruptPrepare",2,myArgs};
static void myCallFunc(const iocshArgBuf *args) {
	sampleCustomInterruptPrepare(args[0].ival, args[1].ival);
}

void sampleCustomInterruptRegistrar(void)
{
	iocshRegister(&myFuncDef, myCallFunc);
}

epicsExportRegistrar(sampleCustomInterruptRegistrar);
