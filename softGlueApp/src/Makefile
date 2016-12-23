TOP=../..
include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================
DBD += softGlueZynqSupport.dbd

INC += drvZynq.h

LIBRARY_IOC = softGlueZynq
LIB_SRCS += drvZynq.c devAsynSoftGlue.c devA32Zed.c
LIB_SRCS += sampleCustomInterruptHandler.c
LIB_SRCS += pixelTriggerAsub.c
LIB_SRCS += MCSAsub.c
LIB_SRCS += readSoftGlueCounter_ISR.c

LIB_LIBS += asyn
LIB_LIBS += seq pv

LIB_LIBS += $(EPICS_BASE_IOC_LIBS)

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

