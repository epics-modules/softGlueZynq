/* Copyright (c) 2016 UChicago Argonne LLC, as Operator of Argonne
 * National Laboratory, and The Regents of the University of California, as
 * Operator of Los Alamos National Laboratory.
 * softGlueZynq is distributed subject to a Software License Agreement found
 * in the file LICENSE that is included with this distribution.
 */

/* pixelTriggerDmaAsub - bin pixelTrigger events into 2D histograms.
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
 *	f		normalizeMode
 *	g		acqMode: 2d/list/x,y,t/MCS
 *	h		debug level
 *	i		scale1
 *	j		scale2
 *	k		scale3
 *	l		scale4
 *	m		scale5
 *	n		scale6
 *	o		scale7
 *  p		desired number of events (for MCS)
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

/* for DMA */
#include <sys/ioctl.h>
#include "dma_proxy.h"

#define MAX(a,b) ((a)>(b)?(a):(b))

#define ACQ_MODE_2D 0
#define ACQ_MODE_LIST 1
#define ACQ_MODE_XYT 2
#define ACQ_MODE_MCS 3
#define ACQ_MODE_NONE 4

/* make global so we can map at init */
struct dma_proxy_channel_interface *rx_proxy_interface_p;
int rx_proxy_fd;
#define MAX_DMA_BYTES 32*1024*4

/* testing */
int ListModeTestMisses = 0;

typedef struct {
	volatile epicsUInt32 *fifoCountAddr, *pixelTriggerDmaWords;
	volatile epicsUInt8 *DFF2Clear;
	float *pixels1, *pixels2, *pixels3, *pixels4, *pixels5, *pixels6, *pixels7;
	float *scale1, *scale2, *scale3, *scale4, *scale5, *scale6, *scale7;
	epicsUInt16 *image1, *image2;
	epicsUInt32 *numEvents, *desNumEvents;
	epicsUInt32 *numX, *numY, *numScalers;
	int cleared, *acqMode, allocatedElements, *debug;
} myISRDataStruct;
static myISRDataStruct myDmaISRData;

static long pixelTriggerDma_init(aSubRecord *pasub) {
	epicsUInt32 *a = (epicsUInt32 *)pasub->a;
	epicsUInt32 *b = (epicsUInt32 *)pasub->b;
	epicsUInt32 *c = (epicsUInt32 *)pasub->c;

	myDmaISRData.pixels1 = (float *)pasub->vala;
	myDmaISRData.pixels2 = (float *)pasub->valb;
	myDmaISRData.pixels3 = (float *)pasub->valc;
	myDmaISRData.pixels4 = (float *)pasub->vald;
	myDmaISRData.pixels5 = (float *)pasub->vale;
	myDmaISRData.pixels6 = (float *)pasub->valf;
	myDmaISRData.pixels7 = (float *)pasub->valg;
	myDmaISRData.numEvents = (epicsUInt32 *)pasub->valh;
	myDmaISRData.desNumEvents = (epicsUInt32 *)pasub->p;
	myDmaISRData.image1 = (epicsUInt16 *)pasub->vali;
	myDmaISRData.image2 = (epicsUInt16 *)pasub->valj;
	myDmaISRData.acqMode = (epicsInt32 *)pasub->g;
	myDmaISRData.debug = (epicsInt32 *)pasub->h;

	myDmaISRData.scale1 = (float *)pasub->i;
	myDmaISRData.scale2 = (float *)pasub->j;
	myDmaISRData.scale3 = (float *)pasub->k;
	myDmaISRData.scale4 = (float *)pasub->l;
	myDmaISRData.scale5 = (float *)pasub->m;
	myDmaISRData.scale6 = (float *)pasub->n;
	myDmaISRData.scale7 = (float *)pasub->o;

	myDmaISRData.numScalers = a;
	myDmaISRData.numX = b;
	myDmaISRData.numY = c;
	myDmaISRData.cleared = 1;
	myDmaISRData.allocatedElements = pasub->nova;
	return(0);
}

