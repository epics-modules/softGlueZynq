# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "aux0_reg" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux0_wait" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux10_reg" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux10_wait" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux11_reg" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux11_wait" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux12_reg" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux12_wait" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux13_reg" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux13_wait" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux14_reg" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux14_wait" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux15_reg" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux15_wait" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux1_reg" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux1_wait" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux2_reg" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux2_wait" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux3_reg" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux3_wait" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux4_reg" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux4_wait" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux5_reg" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux5_wait" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux6_reg" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux6_wait" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux7_reg" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux7_wait" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux8_reg" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux8_wait" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux9_reg" -parent ${Page_0}
  ipgui::add_param $IPINST -name "aux9_wait" -parent ${Page_0}
  ipgui::add_param $IPINST -name "configReg0" -parent ${Page_0}
  ipgui::add_param $IPINST -name "init_read" -parent ${Page_0}
  ipgui::add_param $IPINST -name "read_aux0" -parent ${Page_0}
  ipgui::add_param $IPINST -name "read_aux1" -parent ${Page_0}
  ipgui::add_param $IPINST -name "read_aux10" -parent ${Page_0}
  ipgui::add_param $IPINST -name "read_aux11" -parent ${Page_0}
  ipgui::add_param $IPINST -name "read_aux12" -parent ${Page_0}
  ipgui::add_param $IPINST -name "read_aux13" -parent ${Page_0}
  ipgui::add_param $IPINST -name "read_aux14" -parent ${Page_0}
  ipgui::add_param $IPINST -name "read_aux15" -parent ${Page_0}
  ipgui::add_param $IPINST -name "read_aux2" -parent ${Page_0}
  ipgui::add_param $IPINST -name "read_aux3" -parent ${Page_0}
  ipgui::add_param $IPINST -name "read_aux4" -parent ${Page_0}
  ipgui::add_param $IPINST -name "read_aux5" -parent ${Page_0}
  ipgui::add_param $IPINST -name "read_aux6" -parent ${Page_0}
  ipgui::add_param $IPINST -name "read_aux7" -parent ${Page_0}
  ipgui::add_param $IPINST -name "read_aux8" -parent ${Page_0}
  ipgui::add_param $IPINST -name "read_aux9" -parent ${Page_0}
  ipgui::add_param $IPINST -name "read_wait" -parent ${Page_0}
  ipgui::add_param $IPINST -name "write_wait" -parent ${Page_0}


}

proc update_PARAM_VALUE.aux0_reg { PARAM_VALUE.aux0_reg } {
	# Procedure called to update aux0_reg when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux0_reg { PARAM_VALUE.aux0_reg } {
	# Procedure called to validate aux0_reg
	return true
}

proc update_PARAM_VALUE.aux0_wait { PARAM_VALUE.aux0_wait } {
	# Procedure called to update aux0_wait when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux0_wait { PARAM_VALUE.aux0_wait } {
	# Procedure called to validate aux0_wait
	return true
}

proc update_PARAM_VALUE.aux10_reg { PARAM_VALUE.aux10_reg } {
	# Procedure called to update aux10_reg when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux10_reg { PARAM_VALUE.aux10_reg } {
	# Procedure called to validate aux10_reg
	return true
}

proc update_PARAM_VALUE.aux10_wait { PARAM_VALUE.aux10_wait } {
	# Procedure called to update aux10_wait when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux10_wait { PARAM_VALUE.aux10_wait } {
	# Procedure called to validate aux10_wait
	return true
}

proc update_PARAM_VALUE.aux11_reg { PARAM_VALUE.aux11_reg } {
	# Procedure called to update aux11_reg when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux11_reg { PARAM_VALUE.aux11_reg } {
	# Procedure called to validate aux11_reg
	return true
}

proc update_PARAM_VALUE.aux11_wait { PARAM_VALUE.aux11_wait } {
	# Procedure called to update aux11_wait when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux11_wait { PARAM_VALUE.aux11_wait } {
	# Procedure called to validate aux11_wait
	return true
}

