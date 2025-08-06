/* Copyright (c) 2016 UChicago Argonne LLC, as Operator of Argonne
 * National Laboratory, and The Regents of the University of California, as
 * Operator of Los Alamos National Laboratory.
 * softGlueZynq is distributed subject to a Software License Agreement found
 * in the file LICENSE that is included with this distribution.
 */

/* acquireDmaAsub - acquire events.
 * aSub record fields:
 *  vala[]  plot 1
 *  valb[]  plot 2
 *  valc[]  plot 3
 *  vald[]  plot 4
 *  vale[]  plot 5
 *  valr[]  plot 6
 *  valg[]  plot 7
 *  valh[]  plot 8
 *  vali    number of events in plot arrays
 * 	valj	number of words in circular buffer
 *  a       plot bank: 0:0-7; 1:8-15; 3:16-23
 *  d       clear plot arrays
 *	e		clock rate counter1
 *  f       clear circular buffer
 *	h		debug level
 *	i		scale1
 *	j		scale2
 *	k		scale3
 *	l		scale4
 *	m		scale5
 *	n		scale6
 *	o		scale7
 *	p		scale8
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
#include <string.h>

#include <epicsTypes.h>
#include <iocsh.h>
#include "drvZynq.h"
#include <dbDefs.h>
#include <dbCommon.h>
#include <epicsThread.h>
#include <epicsMutex.h>
#include <recSup.h>
#include <aSubRecord.h>
#include <epicsExport.h>

/* for DMA */
#include <sys/ioctl.h>
#include "dma-proxy.h"

// for socket server
#include<sys/socket.h>
#include<arpa/inet.h>	//inet_addr
#include<unistd.h>	//write
#include "acquireSocket.h"

/* circular buffer */
#define cirBufWords 10000000
epicsUInt32 cirBuf[cirBufWords];
int writeIx, readIx, bufWords;
epicsMutexId ix_mutex; /* protect writeIx, readIx, bufWords from simultaneous access */

epicsUInt32 dataBuf[acquireTranWords];
int cirBufRead(int numWords, epicsUInt32 *data);

int cleared, allocatedElements, *debug, *plotBank;

// This will handle connection for each client
void *connection_handler(void *socket_desc)
{
	// Get the socket descriptor
	int sock = *(int*)socket_desc;
	int read_size;
	char client_message[100];
	int i;
	ssize_t bytesSent;
	
	// Receive a message from client
	for (i=0; i<strlen(client_message); i++) client_message[i] = 0;
	while ( (read_size = recv(sock, client_message, CMD_LEN , MSG_WAITALL)) > 0 ) {
		if (strncmp(client_message, "sendnumw", CMD_LEN) == 0) {
			// Send the message back to client
			if (*debug > 0) printf("connection_handler: sending bufwords = %d\n", bufWords);
			for (i=0; i<strlen(client_message); i++) client_message[i] = 0;
			sprintf(client_message, "%010d", bufWords);
			bytesSent = write(sock, client_message, NUM_LEN);
		} else if (strncmp(client_message, "senddata", CMD_LEN) == 0) {
			if (bufWords >= acquireTranWords) {
			if (*debug > 0) printf("connection_handler: sending %d words\n", acquireTranWords);
				cirBufRead(acquireTranWords, dataBuf);
				bytesSent = write(sock, dataBuf, acquireTranWords*4);
				if (bytesSent == -1) printf("connection_handler: write failed");
				if (*debug > 0) printf("bytesSent = %d\n", (int)bytesSent);
			}
		}
	}
	
	if (read_size == 0) {
		printf("connection_handler: Client disconnected\n");
		fflush(stdout);
	} else if (read_size == -1) {
		perror("connection_handler: recv failed");
	}
	
	// Free the socket pointer
	free(socket_desc);
	
	return 0;
}
void *makeSocket() {
	int socket_desc, new_socket, c, *new_sock;
	struct sockaddr_in server, client;
	
	// Create socket
	socket_desc = socket(AF_INET, SOCK_STREAM, 0);
	if (socket_desc == -1) {
		printf("makeSocket: Could not create socket");
	}
	
	// Prepare the sockaddr_in structure
	server.sin_family = AF_INET;
	server.sin_addr.s_addr = INADDR_ANY;
	server.sin_port = htons( 8888 );
	
	// Bind
	if (bind(socket_desc,(struct sockaddr *)&server, sizeof(server)) < 0) {
		puts("makeSocket: bind failed");
		return (void *)1;
	}
	puts("makeSocket: bind done");
	
	// Listen
	listen(socket_desc , 3);
	
	// Accept and incoming connection
	puts("Waiting for incoming connections...");
	c = sizeof(struct sockaddr_in);
	while ((new_socket = accept(socket_desc, (struct sockaddr *)&client, (socklen_t*)&c))) {
		puts("makeSocket: Connection accepted");
		
		// Reply to the client
		//message = "Hello Client , I have received your connection. And now I will assign a handler for you\n";
		//write(new_socket, message, strlen(message));
		
		pthread_t sniffer_thread;
		new_sock = malloc(4);
		*new_sock = new_socket;
		
		if (pthread_create(&sniffer_thread, NULL,  connection_handler, (void*) new_sock) < 0) {
			perror("makeSocket: could not create thread");
			return (void *)1;
		}
		
		// Now join the thread , so that we dont terminate before the thread
		// pthread_join( sniffer_thread , NULL);
		puts("makeSocket: Handler assigned");
	}
	
	if (new_socket<0) {
		perror("makeSocket: accept failed");
		return (void *)0;
	}
	
	return (void *)0;
}


