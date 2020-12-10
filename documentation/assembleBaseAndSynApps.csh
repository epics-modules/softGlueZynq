#!/bin/csh

mkdir epics
cd epics
wget https://www.aps.anl.gov/epics/download/base/base-3.15.5.tar.gz
tar zxf base-3.15.5.tar.gz
rm base-3.15.5.tar.gz

mkdir synApps_5_8a
cd synApps_5_8a

# support
setenv TAG synApps_5_8
wget https://github.com/epics-synApps/support/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
mv support-${TAG} support
rm ${TAG}.tar.gz

cd support

touch RELEASE_files.txt

# modules ##################################################################

# alive
setenv TAG R1-0-1
wget https://github.com/epics-modules/alive/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'ALIVE=$(SUPPORT)/alive-'${TAG} >>RELEASE_files.txt

# get areaDetector, ADCore, and ADSimDetector from https://github.com/areaDetector
setenv TAG R2-6
wget https://github.com/areaDetector/areaDetector/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'AREADETECTOR=$(SUPPORT)/areaDetector-'${TAG} >>RELEASE_files.txt

cd areaDetector-${TAG}

setenv TAG R2-6
wget https://github.com/areaDetector/ADCore/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'ADCORE=$(AREADETECTOR)/ADCore-'${TAG} >>../RELEASE_files.txt

setenv TAG R1-1
wget https://github.com/areaDetector/ADSupport/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'ADSUPPORT=$(AREADETECTOR)/ADSupport-'${TAG} >>../RELEASE_files.txt

setenv TAG R2-4
wget https://github.com/areaDetector/ADSimDetector/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'ADSIMDETECTOR=$(AREADETECTOR)/ADSimDetector-'${TAG} >>../RELEASE_files.txt

cd ..

# autosave
setenv TAG R5-7-1
wget https://github.com/epics-modules/autosave/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'AUTOSAVE=$(SUPPORT)/autosave-'${TAG} >>RELEASE_files.txt

# busy
setenv TAG R1-6-1
wget https://github.com/epics-modules/busy/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'BUSY=$(SUPPORT)/busy-'${TAG} >>RELEASE_files.txt

# calc
setenv TAG R3-6-1
wget https://github.com/epics-modules/calc/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'CALC=$(SUPPORT)/calc-'${TAG} >>RELEASE_files.txt

# camac
#setenv TAG R2-7
#wget https://github.com/epics-modules/camac/archive/${TAG}.tar.gz
#tar zxf ${TAG}.tar.gz
#rm ${TAG}.tar.gz
#echo 'CAMAC=$(SUPPORT)/camac-'${TAG} >>RELEASE_files.txt

# caputRecorder
setenv TAG R1-5-1
wget https://github.com/epics-modules/caputRecorder/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'CAPUTRECORDER=$(SUPPORT)/caputRecorder-'${TAG} >>RELEASE_files.txt

# dac128V
#setenv TAG R2-8
#wget https://github.com/epics-modules/dac128V/archive/${TAG}.tar.gz
#tar zxf ${TAG}.tar.gz
#rm ${TAG}.tar.gz
#echo 'DAC128V=$(SUPPORT)/dac128V-'${TAG} >>RELEASE_files.txt

# delaygen
setenv TAG R1-1-1
wget https://github.com/epics-modules/delaygen/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'DELAYGEN=$(SUPPORT)/delaygen-'${TAG} >>RELEASE_files.txt

# dxp
#setenv TAG R3-5
#wget https://github.com/epics-modules/dxp/archive/${TAG}.tar.gz
#tar zxf ${TAG}.tar.gz
#rm ${TAG}.tar.gz
#echo 'DXP=$(SUPPORT)/dxp-'${TAG} >>RELEASE_files.txt

# ip
setenv TAG R2-17
wget https://github.com/epics-modules/ip/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'IP=$(SUPPORT)/ip-'${TAG} >>RELEASE_files.txt

# ip330
#setenv TAG R2-8
#wget https://github.com/epics-modules/ip330/archive/${TAG}.tar.gz
#tar zxf ${TAG}.tar.gz
#rm ${TAG}.tar.gz
#echo 'IP330=$(SUPPORT)/ip330-'${TAG} >>RELEASE_files.txt

# ipUnidig
#setenv TAG R2-10
#wget https://github.com/epics-modules/ipUnidig/archive/${TAG}.tar.gz
#tar zxf ${TAG}.tar.gz
#rm ${TAG}.tar.gz
#echo 'IPUNIDIG=$(SUPPORT)/ipUnidig-'${TAG} >>RELEASE_files.txt

# love
#setenv TAG R3-2-5
#wget https://github.com/epics-modules/love/archive/${TAG}.tar.gz
#tar zxf ${TAG}.tar.gz
#rm ${TAG}.tar.gz
#echo 'LOVE=$(SUPPORT)/love-'${TAG} >>RELEASE_files.txt

