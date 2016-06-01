TOP=../..
include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================
DBD += softGlueZynqSupport.dbd

INC += drvZynq.h

LIBRARY_IOC = softGlueZynq
LIB_SRCS += drvZynq.c devAsynSoftGlue.c
#LIB_SRCS += sampleCustomInterruptHandler.c

LIB_LIBS += asyn

LIB_LIBS += $(EPICS_BASE_IOC_LIBS)

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

