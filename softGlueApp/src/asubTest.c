/* Copyright (c) 2016 UChicago Argonne LLC, as Operator of Argonne
 * National Laboratory, and The Regents of the University of California, as
 * Operator of Los Alamos National Laboratory.
 * softGlueZynq is distributed subject to a Software License Agreement found
 * in the file LICENSE that is included with this distribution.
 */

/* clockConfigAsub - configure Xilinx clock-wizard clock frequencies
 * aSub record fields:
 * vala - actual frequency of clock 1	(softGlue register clock)
 * valb - actual frequency of clock 2	(50MHZ_CLOCK)
 * valc - actual frequency of clock 3	(20MHZ_CLOCK)
 * vald - actual frequency of clock 4	(10MHZ_CLOCK)
 * vale - actual frequency of clock 5	(fast gate&delay clock)
 * valf - actual frequency of clock 6	(fast Histo clock)
 * Tim Mooney
 */

// #include <unistd.h>
// #include <sys/mman.h>
// #include <fcntl.h>
// #include <sys/stat.h>

#include <stddef.h>
#include <stdlib.h>
#include <math.h>
#include <stdio.h>

#include <stdint.h>

#include <epicsTypes.h>
#include <epicsThread.h>
#include <iocsh.h>
/* findUioAddr(), UIO array */
// #include "drvZynq.h"
#include <dbDefs.h>
#include <dbCommon.h>
#include <epicsThread.h>
#include <recSup.h>
#include <aSubRecord.h>
#include <epicsExport.h>


#define NINT(f)  (int)((f)>0 ? (f)+0.5 : (f)-0.5)

#define BINARY_LENGTH 1296
#define CHUNK_SIZE 32
#define PADDED_LENGTH (((BINARY_LENGTH + CHUNK_SIZE - 1) / CHUNK_SIZE) * CHUNK_SIZE)
#define NUM_CHUNKS (PADDED_LENGTH / CHUNK_SIZE)

void generate_binary_array(const short indices[], size_t num_indices, uint32_t output[]) {
    // Initialize binary array with 0
    uint8_t binary_array[PADDED_LENGTH] = {0};

    // Set specified indices to 1
    for (size_t i = 0; i < num_indices; ++i) {
        if (indices[i] >= 0 && indices[i] < BINARY_LENGTH) {
            binary_array[indices[i]] = 1;
        }
    }

    // Process each chunk
    for (size_t chunk = 0; chunk < NUM_CHUNKS; ++chunk) {
        uint32_t value = 0;
        for (size_t bit = 0; bit < CHUNK_SIZE; ++bit) {
	    // reversed: 
            // size_t index = chunk * CHUNK_SIZE + (CHUNK_SIZE - 1 - bit); // reverse order
	    size_t index = chunk * CHUNK_SIZE + bit;
            value |= ((uint32_t)binary_array[index] << bit);
        }
        output[chunk] = value;
    }
}

static long asubTest_init(aSubRecord *pasub) {

	printf("\n\n\n\n\n\n\n Calling init \n\n\n\n\n\n\n\n");
	return(0);
}

static long asubTest_do(aSubRecord *pasub) {
	short *vala = (short *)pasub->vala;
	short *a = (short *)pasub->a;
	int *b = (int *)pasub->b;	/* clock select */
	int *c = (int *)pasub->c;	/* do write */
	int *d = (int *)pasub->d;	/* debug */

	uint32_t result[NUM_CHUNKS] = {0};

	// *vala = 2 * (*a);
	
	// for (int i=0; i<pasub->noa; i++)
	// printf("%d'th element: %d\n", i, a[i]);


    	generate_binary_array(a, pasub->noa, result);

	// print so that MSB is on left
	// for (size_t i = 0; i < NUM_CHUNKS; ++i) {
	//     for (int bit = 31; bit >= 0; --bit) {
	//         printf("%u", (result[i] >> bit) & 1);
	//     }
	//     printf("\n");
	// }
	// printf("0'th bit: %u", result[0] & 1);

	
	// printf("\n\n\n\n\n\n\n Calling do \n\n\n\n\n\n\n\n");
	return(0);
}


#include <registryFunction.h>
static registryFunctionRef asubTestRef[] = {
	{"asubTest_init", (REGISTRYFUNCTION)asubTest_init},
	{"asubTest_do", (REGISTRYFUNCTION)asubTest_do}
};

static void asubTestRegister(void) {
	registryFunctionRefAdd(asubTestRef, NELEMENTS(asubTestRef));
}
epicsExportRegistrar(asubTestRegister);