static long pixelTriggerDma_do(aSubRecord *pasub) {
	int allocatedElements = pasub->nova;
	int *clear = (int *)pasub->d;
	double clockRate = *((double *)pasub->e);
	int normMode = *((int *)pasub->f);
	int *acqMode = ((int *)pasub->g);
	float *pixels1 = (float *)pasub->vala;
	float *pixels2 = (float *)pasub->valb;
	float *pixels3 = (float *)pasub->valc;
	float *pixels4 = (float *)pasub->vald;
	float *pixels5 = (float *)pasub->vale;
	float *pixels6 = (float *)pasub->valf;
	float *pixels7 = (float *)pasub->valg;
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
	double time;
	float max2=0, max3=0, max4=0, max5=0, max6=0, max7=0;
	int *debug = (int *)pasub->h;
	myDmaISRData.acqMode = (epicsInt32 *)pasub->g;
	myDmaISRData.debug = (epicsInt32 *)pasub->h;

	if (*debug>1) {
		printf("pixelTriggerDma_do: entry\n");
	}

	if (*clear) {
		/* erase pixel maps */
		for (i=0; i<allocatedElements; i++) {
			pixels1[i] = 0;
			pixels2[i] = 0;
			pixels3[i] = 0;
			pixels4[i] = 0;
			pixels5[i] = 0;
			pixels6[i] = 0;
			pixels7[i] = 0;
			image1[i] = 0;
			image2[i] = 0;
			image3[i] = 0;
			image4[i] = 0;
			image5[i] = 0;
			image6[i] = 0;
			image7[i] = 0;
			*numEvents = 0;
			myDmaISRData.cleared = 1;
		}
		*clear = 0;
		if (*debug == -1) {
			printf("ListModeMisses was %d.  Setting it to 0.\n", ListModeTestMisses);
			ListModeTestMisses = 0;
		}
	}

	if (*acqMode == ACQ_MODE_LIST || *acqMode == ACQ_MODE_NONE || *acqMode == ACQ_MODE_MCS)
		return(0);

	if (normMode==1) {
		/* prepare to normalize to data in pixels1[], which is presumed to record the time spent in the pixel. */
		for (i=0; i<allocatedElements; i++) {
			max2 = MAX(max2, pixels2[i]);
			max3 = MAX(max3, pixels3[i]);
			max4 = MAX(max4, pixels4[i]);
			max5 = MAX(max5, pixels5[i]);
			max6 = MAX(max6, pixels6[i]);
			max7 = MAX(max7, pixels7[i]);
		}
	}

	if (*debug > 1) printf("pixelTriggerDma_do: max2=%f, max3=%f\n", max2, max3);
	/* Copy pixel maps to displayable arrays */
	for (i=0; i<allocatedElements; i++) {
		time = pixels1[i]/clockRate;
		if (pixels1[i] > 0 && normMode==1) {
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

/* When an interrupt matching conditions specified by pixelTriggerDmaPrepare() occurs,
 * we'll get called with the bitmask that generated the interrupt, and the bit that went low or high.
 */
 
 /* We expect events of the following form:
  *		pixelValue
  *		scaler1
  *		scaler2
  *		scaler3
  *		scaler4
  *		scaler5
  *		scaler6
  *		scaler7
  *	where pixelValue is distinguishable from scaler values because its MSbit is set.
  * pixelValue is the pixel we just left.  scalerN are the scaler values from that pixel.
  */
void pixelTriggerDmaRoutine(softGlueIntRoutineData *IRData) {
	epicsUInt32 risingMask = IRData->risingMask;
	epicsUInt32 wentHigh = IRData->wentHigh;
	myISRDataStruct *myDmaISRData = (myISRDataStruct *)(IRData->userPvt);
	int allocatedElements = myDmaISRData->allocatedElements;
	volatile epicsUInt32 *fifoCountAddr = myDmaISRData->fifoCountAddr;
	volatile epicsUInt32 *pixelTriggerDmaWords = myDmaISRData->pixelTriggerDmaWords;
	volatile epicsUInt8 *DFF2Clear = myDmaISRData->DFF2Clear;
	float *pixels1 = myDmaISRData->pixels1;
	float *pixels2 = myDmaISRData->pixels2;
	float *pixels3 = myDmaISRData->pixels3;
	float *pixels4 = myDmaISRData->pixels4;
	float *pixels5 = myDmaISRData->pixels5;
	float *pixels6 = myDmaISRData->pixels6;
	float *pixels7 = myDmaISRData->pixels7;

	float *scale1 = myDmaISRData->scale1;
	float *scale2 = myDmaISRData->scale2;
	float *scale3 = myDmaISRData->scale3;
	float *scale4 = myDmaISRData->scale4;
	float *scale5 = myDmaISRData->scale5;
	float *scale6 = myDmaISRData->scale6;
	float *scale7 = myDmaISRData->scale7;

	epicsUInt32 *numEvents = myDmaISRData->numEvents;
	epicsUInt32 *desNumEvents = myDmaISRData->desNumEvents;
	epicsUInt32 numX = *(myDmaISRData->numX);
	epicsUInt32 numY = *(myDmaISRData->numY);
	int numScalers = *(myDmaISRData->numScalers);
	int numEventWords = numScalers+1;
	int j, offset, record=0;
	epicsUInt16 x, y;
	epicsUInt32 pixelValue=0, timeValue=0, *data, uL;
	float scalerValue;
	epicsTimeStamp  timeStart, timeEnd;
	double dmaTime;
	//struct dma_proxy_channel_interface *rx_proxy_interface_p;
	//int rx_proxy_fd;
	int dummy = 0;
	int timeout_msecs = 10;
	int dma_bytes; /* in bytes32-byte events */
	int dma_words;
	int rep, maxReps=50;
	int *debug = myDmaISRData->debug;
	/* for list mode */
	int *acqMode = myDmaISRData->acqMode;
	epicsUInt16 *image1 = myDmaISRData->image1;
	epicsUInt16 *image2 = myDmaISRData->image2;

	dma_words = *pixelTriggerDmaWords;
	dma_bytes = dma_words*4;

	if (*debug) {
		printf("pixelTriggerDmaRoutine: *desNumEvents=%d\n", *desNumEvents);
	}
	if (*debug>=10) {
		printf("pixelTriggerDmaRoutine(0x%x, 0x%x)\n", risingMask, wentHigh);
	}
	if (*fifoCountAddr < dma_words) return;

	/* do DMA */
	//epicsTimeGetCurrent(&timeStart);
	rx_proxy_fd = open("/dev/dma_proxy_rx", O_RDWR);
	if (rx_proxy_fd < 1) {
		printf("pixelTriggerDmaRoutine: Unable to open DMA proxy device file for RX\n");
		return;
	}
	rx_proxy_interface_p = (struct dma_proxy_channel_interface *)mmap(NULL, sizeof(struct dma_proxy_channel_interface),
			PROT_READ | PROT_WRITE, MAP_SHARED, rx_proxy_fd, 0);

    if (rx_proxy_interface_p == MAP_FAILED) {
       	printf("pixelTriggerDmaRoutine: Failed to mmap for RX\n");
       	return;
    }
	//epicsTimeGetCurrent(&timeEnd);
	//if (*debug > 0) printf("pixelTriggerDmaRoutine: map time = %f\n", epicsTimeDiffInSeconds(&timeEnd, &timeStart));

	rx_proxy_interface_p->length = dma_bytes;
	rx_proxy_interface_p->timeout_msecs = timeout_msecs;

	dmaTime = 0;
	for (rep=0; rep<maxReps; rep++) {

		/* Perform the DMA transfer and after it finishes check the status */
		epicsTimeGetCurrent(&timeStart);
		ioctl(rx_proxy_fd, 0, &dummy);
		if (*debug>0 && (rx_proxy_interface_p->status != PROXY_NO_ERROR)) {
			printf("pixelTriggerDmaRoutine: Proxy rx transfer error\n");
		}
		data = (epicsUInt32 *)(rx_proxy_interface_p->buffer);
		epicsTimeGetCurrent(&timeEnd);
		dmaTime += epicsTimeDiffInSeconds(&timeEnd, &timeStart);

		if (*acqMode == ACQ_MODE_2D) {
			/*** bin data ***/
			for (j=0; j<(dma_words-numEventWords); ) {

				/* Find a valid event */
				while (!(data[j] & 0x80000000) && j<=(dma_words-numEventWords)) j++;
				if (j>(dma_words-numEventWords)) break;

				/* Bin this event */
				*numEvents = *numEvents + 1;
				/* pixelValue was marked by setting MSbit */
				pixelValue = (data[j] & ~0x80000000);
				x = (epicsUInt16) (pixelValue >> 16);
				y = (epicsUInt16) (pixelValue & 0xffff);
				record = (x < numX) && (y < numY) && (myDmaISRData->cleared==0);
				if (pixelValue == 0) record = 0;
				if (*debug>=10) printf("pixelTriggerDmaRoutine: x=%d, y=%d, record=%d, j=%d\n", x, y, record, j);
				offset = y*numX+x;
				if (record) {
					/* scaler values have MSbit cleared.  Make them ints. */
					uL = data[++j];	if (uL & 0x40000000) uL |= 0x80000000;
					scalerValue = (epicsInt32)uL * (*scale1);
					*(pixels1+offset) += scalerValue;
					if (*debug>=10) printf("pixelTriggerDmaRoutine: x=%d, y=%d, scalerValue=%f\n", x, y, scalerValue);

					uL = data[++j];	if (uL & 0x40000000) uL |= 0x80000000;
					*(pixels2+offset) += (epicsInt32)uL * (*scale2);

					uL = data[++j];	if (uL & 0x40000000) uL |= 0x80000000;
					*(pixels3+offset) += (epicsInt32)uL * (*scale3);

					uL = data[++j];	if (uL & 0x40000000) uL |= 0x80000000;
					*(pixels4+offset) += (epicsInt32)uL * (*scale4);

					uL = data[++j];	if (uL & 0x40000000) uL |= 0x80000000;
					*(pixels5+offset) += (epicsInt32)uL * (*scale5);

					uL = data[++j];	if (uL & 0x40000000) uL |= 0x80000000;
					*(pixels6+offset) += (epicsInt32)uL * (*scale6);

					uL = data[++j];	if (uL & 0x40000000) uL |= 0x80000000;
					*(pixels7+offset) += (epicsInt32)uL * (*scale7);
				} else {
					j++;
				}
				myDmaISRData->cleared = 0;
			}
		} else if ((*acqMode == ACQ_MODE_LIST || *acqMode == ACQ_MODE_MCS) && (*numEvents < myDmaISRData->allocatedElements-1)) {
			/* *acqMode == ACQ_MODE_LIST */
			for (j=0; j<(dma_words-numEventWords); ) {
				if (*debug>=2) printf("pixelTriggerDmaRoutine: *numEvents=%d\n", *numEvents);
				/* Find a valid event */
				while (!(data[j] & 0x80000000) && j<=(dma_words-numEventWords)) j++;
				if (j>(dma_words-numEventWords)) {
					if (*debug>=10) printf("pixelTriggerDmaRoutine: stop at j=%d, data[j]=%d\n", j, data[j]);
					break;
				}

				if ((*acqMode == ACQ_MODE_MCS) && ((*numEvents >= *desNumEvents) || (*numEvents >= allocatedElements-1))) {
					/* We're done. Turn the scaler off by clearing DFF-1. */
					*DFF2Clear = 0;
					*DFF2Clear = 0x20;
					/*printf("pixelTriggerDmaRoutine: done\n");*/
					break;
				}

				/* Bin this event */
				pixelValue = (data[j] & ~0x80000000);
				image1[*numEvents] = (epicsUInt16) (pixelValue >> 16);
				image2[*numEvents] = (epicsUInt16) (pixelValue & 0xffff);
				uL = data[++j];	if (uL & 0x40000000) uL |= 0x80000000;
				pixels1[*numEvents] = (epicsInt32)uL * (*scale1);
				if (*debug>=10) printf("pixelTriggerDmaRoutine: pixels1[%d]=%f, j=%d\n", *numEvents, pixels1[*numEvents], j-1);
				if (*debug == -1) {
					if (*numEvents > 0) {
						if ((*numEvents) && (pixels1[*numEvents] != 0) && (pixels1[*numEvents] - pixels1[*numEvents-1]) != 1) {
							ListModeTestMisses++;
							/*printf("pixelTriggerDmaRoutine: missed %d, rep=%d, pixels1=0x%x\n", pixels1[*numEvents] - pixels1[*numEvents-1], rep, pixels1[*numEvents]); */
						}
					}
				}

				uL = data[++j];	if (uL & 0x40000000) uL |= 0x80000000;
				pixels2[*numEvents] = (epicsInt32)uL * (*scale2);
				uL = data[++j];	if (uL & 0x40000000) uL |= 0x80000000;
				pixels3[*numEvents] = (epicsInt32)uL * (*scale3);
				uL = data[++j];	if (uL & 0x40000000) uL |= 0x80000000;
				pixels4[*numEvents] = (epicsInt32)uL * (*scale4);
				uL = data[++j];	if (uL & 0x40000000) uL |= 0x80000000;
				pixels5[*numEvents] = (epicsInt32)uL * (*scale5);
				uL = data[++j];	if (uL & 0x40000000) uL |= 0x80000000;
				pixels6[*numEvents] = (epicsInt32)uL * (*scale6);
				uL = data[++j];	if (uL & 0x40000000) uL |= 0x80000000;
				pixels7[*numEvents] = (epicsInt32)uL * (*scale7);
				myDmaISRData->cleared = 0;
				if (*numEvents < myDmaISRData->allocatedElements-1) {
					*numEvents = *numEvents + 1;
				} else {
					/* for debugging missed events, wrap around to beginning of buffer */
					if (*debug == -1) *numEvents = 0;
				}
			}
		} else if (*acqMode == ACQ_MODE_XYT) {
			/*** bin x,y,t data ***/
			for (j=0; j<(dma_words-numEventWords); ) {

				/* Find a valid event */
				while (!(data[j] & 0x80000000) && j<=(dma_words-numEventWords)) j++;
				if (j>(dma_words-numEventWords)) break;

				/* Bin this event */
				*numEvents = *numEvents + 1;
				pixelValue = (data[j] & ~0x80000000);
				x = (epicsUInt16) (pixelValue >> 16);
				y = (epicsUInt16) (pixelValue & 0xffff);
				record = (x < numX) && (y < numY) && (myDmaISRData->cleared==0);
				if (pixelValue == 0) record = 0;
				uL = data[j+1];	if (uL & 0x40000000) uL |= 0x80000000;
				scalerValue = (epicsInt32)uL * (*scale1);
				timeValue = data[j+5];
				if (*debug>=10) printf("pixelTriggerDmaRoutine: x=%d, y=%d, record=%d, j=%d\n", x, y, record, j);
				offset = y*numX+x;
				if (record) {
					j+=7; /* skip other channels for now */
					switch (timeValue) {
					case 1: *(pixels1+offset) += scalerValue; break;
					case 2: *(pixels2+offset) += scalerValue; break;
					case 3: *(pixels3+offset) += scalerValue; break;
					case 4: *(pixels4+offset) += scalerValue; break;
					case 5: *(pixels5+offset) += scalerValue; break;
					case 6: *(pixels6+offset) += scalerValue; break;
					case 7: *(pixels7+offset) += scalerValue; break;
					default: break;
					}
				} else {
					j++;
				}
				myDmaISRData->cleared = 0;
			}
		}
		/* If there's enough data in the FIFO, do another DMA transaction. */
		if (*debug > 1) printf("pixelTriggerDmaRoutine: *fifoCountAddr=%d\n", *fifoCountAddr);
		if (*fifoCountAddr < dma_words) goto done;
	}

done:
	if (*debug>1 && rep>1) printf("pixelTriggerDmaRoutine: reps=%d, DMA time/rep=%f\n", rep, dmaTime/rep);
	if (*debug>=10) printf("pixelTriggerDmaRoutine: done binning this buffer.\n");
	/* For now, just open and close every time */
	munmap(rx_proxy_interface_p, sizeof(struct dma_proxy_channel_interface));
	close(rx_proxy_fd);
}

/* int pixelTriggerDmaPrepare(componentName, risingMask, fifoSize)
 * componentName: not used
 * risingMask:	bit(s) to which we want to respond (e.g., 0x1, 0x8000000)
 * fifoSize: not used
 */
int pixelTriggerDmaPrepare(const char *componentName, epicsUInt32 risingMask, int fifoSize) {
	int i;
	volatile epicsUInt32 *localAddr = NULL;
	volatile epicsUInt8 *localAddr8 = NULL;
	UIO_struct *pUIO = NULL;

	i = findUioAddr(componentName, 0);
	if (i >= 0) {
		pUIO = UIO[i];
		localAddr = pUIO->localAddr;
	}
	myDmaISRData.fifoCountAddr = localAddr + 26; // Address of fifo count reg
	myDmaISRData.pixelTriggerDmaWords = localAddr + 61; // Address of DMA words reg

	/* To talk to DFF-1_CLEAR, we need the address of the "softGlue_" component */
	i = findUioAddr("softGlue_", 0);
	if (i >= 0) {
		pUIO = UIO[i];
		localAddr8 = (epicsUInt8 *)pUIO->localAddr;
	}
	myDmaISRData.DFF2Clear = localAddr8 + 131; // Address of DFF-2_CLEAR register

	/* Tell softGlue to call pixelTriggerDmaRoutine() when its interrupt-service routine handles an interrupt
	 * with the specified risingMask.  This also tells softGlue to not execute any output links that might
	 * also have been programmed to execute in response to this value of risingMask.
	 */
	softGlueZynqRegisterInterruptRoutine(risingMask, 0, pixelTriggerDmaRoutine, (void *)&myDmaISRData);

	return(0);
}

#include <registryFunction.h>
static registryFunctionRef pixelTriggerDmaRef[] = {
	{"pixelTriggerDma_init", (REGISTRYFUNCTION)pixelTriggerDma_init},
	{"pixelTriggerDma_do", (REGISTRYFUNCTION)pixelTriggerDma_do}
};

static void pixelTriggerDmaRegister(void) {
	registryFunctionRefAdd(pixelTriggerDmaRef, NELEMENTS(pixelTriggerDmaRef));
}


epicsExportRegistrar(pixelTriggerDmaRegister);

/* interrupt stuff */
/* int pixelTriggerDmaPrepare(const char *componentName, epicsUInt32 risingMask, int fifoSize) */
static const iocshArg myArg1 = { "componentName",	iocshArgString};
static const iocshArg myArg2 = { "risingMask",	iocshArgInt};
static const iocshArg myArg3 = { "fifoSize",	iocshArgInt};
static const iocshArg * const myArgs[3] = {&myArg1, &myArg2, &myArg3};
static const iocshFuncDef myFuncDef = {"pixelTriggerDmaPrepare", 3, myArgs};
static void myCallFunc(const iocshArgBuf *args) {
	pixelTriggerDmaPrepare(args[0].sval, args[1].ival, args[2].ival);
}

void pixelTriggerDmaISRRegistrar(void)
{
	iocshRegister(&myFuncDef, myCallFunc);
}

epicsExportRegistrar(pixelTriggerDmaISRRegistrar);