# mca
setenv TAG R7-6
wget https://github.com/epics-modules/mca/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'MCA=$(SUPPORT)/mca-'${TAG} >>RELEASE_files.txt

# measComp
#setenv TAG R1-3
#wget https://github.com/epics-modules/measComp/archive/${TAG}.tar.gz
#tar zxf ${TAG}.tar.gz
#rm ${TAG}.tar.gz
#echo 'MEASCOMP=$(SUPPORT)/measComp-'${TAG} >>RELEASE_files.txt

# modbus
setenv TAG R2-9
wget https://github.com/epics-modules/modbus/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'MODBUS=$(SUPPORT)/modbus-'${TAG} >>RELEASE_files.txt

# motor
setenv TAG R6-9
wget https://github.com/epics-modules/motor/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'MOTOR=$(SUPPORT)/motor-'${TAG} >>RELEASE_files.txt

# optics
setenv TAG R2-9-3
wget https://github.com/epics-modules/optics/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'OPTICS=$(SUPPORT)/optics-'${TAG} >>RELEASE_files.txt

# quadEM
#setenv TAG R6-0
#wget https://github.com/epics-modules/quadEM/archive/${TAG}.tar.gz
#tar zxf ${TAG}.tar.gz
#rm ${TAG}.tar.gz
#echo 'QUADEM=$(SUPPORT)/quadEM-'${TAG} >>RELEASE_files.txt

# softGlue*
#setenv TAG R2-8
#wget https://github.com/epics-modules/softGlue/archive/${TAG}.tar.gz
#tar zxf ${TAG}.tar.gz
#rm ${TAG}.tar.gz
#echo 'SOFTGLUE=$(SUPPORT)/softGlue-'${TAG} >>RELEASE_files.txt

# softGlueZynq
setenv TAG R2-0
wget https://github.com/epics-modules/softGlueZynq/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'SOFTGLUEZYNQ=$(SUPPORT)/softGlueZynq-'${TAG} >>RELEASE_files.txt

# Until softGlueZynq is tagged...
#wget https://github.com/epics-modules/softGlueZynq/archive/master.zip
#unzip master.zip
#rm master.zip
#mv softGlueZynq-master softGlueZynq
#echo 'SOFTGLUEZYNQ=$(SUPPORT)/softGlueZynq' >>RELEASE_files.txt

# sscan
setenv TAG R2-10-1
wget https://github.com/epics-modules/sscan/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'SSCAN=$(SUPPORT)/sscan-'${TAG} >>RELEASE_files.txt

# scaler
setenv TAG 4.0
wget https://github.com/epics-modules/scaler/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'SCALER=$(SUPPORT)/scaler-'${TAG} >>RELEASE_files.txt

# stream
setenv TAG R2-6a
wget https://github.com/epics-modules/stream/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
cd stream-${TAG}
wget http://epics.web.psi.ch/software/streamdevice/StreamDevice-2-6.tgz
wget http://epics.web.psi.ch/software/streamdevice/StreamDevice-2-6-patch20121003
wget http://epics.web.psi.ch/software/streamdevice/StreamDevice-2-6-patch20121009
wget http://epics.web.psi.ch/software/streamdevice/StreamDevice-2-6-patch20121113
tar xf StreamDevice-2-6.tgz
cd StreamDevice-2-6
patch -p0 < ../StreamDevice-2-6-patch20121003
patch -p0 < ../StreamDevice-2-6-patch20121009
patch -p0 < ../StreamDevice-2-6-patch20121113
cd ../..
rm StreamDevice-2-6.tgz
echo 'STREAM=$(SUPPORT)/stream-'${TAG} >>RELEASE_files.txt

# vac
setenv TAG R1-5-1
wget https://github.com/epics-modules/vac/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'VAC=$(SUPPORT)/vac-'${TAG} >>RELEASE_files.txt

# vme
#setenv TAG R2-8-2
#wget https://github.com/epics-modules/vme/archive/${TAG}.tar.gz
#tar zxf ${TAG}.tar.gz
#rm ${TAG}.tar.gz
#echo 'VME=$(SUPPORT)/vme-'${TAG} >>RELEASE_files.txt

# xxx
#setenv TAG R5-8-3
#wget https://github.com/epics-modules/xxx/archive/${TAG}.tar.gz
#tar zxf ${TAG}.tar.gz
#rm ${TAG}.tar.gz
#echo 'XXX=$(SUPPORT)/xxx-'${TAG} >>RELEASE_files.txt

# iocZed
setenv TAG R2-0
wget https://github.com/epics-modules/ioczed/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'IOCZED=$(SUPPORT)/ioczed-'${TAG} >>RELEASE_files.txt

# Until ioczed is tagged...
#wget https://github.com/epics-modules/ioczed/archive/master.zip
#unzip master.zip
#rm master.zip
#mv ioczed-master ioczed
#echo 'IOCZED=$(SUPPORT)/ioczed' >>RELEASE_files.txt

### other directories

# configure
setenv TAG synApps_5_8
wget https://github.com/epics-synApps/configure/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
mv configure-${TAG} configure
rm ${TAG}.tar.gz

