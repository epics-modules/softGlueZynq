#!/bin/env python

# examples of recorded macros, and recorded macros that have been edited
# to use arguments.
# /APSshare/anaconda/x86_64/bin/python

import time
import epics
import numpy as np

def snake(A=32767, F=0.5, dx=20, npts=1000):

	# Y axis	

	# Take one half cycle of a sine wave, from -pi/2 to pi/2 and cut it at
	# the zero crossing. If the sine has amplitude 1, then the slope at the
	# zero crossing is 1. Move both parts of the sine away from the origin
	# along the line x = y. If we want the line to be the fraction, F, of
	# the total y extent, A, and the Y extent of the line is L, then
	# L = F*(L+1), which yields L = F/(1-F).
	L = F/(1.-F)

	# We want A to be a user-specified amplitude of the entire function, so
	# a scale factor, Sy, is given by Sy*(L+1) = A.
	Sy = A/(L+1.)

	# Then, the function is the line S*L, joined to 1/4 of a sine function
	# with amplitude S,  from 0 to pi/2 . Along the x axis, the line extends
	# over distance L, and the quarter-sine function from 0 to pi/2 extends
	# over pi/2. The total length, in equally spaced points along x, is
	# Sx * (L + pi/2) = npts/4
	Sx = (npts/4.) / (L + np.pi/2)
	
	# Each quarter-sine function occupies Sx*pi/2 places in the array we're
	# assembling.
	arr1 = np.linspace(-np.pi/2, 0, int(Sx*np.pi/2))
	sinArr1 = Sy*np.sin(arr1)

	# The full line function:
	arr2 = np.linspace(-L, L, int(Sx*2*L))
	
	# The second quarter-sine function:
	arr3 = np.linspace(0, np.pi/2, int(Sx*np.pi/2))
	sinArr3 = Sy*np.sin(arr3)

	# The total points in this half of the function:
	Nt = 2*int(Sx*np.pi/2) + int(Sx*2*L) - 2
	
	# Now we assemble, skipping the first and last points of the line,
	# because their values are already in the quarter-sine functions:
	half = np.concatenate([sinArr1-Sy*L, Sy*arr2[1:-1], sinArr3+Sy*L])
	allY = np.concatenate([half, np.flip(half,0)])


	# X axis
	
	arr1 = np.linspace(0, np.pi/2, int(Sx*np.pi/2))
	sinArr1 = (dx/2.)*(np.sin(arr1) - 1)
	arr2 = np.linspace(0, 0, int(Sx*2*L))
	arr3 = np.linspace(-np.pi/2, 0, int(Sx*np.pi/2))
	sinArr3 = (dx/2.)*(np.sin(arr3) + 1)
	half = np.concatenate([sinArr1, arr2[1:-1], sinArr3])
	allX = np.concatenate([half, dx+half])
	allX = allX + allX[0]

	# write

	addrPV_Y = "acq_bnp:SG:mem_ADDRA"
	dataPV_Y = "acq_bnp:SG:mem_DINA"
	clkPV_Y = "acq_bnp:SG:mem_CLK_Signal"
	wrtPV_Y = "acq_bnp:SG:mem_WRT_Signal"
	enPV_Y = "acq_bnp:SG:driveRAM_en_Signal"
	nPV_Y = "acq_bnp:SG:driveRAM_N"

	addrPV_X = "acq_bnp:SG:mem2_ADDRA"
	dataPV_X = "acq_bnp:SG:mem2_DINA"
	clkPV_X = "acq_bnp:SG:mem2_CLK_Signal"
	wrtPV_X = "acq_bnp:SG:mem2_WRT_Signal"
	enPV_X = "acq_bnp:SG:driveRAMx_en_Signal"
	nPV_X = "acq_bnp:SG:driveRAMx_N"

	n = epics.caput(wrtPV_Y, "1")
	n = epics.caput(enPV_Y, "0")
	n = epics.caput(wrtPV_X, "1")
	n = epics.caput(enPV_X, "0")
	time.sleep(.001)
	for i in range(0,len(allY)):
		n = epics.caput(addrPV_Y, i, wait=True, timeout=1000000.0)
		n = epics.caput(dataPV_Y, allY[i], wait=True, timeout=1000000.0)
		n = epics.caput(addrPV_X, i, wait=True, timeout=1000000.0)
		n = epics.caput(dataPV_X, allX[i], wait=True, timeout=1000000.0)
		time.sleep(.001)
		n = epics.caput(clkPV_Y,"1!", wait=True, timeout=1000000.0)
		n = epics.caput(clkPV_X,"1!", wait=True, timeout=1000000.0)
		time.sleep(.001)

	n = epics.caput(wrtPV_Y, "0")
	n = epics.caput(enPV_Y, "1")
	n = epics.caput(nPV_Y, len(allY), wait=True, timeout=1000000.0)

	n = epics.caput(wrtPV_X, "0")
	n = epics.caput(enPV_X, "1")
	n = epics.caput(nPV_X, len(allX), wait=True, timeout=1000000.0)

def lissajous(A=32767, npts=1000):

	arr1 = np.linspace(-np.pi/2, 3*np.pi/2, npts)
	sinArr1 = A*np.sin(arr1)

	addrPV_Y = "acq_bnp:SG:mem_ADDRA"
	dataPV_Y = "acq_bnp:SG:mem_DINA"
	clkPV_Y = "acq_bnp:SG:mem_CLK_Signal"
	wrtPV_Y = "acq_bnp:SG:mem_WRT_Signal"
	enPV_Y = "acq_bnp:SG:driveRAM_en_Signal"
	nPV_Y = "acq_bnp:SG:driveRAM_N"

	addrPV_X = "acq_bnp:SG:mem2_ADDRA"
	dataPV_X = "acq_bnp:SG:mem2_DINA"
	clkPV_X = "acq_bnp:SG:mem2_CLK_Signal"
	wrtPV_X = "acq_bnp:SG:mem2_WRT_Signal"
	enPV_X = "acq_bnp:SG:driveRAMx_en_Signal"
	nPV_X = "acq_bnp:SG:driveRAMx_N"

	n = epics.caput(wrtPV_Y, "1")
	n = epics.caput(enPV_Y, "0")
	n = epics.caput(wrtPV_X, "1")
	n = epics.caput(enPV_X, "0")
	time.sleep(.001)
	for i in range(0,len(sinArr1)):
		n = epics.caput(addrPV_Y, i, wait=True, timeout=1000000.0)
		n = epics.caput(dataPV_Y, sinArr1[i], wait=True, timeout=1000000.0)
		n = epics.caput(addrPV_X, i, wait=True, timeout=1000000.0)
		n = epics.caput(dataPV_X, sinArr1[i], wait=True, timeout=1000000.0)
		time.sleep(.001)
		n = epics.caput(clkPV_Y,"1!", wait=True, timeout=1000000.0)
		n = epics.caput(clkPV_X,"1!", wait=True, timeout=1000000.0)
		time.sleep(.001)

	n = epics.caput(wrtPV_Y, "0")
	n = epics.caput(enPV_Y, "1")
	n = epics.caput(nPV_Y, len(sinArr1), wait=True, timeout=1000000.0)

	n = epics.caput(wrtPV_X, "0")
	n = epics.caput(enPV_X, "1")
	n = epics.caput(nPV_X, len(sinArr1), wait=True, timeout=1000000.0)