proc update_PARAM_VALUE.aux12_reg { PARAM_VALUE.aux12_reg } {
	# Procedure called to update aux12_reg when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux12_reg { PARAM_VALUE.aux12_reg } {
	# Procedure called to validate aux12_reg
	return true
}

proc update_PARAM_VALUE.aux12_wait { PARAM_VALUE.aux12_wait } {
	# Procedure called to update aux12_wait when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux12_wait { PARAM_VALUE.aux12_wait } {
	# Procedure called to validate aux12_wait
	return true
}

proc update_PARAM_VALUE.aux13_reg { PARAM_VALUE.aux13_reg } {
	# Procedure called to update aux13_reg when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux13_reg { PARAM_VALUE.aux13_reg } {
	# Procedure called to validate aux13_reg
	return true
}

proc update_PARAM_VALUE.aux13_wait { PARAM_VALUE.aux13_wait } {
	# Procedure called to update aux13_wait when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux13_wait { PARAM_VALUE.aux13_wait } {
	# Procedure called to validate aux13_wait
	return true
}

proc update_PARAM_VALUE.aux14_reg { PARAM_VALUE.aux14_reg } {
	# Procedure called to update aux14_reg when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux14_reg { PARAM_VALUE.aux14_reg } {
	# Procedure called to validate aux14_reg
	return true
}

proc update_PARAM_VALUE.aux14_wait { PARAM_VALUE.aux14_wait } {
	# Procedure called to update aux14_wait when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux14_wait { PARAM_VALUE.aux14_wait } {
	# Procedure called to validate aux14_wait
	return true
}

proc update_PARAM_VALUE.aux15_reg { PARAM_VALUE.aux15_reg } {
	# Procedure called to update aux15_reg when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux15_reg { PARAM_VALUE.aux15_reg } {
	# Procedure called to validate aux15_reg
	return true
}

proc update_PARAM_VALUE.aux15_wait { PARAM_VALUE.aux15_wait } {
	# Procedure called to update aux15_wait when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux15_wait { PARAM_VALUE.aux15_wait } {
	# Procedure called to validate aux15_wait
	return true
}

proc update_PARAM_VALUE.aux1_reg { PARAM_VALUE.aux1_reg } {
	# Procedure called to update aux1_reg when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux1_reg { PARAM_VALUE.aux1_reg } {
	# Procedure called to validate aux1_reg
	return true
}

proc update_PARAM_VALUE.aux1_wait { PARAM_VALUE.aux1_wait } {
	# Procedure called to update aux1_wait when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux1_wait { PARAM_VALUE.aux1_wait } {
	# Procedure called to validate aux1_wait
	return true
}

proc update_PARAM_VALUE.aux2_reg { PARAM_VALUE.aux2_reg } {
	# Procedure called to update aux2_reg when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux2_reg { PARAM_VALUE.aux2_reg } {
	# Procedure called to validate aux2_reg
	return true
}

proc update_PARAM_VALUE.aux2_wait { PARAM_VALUE.aux2_wait } {
	# Procedure called to update aux2_wait when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux2_wait { PARAM_VALUE.aux2_wait } {
	# Procedure called to validate aux2_wait
	return true
}

proc update_PARAM_VALUE.aux3_reg { PARAM_VALUE.aux3_reg } {
	# Procedure called to update aux3_reg when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux3_reg { PARAM_VALUE.aux3_reg } {
	# Procedure called to validate aux3_reg
	return true
}

proc update_PARAM_VALUE.aux3_wait { PARAM_VALUE.aux3_wait } {
	# Procedure called to update aux3_wait when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux3_wait { PARAM_VALUE.aux3_wait } {
	# Procedure called to validate aux3_wait
	return true
}

proc update_PARAM_VALUE.aux4_reg { PARAM_VALUE.aux4_reg } {
	# Procedure called to update aux4_reg when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux4_reg { PARAM_VALUE.aux4_reg } {
	# Procedure called to validate aux4_reg
	return true
}