#define MAX(a,b) ((a)>(b)?(a):(b))

/* make global so we can map at init */
static struct channel_buffer *rx_proxy_interface_p;
static int rx_proxy_fd;

enum eType {event8, event24};
enum eType eventType;

void cirBufInit() {
	writeIx = 0;
	readIx = 0;
	bufWords = 0;
	ix_mutex = epicsMutexCreate();
}

int cirBufWrite(int numWords, epicsUInt32 *data) {
	int numWords1, numWords2;

	epicsMutexLock(ix_mutex);
	if (numWords > (cirBufWords - bufWords)) {
		if (*debug > 0) printf("cirBufWrite: no room for %d new words. bufWords=%d.\n", numWords, bufWords);
		epicsMutexUnlock(ix_mutex);
		return(-1);
	}
	if ((writeIx + numWords) > (cirBufWords-1)) {
		// Write until end of buffer; write remaining items from beginning of buffer
		// Want writeIx + numWords1 = cirBufWords-1
		numWords1 =  (cirBufWords-1) - writeIx;
		numWords2 = numWords - numWords1;
		if (numWords1 > 0) memcpy(&(cirBuf[writeIx]), data, numWords1*4);
		memcpy((void*)&(cirBuf[0]), (void*)&(data[numWords1]), numWords2*4);
		writeIx = numWords2;
	} else {
		// Just write
		memcpy((void*)&(cirBuf[writeIx]), (void*)data, numWords*4);
		writeIx += numWords;
	}
	bufWords += numWords;
	if (*debug > 0) printf("cirBufWrite: writeIx = %d, bufWords = %d\n", writeIx, bufWords);
	epicsMutexUnlock(ix_mutex);
	return(0);
}

int cirBufRead(int numWords, epicsUInt32 *data) {
	int numWords1, numWords2;

	epicsMutexLock(ix_mutex);
	if (numWords > bufWords) {
		epicsMutexUnlock(ix_mutex);
		return(-1);
	}
	if ((readIx + numWords) > (cirBufWords-1)) {
		numWords1 =  (cirBufWords-1) - readIx;
		numWords2 = numWords - numWords1;
		if (numWords1 > 0) memcpy(data, &(cirBuf[readIx]), numWords1*4);
		memcpy(&(data[numWords1]), cirBuf, numWords2*4);
		readIx = numWords2;
	} else {
		memcpy(data, &(cirBuf[readIx]), numWords*4);
		readIx += numWords;
	}
	bufWords -= numWords;
	if (*debug > 0) printf("cirBufRead: readIx = %d, bufWords = %d\n", readIx, bufWords);
	epicsMutexUnlock(ix_mutex);
	return(0);
}

volatile epicsUInt32 *fifoCountAddr, *acquireDmaWords;
float *plot1, *plot2, *plot3, *plot4, *plot5, *plot6, *plot7, *plot8;
float *scale1, *scale2, *scale3, *scale4, *scale5, *scale6, *scale7, *scale8;
epicsUInt32 *numEvents, *numCBwords;

