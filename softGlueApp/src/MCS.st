program MCS("P=zzz:,Q=MCS1:,H=SG:,N=4000, AXI_Addr=0x43C40000")
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

int MCSDebug;
assign  MCSDebug to "{P}{Q}Debug"; 
monitor MCSDebug;

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
int *preg, *pcnt;
int doRead;
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

ss MCSread {
	state init {
		when () {
			if (MCSDebug) printf("MCSread:init");
			newData = 0;
			AXI_Address = strtol(seq_macValueGet(ssId,"AXI_Addr"), 0, 16);
			if (MCSDebug) {
				printf("MCSread: AXI_Address=0x%x\n", AXI_Address);
			}
			%%pVar->fd = open("/dev/mem",O_RDWR|O_SYNC);
			%%if (pVar->fd < 0) {
			%%	printf("Can't open /dev/mem\n");
			%%}
			%%pVar->preg = (int *) mmap(0,255,PROT_READ|PROT_WRITE,MAP_SHARED,pVar->fd,pVar->AXI_Address);
			%%pVar->pcnt = pVar->preg + 1;
		} state waitForStart
	}

	state waitForStart {
		when (start) {
		} state start
	}

	state start {
		when (start) {
			if (MCSDebug) {
				%%printf("MCSread: AXI_Address=0x%x\n", pVar->AXI_Address);
			}
			%%pVar->currIx = 0;
			%%*(pVar->preg) = 0;
			start = 0;
			pvPut(start);
			for (i=0; i<MAX_SIGNALS; i++) {
				for (ii=0; ii<MAX_ELEMENTS; ii++) {
					s[i][ii] = 0;
				}
				pvPut(s[i]);
			}
		} state waitForFIFO
	}

	state waitForFIFO {
		when (start) {
		} state start
		when (stop) {
			stop = 0;
			pvPut(stop);
		} state waitForStart
		when () {
			%%pVar->doRead = *(pVar->pcnt) > 7;
			if (MCSDebug>5) {
				%%printf("MCSread: *(pVar->pcnt)=%d\n", *(pVar->pcnt));
			}
		} state checkWait
	}

	state checkWait {
		when (doRead) {
		} state read
		when (delay(.1)) {
		} state waitForFIFO
	}


	state read {
		when (stop) {
			stop = 0;
			pvPut(stop);
		} state waitForStart
		when () {
		} state readMore
	}

	state readMore {
		when () {
			%%for (pVar->ii=0; (*(pVar->pcnt) > MAX_SIGNALS) && (pVar->ii) < 100000; (pVar->ii)++) {
			%%	pVar->newData = 1;
			%%	for (pVar->i=0; pVar->i < MAX_SIGNALS; (pVar->i)++) {
			%%		pVar->s[pVar->i][pVar->currIx] = *(pVar->preg) & 0x7fffffff;
			%%	}
			%%	if (pVar->_stop) {
			%%		pVar->_stop = 0;
			%%		break;
			%%	}
			%%	if (pVar->currIx < MAX_ELEMENTS-1)
			%%		(pVar->currIx)++;
			%%	else {
			%%		if (pVar->continuous)
			%%			pVar->currIx = 0;
			%%		else
			%%			pVar->stop = 1;
			%%	}
			%%}
		} state read
	}

}


ss MCSwrite {
	state init {
		when () {
			if (MCSDebug) printf("MCSwrite:init");
		} state start
	}
	state start {
		when (delay(.2)) {
			if (newData) {
				for (j=0; j<MAX_SIGNALS; j++) pvPut(s[j]);
				newData = 0;
				if (MCSDebug) printf("MCSwrite: newData\n");
			}
			if (MCSDebug>5 && currIx>1) {
				printf("MCSwrite:ix=%d, s[0][ix]=%d, s[1][ix]=%d\n", currIx-1, s[0][currIx-1], s[1][currIx-1]);
			}
			if (stop) _stop = 1;
		} state start
	}
}