proc update_PARAM_VALUE.aux4_wait { PARAM_VALUE.aux4_wait } {
	# Procedure called to update aux4_wait when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux4_wait { PARAM_VALUE.aux4_wait } {
	# Procedure called to validate aux4_wait
	return true
}

proc update_PARAM_VALUE.aux5_reg { PARAM_VALUE.aux5_reg } {
	# Procedure called to update aux5_reg when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux5_reg { PARAM_VALUE.aux5_reg } {
	# Procedure called to validate aux5_reg
	return true
}

proc update_PARAM_VALUE.aux5_wait { PARAM_VALUE.aux5_wait } {
	# Procedure called to update aux5_wait when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux5_wait { PARAM_VALUE.aux5_wait } {
	# Procedure called to validate aux5_wait
	return true
}

proc update_PARAM_VALUE.aux6_reg { PARAM_VALUE.aux6_reg } {
	# Procedure called to update aux6_reg when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux6_reg { PARAM_VALUE.aux6_reg } {
	# Procedure called to validate aux6_reg
	return true
}

proc update_PARAM_VALUE.aux6_wait { PARAM_VALUE.aux6_wait } {
	# Procedure called to update aux6_wait when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux6_wait { PARAM_VALUE.aux6_wait } {
	# Procedure called to validate aux6_wait
	return true
}

proc update_PARAM_VALUE.aux7_reg { PARAM_VALUE.aux7_reg } {
	# Procedure called to update aux7_reg when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux7_reg { PARAM_VALUE.aux7_reg } {
	# Procedure called to validate aux7_reg
	return true
}

proc update_PARAM_VALUE.aux7_wait { PARAM_VALUE.aux7_wait } {
	# Procedure called to update aux7_wait when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux7_wait { PARAM_VALUE.aux7_wait } {
	# Procedure called to validate aux7_wait
	return true
}

proc update_PARAM_VALUE.aux8_reg { PARAM_VALUE.aux8_reg } {
	# Procedure called to update aux8_reg when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux8_reg { PARAM_VALUE.aux8_reg } {
	# Procedure called to validate aux8_reg
	return true
}

proc update_PARAM_VALUE.aux8_wait { PARAM_VALUE.aux8_wait } {
	# Procedure called to update aux8_wait when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux8_wait { PARAM_VALUE.aux8_wait } {
	# Procedure called to validate aux8_wait
	return true
}

proc update_PARAM_VALUE.aux9_reg { PARAM_VALUE.aux9_reg } {
	# Procedure called to update aux9_reg when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux9_reg { PARAM_VALUE.aux9_reg } {
	# Procedure called to validate aux9_reg
	return true
}

proc update_PARAM_VALUE.aux9_wait { PARAM_VALUE.aux9_wait } {
	# Procedure called to update aux9_wait when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.aux9_wait { PARAM_VALUE.aux9_wait } {
	# Procedure called to validate aux9_wait
	return true
}

proc update_PARAM_VALUE.configReg0 { PARAM_VALUE.configReg0 } {
	# Procedure called to update configReg0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.configReg0 { PARAM_VALUE.configReg0 } {
	# Procedure called to validate configReg0
	return true
}

proc update_PARAM_VALUE.init_read { PARAM_VALUE.init_read } {
	# Procedure called to update init_read when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.init_read { PARAM_VALUE.init_read } {
	# Procedure called to validate init_read
	return true
}

proc update_PARAM_VALUE.read_aux0 { PARAM_VALUE.read_aux0 } {
	# Procedure called to update read_aux0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.read_aux0 { PARAM_VALUE.read_aux0 } {
	# Procedure called to validate read_aux0
	return true
}

proc update_PARAM_VALUE.read_aux1 { PARAM_VALUE.read_aux1 } {
	# Procedure called to update read_aux1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.read_aux1 { PARAM_VALUE.read_aux1 } {
	# Procedure called to validate read_aux1
	return true
}

