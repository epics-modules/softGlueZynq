/* System includes */
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>

/* EPICS includes */
#include <epicsTypes.h>
#include <epicsExport.h>
#include <iocsh.h>

typedef struct {
	epicsUInt32 risingMask;
	epicsUInt32 fallingMask;
	epicsUInt32 wentLow, wentHigh;
	void *userPvt;
} softGlueIntRoutineData;

int softGlueRegisterInterruptRoutine(epicsUInt32 risingMask, epicsUInt32 fallingMask,
	void (*routine)(softGlueIntRoutineData *IRData), void *userPvt);

epicsUInt32 *softGlueCalcSpecifiedRegisterAddress(int type, int addr);
