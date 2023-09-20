# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "endState" -parent ${Page_0}
  ipgui::add_param $IPINST -name "init" -parent ${Page_0}
  ipgui::add_param $IPINST -name "initState" -parent ${Page_0}
  ipgui::add_param $IPINST -name "latch" -parent ${Page_0}
  ipgui::add_param $IPINST -name "latchState1" -parent ${Page_0}
  ipgui::add_param $IPINST -name "latchState2" -parent ${Page_0}
  ipgui::add_param $IPINST -name "latchState3" -parent ${Page_0}
  ipgui::add_param $IPINST -name "rest" -parent ${Page_0}
  ipgui::add_param $IPINST -name "rest1" -parent ${Page_0}
  ipgui::add_param $IPINST -name "shiftin" -parent ${Page_0}
  ipgui::add_param $IPINST -name "shiftout" -parent ${Page_0}
  ipgui::add_param $IPINST -name "startState" -parent ${Page_0}


}

proc update_PARAM_VALUE.endState { PARAM_VALUE.endState } {
	# Procedure called to update endState when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.endState { PARAM_VALUE.endState } {
	# Procedure called to validate endState
	return true
}

proc update_PARAM_VALUE.init { PARAM_VALUE.init } {
	# Procedure called to update init when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.init { PARAM_VALUE.init } {
	# Procedure called to validate init
	return true
}

proc update_PARAM_VALUE.initState { PARAM_VALUE.initState } {
	# Procedure called to update initState when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.initState { PARAM_VALUE.initState } {
	# Procedure called to validate initState
	return true
}

proc update_PARAM_VALUE.latch { PARAM_VALUE.latch } {
	# Procedure called to update latch when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.latch { PARAM_VALUE.latch } {
	# Procedure called to validate latch
	return true
}

proc update_PARAM_VALUE.latchState1 { PARAM_VALUE.latchState1 } {
	# Procedure called to update latchState1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.latchState1 { PARAM_VALUE.latchState1 } {
	# Procedure called to validate latchState1
	return true
}

proc update_PARAM_VALUE.latchState2 { PARAM_VALUE.latchState2 } {
	# Procedure called to update latchState2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.latchState2 { PARAM_VALUE.latchState2 } {
	# Procedure called to validate latchState2
	return true
}

proc update_PARAM_VALUE.latchState3 { PARAM_VALUE.latchState3 } {
	# Procedure called to update latchState3 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.latchState3 { PARAM_VALUE.latchState3 } {
	# Procedure called to validate latchState3
	return true
}

proc update_PARAM_VALUE.rest { PARAM_VALUE.rest } {
	# Procedure called to update rest when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.rest { PARAM_VALUE.rest } {
	# Procedure called to validate rest
	return true
}

proc update_PARAM_VALUE.rest1 { PARAM_VALUE.rest1 } {
	# Procedure called to update rest1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.rest1 { PARAM_VALUE.rest1 } {
	# Procedure called to validate rest1
	return true
}

proc update_PARAM_VALUE.shiftin { PARAM_VALUE.shiftin } {
	# Procedure called to update shiftin when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.shiftin { PARAM_VALUE.shiftin } {
	# Procedure called to validate shiftin
	return true
}

proc update_PARAM_VALUE.shiftout { PARAM_VALUE.shiftout } {
	# Procedure called to update shiftout when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.shiftout { PARAM_VALUE.shiftout } {
	# Procedure called to validate shiftout
	return true
}

proc update_PARAM_VALUE.startState { PARAM_VALUE.startState } {
	# Procedure called to update startState when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.startState { PARAM_VALUE.startState } {
	# Procedure called to validate startState
	return true
}


proc update_MODELPARAM_VALUE.init { MODELPARAM_VALUE.init PARAM_VALUE.init } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.init}] ${MODELPARAM_VALUE.init}
}

proc update_MODELPARAM_VALUE.shiftout { MODELPARAM_VALUE.shiftout PARAM_VALUE.shiftout } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.shiftout}] ${MODELPARAM_VALUE.shiftout}
}

proc update_MODELPARAM_VALUE.shiftin { MODELPARAM_VALUE.shiftin PARAM_VALUE.shiftin } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.shiftin}] ${MODELPARAM_VALUE.shiftin}
}

proc update_MODELPARAM_VALUE.latch { MODELPARAM_VALUE.latch PARAM_VALUE.latch } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.latch}] ${MODELPARAM_VALUE.latch}
}

proc update_MODELPARAM_VALUE.rest { MODELPARAM_VALUE.rest PARAM_VALUE.rest } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.rest}] ${MODELPARAM_VALUE.rest}
}

proc update_MODELPARAM_VALUE.initState { MODELPARAM_VALUE.initState PARAM_VALUE.initState } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.initState}] ${MODELPARAM_VALUE.initState}
}

proc update_MODELPARAM_VALUE.rest1 { MODELPARAM_VALUE.rest1 PARAM_VALUE.rest1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.rest1}] ${MODELPARAM_VALUE.rest1}
}

proc update_MODELPARAM_VALUE.startState { MODELPARAM_VALUE.startState PARAM_VALUE.startState } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.startState}] ${MODELPARAM_VALUE.startState}
}

proc update_MODELPARAM_VALUE.latchState1 { MODELPARAM_VALUE.latchState1 PARAM_VALUE.latchState1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.latchState1}] ${MODELPARAM_VALUE.latchState1}
}

proc update_MODELPARAM_VALUE.latchState2 { MODELPARAM_VALUE.latchState2 PARAM_VALUE.latchState2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.latchState2}] ${MODELPARAM_VALUE.latchState2}
}

proc update_MODELPARAM_VALUE.latchState3 { MODELPARAM_VALUE.latchState3 PARAM_VALUE.latchState3 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.latchState3}] ${MODELPARAM_VALUE.latchState3}
}

proc update_MODELPARAM_VALUE.endState { MODELPARAM_VALUE.endState PARAM_VALUE.endState } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.endState}] ${MODELPARAM_VALUE.endState}
}