proc update_PARAM_VALUE.read_aux10 { PARAM_VALUE.read_aux10 } {
	# Procedure called to update read_aux10 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.read_aux10 { PARAM_VALUE.read_aux10 } {
	# Procedure called to validate read_aux10
	return true
}

proc update_PARAM_VALUE.read_aux11 { PARAM_VALUE.read_aux11 } {
	# Procedure called to update read_aux11 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.read_aux11 { PARAM_VALUE.read_aux11 } {
	# Procedure called to validate read_aux11
	return true
}

proc update_PARAM_VALUE.read_aux12 { PARAM_VALUE.read_aux12 } {
	# Procedure called to update read_aux12 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.read_aux12 { PARAM_VALUE.read_aux12 } {
	# Procedure called to validate read_aux12
	return true
}

proc update_PARAM_VALUE.read_aux13 { PARAM_VALUE.read_aux13 } {
	# Procedure called to update read_aux13 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.read_aux13 { PARAM_VALUE.read_aux13 } {
	# Procedure called to validate read_aux13
	return true
}

proc update_PARAM_VALUE.read_aux14 { PARAM_VALUE.read_aux14 } {
	# Procedure called to update read_aux14 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.read_aux14 { PARAM_VALUE.read_aux14 } {
	# Procedure called to validate read_aux14
	return true
}

proc update_PARAM_VALUE.read_aux15 { PARAM_VALUE.read_aux15 } {
	# Procedure called to update read_aux15 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.read_aux15 { PARAM_VALUE.read_aux15 } {
	# Procedure called to validate read_aux15
	return true
}

proc update_PARAM_VALUE.read_aux2 { PARAM_VALUE.read_aux2 } {
	# Procedure called to update read_aux2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.read_aux2 { PARAM_VALUE.read_aux2 } {
	# Procedure called to validate read_aux2
	return true
}

proc update_PARAM_VALUE.read_aux3 { PARAM_VALUE.read_aux3 } {
	# Procedure called to update read_aux3 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.read_aux3 { PARAM_VALUE.read_aux3 } {
	# Procedure called to validate read_aux3
	return true
}

proc update_PARAM_VALUE.read_aux4 { PARAM_VALUE.read_aux4 } {
	# Procedure called to update read_aux4 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.read_aux4 { PARAM_VALUE.read_aux4 } {
	# Procedure called to validate read_aux4
	return true
}

proc update_PARAM_VALUE.read_aux5 { PARAM_VALUE.read_aux5 } {
	# Procedure called to update read_aux5 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.read_aux5 { PARAM_VALUE.read_aux5 } {
	# Procedure called to validate read_aux5
	return true
}

proc update_PARAM_VALUE.read_aux6 { PARAM_VALUE.read_aux6 } {
	# Procedure called to update read_aux6 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.read_aux6 { PARAM_VALUE.read_aux6 } {
	# Procedure called to validate read_aux6
	return true
}

proc update_PARAM_VALUE.read_aux7 { PARAM_VALUE.read_aux7 } {
	# Procedure called to update read_aux7 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.read_aux7 { PARAM_VALUE.read_aux7 } {
	# Procedure called to validate read_aux7
	return true
}

proc update_PARAM_VALUE.read_aux8 { PARAM_VALUE.read_aux8 } {
	# Procedure called to update read_aux8 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.read_aux8 { PARAM_VALUE.read_aux8 } {
	# Procedure called to validate read_aux8
	return true
}

proc update_PARAM_VALUE.read_aux9 { PARAM_VALUE.read_aux9 } {
	# Procedure called to update read_aux9 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.read_aux9 { PARAM_VALUE.read_aux9 } {
	# Procedure called to validate read_aux9
	return true
}

proc update_PARAM_VALUE.read_wait { PARAM_VALUE.read_wait } {
	# Procedure called to update read_wait when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.read_wait { PARAM_VALUE.read_wait } {
	# Procedure called to validate read_wait
	return true
}

proc update_PARAM_VALUE.write_wait { PARAM_VALUE.write_wait } {
	# Procedure called to update write_wait when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.write_wait { PARAM_VALUE.write_wait } {
	# Procedure called to validate write_wait
	return true
}


