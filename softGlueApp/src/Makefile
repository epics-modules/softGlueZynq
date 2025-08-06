TOP=../..
include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================
DBD += softGlueZynqSupport.dbd

INC += drvZynq.h

LIBRARY_IOC_Linux = softGlueZynq
LIB_SRCS += drvZynq.c devAsynSoftGlue.c devA32Zed.c
LIB_SRCS += sampleCustomInterruptHandler.c
LIB_SRCS += pixelTriggerAsub.c
LIB_SRCS += scalerAsub.c
LIB_SRCS += pixelTriggerDmaAsub.c
LIB_SRCS += acquireDmaAsub.c
# While testing, neglect this code which hasn't been reworked to use the new
# DMAproxy for PetaLinux 2023.
# DMA LIB_SRCS += histScalerDmaAsub.c
LIB_SRCS += MCSAsub.c
LIB_SRCS += clockConfigAsub.c clockConfigAsubExt.c
LIB_SRCS += readSoftGlueCounter_ISR.c
ifdef SCALER
	LIB_SRCS += devSGscaler16.c
endif

LIB_LIBS += asyn
LIB_LIBS += seq pv

LIB_LIBS += $(EPICS_BASE_IOC_LIBS)

# socket server test code
PROD += socket_test1
socket_test1_SRCS += socket_test1.c

PROD += socket_test2
socket_test2_SRCS += socket_test2.c

PROD += socket_test3
socket_test3_SRCS += socket_test3.c

PROD += socket_test4
socket_test4_SRCS += socket_test4.c

PROD += socket_test5
socket_test5_SRCS += socket_test5.c

PROD += socket_test6
socket_test6_SRCS += socket_test6.c

PROD += socket_test7
socket_test7_SRCS += socket_test7.c

PROD += acquireSocketClient
acquireSocketClient_SRCS += acquireSocketClient.c

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

