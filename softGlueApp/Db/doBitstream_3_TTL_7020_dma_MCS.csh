#!/bin/csh
# Note this script presumes the Vivado project settings include "-bin_file*"
# ("Write a binary file without header (.bin)")
flipBin.py /home/beams/MOONEY/zynq/VivadoProjects/softGlue_3_TTL_7020_dma_MCS/softGlue_3_TTL_7020_dma_MCS.runs/impl_1/design_1_wrapper.bin softGlue_FPGAContent_7020_dma_MCS.bin