static long acquireDma_init(aSubRecord *pasub) {

	numEvents = (epicsUInt32 *)pasub->vali;
	numCBwords = (epicsUInt32 *)pasub->valj;
	plotBank = (epicsInt32 *)pasub->a;
	debug = (epicsInt32 *)pasub->h;

	plot1 = (float *)pasub->vala;
	plot2 = (float *)pasub->valb;
	plot3 = (float *)pasub->valc;
	plot4 = (float *)pasub->vald;
	plot5 = (float *)pasub->vale;
	plot6 = (float *)pasub->valf;
	plot7 = (float *)pasub->valg;
	plot8 = (float *)pasub->valh;

	scale1 = (float *)pasub->i;
	scale2 = (float *)pasub->j;
	scale3 = (float *)pasub->k;
	scale4 = (float *)pasub->l;
	scale5 = (float *)pasub->m;
	scale6 = (float *)pasub->n;
	scale7 = (float *)pasub->o;
	scale8 = (float *)pasub->p;

	cleared = 1;
	allocatedElements = pasub->nova;


	pthread_t socket_thread;
	if (pthread_create(&socket_thread, NULL,  makeSocket, (void*)0) < 0) {
		perror("acquireDma_init: could not create socket thread");
		return 1;
	}
	return(0);
}

static long acquireDma_do(aSubRecord *pasub) {
	int allocatedElements = pasub->nova;
	int *clear = (int *)pasub->d;
	int *clearCircBuf = (int *)pasub->f;
	int i;

	if (*debug>1) {
		printf("acquireDma_do: entry\n");
	}

	if (*clear) {
		/* erase pixel maps */
		for (i=0; i<allocatedElements; i++) {
			plot1[i] = 0;
			plot2[i] = 0;
			plot3[i] = 0;
			plot4[i] = 0;
			plot5[i] = 0;
			plot6[i] = 0;
			plot7[i] = 0;
			plot8[i] = 0;
			*numEvents = 0;
			cleared = 1;
		}
		*clear = 0;
	}

	if (*clearCircBuf) {
		epicsMutexLock(ix_mutex);
		writeIx = 0;
		readIx = 0;
		bufWords = 0;
		*numCBwords = bufWords;
		epicsMutexUnlock(ix_mutex);
		*clearCircBuf = 0;
	}

 	// Tell client how many words are in the circular buffer, cirBuf.
	*numCBwords = bufWords;
	
	return(0);
}

/* interrupt driven stuff */

/* When an interrupt matching conditions specified by acquireDmaPrepare() occurs,
 * we'll get called with the bitmask that generated the interrupt, and the bit that went low or high.
 */
 
 /* We expect events of the following form:
  *		scaler1
  *		scaler2
  *		scaler3
  *		scaler4
  *		scaler5
  *		scaler6
  *		scaler7
  *		scaler8
  *	where scaler1 is distinguishable from other scaler values because its MSbit is set.
  */