proc update_MODELPARAM_VALUE.init_read { MODELPARAM_VALUE.init_read PARAM_VALUE.init_read } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.init_read}] ${MODELPARAM_VALUE.init_read}
}

proc update_MODELPARAM_VALUE.read_wait { MODELPARAM_VALUE.read_wait PARAM_VALUE.read_wait } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.read_wait}] ${MODELPARAM_VALUE.read_wait}
}

proc update_MODELPARAM_VALUE.write_wait { MODELPARAM_VALUE.write_wait PARAM_VALUE.write_wait } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.write_wait}] ${MODELPARAM_VALUE.write_wait}
}

proc update_MODELPARAM_VALUE.read_aux0 { MODELPARAM_VALUE.read_aux0 PARAM_VALUE.read_aux0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.read_aux0}] ${MODELPARAM_VALUE.read_aux0}
}

proc update_MODELPARAM_VALUE.aux0_wait { MODELPARAM_VALUE.aux0_wait PARAM_VALUE.aux0_wait } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux0_wait}] ${MODELPARAM_VALUE.aux0_wait}
}

proc update_MODELPARAM_VALUE.read_aux1 { MODELPARAM_VALUE.read_aux1 PARAM_VALUE.read_aux1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.read_aux1}] ${MODELPARAM_VALUE.read_aux1}
}

proc update_MODELPARAM_VALUE.aux1_wait { MODELPARAM_VALUE.aux1_wait PARAM_VALUE.aux1_wait } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux1_wait}] ${MODELPARAM_VALUE.aux1_wait}
}

proc update_MODELPARAM_VALUE.read_aux2 { MODELPARAM_VALUE.read_aux2 PARAM_VALUE.read_aux2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.read_aux2}] ${MODELPARAM_VALUE.read_aux2}
}

proc update_MODELPARAM_VALUE.aux2_wait { MODELPARAM_VALUE.aux2_wait PARAM_VALUE.aux2_wait } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux2_wait}] ${MODELPARAM_VALUE.aux2_wait}
}

proc update_MODELPARAM_VALUE.read_aux3 { MODELPARAM_VALUE.read_aux3 PARAM_VALUE.read_aux3 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.read_aux3}] ${MODELPARAM_VALUE.read_aux3}
}

proc update_MODELPARAM_VALUE.aux3_wait { MODELPARAM_VALUE.aux3_wait PARAM_VALUE.aux3_wait } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux3_wait}] ${MODELPARAM_VALUE.aux3_wait}
}

proc update_MODELPARAM_VALUE.read_aux4 { MODELPARAM_VALUE.read_aux4 PARAM_VALUE.read_aux4 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.read_aux4}] ${MODELPARAM_VALUE.read_aux4}
}

proc update_MODELPARAM_VALUE.aux4_wait { MODELPARAM_VALUE.aux4_wait PARAM_VALUE.aux4_wait } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux4_wait}] ${MODELPARAM_VALUE.aux4_wait}
}

proc update_MODELPARAM_VALUE.read_aux5 { MODELPARAM_VALUE.read_aux5 PARAM_VALUE.read_aux5 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.read_aux5}] ${MODELPARAM_VALUE.read_aux5}
}

proc update_MODELPARAM_VALUE.aux5_wait { MODELPARAM_VALUE.aux5_wait PARAM_VALUE.aux5_wait } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux5_wait}] ${MODELPARAM_VALUE.aux5_wait}
}

proc update_MODELPARAM_VALUE.read_aux6 { MODELPARAM_VALUE.read_aux6 PARAM_VALUE.read_aux6 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.read_aux6}] ${MODELPARAM_VALUE.read_aux6}
}

proc update_MODELPARAM_VALUE.aux6_wait { MODELPARAM_VALUE.aux6_wait PARAM_VALUE.aux6_wait } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux6_wait}] ${MODELPARAM_VALUE.aux6_wait}
}

proc update_MODELPARAM_VALUE.read_aux7 { MODELPARAM_VALUE.read_aux7 PARAM_VALUE.read_aux7 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.read_aux7}] ${MODELPARAM_VALUE.read_aux7}
}

