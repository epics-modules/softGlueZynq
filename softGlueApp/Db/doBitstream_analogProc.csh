#!/bin/csh
# Note this script presumes the Vivado project settings include "-bin_file*"
# ("Write a binary file without header (.bin)")
flipBin.py /home/oxygen/MOONEY/zynq/VivadoProjects/analogProc/analogProc.runs/impl_1/design_1_wrapper.bin analogProc_FPGAContent_7010.bin
