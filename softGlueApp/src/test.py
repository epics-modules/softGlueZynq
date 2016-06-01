import epics
import time
P="xxx:"
H="softGlue:"

def int():
	for i in range(1,49):
		intEdgePV = P+H+"In_%dIntEdge"%(i)
		epics.caput(intEdgePV, 1)
		time.sleep(2)
		epics.caput(intEdgePV, 3)
		time.sleep(2)
		epics.caput(intEdgePV, 0)
		time.sleep(2)


def connect():
	for i in range(1,49):
		intDoPV = P+H+"In_%dDo.OUT"%(i)
		epics.caput(intDoPV, P+"userCalcOut3.A PP")

def zero():
	for i in range(1,49):
		signalPV = P+H+"FO%d_Signal"%(i)
		epics.caput(signalPV,"0")

def write_a():
	for i in range(1,49):
		signalPV = P+H+"FO%d_Signal"%(i)
		epics.caput(signalPV,"a")

def test():
	for i in range(1,49):
		isOutput = True #assume
		signalPV = P+H+"FO%d_Signal"%(i)
		procPV = P+H+"FO%d_BI"%(i)+".PROC"
		resultPV = P+H+"FO%d_BI"%(i)
		#print "testing " + signalPV
		epics.caput(signalPV,"0")
		epics.caput(procPV,"0")
		time.sleep(0.1)
		result = epics.caget(resultPV)
		if result != 0:
			isOutput = False
		if isOutput:
			epics.caput(signalPV,"1")
			epics.caput(procPV,"0")
			time.sleep(0.1)
			result = epics.caget(resultPV)
			if result != 1:
				isOutput = False
		type = "IN"
		if isOutput:
			type = "OUT"
		print "signal", i, "is an %s" % (type)



