/* Copyright (c) 2016 UChicago Argonne LLC, as Operator of Argonne
 * National Laboratory, and The Regents of the University of California, as
 * Operator of Los Alamos National Laboratory.
 * softGlueZynq is distributed subject to a Software License Agreement found
 * in the file LICENSE that is included with this distribution.
 */

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

#define MAX_UIO 10
#define UIO_NAMELEN 100
typedef struct {
	char componentName[UIO_NAMELEN];
	int map;
	char uioFileName[UIO_NAMELEN];
	char uioDevName[UIO_NAMELEN];
	volatile epicsUInt32 *addr;
	volatile epicsUInt32 *localAddr;
	FILE *uioName_fd;
	int uio_fd;
} UIO_struct;

extern UIO_struct *UIO[MAX_UIO];

int findUioAddr(const char *componentName, int map);

int softGlueRegisterInterruptRoutine(epicsUInt32 risingMask, epicsUInt32 fallingMask,
	void (*routine)(softGlueIntRoutineData *IRData), void *userPvt);

epicsUInt32 *softGlueZCalcSpecifiedRegisterAddress(int type, int addr);
