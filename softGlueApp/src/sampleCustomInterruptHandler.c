/* Demonstrate softGlue custom interrupt routine to write new values to DivByN-3_N
 */

#include "drvIP_EP201.h"
#include <epicsExport.h>
#include <iocsh.h>

typedef struct {
	epicsUInt16 *addrMSW;
	epicsUInt16 *addrLSW;
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
	epicsUInt16 mask = IRData->mask;
	myISRDataStruct *myISRData = (myISRDataStruct *)(IRData->userPvt);
	epicsUInt16 *addrMSW = myISRData->addrMSW;
	epicsUInt16 *addrLSW = myISRData->addrLSW;
	int *DivByN_values = myISRData->DivByN_values;
	int numValues = myISRData->numValues;
	int *thisValue = &(myISRData->thisValue);

	logMsg("sampleCustomInterruptRoutine(0x%x) wentLow=0x%x, wentHigh=0x%x\n", mask, IRData->wentLow, IRData->wentHigh);
	logMsg("sampleCustomInterruptRoutine(0x%x) div[%d]=%d\n", mask, *thisValue, DivByN_values[*thisValue]);
	*addrMSW = (DivByN_values[*thisValue]-1)/65536;
	*addrLSW = (DivByN_values[*thisValue]-1)%65536;
	if (++(*thisValue) >= numValues) (*thisValue) = 0;
}

/* int sampleCustomInterruptPrepare(int carrier, int slot, int sopcAddress, int mask)
 * carrier: 	IP carrier (e.g., 0)
 * slot:		IP slot (e.g., 0)
 * sopcAddress: address of fieldIO_registerSet (I/O register) of the interrupt bit to which
 *				we want to respond (e.g., 0x800000, or 0x800010, or 0x800020)
 * mask:		bit(s) to which we want to respond (e.g., 0x1)
 */
int sampleCustomInterruptPrepare(int carrier, int slot, int sopcAddress, int mask) {
	int i;
	
	myISRData.numValues = MAX_VALUES;
	myISRData.thisValue = 0;
	myISRData.DivByN_values = sampleCustomInterruptValues;

	/* Get the address of the divByN N register.
	 * The sopc addresses 0x800720 and 0x800718 are from softGlue_FPGAContent.substitutions.
	 * They specify the DivByN-3_N register to which we want to write.  It's a 32-bit register,
	 * so we'll need to write to the MSW and LSW parts separately.
	 */
	myISRData.addrMSW = softGlueCalcSpecifiedRegisterAddress((epicsUInt16) carrier, (epicsUInt16) slot, 0x800720);
	myISRData.addrLSW = softGlueCalcSpecifiedRegisterAddress((epicsUInt16) carrier, (epicsUInt16) slot, 0x800718);

	/* Tell softGlue to call sampleCustomInterruptRoutine() when its interrupt-service routine handles an interrupt
	 * from the specified carrier, slot, sopcAddress (I/O register), and bit (mask).  This also
	 * tells softGlue to not execute any output links that might also have been programmed to
	 * execute in response to this interrupt.
	 */
	softGlueRegisterInterruptRoutine(carrier, slot, sopcAddress, mask, sampleCustomInterruptRoutine,
		(void *)&myISRData);

	/* prepare example data for sampleCustomInterruptRoutine() */
	sampleCustomInterruptValues[0] = 10;
	for (i=1; i<MAX_VALUES; i++) {
		sampleCustomInterruptValues[i] = sampleCustomInterruptValues[i-1] + (i>MAX_VALUES/2 ? -1 : 1);
	}
	return(0);
}

/* int sampleCustomInterruptPrepare(int carrier, int slot, int sopcAddress, int mask) */
static const iocshArg myArg1 = { "Carrier Number",  iocshArgInt};
static const iocshArg myArg2 = { "Slot Number", 	iocshArgInt};
static const iocshArg myArg3 = { "sopcAddress", iocshArgInt};
static const iocshArg myArg4 = { "mask",	iocshArgInt};
static const iocshArg * const myArgs[4] = {&myArg1, &myArg2, &myArg3, &myArg4};
static const iocshFuncDef myFuncDef = {"sampleCustomInterruptPrepare",4,myArgs};
static void myCallFunc(const iocshArgBuf *args) {
	sampleCustomInterruptPrepare(args[0].ival, args[1].ival, args[2].ival, args[3].ival);
}

void sampleCustomInterruptRegistrar(void)
{
	iocshRegister(&myFuncDef, myCallFunc);
}

epicsExportRegistrar(sampleCustomInterruptRegistrar);
