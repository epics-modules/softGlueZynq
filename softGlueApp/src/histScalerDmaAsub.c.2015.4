/* Copyright (c) 2016 UChicago Argonne LLC, as Operator of Argonne
 * National Laboratory, and The Regents of the University of California, as
 * Operator of Los Alamos National Laboratory.
 * softGlueZynq is distributed subject to a Software License Agreement found
 * in the file LICENSE that is included with this distribution.
 */

/* histScalerDmaAsub - collect histogramming scaler channels into an array.
 * aSub record fields:
 *  vala[]  input 0
 *  valh    number of events
 *  a       number of scaler channels
 *  d       clear arrays
 *	h		debug level
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

#define MAX_DMA_BYTES 32*1024*4

volatile epicsUInt32 *hs_localAddr = NULL;
volatile epicsUInt32 *hs_fifoCountAddr = NULL;
volatile epicsUInt32 *histScalerDmaWords = NULL;
static volatile epicsUInt8 *histRead, *histClear;

static long histScalerDma_init(aSubRecord *pasub) {
	int i;
	UIO_struct *pUIO = NULL;
	volatile epicsUInt8 *reg8_localAddr;

	i = findUioAddr("softGlueReg32_", 0);
	if (i >= 0) {
		pUIO = UIO[i];
		hs_localAddr = pUIO->localAddr;
	}
	hs_fifoCountAddr = hs_localAddr + 26; // Address of fifo count reg
	histScalerDmaWords = hs_localAddr + 61; // Address of DMA words reg

	i = findUioAddr("softGlue_", 0);
	if (i >= 0) {
		pUIO = UIO[i];
		reg8_localAddr = (epicsUInt8 *)(pUIO->localAddr);
		histRead = reg8_localAddr + 278;	/* HistScal-1_READ */
		histClear = reg8_localAddr + 207;	/* HistScal-1_CLEAR */
	}
	return(0);
}

static long histScalerDma_do(aSubRecord *pasub) {
	int j;
	epicsUInt32 *data;
	epicsTimeStamp  timeStart, timeEnd;
	double dmaTime;
	struct dma_proxy_channel_interface *hs_rx_proxy_interface_p;
	int hs_rx_proxy_fd;
	int dummy = 0;
	int timeout_msecs = 10;
	int dma_bytes; /* in bytes32-byte events */
	int dma_words;

	int *clear = (int *)pasub->d;
	epicsUInt32 *counts1 = (epicsUInt32 *)pasub->vala;

	int i;
	int *debug = (int *)pasub->h;

	if (*debug>1) {
		printf("histScalerDma_do: entry\n");
	}

	if (*clear) {
		/* erase pixel maps */
		for (i=0; i<pasub->nova; i++) {
			counts1[i] = 0;
		}
		*histClear = 0x20;
		*histClear = 0;
		*clear = 0;
	}

	/* cause HistScal component to dump its data to the FIFO */
	*histRead = 0x20;
	*histRead = 0;

	dma_words = *histScalerDmaWords;
	dma_bytes = dma_words*4;

	if (*hs_fifoCountAddr < dma_words) {
		if (*debug>1) {
			printf("histScalerDma_do: avail words (%d) < dma_words (%d)\n",
				*hs_fifoCountAddr, dma_words);
		}
		return(0);
	}

	/* do DMA */
	hs_rx_proxy_fd = open("/dev/dma_proxy_rx", O_RDWR);
	if (hs_rx_proxy_fd < 1) {
		printf("histScalerDmaRoutine: Unable to open DMA proxy device file for RX\n");
		return(0);
	}
	hs_rx_proxy_interface_p = (struct dma_proxy_channel_interface *)mmap(NULL, sizeof(struct dma_proxy_channel_interface),
			PROT_READ | PROT_WRITE, MAP_SHARED, hs_rx_proxy_fd, 0);

    if (hs_rx_proxy_interface_p == MAP_FAILED) {
       	printf("histScalerDmaRoutine: Failed to mmap for RX\n");
       	return(0);
    }

	hs_rx_proxy_interface_p->length = dma_bytes;
	hs_rx_proxy_interface_p->timeout_msecs = timeout_msecs;

	dmaTime = 0;

	/* Perform the DMA transfer and after it finishes check the status */
	epicsTimeGetCurrent(&timeStart);
	ioctl(hs_rx_proxy_fd, 0, &dummy);
	if (*debug && (hs_rx_proxy_interface_p->status != PROXY_NO_ERROR)) {
		printf("histScalerDmaRoutine: Proxy rx transfer error\n");
		munmap(hs_rx_proxy_interface_p, sizeof(struct dma_proxy_channel_interface));
		close(hs_rx_proxy_fd);
		return(0);
	}
	data = (epicsUInt32 *)(hs_rx_proxy_interface_p->buffer);
	epicsTimeGetCurrent(&timeEnd);
	dmaTime += epicsTimeDiffInSeconds(&timeEnd, &timeStart);

	/*** collect data ***/
	for (j=0; j<dma_words; j++) {
		counts1[j] = data[j] & 0x7fffffff;
		if (*debug > 10) printf("histScalerDmaRoutine: counts1[%d]=%d, first==%d\n", j, counts1[j], (data[j] & 0x80000000)!=0);
		*clear = 0;
	}
	/* If there's enough data in the FIFO, do another DMA transaction. */
	if (*debug > 1) printf("histScalerDmaRoutine: *hs_fifoCountAddr=%d\n", *hs_fifoCountAddr);

	if (*debug) printf("histScalerDmaRoutine: DMA time=%f\n", dmaTime);
	if (*debug>=10) printf("histScalerDmaRoutine: done binning this buffer.\n");
	/* For now, just open and close every time */
	munmap(hs_rx_proxy_interface_p, sizeof(struct dma_proxy_channel_interface));
	close(hs_rx_proxy_fd);

	return(0);
}


#include <registryFunction.h>
static registryFunctionRef histScalerDmaRef[] = {
	{"histScalerDma_init", (REGISTRYFUNCTION)histScalerDma_init},
	{"histScalerDma_do", (REGISTRYFUNCTION)histScalerDma_do}
};

static void histScalerDmaRegister(void) {
	registryFunctionRefAdd(histScalerDmaRef, NELEMENTS(histScalerDmaRef));
}
epicsExportRegistrar(histScalerDmaRegister);