void acquireDmaRoutine(softGlueIntRoutineData *IRData) {
	epicsUInt32 risingMask = IRData->risingMask;
	epicsUInt32 wentHigh = IRData->wentHigh;

	epicsUInt32 j;
	epicsTimeStamp  timeStart, timeEnd;
	double dmaTime;
	int buffer_id = 0;
	int dma_bytes;
	epicsUInt32 dma_words;
	epicsUInt32 *data, uL;
	int rep, maxReps=50; // for testing, maxReps=1. For efficiency, maxReps=50;

	dma_words = *acquireDmaWords;
	dma_bytes = dma_words*4;

	if (*debug>=10) {
		printf("acquireDmaRoutine(0x%x, 0x%x)\n", risingMask, wentHigh);
	}
	/* Look, within softGlue, for the current number of words in the FIFO */
	if (*fifoCountAddr < dma_words) return;

	/* do DMA */
	rx_proxy_fd = open("/dev/dma_proxy_rx", O_RDWR);
	if (rx_proxy_fd < 1) {
		printf("acquireDmaRoutine: Unable to open DMA proxy device file for RX\n");
		return;
	}
	if (*debug > 0) {
		printf("acquireDmaRoutine: Opened /dev/dma_proxy_rx\n");
	}
	rx_proxy_interface_p = (struct channel_buffer *)mmap(NULL, sizeof(struct channel_buffer),
			PROT_READ | PROT_WRITE, MAP_SHARED, rx_proxy_fd, 0);

    if (rx_proxy_interface_p == MAP_FAILED) {
       	printf("acquireDmaRoutine: Failed to mmap for RX\n");
       	return;
    }
	if (*debug > 0) {
		printf("acquireDmaRoutine: mmap succeeded.\n");
	}

	rx_proxy_interface_p->length = dma_bytes;

	dmaTime = 0;
	for (rep=0; rep<maxReps; rep++) {

		/* Perform the DMA transfer and after it finishes check the status */
		epicsTimeGetCurrent(&timeStart);
		ioctl(rx_proxy_fd, START_XFER, &buffer_id);
		if (*debug>0) {
			printf("acquireDmaRoutine: ioctl(rx_proxy_fd, START_XFER, &buffer_id)\n");
			//sleep(30);
		}
		ioctl(rx_proxy_fd, FINISH_XFER, &buffer_id);
		if (*debug>0) {
			if (rx_proxy_interface_p->status != PROXY_NO_ERROR) {
				printf("acquireDmaRoutine: Proxy rx transfer error\n");
			} else {
				printf("acquireDmaRoutine: ioctl(rx_proxy_fd, FINISH_XFER, &buffer_id) returned X.\n");
			}
		}

		data = (epicsUInt32 *)(rx_proxy_interface_p->buffer);
		epicsTimeGetCurrent(&timeEnd);
		dmaTime += epicsTimeDiffInSeconds(&timeEnd, &timeStart);

		/* write data to circular buffer for transfer out via socket */
		cirBufWrite(dma_words, data);
		*numCBwords = bufWords;
		if (*debug > 0) printf("acquireDmaRoutine: wrote %d to cirBuf.\n", dma_words);

		/* split event data into arrays for plotting */
		for (j=0; j<dma_words; ) {
			if (*debug>=3) printf("acquireDmaRoutine: *numEvents=%d, j=%d, data[j]=%x\n", *numEvents, j, data[j]);
			/* Find a valid event */
			while (!(data[j] & 0x80000000) && (j<=dma_words)) j++;
			if (j>dma_words) {
				if (*debug>=10) printf("acquireDmaRoutine: stop at j=%d, data[j]=%d\n", j, data[j]);
				break;
			}
			if ((data[j] & 0xc0000000) == 0xc0000000) {
				eventType = event24;
				data[j] &= ~0xc0000000; // clear event-marker bits
				if (*debug>0) printf("acquireDmaRoutine: eventType == event24\n");
			} else {
				eventType = event8;
				data[j] &= ~0xc0000000; // clear event-marker bits
			}

			/* record this event */
			if (*plotBank == 0) {
				uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
				plot1[*numEvents] = (epicsInt32)uL * (*scale1);
				if (*debug>=10) printf("acquireDmaRoutine: plot1[%d]=%f, j=%d\n", *numEvents, plot1[*numEvents], j-1);
				uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
				plot2[*numEvents] = (epicsInt32)uL * (*scale2);
				uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
				plot3[*numEvents] = (epicsInt32)uL * (*scale3);
				uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
				plot4[*numEvents] = (epicsInt32)uL * (*scale4);
				uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
				plot5[*numEvents] = (epicsInt32)uL * (*scale5);
				uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
				plot6[*numEvents] = (epicsInt32)uL * (*scale6);
				uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
				plot7[*numEvents] = (epicsInt32)uL * (*scale7);
				uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
				plot8[*numEvents] = (epicsInt32)uL * (*scale8);
			} else {
				j += 8;
			}
			if ((eventType == event8) && (*plotBank == 0)) {
				if (*numEvents < allocatedElements-1) {
					*numEvents = *numEvents + 1;
				} else {
					/* maybe wrap around to beginning of buffer */
					if (*debug == -1) *numEvents = 0;
				}
			}
			if (eventType == event24) {
				// Skip partial events
				if (j+24 >= dma_words) break;
			 	if (*plotBank == 1) {
					// The Asub record doesn't have enough fields to plot all 24
					// input values. *plotBank selects 0-7, 8-15, or 16-23.
					uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
					plot1[*numEvents] = (epicsInt32)uL;
					uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
					plot2[*numEvents] = (epicsInt32)uL;
					uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
					plot3[*numEvents] = (epicsInt32)uL;
					uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
					plot4[*numEvents] = (epicsInt32)uL;
					uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
					plot5[*numEvents] = (epicsInt32)uL;
					uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
					plot6[*numEvents] = (epicsInt32)uL;
					uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
					plot7[*numEvents] = (epicsInt32)uL;
					uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
					plot8[*numEvents] = (epicsInt32)uL;
				} else {
					j += 8;
				}

			 	if (*plotBank == 2) {
					uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
					plot1[*numEvents] = (epicsInt32)uL;
					uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
					plot2[*numEvents] = (epicsInt32)uL;
					uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
					plot3[*numEvents] = (epicsInt32)uL;
					uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
					plot4[*numEvents] = (epicsInt32)uL;
					uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
					plot5[*numEvents] = (epicsInt32)uL;
					uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
					plot6[*numEvents] = (epicsInt32)uL;
					uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
					plot7[*numEvents] = (epicsInt32)uL;
					uL = data[j++];	if (uL & 0x20000000) uL |= 0xc0000000;
					plot8[*numEvents] = (epicsInt32)uL;
				} else {
					j+= 8;
				}

				if (*numEvents < allocatedElements-1) {
					*numEvents = *numEvents + 1;
				} else {
					/* maybe wrap around to beginning of buffer */
					if (*debug == -1) *numEvents = 0;
				}
			}
			cleared = 0;
		} 
		/* If there's enough data in the FIFO, do another DMA transaction. */
		if (*debug > 2) printf("acquireDmaRoutine: *fifoCountAddr=%d, rep=%d\n", *fifoCountAddr, rep);
		if (*fifoCountAddr < dma_words) goto done;
	}

done:
	if (*debug>1 && rep>1) printf("acquireDmaRoutine: reps=%d, DMA time/rep=%f\n", rep, dmaTime/rep);
	if (*debug>=10) printf("acquireDmaRoutine: done binning this buffer.\n");
	/* For now, just open and close every time */
	munmap(rx_proxy_interface_p, sizeof(struct channel_buffer));
	close(rx_proxy_fd);
}

