program DMA("P=zzz:,Q=DMA1:,H=SG:,N=4000, AXI_Addr=0x40400000")
%%#include	<stdlib.h>
%%#include	<stddef.h>
%%#include	<stdio.h>
%%#include	<sys/types.h>
%%#include	<unistd.h>
%%#include	<sys/mman.h>
%%#include	<fcntl.h>
%%#include	<sys/stat.h>

option +r;

#define MAX_SIGNALS 8
#define MAX_ELEMENTS 50000

int DMADebug;
assign  DMADebug to "{P}{Q}Debug"; 
monitor DMADebug;

int start;
assign  start to "{P}{Q}start"; 
monitor start;

int stop;
assign  stop to "{P}{Q}stop"; 
monitor stop;
int _stop;

int continuous;
assign  continuous to "{P}{Q}continuous";
monitor continuous;

int newData;
int AXI_Address;
int fd;
int *pbase;
unsigned int* dma_data;
int doRead;
int dmaDone;
int currIx;
int s[MAX_SIGNALS][MAX_ELEMENTS];
int j;
int i, ii;

assign s to {
	"{P}{Q}s0",
	"{P}{Q}s1",
	"{P}{Q}s2",
	"{P}{Q}s3",
	"{P}{Q}s4",
	"{P}{Q}s5",
	"{P}{Q}s6",
	"{P}{Q}s7"
};

%%#define S2MM_CONTROL 12
%%#define S2MM_STATUS 13
%%#define S2MM_ADDR_LS 18
%%#define S2MM_ADDR_MS 19
%%#define S2MM_BUFLEN 22
%%#define BUFLEN 2097151	/* 0x1fffff 4-byte words */
%%#define DEST_ADDR 0x0f000000

ss DMAread {
	state init {
		when () {
			if (DMADebug) printf("DMAread:init");
			newData = 0;
			AXI_Address = strtol(seq_macValueGet(ssId,"AXI_Addr"), 0, 16);
			if (DMADebug) {
				printf("DMAread: AXI_Address=0x%x\n", AXI_Address);
			}
			%%pVar->fd = open("/dev/mem",O_RDWR|O_SYNC);
			%%if (pVar->fd < 0) {
			%%	printf("Can't open /dev/mem\n");
			%%}
			%%pVar->pbase = (int *) mmap(0,255,PROT_READ|PROT_WRITE,MAP_SHARED,pVar->fd,pVar->AXI_Address);
			/* Memory map destination address */
			%%pVar->dma_data = mmap(NULL, BUFLEN*4, PROT_READ | PROT_WRITE, MAP_SHARED, pVar->fd, DEST_ADDR);
		} state waitForStart
	}

	state waitForStart {
		when (start) {
		} state start
	}

	state start {
		when (start) {
			if (DMADebug) {
				%%printf("DMAread: AXI_Address=0x%x, dma_data=%p\n", pVar->AXI_Address, pVar->dma_data);
			}
			/* %% memset(pVar->dma_data, 0, BUFLEN*4); */ /* clear the memory DMA will write to */
			%% *(pVar->pbase+S2MM_CONTROL) = 4;	/* reset */
			%% *(pVar->pbase+S2MM_CONTROL) = 0;	/* halt */

			%% *(pVar->pbase+S2MM_ADDR_LS) = DEST_ADDR;
			%% *(pVar->pbase+S2MM_ADDR_MS) = 0;

			%% *(pVar->pbase+S2MM_CONTROL) = 1;	/* run */

			%% *(pVar->pbase+S2MM_BUFLEN) = BUFLEN*4; /* this actually starts the DMA operation */
			start = 0;
			pvPut(start);
			for (i=0; i<MAX_SIGNALS; i++) {
				for (ii=0; ii<MAX_ELEMENTS; ii++) {
					s[i][ii] = 0;
				}
				pvPut(s[i]);
			}
		} state read
	}

	state read {
		when (stop) {
			%%*(pVar->pbase+S2MM_CONTROL) = 0;	/* halt */
			stop = 0;
			pvPut(stop);
		} state waitForStart
		when (delay(1)) {
			%% pVar->dmaDone = ((*(pVar->pbase+S2MM_STATUS)&(1<12) != 0) || (*(pVar->pbase+S2MM_STATUS)&(1<1) != 0));
			printf("DMAread: dma_data: done=%d, %d, %d, %d\n", dmaDone, dma_data[0], dma_data[1], dma_data[2]);
		} state read
	}

}
