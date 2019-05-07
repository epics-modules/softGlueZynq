TOP=../..
include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE

#----------------------------------------------------
#  Optimization of db files using dbst (DEFAULT: NO)
#DB_OPT = YES

#----------------------------------------------------
# Create and install (or just install)
# databases, templates, substitutions like this

#----------------------------------------------------
# If <anyname>.db template is not named <anyname>*.template add
# <anyname>_template = <templatename>

DB += softGlue_FPGAContent.db
DB += softGlue_FPGARegisters.db
DB += softGlue_FPGAInt.db

DB += analogProc_FPGAContent.db
DB += analogProc_FPGARegisters.db

DB += MCSAsub.db DMA.db pixelTrigger.db readSoftGlueCounter_ISR.db
DB += pixelTriggerDma.db
DB += pixelTriggerDmaListFFT.db
DB += histScalerDma.db
DB += clockConfig.db
DB += SGscaler.db
DB += softGlue_config.db

DB_INSTALLS += ../softGlue_SignalShow.db  ../softGlue_convenience.db

REQ += $(patsubst ../%, %, $(wildcard ../*.req))

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