proc update_MODELPARAM_VALUE.aux7_wait { MODELPARAM_VALUE.aux7_wait PARAM_VALUE.aux7_wait } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux7_wait}] ${MODELPARAM_VALUE.aux7_wait}
}

proc update_MODELPARAM_VALUE.read_aux8 { MODELPARAM_VALUE.read_aux8 PARAM_VALUE.read_aux8 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.read_aux8}] ${MODELPARAM_VALUE.read_aux8}
}

proc update_MODELPARAM_VALUE.aux8_wait { MODELPARAM_VALUE.aux8_wait PARAM_VALUE.aux8_wait } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux8_wait}] ${MODELPARAM_VALUE.aux8_wait}
}

proc update_MODELPARAM_VALUE.read_aux9 { MODELPARAM_VALUE.read_aux9 PARAM_VALUE.read_aux9 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.read_aux9}] ${MODELPARAM_VALUE.read_aux9}
}

proc update_MODELPARAM_VALUE.aux9_wait { MODELPARAM_VALUE.aux9_wait PARAM_VALUE.aux9_wait } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux9_wait}] ${MODELPARAM_VALUE.aux9_wait}
}

proc update_MODELPARAM_VALUE.read_aux10 { MODELPARAM_VALUE.read_aux10 PARAM_VALUE.read_aux10 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.read_aux10}] ${MODELPARAM_VALUE.read_aux10}
}

proc update_MODELPARAM_VALUE.aux10_wait { MODELPARAM_VALUE.aux10_wait PARAM_VALUE.aux10_wait } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux10_wait}] ${MODELPARAM_VALUE.aux10_wait}
}

proc update_MODELPARAM_VALUE.read_aux11 { MODELPARAM_VALUE.read_aux11 PARAM_VALUE.read_aux11 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.read_aux11}] ${MODELPARAM_VALUE.read_aux11}
}

proc update_MODELPARAM_VALUE.aux11_wait { MODELPARAM_VALUE.aux11_wait PARAM_VALUE.aux11_wait } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux11_wait}] ${MODELPARAM_VALUE.aux11_wait}
}

proc update_MODELPARAM_VALUE.read_aux12 { MODELPARAM_VALUE.read_aux12 PARAM_VALUE.read_aux12 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.read_aux12}] ${MODELPARAM_VALUE.read_aux12}
}

proc update_MODELPARAM_VALUE.aux12_wait { MODELPARAM_VALUE.aux12_wait PARAM_VALUE.aux12_wait } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux12_wait}] ${MODELPARAM_VALUE.aux12_wait}
}

proc update_MODELPARAM_VALUE.read_aux13 { MODELPARAM_VALUE.read_aux13 PARAM_VALUE.read_aux13 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.read_aux13}] ${MODELPARAM_VALUE.read_aux13}
}

proc update_MODELPARAM_VALUE.aux13_wait { MODELPARAM_VALUE.aux13_wait PARAM_VALUE.aux13_wait } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux13_wait}] ${MODELPARAM_VALUE.aux13_wait}
}

proc update_MODELPARAM_VALUE.read_aux14 { MODELPARAM_VALUE.read_aux14 PARAM_VALUE.read_aux14 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.read_aux14}] ${MODELPARAM_VALUE.read_aux14}
}

proc update_MODELPARAM_VALUE.aux14_wait { MODELPARAM_VALUE.aux14_wait PARAM_VALUE.aux14_wait } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux14_wait}] ${MODELPARAM_VALUE.aux14_wait}
}

proc update_MODELPARAM_VALUE.read_aux15 { MODELPARAM_VALUE.read_aux15 PARAM_VALUE.read_aux15 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.read_aux15}] ${MODELPARAM_VALUE.read_aux15}
}

proc update_MODELPARAM_VALUE.aux15_wait { MODELPARAM_VALUE.aux15_wait PARAM_VALUE.aux15_wait } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux15_wait}] ${MODELPARAM_VALUE.aux15_wait}
}

