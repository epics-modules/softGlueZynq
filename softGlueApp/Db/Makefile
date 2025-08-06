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
DB += softGlue_FPGAContent_BCDALAB.db
DB += softGlue_FPGAContent_qudis.db
DB += softGlue_FPGAContent_NPI.db
DB += softGlue_FPGAContent_ACQ.db
#DB += softGlue_FPGAContent_zygo.db
DB += softGlue_FPGAContent_ACQ2206.db
DB += softGlue_FPGARegisters.db
DB += softGlue_FPGARegisters_BCDALAB.db
DB += softGlue_FPGARegisters_qudis.db
DB += softGlue_FPGARegisters_ACQ2206.db
DB += softGlue_FPGARegisters64_ACQ2206.db
DB += softGlue_FPGARegisters64_NPI.db
DB += softGlue_FPGARegisters64_ACQ.db
#DB += softGlue_FPGARegisters_zygo.db
DB += softGlue_FPGAInt.db

DB += analogProc_FPGAContent.db
DB += analogProc_FPGARegisters.db

DB += MCSAsub.db DMA.db pixelTrigger.db readSoftGlueCounter_ISR.db
DB += pixelTriggerDma.db
DB += pixelTriggerDmaListFFT.db
DB += acquireDma.db
DB += acquireDmaListFFT.db
DB += histScalerDma.db
DB += clockConfig.db clockConfigExt.db
DB += SGscaler.db
DB += softGlue_config.db
DB += resetDMA.db
DB_INSTALLS += ../softGlue_SignalShow.db  ../softGlue_convenience.db

REQ += $(patsubst ../%, %, $(wildcard ../*.req))

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