/* int acquireDmaPrepare(componentName, risingMask, fifoSize)
 * componentName: not used
 * risingMask:	bit(s) to which we want to respond (e.g., 0x1, 0x8000000)
 * fifoSize: not used
 */
int acquireDmaPrepare(const char *componentName, epicsUInt32 risingMask, int fifoSize, int FIFOCTreg) {
	int i;
	volatile epicsUInt32 *localAddr = NULL;
	UIO_struct *pUIO = NULL;

	i = findUioAddr(componentName, 0);
	if (i >= 0) {
		pUIO = UIO[i];
		localAddr = pUIO->localAddr;
	}
	fifoCountAddr = localAddr + 26; // Address of fifo count reg
	acquireDmaWords = localAddr + FIFOCTreg; //61; // Address of DMA words reg

	/* Tell softGlue to call acquireDmaRoutine() when its interrupt-service routine handles an interrupt
	 * with the specified risingMask.  This also tells softGlue to not execute any output links that might
	 * also have been programmed to execute in response to this value of risingMask.
	 */
	softGlueZynqRegisterInterruptRoutine(risingMask, 0, acquireDmaRoutine, NULL);

	ix_mutex = epicsMutexCreate();

	return(0);
}

#include <registryFunction.h>
static registryFunctionRef acquireDmaRef[] = {
	{"acquireDma_init", (REGISTRYFUNCTION)acquireDma_init},
	{"acquireDma_do", (REGISTRYFUNCTION)acquireDma_do}
};

static void acquireDmaRegister(void) {
	registryFunctionRefAdd(acquireDmaRef, NELEMENTS(acquireDmaRef));
}


epicsExportRegistrar(acquireDmaRegister);

/* interrupt stuff */
/* int acquireDmaPrepare(const char *componentName, epicsUInt32 risingMask, int fifoSize, intFIFOCTreg=61) */
static const iocshArg myArg1 = { "componentName",	iocshArgString};
static const iocshArg myArg2 = { "risingMask",	iocshArgInt};
static const iocshArg myArg3 = { "fifoSize",	iocshArgInt};
static const iocshArg myArg4 = { "FIFOCTreg",	iocshArgInt};
static const iocshArg * const myArgs[4] = {&myArg1, &myArg2, &myArg3, &myArg4};
static const iocshFuncDef myFuncDef = {"acquireDmaPrepare", 4, myArgs};
static void myCallFunc(const iocshArgBuf *args) {
	acquireDmaPrepare(args[0].sval, args[1].ival, args[2].ival, args[3].ival);
}

void acquireDmaISRRegistrar(void)
{
	iocshRegister(&myFuncDef, myCallFunc);
}

epicsExportRegistrar(acquireDmaISRRegistrar);