# utils
setenv TAG synApps_5_8
wget https://github.com/epics-synApps/utils/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
mv utils-${TAG} utils
rm ${TAG}.tar.gz

# documentation
setenv TAG synApps_5_8
wget https://github.com/epics-synApps/documentation/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
mv documentation-${TAG} documentation
rm ${TAG}.tar.gz

# get areaDetector, ADCore, ADBinaries from https://github.com/areaDetector
#setenv TAG R2-4
#wget https://github.com/areaDetector/areaDetector/archive/${TAG}.tar.gz
#tar zxf ${TAG}.tar.gz
#rm ${TAG}.tar.gz
#echo 'AREADETECTOR=$(SUPPORT)/areaDetector-'${TAG} >>RELEASE_files.txt
#
#cd areaDetector-${TAG}
#
#setenv TAG R2-4
#wget https://github.com/areaDetector/ADCore/archive/${TAG}.tar.gz
#tar zxf ${TAG}.tar.gz
#rm ${TAG}.tar.gz
#echo 'ADCORE=$(AREADETECTOR)/ADCore-'${TAG} >>../RELEASE_files.txt
#
#setenv TAG R2-2
#wget https://github.com/areaDetector/ADBinaries/archive/${TAG}.tar.gz
#tar zxf ${TAG}.tar.gz
#rm ${TAG}.tar.gz
#echo 'ADBINARIES=$(AREADETECTOR)/ADBinaries-'${TAG} >>../RELEASE_files.txt
#
#cd ..

# get allenBradley-2-3
#wget http://www.aps.anl.gov/epics/download/modules/allenBradley-2.3.tar.gz
#tar xf allenBradley-2.3.tar.gz
#mv allenBradley-2.3 allenBradley-2-3
#rm allenBradley-2.3.tar.gz
#echo 'ALLENBRADLEY=$(SUPPORT)/allenBradley-2-3' >>RELEASE_files.txt

# asyn
setenv TAG R4-30
wget https://github.com/epics-modules/asyn/archive/${TAG}.tar.gz
tar zxf ${TAG}.tar.gz
rm ${TAG}.tar.gz
echo 'ASYN=$(SUPPORT)/asyn-'${TAG} >>RELEASE_files.txt

# ipac
setenv TAG V2-14
svn export https://svn.aps.anl.gov/epics/ipac/tags/${TAG} ipac-${TAG}
echo 'IPAC=$(SUPPORT)/ipac-'${TAG} >>RELEASE_files.txt

# seq
wget http://www-csr.bessy.de/control/SoftDist/sequencer/releases/seq-2.2.3.tar.gz
tar zxf seq-2.2.3.tar.gz
# The synApps build can't handle '.'
mv seq-2.2.3 seq-2-2-3
rm seq-2.2.3.tar.gz
echo 'SNCSEQ=$(SUPPORT)/seq-2-2-3' >>RELEASE_files.txt

# iocStats
wget https://github.com/epics-modules/iocStats/archive/3.1.14.tar.gz
tar zxf 3.1.14.tar.gz
mv iocStats-3.1.14 iocStats-R3-1-14
rm 3.1.14.tar.gz
echo 'IOCSTATS=$(SUPPORT)/iocStats-R3-1-14' >>RELEASE_files.txt

# etherIP
#wget https://github.com/EPICSTools/ether_ip/archive/ether_ip-2-26.tar.gz
#tar zxf ether_ip-2-26.tar.gz
#mv ether_ip-ether_ip-2-26 ether_ip-2-26
#rm ether_ip-2-26.tar.gz
#echo 'ETHERIP=$(SUPPORT)/ether_ip-2-26' >>RELEASE_files.txt

# edit epics/base-3.15.5/configure/CONFIG_SITE to set CROSS_COMPILER_TARGET_ARCHS=linux-arm
# edit epics/base-3.15.5/configure/os/CONFIG_SITE.linux-x86.linux-arm to set GNU_DIR to point to your Xilinx SDK
# do 'make -j' in epics/base-3.15.5

# edit epics/synApps_5_8a/support/configure/RELEASE to set SUPPORT and EPICS_BASE
# edit epics/synApps_5_8a/support/configure/RELEASE to agree with epics/synApps_5_8a/support/RELEASE_files.txt
# edit epics/synApps_5_8a/support/mca-R7-6/mcaApp/RontecSrc/Makefile to comment out 'PROD_IOC'
# edit epics/synApps_5_8a/support/delaygen-R1-1-1/delaygenApp/src/Makefile to comment out 'PROD_IOC'
# edit epics/synApps_5_8a/support/motor-R6-9/motorApp/NewportSrc/Makefile to comment out 'PROD_IOC' twice
# edit epics/synApps_5_8a/support/iocStats-R3-1-14/RELEASE_SITE to edit or comment out everything
# do 'make release' in epics/synApps_5_8a/support
# do 'make -j' in epics/synApps_5_8a/support