proc update_MODELPARAM_VALUE.aux0_reg { MODELPARAM_VALUE.aux0_reg PARAM_VALUE.aux0_reg } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux0_reg}] ${MODELPARAM_VALUE.aux0_reg}
}

proc update_MODELPARAM_VALUE.aux1_reg { MODELPARAM_VALUE.aux1_reg PARAM_VALUE.aux1_reg } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux1_reg}] ${MODELPARAM_VALUE.aux1_reg}
}

proc update_MODELPARAM_VALUE.aux2_reg { MODELPARAM_VALUE.aux2_reg PARAM_VALUE.aux2_reg } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux2_reg}] ${MODELPARAM_VALUE.aux2_reg}
}

proc update_MODELPARAM_VALUE.aux3_reg { MODELPARAM_VALUE.aux3_reg PARAM_VALUE.aux3_reg } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux3_reg}] ${MODELPARAM_VALUE.aux3_reg}
}

proc update_MODELPARAM_VALUE.aux4_reg { MODELPARAM_VALUE.aux4_reg PARAM_VALUE.aux4_reg } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux4_reg}] ${MODELPARAM_VALUE.aux4_reg}
}

proc update_MODELPARAM_VALUE.aux5_reg { MODELPARAM_VALUE.aux5_reg PARAM_VALUE.aux5_reg } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux5_reg}] ${MODELPARAM_VALUE.aux5_reg}
}

proc update_MODELPARAM_VALUE.aux6_reg { MODELPARAM_VALUE.aux6_reg PARAM_VALUE.aux6_reg } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux6_reg}] ${MODELPARAM_VALUE.aux6_reg}
}

proc update_MODELPARAM_VALUE.aux7_reg { MODELPARAM_VALUE.aux7_reg PARAM_VALUE.aux7_reg } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux7_reg}] ${MODELPARAM_VALUE.aux7_reg}
}

proc update_MODELPARAM_VALUE.aux8_reg { MODELPARAM_VALUE.aux8_reg PARAM_VALUE.aux8_reg } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux8_reg}] ${MODELPARAM_VALUE.aux8_reg}
}

proc update_MODELPARAM_VALUE.aux9_reg { MODELPARAM_VALUE.aux9_reg PARAM_VALUE.aux9_reg } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux9_reg}] ${MODELPARAM_VALUE.aux9_reg}
}

proc update_MODELPARAM_VALUE.aux10_reg { MODELPARAM_VALUE.aux10_reg PARAM_VALUE.aux10_reg } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux10_reg}] ${MODELPARAM_VALUE.aux10_reg}
}

proc update_MODELPARAM_VALUE.aux11_reg { MODELPARAM_VALUE.aux11_reg PARAM_VALUE.aux11_reg } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux11_reg}] ${MODELPARAM_VALUE.aux11_reg}
}

proc update_MODELPARAM_VALUE.aux12_reg { MODELPARAM_VALUE.aux12_reg PARAM_VALUE.aux12_reg } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux12_reg}] ${MODELPARAM_VALUE.aux12_reg}
}

proc update_MODELPARAM_VALUE.aux13_reg { MODELPARAM_VALUE.aux13_reg PARAM_VALUE.aux13_reg } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux13_reg}] ${MODELPARAM_VALUE.aux13_reg}
}

proc update_MODELPARAM_VALUE.aux14_reg { MODELPARAM_VALUE.aux14_reg PARAM_VALUE.aux14_reg } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux14_reg}] ${MODELPARAM_VALUE.aux14_reg}
}

proc update_MODELPARAM_VALUE.aux15_reg { MODELPARAM_VALUE.aux15_reg PARAM_VALUE.aux15_reg } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.aux15_reg}] ${MODELPARAM_VALUE.aux15_reg}
}

proc update_MODELPARAM_VALUE.configReg0 { MODELPARAM_VALUE.configReg0 PARAM_VALUE.configReg0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.configReg0}] ${MODELPARAM_VALUE.configReg0}
}

