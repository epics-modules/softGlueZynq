
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg400-1
#    set_property BOARD_PART em.avnet.com:microzed_7020:part0:1.1 [current_project]

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports
  set FI_01 [ create_bd_port -dir I FI_01 ]
  set FI_02 [ create_bd_port -dir I FI_02 ]
  set FI_03 [ create_bd_port -dir I FI_03 ]
  set FI_04 [ create_bd_port -dir I FI_04 ]
  set FI_05 [ create_bd_port -dir I FI_05 ]
  set FI_06 [ create_bd_port -dir I FI_06 ]
  set FI_07 [ create_bd_port -dir I FI_07 ]
  set FI_08 [ create_bd_port -dir I FI_08 ]
  set FI_09 [ create_bd_port -dir I FI_09 ]
  set FI_10 [ create_bd_port -dir I FI_10 ]
  set FI_11 [ create_bd_port -dir I FI_11 ]
  set FI_12 [ create_bd_port -dir I FI_12 ]
  set FI_13 [ create_bd_port -dir I FI_13 ]
  set FI_14 [ create_bd_port -dir I FI_14 ]
  set FI_15 [ create_bd_port -dir I FI_15 ]
  set FI_16 [ create_bd_port -dir I FI_16 ]
  set FI_17 [ create_bd_port -dir I FI_17 ]
  set FI_18 [ create_bd_port -dir I FI_18 ]
  set FI_19 [ create_bd_port -dir I FI_19 ]
  set FI_20 [ create_bd_port -dir I FI_20 ]
  set FI_21 [ create_bd_port -dir I FI_21 ]
  set FI_22 [ create_bd_port -dir I FI_22 ]
  set FI_23 [ create_bd_port -dir I FI_23 ]
  set FI_24 [ create_bd_port -dir I FI_24 ]
  set FI_diff_N25 [ create_bd_port -dir I -from 0 -to 0 FI_diff_N25 ]
  set FI_diff_N26 [ create_bd_port -dir I -from 0 -to 0 FI_diff_N26 ]
  set FI_diff_N27 [ create_bd_port -dir I -from 0 -to 0 FI_diff_N27 ]
  set FI_diff_N28 [ create_bd_port -dir I -from 0 -to 0 FI_diff_N28 ]
  set FI_diff_N29 [ create_bd_port -dir I -from 0 -to 0 FI_diff_N29 ]
  set FI_diff_N30 [ create_bd_port -dir I -from 0 -to 0 FI_diff_N30 ]
  set FI_diff_N31 [ create_bd_port -dir I -from 0 -to 0 FI_diff_N31 ]
  set FI_diff_N32 [ create_bd_port -dir I -from 0 -to 0 FI_diff_N32 ]
  set FI_diff_N33 [ create_bd_port -dir I -from 0 -to 0 FI_diff_N33 ]
  set FI_diff_N34 [ create_bd_port -dir I -from 0 -to 0 FI_diff_N34 ]
  set FI_diff_N35 [ create_bd_port -dir I -from 0 -to 0 FI_diff_N35 ]
  set FI_diff_N36 [ create_bd_port -dir I -from 0 -to 0 FI_diff_N36 ]
  set FI_diff_P25 [ create_bd_port -dir I -from 0 -to 0 FI_diff_P25 ]
  set FI_diff_P26 [ create_bd_port -dir I -from 0 -to 0 FI_diff_P26 ]
  set FI_diff_P27 [ create_bd_port -dir I -from 0 -to 0 FI_diff_P27 ]
  set FI_diff_P28 [ create_bd_port -dir I -from 0 -to 0 FI_diff_P28 ]
  set FI_diff_P29 [ create_bd_port -dir I -from 0 -to 0 FI_diff_P29 ]
  set FI_diff_P30 [ create_bd_port -dir I -from 0 -to 0 FI_diff_P30 ]
  set FI_diff_P31 [ create_bd_port -dir I -from 0 -to 0 FI_diff_P31 ]
  set FI_diff_P32 [ create_bd_port -dir I -from 0 -to 0 FI_diff_P32 ]
  set FI_diff_P33 [ create_bd_port -dir I -from 0 -to 0 FI_diff_P33 ]
  set FI_diff_P34 [ create_bd_port -dir I -from 0 -to 0 FI_diff_P34 ]
  set FI_diff_P35 [ create_bd_port -dir I -from 0 -to 0 FI_diff_P35 ]
  set FI_diff_P36 [ create_bd_port -dir I -from 0 -to 0 FI_diff_P36 ]
  set FO_01 [ create_bd_port -dir O FO_01 ]
  set FO_02 [ create_bd_port -dir O FO_02 ]
  set FO_03 [ create_bd_port -dir O FO_03 ]
  set FO_04 [ create_bd_port -dir O FO_04 ]
  set FO_05 [ create_bd_port -dir O FO_05 ]
  set FO_06 [ create_bd_port -dir O FO_06 ]
  set FO_07 [ create_bd_port -dir O FO_07 ]
  set FO_08 [ create_bd_port -dir O FO_08 ]
  set FO_09 [ create_bd_port -dir O FO_09 ]
  set FO_10 [ create_bd_port -dir O FO_10 ]
  set FO_11 [ create_bd_port -dir O FO_11 ]
  set FO_12 [ create_bd_port -dir O FO_12 ]
  set FO_13 [ create_bd_port -dir O FO_13 ]
  set FO_14 [ create_bd_port -dir O FO_14 ]
  set FO_15 [ create_bd_port -dir O FO_15 ]
  set FO_16 [ create_bd_port -dir O FO_16 ]
  set FO_17 [ create_bd_port -dir O FO_17 ]
  set FO_18 [ create_bd_port -dir O FO_18 ]
  set FO_19 [ create_bd_port -dir O FO_19 ]
  set FO_20 [ create_bd_port -dir O FO_20 ]
  set FO_21 [ create_bd_port -dir O FO_21 ]
  set FO_22 [ create_bd_port -dir O FO_22 ]
  set FO_23 [ create_bd_port -dir O FO_23 ]
  set FO_24 [ create_bd_port -dir O FO_24 ]

  # Create instance: AND_0, and set properties
  set AND_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 AND_0 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {and} \
CONFIG.C_SIZE {1} \
 ] $AND_0

  # Create instance: AND_1, and set properties
  set AND_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 AND_1 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $AND_1

  # Create instance: AND_2, and set properties
  set AND_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 AND_2 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $AND_2

  # Create instance: AND_3, and set properties
  set AND_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 AND_3 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $AND_3

  # Create instance: AND_4, and set properties
  set AND_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 AND_4 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $AND_4

  # Create instance: DFF_1, and set properties
  set DFF_1 [ create_bd_cell -type ip -vlnv user.org:user:flipflop:1.0 DFF_1 ]

  # Create instance: DFF_2, and set properties
  set DFF_2 [ create_bd_cell -type ip -vlnv user.org:user:flipflop:1.0 DFF_2 ]

  # Create instance: DFF_3, and set properties
  set DFF_3 [ create_bd_cell -type ip -vlnv user.org:user:flipflop:1.0 DFF_3 ]

  # Create instance: DFF_4, and set properties
  set DFF_4 [ create_bd_cell -type ip -vlnv user.org:user:flipflop:1.0 DFF_4 ]

  # Create instance: DFF_5, and set properties
  set DFF_5 [ create_bd_cell -type ip -vlnv user.org:user:flipflop:1.0 DFF_5 ]

  # Create instance: DFF_6, and set properties
  set DFF_6 [ create_bd_cell -type ip -vlnv user.org:user:flipflop:1.0 DFF_6 ]

  # Create instance: DnCntr_1, and set properties
  set DnCntr_1 [ create_bd_cell -type ip -vlnv user.org:user:downcounter:1.0 DnCntr_1 ]

  # Create instance: DnCntr_2, and set properties
  set DnCntr_2 [ create_bd_cell -type ip -vlnv user.org:user:downcounter:1.0 DnCntr_2 ]

  # Create instance: DnCntr_3, and set properties
  set DnCntr_3 [ create_bd_cell -type ip -vlnv user.org:user:downcounter:1.0 DnCntr_3 ]

  # Create instance: DnCntr_4, and set properties
  set DnCntr_4 [ create_bd_cell -type ip -vlnv user.org:user:downcounter:1.0 DnCntr_4 ]

  # Create instance: OR_1, and set properties
  set OR_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 OR_1 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {or} \
CONFIG.C_SIZE {1} \
 ] $OR_1

  # Create instance: OR_2, and set properties
  set OR_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 OR_2 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {or} \
CONFIG.C_SIZE {1} \
 ] $OR_2

  # Create instance: OR_3, and set properties
  set OR_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 OR_3 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {or} \
CONFIG.C_SIZE {1} \
 ] $OR_3

  # Create instance: OR_4, and set properties
  set OR_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 OR_4 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {or} \
CONFIG.C_SIZE {1} \
 ] $OR_4

  # Create instance: OR_5, and set properties
  set OR_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 OR_5 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {or} \
CONFIG.C_SIZE {1} \
 ] $OR_5

  # Create instance: OR_6, and set properties
  set OR_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 OR_6 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {or} \
CONFIG.C_SIZE {1} \
 ] $OR_6

  # Create instance: OR_7, and set properties
  set OR_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 OR_7 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {or} \
CONFIG.C_SIZE {1} \
 ] $OR_7

  # Create instance: UpCntr_1, and set properties
  set UpCntr_1 [ create_bd_cell -type ip -vlnv user.org:user:upcounter:1.0 UpCntr_1 ]

  # Create instance: UpCntr_2, and set properties
  set UpCntr_2 [ create_bd_cell -type ip -vlnv user.org:user:upcounter:1.0 UpCntr_2 ]

  # Create instance: UpCntr_3, and set properties
  set UpCntr_3 [ create_bd_cell -type ip -vlnv user.org:user:upcounter:1.0 UpCntr_3 ]

  # Create instance: UpCntr_4, and set properties
  set UpCntr_4 [ create_bd_cell -type ip -vlnv user.org:user:upcounter:1.0 UpCntr_4 ]

  # Create instance: XOR_1, and set properties
  set XOR_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 XOR_1 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {xor} \
CONFIG.C_SIZE {1} \
 ] $XOR_1

  # Create instance: XOR_2, and set properties
  set XOR_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 XOR_2 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {xor} \
CONFIG.C_SIZE {1} \
 ] $XOR_2

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [ list \
CONFIG.c_addr_width {32} \
CONFIG.c_include_mm2s_dre {0} \
CONFIG.c_include_s2mm_dre {0} \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {32} \
CONFIG.c_m_axis_mm2s_tdata_width {32} \
CONFIG.c_micro_dma {0} \
CONFIG.c_mm2s_burst_size {256} \
CONFIG.c_s2mm_burst_size {256} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_0

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {2} \
 ] $axi_interconnect_0

  # Create instance: clk_wiz0_0_0, and set properties
  set clk_wiz0_0_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.2 clk_wiz0_0_0 ]
  set_property -dict [ list \
CONFIG.CLKIN1_JITTER_PS {100.0} \
CONFIG.CLKOUT1_DRIVES {BUFG} \
CONFIG.CLKOUT1_JITTER {130.958} \
CONFIG.CLKOUT1_PHASE_ERROR {98.575} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100} \
CONFIG.CLKOUT1_USED {true} \
CONFIG.CLKOUT2_DRIVES {BUFG} \
CONFIG.CLKOUT2_JITTER {151.636} \
CONFIG.CLKOUT2_PHASE_ERROR {98.575} \
CONFIG.CLKOUT2_REQUESTED_DUTY_CYCLE {50} \
CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {50} \
CONFIG.CLKOUT2_REQUESTED_PHASE {0} \
CONFIG.CLKOUT2_USED {true} \
CONFIG.CLKOUT3_DRIVES {BUFG} \
CONFIG.CLKOUT3_JITTER {183.243} \
CONFIG.CLKOUT3_PHASE_ERROR {98.575} \
CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {20} \
CONFIG.CLKOUT3_REQUESTED_PHASE {0} \
CONFIG.CLKOUT3_USED {true} \
CONFIG.CLKOUT4_DRIVES {BUFG} \
CONFIG.CLKOUT4_JITTER {209.588} \
CONFIG.CLKOUT4_PHASE_ERROR {98.575} \
CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {10.000} \
CONFIG.CLKOUT4_REQUESTED_PHASE {0.000} \
CONFIG.CLKOUT4_USED {true} \
CONFIG.CLKOUT5_DRIVES {BUFG} \
CONFIG.CLKOUT5_JITTER {110.209} \
CONFIG.CLKOUT5_PHASE_ERROR {98.575} \
CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {250} \
CONFIG.CLKOUT5_USED {true} \
CONFIG.CLKOUT6_DRIVES {BUFG} \
CONFIG.CLKOUT6_JITTER {110.209} \
CONFIG.CLKOUT6_PHASE_ERROR {98.575} \
CONFIG.CLKOUT6_REQUESTED_OUT_FREQ {250} \
CONFIG.CLKOUT6_USED {true} \
CONFIG.CLKOUT7_DRIVES {BUFG} \
CONFIG.CLKOUT7_JITTER {212.630} \
CONFIG.CLKOUT7_PHASE_ERROR {208.802} \
CONFIG.CLKOUT7_USED {false} \
CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
CONFIG.MMCM_CLKFBOUT_MULT_F {10.000} \
CONFIG.MMCM_CLKIN1_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {10.000} \
CONFIG.MMCM_CLKOUT1_DIVIDE {20} \
CONFIG.MMCM_CLKOUT1_DUTY_CYCLE {0.500} \
CONFIG.MMCM_CLKOUT1_PHASE {0.000} \
CONFIG.MMCM_CLKOUT2_DIVIDE {50} \
CONFIG.MMCM_CLKOUT2_PHASE {0.000} \
CONFIG.MMCM_CLKOUT3_DIVIDE {100} \
CONFIG.MMCM_CLKOUT3_PHASE {0.000} \
CONFIG.MMCM_CLKOUT4_DIVIDE {4} \
CONFIG.MMCM_CLKOUT5_DIVIDE {4} \
CONFIG.MMCM_CLKOUT6_DIVIDE {1} \
CONFIG.MMCM_COMPENSATION {ZHOLD} \
CONFIG.MMCM_DIVCLK_DIVIDE {1} \
CONFIG.NUM_OUT_CLKS {6} \
CONFIG.PRIMITIVE {MMCM} \
CONFIG.PRIM_IN_FREQ {100} \
CONFIG.PRIM_SOURCE {Single_ended_clock_capable_pin} \
CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
CONFIG.USE_DYN_RECONFIG {true} \
CONFIG.USE_LOCKED {true} \
CONFIG.USE_PHASE_ALIGNMENT {false} \
CONFIG.USE_RESET {true} \
 ] $clk_wiz0_0_0

  # Create instance: clk_wiz1_0_0, and set properties
  set clk_wiz1_0_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.2 clk_wiz1_0_0 ]
  set_property -dict [ list \
CONFIG.CLKIN1_JITTER_PS {500.0} \
CONFIG.CLKOUT1_DRIVES {BUFG} \
CONFIG.CLKOUT1_JITTER {231.111} \
CONFIG.CLKOUT1_PHASE_ERROR {301.005} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {250} \
CONFIG.CLKOUT1_USED {true} \
CONFIG.CLKOUT2_DRIVES {BUFG} \
CONFIG.CLKOUT2_JITTER {151.636} \
CONFIG.CLKOUT2_PHASE_ERROR {98.575} \
CONFIG.CLKOUT2_REQUESTED_DUTY_CYCLE {50} \
CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {50} \
CONFIG.CLKOUT2_REQUESTED_PHASE {0.000} \
CONFIG.CLKOUT2_USED {false} \
CONFIG.CLKOUT3_DRIVES {BUFG} \
CONFIG.CLKOUT3_JITTER {183.243} \
CONFIG.CLKOUT3_PHASE_ERROR {98.575} \
CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {20} \
CONFIG.CLKOUT3_REQUESTED_PHASE {0.000} \
CONFIG.CLKOUT3_USED {false} \
CONFIG.CLKOUT4_DRIVES {BUFG} \
CONFIG.CLKOUT4_JITTER {209.588} \
CONFIG.CLKOUT4_PHASE_ERROR {98.575} \
CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {10.000} \
CONFIG.CLKOUT4_REQUESTED_PHASE {0.000} \
CONFIG.CLKOUT4_USED {false} \
CONFIG.CLKOUT5_DRIVES {BUFG} \
CONFIG.CLKOUT5_JITTER {110.209} \
CONFIG.CLKOUT5_PHASE_ERROR {98.575} \
CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {250} \
CONFIG.CLKOUT5_USED {false} \
CONFIG.CLKOUT6_DRIVES {BUFG} \
CONFIG.CLKOUT6_JITTER {110.209} \
CONFIG.CLKOUT6_PHASE_ERROR {98.575} \
CONFIG.CLKOUT6_REQUESTED_OUT_FREQ {250} \
CONFIG.CLKOUT6_USED {false} \
CONFIG.CLKOUT7_DRIVES {BUFG} \
CONFIG.CLKOUT7_JITTER {212.630} \
CONFIG.CLKOUT7_PHASE_ERROR {208.802} \
CONFIG.CLKOUT7_USED {false} \
CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
CONFIG.MMCM_CLKFBOUT_MULT_F {50.000} \
CONFIG.MMCM_CLKIN1_PERIOD {50.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {4.000} \
CONFIG.MMCM_CLKOUT1_DIVIDE {1} \
CONFIG.MMCM_CLKOUT1_DUTY_CYCLE {0.500} \
CONFIG.MMCM_CLKOUT1_PHASE {0.000} \
CONFIG.MMCM_CLKOUT2_DIVIDE {1} \
CONFIG.MMCM_CLKOUT2_PHASE {0.000} \
CONFIG.MMCM_CLKOUT3_DIVIDE {1} \
CONFIG.MMCM_CLKOUT3_PHASE {0.000} \
CONFIG.MMCM_CLKOUT4_DIVIDE {1} \
CONFIG.MMCM_CLKOUT5_DIVIDE {1} \
CONFIG.MMCM_CLKOUT6_DIVIDE {1} \
CONFIG.MMCM_COMPENSATION {ZHOLD} \
CONFIG.MMCM_DIVCLK_DIVIDE {1} \
CONFIG.NUM_OUT_CLKS {1} \
CONFIG.PRIMITIVE {MMCM} \
CONFIG.PRIM_IN_FREQ {20} \
CONFIG.PRIM_SOURCE {Single_ended_clock_capable_pin} \
CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
CONFIG.USE_DYN_RECONFIG {true} \
CONFIG.USE_LOCKED {true} \
CONFIG.USE_PHASE_ALIGNMENT {false} \
CONFIG.USE_RESET {true} \
 ] $clk_wiz1_0_0

  # Create instance: demux2_1, and set properties
  set demux2_1 [ create_bd_cell -type ip -vlnv user.org:user:demux2:1.0 demux2_1 ]

  # Create instance: demux2_2, and set properties
  set demux2_2 [ create_bd_cell -type ip -vlnv user.org:user:demux2:1.0 demux2_2 ]

  # Create instance: divByN_1, and set properties
  set divByN_1 [ create_bd_cell -type ip -vlnv user.org:user:divByN:1.0 divByN_1 ]

  # Create instance: divByN_2, and set properties
  set divByN_2 [ create_bd_cell -type ip -vlnv user.org:user:divByN:1.0 divByN_2 ]

  # Create instance: divByN_3, and set properties
  set divByN_3 [ create_bd_cell -type ip -vlnv user.org:user:divByN:1.0 divByN_3 ]

  # Create instance: divByN_4, and set properties
  set divByN_4 [ create_bd_cell -type ip -vlnv user.org:user:divByN:1.0 divByN_4 ]

  # Create instance: fhistoScalerStream_0, and set properties
  set fhistoScalerStream_0 [ create_bd_cell -type ip -vlnv user.org:user:fhistoScalerStream:1.0 fhistoScalerStream_0 ]

  # Create instance: fifo_generator_1, and set properties
  set fifo_generator_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.0 fifo_generator_1 ]
  set_property -dict [ list \
CONFIG.Empty_Threshold_Assert_Value_axis {65534} \
CONFIG.Empty_Threshold_Assert_Value_rach {14} \
CONFIG.Empty_Threshold_Assert_Value_wach {14} \
CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
CONFIG.Enable_Data_Counts_axis {true} \
CONFIG.Enable_TLAST {true} \
CONFIG.FIFO_Application_Type_axis {Packet_FIFO} \
CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
CONFIG.Full_Flags_Reset_Value {1} \
CONFIG.Full_Threshold_Assert_Value_axis {65535} \
CONFIG.Full_Threshold_Assert_Value_rach {15} \
CONFIG.Full_Threshold_Assert_Value_wach {15} \
CONFIG.Full_Threshold_Assert_Value_wrch {15} \
CONFIG.INTERFACE_TYPE {AXI_STREAM} \
CONFIG.Input_Depth_axis {65536} \
CONFIG.Programmable_Full_Type_axis {Single_Programmable_Full_Threshold_Input_Port} \
CONFIG.Reset_Type {Asynchronous_Reset} \
CONFIG.TDATA_NUM_BYTES {4} \
CONFIG.TKEEP_WIDTH {4} \
CONFIG.TSTRB_WIDTH {4} \
CONFIG.TUSER_WIDTH {0} \
 ] $fifo_generator_1

  # Create instance: freqCounter_0, and set properties
  set freqCounter_0 [ create_bd_cell -type ip -vlnv user.org:user:freqCounter:1.0 freqCounter_0 ]

  # Create instance: gateDelayFast_1, and set properties
  set gateDelayFast_1 [ create_bd_cell -type ip -vlnv user.org:user:gateDelayFast:1.0 gateDelayFast_1 ]
  set_property -dict [ list \
CONFIG.N {16} \
 ] $gateDelayFast_1

  # Create instance: gateDelayFast_2, and set properties
  set gateDelayFast_2 [ create_bd_cell -type ip -vlnv user.org:user:gateDelayFast:1.0 gateDelayFast_2 ]
  set_property -dict [ list \
CONFIG.N {16} \
 ] $gateDelayFast_2

  # Create instance: gateDelayFast_3, and set properties
  set gateDelayFast_3 [ create_bd_cell -type ip -vlnv user.org:user:gateDelayFast:1.0 gateDelayFast_3 ]
  set_property -dict [ list \
CONFIG.N {16} \
 ] $gateDelayFast_3

  # Create instance: gateDelayFast_4, and set properties
  set gateDelayFast_4 [ create_bd_cell -type ip -vlnv user.org:user:gateDelayFast:1.0 gateDelayFast_4 ]
  set_property -dict [ list \
CONFIG.N {16} \
 ] $gateDelayFast_4

  # Create instance: gateDly_1, and set properties
  set gateDly_1 [ create_bd_cell -type ip -vlnv user.org:user:gateDelay:1.0 gateDly_1 ]

  # Create instance: gateDly_2, and set properties
  set gateDly_2 [ create_bd_cell -type ip -vlnv user.org:user:gateDelay:1.0 gateDly_2 ]

  # Create instance: gateDly_3, and set properties
  set gateDly_3 [ create_bd_cell -type ip -vlnv user.org:user:gateDelay:1.0 gateDly_3 ]

  # Create instance: gateDly_4, and set properties
  set gateDly_4 [ create_bd_cell -type ip -vlnv user.org:user:gateDelay:1.0 gateDly_4 ]

  # Create instance: histoScalerStream_0, and set properties
  set histoScalerStream_0 [ create_bd_cell -type ip -vlnv user.org:user:histoScalerStream:1.0 histoScalerStream_0 ]

  # Create instance: mux2_0, and set properties
  set mux2_0 [ create_bd_cell -type ip -vlnv user.org:user:mux2:1.0 mux2_0 ]

  # Create instance: mux2_1, and set properties
  set mux2_1 [ create_bd_cell -type ip -vlnv user.org:user:mux2:1.0 mux2_1 ]

  # Create instance: mux2_2, and set properties
  set mux2_2 [ create_bd_cell -type ip -vlnv user.org:user:mux2:1.0 mux2_2 ]

  # Create instance: mux2_3, and set properties
  set mux2_3 [ create_bd_cell -type ip -vlnv user.org:user:mux2:1.0 mux2_3 ]

  # Create instance: mux2_4, and set properties
  set mux2_4 [ create_bd_cell -type ip -vlnv user.org:user:mux2:1.0 mux2_4 ]

  # Create instance: mux2_5, and set properties
  set mux2_5 [ create_bd_cell -type ip -vlnv user.org:user:mux2:1.0 mux2_5 ]

  # Create instance: mux2_6, and set properties
  set mux2_6 [ create_bd_cell -type ip -vlnv user.org:user:mux2:1.0 mux2_6 ]

  # Create instance: one, and set properties
  set one [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 one ]
  set_property -dict [ list \
CONFIG.CONST_VAL {1} \
 ] $one

  # Create instance: pixelFIFO_v1_0_0, and set properties
  set pixelFIFO_v1_0_0 [ create_bd_cell -type ip -vlnv user.org:user:pixelFIFO_v1_0:1.0 pixelFIFO_v1_0_0 ]
  set_property -dict [ list \
CONFIG.FIFO_POINTER_BITS {5} \
 ] $pixelFIFO_v1_0_0

  # Create instance: pixelTrigger_0, and set properties
  set pixelTrigger_0 [ create_bd_cell -type ip -vlnv user.org:user:pixelTrigger:1.0 pixelTrigger_0 ]

  # Create instance: pixelTrigger_1, and set properties
  set pixelTrigger_1 [ create_bd_cell -type ip -vlnv user.org:user:pixelTrigger:1.0 pixelTrigger_1 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {667} \
CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
CONFIG.PCW_ENET0_RESET_ENABLE {0} \
CONFIG.PCW_EN_CLK0_PORT {1} \
CONFIG.PCW_EN_CLK1_PORT {1} \
CONFIG.PCW_EN_CLK2_PORT {1} \
CONFIG.PCW_EN_CLK3_PORT {1} \
CONFIG.PCW_EN_DDR {1} \
CONFIG.PCW_EN_RST0_PORT {1} \
CONFIG.PCW_EN_RST1_PORT {1} \
CONFIG.PCW_EN_RST2_PORT {0} \
CONFIG.PCW_EN_RST3_PORT {0} \
CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {DDR PLL} \
CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK_CLK0_BUF {true} \
CONFIG.PCW_FCLK_CLK1_BUF {true} \
CONFIG.PCW_FCLK_CLK2_BUF {true} \
CONFIG.PCW_FCLK_CLK3_BUF {true} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {150} \
CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {20} \
CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_I2C_RESET_ENABLE {0} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_MIO_0_PULLUP {disabled} \
CONFIG.PCW_MIO_0_SLEW {slow} \
CONFIG.PCW_MIO_10_PULLUP {disabled} \
CONFIG.PCW_MIO_10_SLEW {slow} \
CONFIG.PCW_MIO_11_PULLUP {disabled} \
CONFIG.PCW_MIO_11_SLEW {slow} \
CONFIG.PCW_MIO_12_PULLUP {disabled} \
CONFIG.PCW_MIO_12_SLEW {slow} \
CONFIG.PCW_MIO_13_PULLUP {disabled} \
CONFIG.PCW_MIO_13_SLEW {slow} \
CONFIG.PCW_MIO_14_PULLUP {disabled} \
CONFIG.PCW_MIO_14_SLEW {slow} \
CONFIG.PCW_MIO_15_PULLUP {disabled} \
CONFIG.PCW_MIO_15_SLEW {slow} \
CONFIG.PCW_MIO_16_PULLUP {disabled} \
CONFIG.PCW_MIO_16_SLEW {slow} \
CONFIG.PCW_MIO_17_PULLUP {disabled} \
CONFIG.PCW_MIO_17_SLEW {slow} \
CONFIG.PCW_MIO_18_PULLUP {disabled} \
CONFIG.PCW_MIO_18_SLEW {slow} \
CONFIG.PCW_MIO_19_PULLUP {disabled} \
CONFIG.PCW_MIO_19_SLEW {slow} \
CONFIG.PCW_MIO_1_PULLUP {disabled} \
CONFIG.PCW_MIO_1_SLEW {slow} \
CONFIG.PCW_MIO_20_PULLUP {disabled} \
CONFIG.PCW_MIO_20_SLEW {slow} \
CONFIG.PCW_MIO_21_PULLUP {disabled} \
CONFIG.PCW_MIO_21_SLEW {slow} \
CONFIG.PCW_MIO_22_PULLUP {disabled} \
CONFIG.PCW_MIO_22_SLEW {slow} \
CONFIG.PCW_MIO_23_PULLUP {disabled} \
CONFIG.PCW_MIO_23_SLEW {slow} \
CONFIG.PCW_MIO_24_PULLUP {disabled} \
CONFIG.PCW_MIO_24_SLEW {slow} \
CONFIG.PCW_MIO_25_PULLUP {disabled} \
CONFIG.PCW_MIO_25_SLEW {slow} \
CONFIG.PCW_MIO_26_PULLUP {disabled} \
CONFIG.PCW_MIO_26_SLEW {slow} \
CONFIG.PCW_MIO_27_PULLUP {disabled} \
CONFIG.PCW_MIO_27_SLEW {slow} \
CONFIG.PCW_MIO_28_PULLUP {disabled} \
CONFIG.PCW_MIO_28_SLEW {slow} \
CONFIG.PCW_MIO_29_PULLUP {disabled} \
CONFIG.PCW_MIO_29_SLEW {slow} \
CONFIG.PCW_MIO_2_SLEW {slow} \
CONFIG.PCW_MIO_30_PULLUP {disabled} \
CONFIG.PCW_MIO_30_SLEW {slow} \
CONFIG.PCW_MIO_31_PULLUP {disabled} \
CONFIG.PCW_MIO_31_SLEW {slow} \
CONFIG.PCW_MIO_32_PULLUP {disabled} \
CONFIG.PCW_MIO_32_SLEW {slow} \
CONFIG.PCW_MIO_33_PULLUP {disabled} \
CONFIG.PCW_MIO_33_SLEW {slow} \
CONFIG.PCW_MIO_34_PULLUP {disabled} \
CONFIG.PCW_MIO_34_SLEW {slow} \
CONFIG.PCW_MIO_35_PULLUP {disabled} \
CONFIG.PCW_MIO_35_SLEW {slow} \
CONFIG.PCW_MIO_36_PULLUP {disabled} \
CONFIG.PCW_MIO_36_SLEW {slow} \
CONFIG.PCW_MIO_37_PULLUP {disabled} \
CONFIG.PCW_MIO_37_SLEW {slow} \
CONFIG.PCW_MIO_38_PULLUP {disabled} \
CONFIG.PCW_MIO_38_SLEW {slow} \
CONFIG.PCW_MIO_39_PULLUP {disabled} \
CONFIG.PCW_MIO_39_SLEW {slow} \
CONFIG.PCW_MIO_3_SLEW {slow} \
CONFIG.PCW_MIO_40_PULLUP {disabled} \
CONFIG.PCW_MIO_40_SLEW {slow} \
CONFIG.PCW_MIO_41_PULLUP {disabled} \
CONFIG.PCW_MIO_41_SLEW {slow} \
CONFIG.PCW_MIO_42_PULLUP {disabled} \
CONFIG.PCW_MIO_42_SLEW {slow} \
CONFIG.PCW_MIO_43_PULLUP {disabled} \
CONFIG.PCW_MIO_43_SLEW {slow} \
CONFIG.PCW_MIO_44_PULLUP {disabled} \
CONFIG.PCW_MIO_44_SLEW {slow} \
CONFIG.PCW_MIO_45_PULLUP {disabled} \
CONFIG.PCW_MIO_45_SLEW {slow} \
CONFIG.PCW_MIO_46_PULLUP {disabled} \
CONFIG.PCW_MIO_46_SLEW {slow} \
CONFIG.PCW_MIO_47_PULLUP {disabled} \
CONFIG.PCW_MIO_47_SLEW {slow} \
CONFIG.PCW_MIO_48_PULLUP {disabled} \
CONFIG.PCW_MIO_48_SLEW {slow} \
CONFIG.PCW_MIO_49_PULLUP {disabled} \
CONFIG.PCW_MIO_49_SLEW {slow} \
CONFIG.PCW_MIO_4_SLEW {slow} \
CONFIG.PCW_MIO_50_PULLUP {disabled} \
CONFIG.PCW_MIO_50_SLEW {slow} \
CONFIG.PCW_MIO_51_PULLUP {disabled} \
CONFIG.PCW_MIO_51_SLEW {slow} \
CONFIG.PCW_MIO_52_PULLUP {disabled} \
CONFIG.PCW_MIO_52_SLEW {slow} \
CONFIG.PCW_MIO_53_PULLUP {disabled} \
CONFIG.PCW_MIO_53_SLEW {slow} \
CONFIG.PCW_MIO_5_SLEW {slow} \
CONFIG.PCW_MIO_6_SLEW {slow} \
CONFIG.PCW_MIO_7_SLEW {slow} \
CONFIG.PCW_MIO_8_SLEW {slow} \
CONFIG.PCW_MIO_9_PULLUP {disabled} \
CONFIG.PCW_MIO_9_SLEW {slow} \
CONFIG.PCW_PACKAGE_NAME {clg400} \
CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_IO {MIO 46} \
CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
CONFIG.PCW_SD0_GRP_WP_IO {MIO 50} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {25} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_TTC0_TTC0_IO {EMIO} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
CONFIG.PCW_UIPARAM_DDR_BL {8} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.294} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.298} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.338} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.334} \
CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {39.7} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {39.7} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {54.14} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {54.14} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {50.05} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {50.43} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {50.10} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {50.01} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {-0.073} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {-0.072} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.024} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.023} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {49.59} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {51.74} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {50.32} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {48.55} \
CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3 (Low Voltage)} \
CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} \
CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_USB0_RESET_ENABLE {1} \
CONFIG.PCW_USB0_RESET_IO {MIO 7} \
CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
CONFIG.PCW_USE_DMA0 {0} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_M_AXI_GP0 {1} \
CONFIG.PCW_USE_M_AXI_GP1 {0} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
 ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.M03_HAS_DATA_FIFO {0} \
CONFIG.NUM_MI {7} \
CONFIG.NUM_SI {2} \
 ] $processing_system7_0_axi_periph

  # Create instance: quadDec_1, and set properties
  set quadDec_1 [ create_bd_cell -type ip -vlnv user.org:user:quadDec:1.0 quadDec_1 ]

  # Create instance: quadDec_2, and set properties
  set quadDec_2 [ create_bd_cell -type ip -vlnv user.org:user:quadDec:1.0 quadDec_2 ]

  # Create instance: rst_processing_system7_0_100M1, and set properties
  set rst_processing_system7_0_100M1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M1 ]
  set_property -dict [ list \
CONFIG.C_EXT_RST_WIDTH {4} \
 ] $rst_processing_system7_0_100M1

  # Create instance: rst_processing_system7_0_100M2, and set properties
  set rst_processing_system7_0_100M2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M2 ]
  set_property -dict [ list \
CONFIG.C_EXT_RST_WIDTH {4} \
 ] $rst_processing_system7_0_100M2

  # Create instance: scalerAND, and set properties
  set scalerAND [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 scalerAND ]
  set_property -dict [ list \
CONFIG.C_OPERATION {and} \
CONFIG.C_SIZE {1} \
 ] $scalerAND

  # Create instance: scalerChan_1, and set properties
  set scalerChan_1 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 scalerChan_1 ]

  # Create instance: scalerChan_2, and set properties
  set scalerChan_2 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 scalerChan_2 ]

  # Create instance: scalerChan_3, and set properties
  set scalerChan_3 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 scalerChan_3 ]

  # Create instance: scalerChan_4, and set properties
  set scalerChan_4 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 scalerChan_4 ]

  # Create instance: scalerChan_5, and set properties
  set scalerChan_5 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 scalerChan_5 ]

  # Create instance: scalerChan_6, and set properties
  set scalerChan_6 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 scalerChan_6 ]

  # Create instance: scalerChan_7, and set properties
  set scalerChan_7 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 scalerChan_7 ]

  # Create instance: scalerChan_8, and set properties
  set scalerChan_8 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 scalerChan_8 ]

  # Create instance: scalerChan_9, and set properties
  set scalerChan_9 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 scalerChan_9 ]

  # Create instance: scalerChan_10, and set properties
  set scalerChan_10 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 scalerChan_10 ]

  # Create instance: scalerChan_11, and set properties
  set scalerChan_11 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 scalerChan_11 ]

  # Create instance: scalerChan_12, and set properties
  set scalerChan_12 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 scalerChan_12 ]

  # Create instance: scalerChan_13, and set properties
  set scalerChan_13 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 scalerChan_13 ]

  # Create instance: scalerChan_14, and set properties
  set scalerChan_14 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 scalerChan_14 ]

  # Create instance: scalerChan_15, and set properties
  set scalerChan_15 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 scalerChan_15 ]

  # Create instance: scalerChan_16, and set properties
  set scalerChan_16 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 scalerChan_16 ]

  # Create instance: scaler_or, and set properties
  set scaler_or [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 scaler_or ]
  set_property -dict [ list \
CONFIG.C_OPERATION {or} \
CONFIG.C_SIZE {1} \
 ] $scaler_or

  # Create instance: scaler_or1, and set properties
  set scaler_or1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 scaler_or1 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
 ] $scaler_or1

  # Create instance: scaler_or2, and set properties
  set scaler_or2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 scaler_or2 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
 ] $scaler_or2

  # Create instance: scalersToFIFO_1, and set properties
  set scalersToFIFO_1 [ create_bd_cell -type ip -vlnv user.org:user:scalersToFIFO:1.0 scalersToFIFO_1 ]

  # Create instance: scalersToStream_0, and set properties
  set scalersToStream_0 [ create_bd_cell -type ip -vlnv user.org:user:scalersToStream:1.0 scalersToStream_0 ]

  # Create instance: softGlueReg32_v1_0_0, and set properties
  set softGlueReg32_v1_0_0 [ create_bd_cell -type ip -vlnv user.org:user:softGlueReg32_v1_0:1.0 softGlueReg32_v1_0_0 ]

  # Create instance: softGlue_300IO_v1_0_0, and set properties
  set softGlue_300IO_v1_0_0 [ create_bd_cell -type ip -vlnv user.org:user:softGlue_300IO_v1_0:1.0 softGlue_300IO_v1_0_0 ]
  set_property -dict [ list \
CONFIG.C_INTR_SENSITIVITY {0x00000000} \
CONFIG.C_NUM_OF_INTR {32} \
 ] $softGlue_300IO_v1_0_0

  # Create instance: ssi_master_0, and set properties
  set ssi_master_0 [ create_bd_cell -type ip -vlnv user.org:user:ssi_master:1.0 ssi_master_0 ]

  # Create instance: streamMux_0, and set properties
  set streamMux_0 [ create_bd_cell -type ip -vlnv user.org:user:streamMux:1.0 streamMux_0 ]

  # Create instance: updncntr_1, and set properties
  set updncntr_1 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 updncntr_1 ]

  # Create instance: updncntr_2, and set properties
  set updncntr_2 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 updncntr_2 ]

  # Create instance: updncntr_3, and set properties
  set updncntr_3 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 updncntr_3 ]

  # Create instance: updncntr_4, and set properties
  set updncntr_4 [ create_bd_cell -type ip -vlnv user.org:user:updowncounter:1.0 updncntr_4 ]

  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_0 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $util_ds_buf_0

  # Create instance: util_ds_buf_1, and set properties
  set util_ds_buf_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_1 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $util_ds_buf_1

  # Create instance: util_ds_buf_2, and set properties
  set util_ds_buf_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_2 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $util_ds_buf_2

  # Create instance: util_ds_buf_3, and set properties
  set util_ds_buf_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_3 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $util_ds_buf_3

  # Create instance: util_ds_buf_4, and set properties
  set util_ds_buf_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_4 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $util_ds_buf_4

  # Create instance: util_ds_buf_5, and set properties
  set util_ds_buf_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_5 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $util_ds_buf_5

  # Create instance: util_ds_buf_6, and set properties
  set util_ds_buf_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_6 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $util_ds_buf_6

  # Create instance: util_ds_buf_7, and set properties
  set util_ds_buf_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_7 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $util_ds_buf_7

  # Create instance: util_ds_buf_8, and set properties
  set util_ds_buf_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_8 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $util_ds_buf_8

  # Create instance: util_ds_buf_9, and set properties
  set util_ds_buf_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_9 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $util_ds_buf_9

  # Create instance: util_ds_buf_10, and set properties
  set util_ds_buf_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_10 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $util_ds_buf_10

  # Create instance: util_ds_buf_11, and set properties
  set util_ds_buf_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_11 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $util_ds_buf_11

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {3} \
 ] $xlconcat_1

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {32} \
 ] $xlconcat_2

  # Create instance: xlconcat_3, and set properties
  set xlconcat_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_3 ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {16} \
CONFIG.IN1_WIDTH {16} \
CONFIG.NUM_PORTS {2} \
 ] $xlconcat_3

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {1} \
CONFIG.DOUT_WIDTH {2} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {2} \
CONFIG.DIN_TO {2} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {3} \
CONFIG.DIN_TO {3} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {4} \
CONFIG.DIN_TO {4} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {5} \
CONFIG.DIN_TO {5} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {6} \
CONFIG.DIN_TO {6} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: zero, and set properties
  set zero [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 zero ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
 ] $zero

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_dma_0/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net S01_AXI_1 [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net fhistoScalerStream_0_M_AXIS [get_bd_intf_pins fhistoScalerStream_0/M_AXIS] [get_bd_intf_pins streamMux_0/s2]
  connect_bd_intf_net -intf_net fifo_generator_1_M_AXIS [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM] [get_bd_intf_pins fifo_generator_1/M_AXIS]
  connect_bd_intf_net -intf_net histoScalerStream_0_M_AXIS [get_bd_intf_pins histoScalerStream_0/M_AXIS] [get_bd_intf_pins streamMux_0/s1]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI] [get_bd_intf_pins softGlue_300IO_v1_0_0/s00_axi]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI] [get_bd_intf_pins softGlue_300IO_v1_0_0/s_axi_intr]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI] [get_bd_intf_pins softGlueReg32_v1_0_0/s00_axi]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M03_AXI [get_bd_intf_pins pixelFIFO_v1_0_0/s00_axi] [get_bd_intf_pins processing_system7_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M04_AXI [get_bd_intf_pins axi_dma_0/S_AXI_LITE] [get_bd_intf_pins processing_system7_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M05_AXI [get_bd_intf_pins clk_wiz0_0_0/s_axi_lite] [get_bd_intf_pins processing_system7_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M06_AXI [get_bd_intf_pins clk_wiz1_0_0/s_axi_lite] [get_bd_intf_pins processing_system7_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net scalersToStream_0_M_AXIS [get_bd_intf_pins scalersToStream_0/M_AXIS] [get_bd_intf_pins streamMux_0/s0]
  connect_bd_intf_net -intf_net streamMux_0_m [get_bd_intf_pins fifo_generator_1/S_AXIS] [get_bd_intf_pins streamMux_0/m]

  # Create port connections
  connect_bd_net -net AND_0_Res [get_bd_pins AND_0/Res] [get_bd_pins softGlue_300IO_v1_0_0/sg_in081]
  connect_bd_net -net AND_1_Res [get_bd_pins AND_1/Res] [get_bd_pins softGlue_300IO_v1_0_0/sg_in000]
  connect_bd_net -net AND_2_Res [get_bd_pins AND_2/Res] [get_bd_pins softGlue_300IO_v1_0_0/sg_in001]
  connect_bd_net -net AND_3_Res [get_bd_pins AND_3/Res] [get_bd_pins softGlue_300IO_v1_0_0/sg_in002]
  connect_bd_net -net AND_4_Res [get_bd_pins AND_4/Res] [get_bd_pins softGlue_300IO_v1_0_0/sg_in003]
  connect_bd_net -net ARESETN_1 [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_100M1/interconnect_aresetn]
  connect_bd_net -net DFF_1_Q [get_bd_pins DFF_1/Q] [get_bd_pins softGlue_300IO_v1_0_0/sg_in014]
  connect_bd_net -net DFF_2_Q [get_bd_pins DFF_2/Q] [get_bd_pins softGlue_300IO_v1_0_0/sg_in015]
  connect_bd_net -net DFF_3_Q [get_bd_pins DFF_3/Q] [get_bd_pins softGlue_300IO_v1_0_0/sg_in016]
  connect_bd_net -net DFF_4_Q [get_bd_pins DFF_4/Q] [get_bd_pins softGlue_300IO_v1_0_0/sg_in017]
  connect_bd_net -net DFF_5_Q [get_bd_pins AND_0/Op1] [get_bd_pins DFF_5/Q]
  connect_bd_net -net DFF_6_Q [get_bd_pins DFF_6/Q] [get_bd_pins scalerAND/Op1] [get_bd_pins softGlue_300IO_v1_0_0/sg_in083]
  connect_bd_net -net DnCntr_1_Counts [get_bd_pins DnCntr_1/Counts] [get_bd_pins softGlueReg32_v1_0_0/out_reg8]
  connect_bd_net -net DnCntr_1_Q [get_bd_pins DnCntr_1/Q] [get_bd_pins softGlue_300IO_v1_0_0/sg_in018]
  connect_bd_net -net DnCntr_2_Counts [get_bd_pins DnCntr_2/Counts] [get_bd_pins softGlueReg32_v1_0_0/out_reg9]
  connect_bd_net -net DnCntr_2_Q [get_bd_pins DnCntr_2/Q] [get_bd_pins softGlue_300IO_v1_0_0/sg_in019]
  connect_bd_net -net DnCntr_3_Counts [get_bd_pins DnCntr_3/Counts] [get_bd_pins softGlueReg32_v1_0_0/out_reg10]
  connect_bd_net -net DnCntr_3_Q [get_bd_pins DnCntr_3/Q] [get_bd_pins softGlue_300IO_v1_0_0/sg_in020]
  connect_bd_net -net DnCntr_4_Counts [get_bd_pins DnCntr_4/Counts] [get_bd_pins softGlueReg32_v1_0_0/out_reg11]
  connect_bd_net -net DnCntr_4_Q [get_bd_pins DnCntr_4/Q] [get_bd_pins softGlue_300IO_v1_0_0/sg_in021]
  connect_bd_net -net FI_12_1 [get_bd_ports FI_12] [get_bd_pins scalerChan_12/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_in063] [get_bd_pins xlconcat_2/In11]
  connect_bd_net -net FI_22_1 [get_bd_ports FI_22] [get_bd_pins softGlue_300IO_v1_0_0/sg_in073]
  connect_bd_net -net FI_23_1 [get_bd_ports FI_23] [get_bd_pins softGlue_300IO_v1_0_0/sg_in074]
  connect_bd_net -net FI_24_1 [get_bd_ports FI_24] [get_bd_pins softGlue_300IO_v1_0_0/sg_in075]
  connect_bd_net -net IBUF_DS_N_1 [get_bd_ports FI_diff_N25] [get_bd_pins util_ds_buf_0/IBUF_DS_N]
  connect_bd_net -net IBUF_DS_N_10_1 [get_bd_ports FI_diff_N36] [get_bd_pins util_ds_buf_11/IBUF_DS_N]
  connect_bd_net -net IBUF_DS_N_1_1 [get_bd_ports FI_diff_N27] [get_bd_pins util_ds_buf_2/IBUF_DS_N]
  connect_bd_net -net IBUF_DS_N_2 [get_bd_ports FI_diff_N26] [get_bd_pins util_ds_buf_1/IBUF_DS_N]
  connect_bd_net -net IBUF_DS_N_2_1 [get_bd_ports FI_diff_N28] [get_bd_pins util_ds_buf_3/IBUF_DS_N]
  connect_bd_net -net IBUF_DS_N_3_1 [get_bd_ports FI_diff_N29] [get_bd_pins util_ds_buf_4/IBUF_DS_N]
  connect_bd_net -net IBUF_DS_N_4_1 [get_bd_ports FI_diff_N30] [get_bd_pins util_ds_buf_5/IBUF_DS_N]
  connect_bd_net -net IBUF_DS_N_5_1 [get_bd_ports FI_diff_N31] [get_bd_pins util_ds_buf_6/IBUF_DS_N]
  connect_bd_net -net IBUF_DS_N_6_1 [get_bd_ports FI_diff_N32] [get_bd_pins util_ds_buf_7/IBUF_DS_N]
  connect_bd_net -net IBUF_DS_N_7_1 [get_bd_ports FI_diff_N33] [get_bd_pins util_ds_buf_8/IBUF_DS_N]
  connect_bd_net -net IBUF_DS_N_8_1 [get_bd_ports FI_diff_N34] [get_bd_pins util_ds_buf_9/IBUF_DS_N]
  connect_bd_net -net IBUF_DS_N_9_1 [get_bd_ports FI_diff_N35] [get_bd_pins util_ds_buf_10/IBUF_DS_N]
  connect_bd_net -net IBUF_DS_P_1 [get_bd_ports FI_diff_P25] [get_bd_pins util_ds_buf_0/IBUF_DS_P]
  connect_bd_net -net IBUF_DS_P_10_1 [get_bd_ports FI_diff_P36] [get_bd_pins util_ds_buf_11/IBUF_DS_P]
  connect_bd_net -net IBUF_DS_P_1_1 [get_bd_ports FI_diff_P27] [get_bd_pins util_ds_buf_2/IBUF_DS_P]
  connect_bd_net -net IBUF_DS_P_2 [get_bd_ports FI_diff_P26] [get_bd_pins util_ds_buf_1/IBUF_DS_P]
  connect_bd_net -net IBUF_DS_P_2_1 [get_bd_ports FI_diff_P28] [get_bd_pins util_ds_buf_3/IBUF_DS_P]
  connect_bd_net -net IBUF_DS_P_3_1 [get_bd_ports FI_diff_P29] [get_bd_pins util_ds_buf_4/IBUF_DS_P]
  connect_bd_net -net IBUF_DS_P_4_1 [get_bd_ports FI_diff_P30] [get_bd_pins util_ds_buf_5/IBUF_DS_P]
  connect_bd_net -net IBUF_DS_P_5_1 [get_bd_ports FI_diff_P31] [get_bd_pins util_ds_buf_6/IBUF_DS_P]
  connect_bd_net -net IBUF_DS_P_6_1 [get_bd_ports FI_diff_P32] [get_bd_pins util_ds_buf_7/IBUF_DS_P]
  connect_bd_net -net IBUF_DS_P_7_1 [get_bd_ports FI_diff_P33] [get_bd_pins util_ds_buf_8/IBUF_DS_P]
  connect_bd_net -net IBUF_DS_P_8_1 [get_bd_ports FI_diff_P34] [get_bd_pins util_ds_buf_9/IBUF_DS_P]
  connect_bd_net -net IBUF_DS_P_9_1 [get_bd_ports FI_diff_P35] [get_bd_pins util_ds_buf_10/IBUF_DS_P]
  connect_bd_net -net Net1 [get_bd_pins scalerChan_12/Clear] [get_bd_pins scalerChan_13/Clear] [get_bd_pins scalerChan_14/Clear] [get_bd_pins scalerChan_15/Clear] [get_bd_pins scalerChan_16/Clear]
  connect_bd_net -net OR_1_Res [get_bd_pins OR_1/Res] [get_bd_pins softGlue_300IO_v1_0_0/sg_in004]
  connect_bd_net -net OR_2_Res [get_bd_pins OR_2/Res] [get_bd_pins softGlue_300IO_v1_0_0/sg_in005]
  connect_bd_net -net OR_3_Res [get_bd_pins OR_3/Res] [get_bd_pins softGlue_300IO_v1_0_0/sg_in006]
  connect_bd_net -net OR_4_Res [get_bd_pins OR_4/Res] [get_bd_pins softGlue_300IO_v1_0_0/sg_in007]
  connect_bd_net -net OR_5_Res [get_bd_pins OR_5/Res] [get_bd_pins softGlue_300IO_v1_0_0/sg_in042]
  connect_bd_net -net OR_6_Res [get_bd_pins OR_6/Res] [get_bd_pins softGlue_300IO_v1_0_0/sg_in043]
  connect_bd_net -net OR_7_Res [get_bd_pins AND_0/Op2] [get_bd_pins DFF_5/Clk] [get_bd_pins OR_7/Res] [get_bd_pins softGlue_300IO_v1_0_0/sg_in099]
  connect_bd_net -net UpCntr_1_Counts [get_bd_pins UpCntr_1/Counts] [get_bd_pins scalersToStream_0/in1] [get_bd_pins softGlueReg32_v1_0_0/out_reg0]
  connect_bd_net -net UpCntr_2_Counts [get_bd_pins UpCntr_2/Counts] [get_bd_pins scalersToStream_0/in2] [get_bd_pins softGlueReg32_v1_0_0/out_reg1]
  connect_bd_net -net UpCntr_3_Counts [get_bd_pins UpCntr_3/Counts] [get_bd_pins scalersToStream_0/in3] [get_bd_pins softGlueReg32_v1_0_0/out_reg2]
  connect_bd_net -net UpCntr_4_Counts [get_bd_pins UpCntr_4/Counts] [get_bd_pins scalersToStream_0/in4] [get_bd_pins softGlueReg32_v1_0_0/out_reg3]
  connect_bd_net -net XOR_1_Res [get_bd_pins XOR_1/Res] [get_bd_pins softGlue_300IO_v1_0_0/sg_in008]
  connect_bd_net -net XOR_2_Res [get_bd_pins XOR_2/Res] [get_bd_pins softGlue_300IO_v1_0_0/sg_in009]
  connect_bd_net -net axi_dma_0_mm2s_introut [get_bd_pins axi_dma_0/mm2s_introut] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins xlconcat_1/In2]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz0_0_0/clk_out1] [get_bd_pins softGlue_300IO_v1_0_0/softGlueRegClock]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz0_0_0/clk_out2] [get_bd_pins softGlue_300IO_v1_0_0/sg_in045]
  connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_pins clk_wiz0_0_0/clk_out3] [get_bd_pins softGlue_300IO_v1_0_0/sg_in046]
  connect_bd_net -net clk_wiz_0_clk_out4 [get_bd_pins clk_wiz0_0_0/clk_out4] [get_bd_pins softGlue_300IO_v1_0_0/sg_in047]
  connect_bd_net -net clk_wiz_0_clk_out5 [get_bd_pins clk_wiz0_0_0/clk_out5] [get_bd_pins gateDelayFast_1/Clk] [get_bd_pins gateDelayFast_2/Clk] [get_bd_pins gateDelayFast_3/Clk] [get_bd_pins gateDelayFast_4/Clk]
  connect_bd_net -net clk_wiz_0_clk_out6 [get_bd_pins clk_wiz1_0_0/clk_out1] [get_bd_pins fhistoScalerStream_0/Ck] [get_bd_pins mux2_6/In1] [get_bd_pins softGlue_300IO_v1_0_0/sg_in085]
  connect_bd_net -net demux2_1_Out0 [get_bd_pins demux2_1/Out0] [get_bd_pins softGlue_300IO_v1_0_0/sg_in022]
  connect_bd_net -net demux2_1_Out1 [get_bd_pins demux2_1/Out1] [get_bd_pins softGlue_300IO_v1_0_0/sg_in023]
  connect_bd_net -net demux2_2_Out0 [get_bd_pins demux2_2/Out0] [get_bd_pins softGlue_300IO_v1_0_0/sg_in024]
  connect_bd_net -net demux2_2_Out1 [get_bd_pins demux2_2/Out1] [get_bd_pins softGlue_300IO_v1_0_0/sg_in025]
  connect_bd_net -net divByN_1_Q [get_bd_pins divByN_1/Q] [get_bd_pins softGlue_300IO_v1_0_0/sg_in028]
  connect_bd_net -net divByN_2_Q [get_bd_pins divByN_2/Q] [get_bd_pins softGlue_300IO_v1_0_0/sg_in029]
  connect_bd_net -net divByN_3_Q [get_bd_pins divByN_3/Q] [get_bd_pins softGlue_300IO_v1_0_0/sg_in030]
  connect_bd_net -net divByN_4_Q [get_bd_pins divByN_4/Q] [get_bd_pins softGlue_300IO_v1_0_0/sg_in031]
  connect_bd_net -net fifo_generator_1_axis_data_count [get_bd_pins fifo_generator_1/axis_data_count] [get_bd_pins softGlueReg32_v1_0_0/out_reg26]
  connect_bd_net -net fifo_generator_1_axis_prog_full [get_bd_pins fifo_generator_1/axis_prog_full] [get_bd_pins softGlue_300IO_v1_0_0/sg_in098]
  connect_bd_net -net freqCounter_0_Counts [get_bd_pins freqCounter_0/Counts] [get_bd_pins softGlueReg32_v1_0_0/out_reg27]
  connect_bd_net -net gateDelayFast_1_Q [get_bd_pins gateDelayFast_1/Q] [get_bd_pins mux2_5/In1]
  connect_bd_net -net gateDelayFast_2_Q [get_bd_pins gateDelayFast_2/Q] [get_bd_pins mux2_3/In1]
  connect_bd_net -net gateDelayFast_3_Q [get_bd_pins fhistoScalerStream_0/Sync] [get_bd_pins gateDelayFast_3/Q] [get_bd_pins mux2_4/In1]
  connect_bd_net -net gateDelayFast_4_Q [get_bd_pins fhistoScalerStream_0/Det] [get_bd_pins gateDelayFast_4/Q] [get_bd_pins mux2_0/In1]
  connect_bd_net -net gateDly_1_Q [get_bd_pins gateDly_1/Q] [get_bd_pins softGlue_300IO_v1_0_0/sg_in048]
  connect_bd_net -net gateDly_2_Q [get_bd_pins gateDly_2/Q] [get_bd_pins softGlue_300IO_v1_0_0/sg_in049]
  connect_bd_net -net gateDly_3_Q [get_bd_pins gateDly_3/Q] [get_bd_pins softGlue_300IO_v1_0_0/sg_in050]
  connect_bd_net -net gateDly_4_Q [get_bd_pins gateDly_4/Q] [get_bd_pins softGlue_300IO_v1_0_0/sg_in051]
  connect_bd_net -net mux2_0_Outp [get_bd_ports FO_12] [get_bd_pins mux2_0/Outp]
  connect_bd_net -net mux2_1_Outp [get_bd_pins mux2_1/Outp] [get_bd_pins softGlue_300IO_v1_0_0/sg_in026]
  connect_bd_net -net mux2_2_Outp [get_bd_pins mux2_2/Outp] [get_bd_pins softGlue_300IO_v1_0_0/sg_in027]
  connect_bd_net -net mux2_3_Outp [get_bd_ports FO_10] [get_bd_pins mux2_3/Outp]
  connect_bd_net -net mux2_4_Outp [get_bd_ports FO_11] [get_bd_pins mux2_4/Outp]
  connect_bd_net -net mux2_5_Outp [get_bd_ports FO_09] [get_bd_pins mux2_5/Outp]
  connect_bd_net -net mux2_6_Outp [get_bd_ports FO_24] [get_bd_pins mux2_6/Outp]
  connect_bd_net -net one_dout [get_bd_pins one/dout] [get_bd_pins scalerChan_10/UpDn] [get_bd_pins scalerChan_11/UpDn] [get_bd_pins scalerChan_12/UpDn] [get_bd_pins scalerChan_13/UpDn] [get_bd_pins scalerChan_14/UpDn] [get_bd_pins scalerChan_15/UpDn] [get_bd_pins scalerChan_16/UpDn] [get_bd_pins scalerChan_2/UpDn] [get_bd_pins scalerChan_3/UpDn] [get_bd_pins scalerChan_4/UpDn] [get_bd_pins scalerChan_5/UpDn] [get_bd_pins scalerChan_6/UpDn] [get_bd_pins scalerChan_7/UpDn] [get_bd_pins scalerChan_8/UpDn] [get_bd_pins scalerChan_9/UpDn]
  connect_bd_net -net pixelFIFO_v1_0_0_roomForEvent [get_bd_pins DFF_5/Clear] [get_bd_pins pixelFIFO_v1_0_0/roomForEvent]
  connect_bd_net -net pixelTrigger_0_Counts [get_bd_pins pixelTrigger_0/Counts] [get_bd_pins softGlueReg32_v1_0_0/out_reg29]
  connect_bd_net -net pixelTrigger_0_Pixel [get_bd_pins pixelTrigger_0/Pixel] [get_bd_pins softGlueReg32_v1_0_0/out_reg28] [get_bd_pins xlconcat_3/In0]
  connect_bd_net -net pixelTrigger_0_Trig [get_bd_pins OR_7/Op1] [get_bd_pins pixelTrigger_0/Trig] [get_bd_pins softGlue_300IO_v1_0_0/sg_in076]
  connect_bd_net -net pixelTrigger_0_miss [get_bd_pins pixelTrigger_0/miss] [get_bd_pins softGlue_300IO_v1_0_0/sg_in077]
  connect_bd_net -net pixelTrigger_1_Counts [get_bd_pins pixelTrigger_1/Counts] [get_bd_pins softGlueReg32_v1_0_0/out_reg31]
  connect_bd_net -net pixelTrigger_1_Pixel [get_bd_pins pixelTrigger_1/Pixel] [get_bd_pins softGlueReg32_v1_0_0/out_reg30] [get_bd_pins xlconcat_3/In1]
  connect_bd_net -net pixelTrigger_1_Trig [get_bd_pins OR_7/Op2] [get_bd_pins pixelTrigger_1/Trig] [get_bd_pins softGlue_300IO_v1_0_0/sg_in078]
  connect_bd_net -net pixelTrigger_1_miss [get_bd_pins pixelTrigger_1/miss] [get_bd_pins softGlue_300IO_v1_0_0/sg_in079]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins DFF_5/regClk] [get_bd_pins DFF_6/regClk] [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins clk_wiz0_0_0/s_axi_aclk] [get_bd_pins clk_wiz1_0_0/s_axi_aclk] [get_bd_pins fhistoScalerStream_0/M_AXIS_ACLK] [get_bd_pins fifo_generator_1/s_aclk] [get_bd_pins histoScalerStream_0/M_AXIS_ACLK] [get_bd_pins pixelFIFO_v1_0_0/s00_axi_aclk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/M03_ACLK] [get_bd_pins processing_system7_0_axi_periph/M04_ACLK] [get_bd_pins processing_system7_0_axi_periph/M05_ACLK] [get_bd_pins processing_system7_0_axi_periph/M06_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins processing_system7_0_axi_periph/S01_ACLK] [get_bd_pins rst_processing_system7_0_100M1/slowest_sync_clk] [get_bd_pins rst_processing_system7_0_100M2/slowest_sync_clk] [get_bd_pins scalerChan_1/regClk] [get_bd_pins scalerChan_10/regClk] [get_bd_pins scalerChan_11/regClk] [get_bd_pins scalerChan_12/regClk] [get_bd_pins scalerChan_13/regClk] [get_bd_pins scalerChan_14/regClk] [get_bd_pins scalerChan_15/regClk] [get_bd_pins scalerChan_16/regClk] [get_bd_pins scalerChan_2/regClk] [get_bd_pins scalerChan_3/regClk] [get_bd_pins scalerChan_4/regClk] [get_bd_pins scalerChan_5/regClk] [get_bd_pins scalerChan_6/regClk] [get_bd_pins scalerChan_7/regClk] [get_bd_pins scalerChan_8/regClk] [get_bd_pins scalerChan_9/regClk] [get_bd_pins scalersToFIFO_1/regClk] [get_bd_pins scalersToStream_0/M_AXIS_ACLK] [get_bd_pins softGlueReg32_v1_0_0/s00_axi_aclk] [get_bd_pins softGlue_300IO_v1_0_0/s00_axi_aclk] [get_bd_pins softGlue_300IO_v1_0_0/s_axi_intr_aclk] [get_bd_pins streamMux_0/m_aclk] [get_bd_pins streamMux_0/s0_aclk] [get_bd_pins streamMux_0/s1_aclk] [get_bd_pins streamMux_0/s2_aclk] [get_bd_pins streamMux_0/s3_aclk]
  connect_bd_net -net processing_system7_0_FCLK_CLK2 [get_bd_pins clk_wiz1_0_0/clk_in1] [get_bd_pins processing_system7_0/FCLK_CLK2]
  connect_bd_net -net processing_system7_0_FCLK_CLK3 [get_bd_pins clk_wiz0_0_0/clk_in1] [get_bd_pins processing_system7_0/FCLK_CLK3]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M1/ext_reset_in] [get_bd_pins rst_processing_system7_0_100M2/ext_reset_in]
  connect_bd_net -net quadDec_1_dir [get_bd_pins quadDec_1/dir] [get_bd_pins softGlue_300IO_v1_0_0/sg_in039]
  connect_bd_net -net quadDec_1_miss [get_bd_pins quadDec_1/miss] [get_bd_pins softGlue_300IO_v1_0_0/sg_in036]
  connect_bd_net -net quadDec_1_step [get_bd_pins quadDec_1/step] [get_bd_pins softGlue_300IO_v1_0_0/sg_in038]
  connect_bd_net -net quadDec_2_dir [get_bd_pins quadDec_2/dir] [get_bd_pins softGlue_300IO_v1_0_0/sg_in041]
  connect_bd_net -net quadDec_2_miss [get_bd_pins quadDec_2/miss] [get_bd_pins softGlue_300IO_v1_0_0/sg_in037]
  connect_bd_net -net quadDec_2_step [get_bd_pins quadDec_2/step] [get_bd_pins softGlue_300IO_v1_0_0/sg_in040]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins clk_wiz0_0_0/s_axi_aresetn] [get_bd_pins clk_wiz1_0_0/s_axi_aresetn] [get_bd_pins pixelFIFO_v1_0_0/s00_axi_aresetn] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M03_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M04_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M05_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M06_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S01_ARESETN] [get_bd_pins rst_processing_system7_0_100M1/peripheral_aresetn] [get_bd_pins softGlueReg32_v1_0_0/s00_axi_aresetn] [get_bd_pins softGlue_300IO_v1_0_0/s00_axi_aresetn] [get_bd_pins softGlue_300IO_v1_0_0/s_axi_intr_aresetn]
  connect_bd_net -net scalerAND_Res [get_bd_pins scalerAND/Res] [get_bd_pins scalerChan_1/En] [get_bd_pins scalerChan_10/En] [get_bd_pins scalerChan_11/En] [get_bd_pins scalerChan_12/En] [get_bd_pins scalerChan_13/En] [get_bd_pins scalerChan_14/En] [get_bd_pins scalerChan_15/En] [get_bd_pins scalerChan_16/En] [get_bd_pins scalerChan_2/En] [get_bd_pins scalerChan_3/En] [get_bd_pins scalerChan_4/En] [get_bd_pins scalerChan_5/En] [get_bd_pins scalerChan_6/En] [get_bd_pins scalerChan_7/En] [get_bd_pins scalerChan_8/En] [get_bd_pins scalerChan_9/En]
  connect_bd_net -net scalerChan_10_Counts [get_bd_pins scalerChan_10/Counts] [get_bd_pins scalersToFIFO_1/in9]
  connect_bd_net -net scalerChan_11_Counts [get_bd_pins scalerChan_11/Counts] [get_bd_pins scalersToFIFO_1/in10]
  connect_bd_net -net scalerChan_12_Counts [get_bd_pins scalerChan_12/Counts] [get_bd_pins scalersToFIFO_1/in11]
  connect_bd_net -net scalerChan_13_Counts [get_bd_pins scalerChan_13/Counts] [get_bd_pins scalersToFIFO_1/in12]
  connect_bd_net -net scalerChan_14_Counts [get_bd_pins scalerChan_14/Counts] [get_bd_pins scalersToFIFO_1/in13]
  connect_bd_net -net scalerChan_15_Counts [get_bd_pins scalerChan_15/Counts] [get_bd_pins scalersToFIFO_1/in14]
  connect_bd_net -net scalerChan_16_Counts [get_bd_pins scalerChan_16/Counts] [get_bd_pins scalersToFIFO_1/in15]
  connect_bd_net -net scalerChan_1_Counts [get_bd_pins scalerChan_1/Counts] [get_bd_pins scalersToFIFO_1/in0]
  connect_bd_net -net scalerChan_1_Q [get_bd_pins scalerChan_1/Q] [get_bd_pins scaler_or/Op2] [get_bd_pins softGlue_300IO_v1_0_0/sg_in082]
  connect_bd_net -net scalerChan_2_Counts [get_bd_pins scalerChan_2/Counts] [get_bd_pins scalersToFIFO_1/in1]
  connect_bd_net -net scalerChan_3_Counts [get_bd_pins scalerChan_3/Counts] [get_bd_pins scalersToFIFO_1/in2]
  connect_bd_net -net scalerChan_4_Counts [get_bd_pins scalerChan_4/Counts] [get_bd_pins scalersToFIFO_1/in3]
  connect_bd_net -net scalerChan_5_Counts [get_bd_pins scalerChan_5/Counts] [get_bd_pins scalersToFIFO_1/in4]
  connect_bd_net -net scalerChan_6_Counts [get_bd_pins scalerChan_6/Counts] [get_bd_pins scalersToFIFO_1/in5]
  connect_bd_net -net scalerChan_7_Counts [get_bd_pins scalerChan_7/Counts] [get_bd_pins scalersToFIFO_1/in6]
  connect_bd_net -net scalerChan_8_Counts [get_bd_pins scalerChan_8/Counts] [get_bd_pins scalersToFIFO_1/in7]
  connect_bd_net -net scalerChan_9_Counts [get_bd_pins scalerChan_9/Counts] [get_bd_pins scalersToFIFO_1/in8]
  connect_bd_net -net scaler_or1_Res [get_bd_pins DFF_6/Clear] [get_bd_pins scaler_or1/Res]
  connect_bd_net -net scaler_or2_Res [get_bd_pins DFF_6/Set] [get_bd_pins scaler_or2/Res]
  connect_bd_net -net scaler_or_Res [get_bd_pins scaler_or/Res] [get_bd_pins scaler_or1/Op1]
  connect_bd_net -net scalersToFIFO_1_outReg [get_bd_pins pixelFIFO_v1_0_0/pixelValue] [get_bd_pins scalersToFIFO_1/outReg]
  connect_bd_net -net scalersToFIFO_1_wrtCk [get_bd_pins pixelFIFO_v1_0_0/writeCk] [get_bd_pins scalersToFIFO_1/wrtCk] [get_bd_pins softGlue_300IO_v1_0_0/sg_in080]
  connect_bd_net -net scalersToStream_0_chanAdvDone [get_bd_pins scalersToStream_0/chanAdvDone] [get_bd_pins softGlue_300IO_v1_0_0/sg_in084]
  connect_bd_net -net sg_in052_1 [get_bd_ports FI_01] [get_bd_pins gateDelayFast_1/Inp] [get_bd_pins softGlue_300IO_v1_0_0/sg_in052] [get_bd_pins xlconcat_2/In0]
  connect_bd_net -net sg_in053_1 [get_bd_ports FI_02] [get_bd_pins gateDelayFast_2/Inp] [get_bd_pins scalerChan_2/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_in053] [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net sg_in054_1 [get_bd_ports FI_03] [get_bd_pins gateDelayFast_3/Inp] [get_bd_pins scalerChan_3/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_in054] [get_bd_pins xlconcat_2/In2]
  connect_bd_net -net sg_in055_1 [get_bd_ports FI_04] [get_bd_pins gateDelayFast_4/Inp] [get_bd_pins scalerChan_4/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_in055] [get_bd_pins xlconcat_2/In3]
  connect_bd_net -net sg_in056_1 [get_bd_ports FI_05] [get_bd_pins scalerChan_5/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_in056] [get_bd_pins xlconcat_2/In4]
  connect_bd_net -net sg_in057_1 [get_bd_ports FI_06] [get_bd_pins scalerChan_6/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_in057] [get_bd_pins xlconcat_2/In5]
  connect_bd_net -net sg_in058_1 [get_bd_ports FI_07] [get_bd_pins scalerChan_7/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_in058] [get_bd_pins xlconcat_2/In6]
  connect_bd_net -net sg_in059_1 [get_bd_ports FI_08] [get_bd_pins scalerChan_8/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_in059] [get_bd_pins xlconcat_2/In7]
  connect_bd_net -net sg_in060_1 [get_bd_ports FI_09] [get_bd_pins scalerChan_9/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_in060] [get_bd_pins xlconcat_2/In8]
  connect_bd_net -net sg_in061_1 [get_bd_ports FI_10] [get_bd_pins scalerChan_10/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_in061] [get_bd_pins xlconcat_2/In9]
  connect_bd_net -net sg_in062_1 [get_bd_ports FI_11] [get_bd_pins scalerChan_11/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_in062] [get_bd_pins xlconcat_2/In10]
  connect_bd_net -net sg_in064_1 [get_bd_ports FI_13] [get_bd_pins scalerChan_13/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_in064] [get_bd_pins xlconcat_2/In12]
  connect_bd_net -net sg_in065_1 [get_bd_ports FI_14] [get_bd_pins scalerChan_14/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_in065] [get_bd_pins xlconcat_2/In13]
  connect_bd_net -net sg_in066_1 [get_bd_ports FI_15] [get_bd_pins scalerChan_15/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_in066] [get_bd_pins xlconcat_2/In14]
  connect_bd_net -net sg_in067_1 [get_bd_ports FI_16] [get_bd_pins scalerChan_16/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_in067] [get_bd_pins xlconcat_2/In15]
  connect_bd_net -net sg_in068_1 [get_bd_ports FI_17] [get_bd_pins softGlue_300IO_v1_0_0/sg_in068]
  connect_bd_net -net sg_in069_1 [get_bd_ports FI_18] [get_bd_pins softGlue_300IO_v1_0_0/sg_in069]
  connect_bd_net -net sg_in070_1 [get_bd_ports FI_19] [get_bd_pins softGlue_300IO_v1_0_0/sg_in070]
  connect_bd_net -net sg_in071_1 [get_bd_ports FI_20] [get_bd_pins softGlue_300IO_v1_0_0/sg_in071]
  connect_bd_net -net sg_in072_1 [get_bd_ports FI_21] [get_bd_pins softGlue_300IO_v1_0_0/sg_in072]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg32 [get_bd_pins DnCntr_1/Preset] [get_bd_pins softGlueReg32_v1_0_0/in_reg32]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg33 [get_bd_pins DnCntr_2/Preset] [get_bd_pins softGlueReg32_v1_0_0/in_reg33]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg34 [get_bd_pins DnCntr_3/Preset] [get_bd_pins softGlueReg32_v1_0_0/in_reg34]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg35 [get_bd_pins DnCntr_4/Preset] [get_bd_pins softGlueReg32_v1_0_0/in_reg35]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg36 [get_bd_pins divByN_1/N] [get_bd_pins softGlueReg32_v1_0_0/in_reg36]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg37 [get_bd_pins divByN_2/N] [get_bd_pins softGlueReg32_v1_0_0/in_reg37]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg38 [get_bd_pins divByN_3/N] [get_bd_pins softGlueReg32_v1_0_0/in_reg38]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg39 [get_bd_pins divByN_4/N] [get_bd_pins softGlueReg32_v1_0_0/in_reg39]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg40 [get_bd_pins softGlueReg32_v1_0_0/in_reg40] [get_bd_pins updncntr_1/Preset]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg41 [get_bd_pins softGlueReg32_v1_0_0/in_reg41] [get_bd_pins updncntr_2/Preset]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg42 [get_bd_pins softGlueReg32_v1_0_0/in_reg42] [get_bd_pins updncntr_3/Preset]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg43 [get_bd_pins softGlueReg32_v1_0_0/in_reg43] [get_bd_pins updncntr_4/Preset]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg44 [get_bd_pins scalerChan_1/Preset] [get_bd_pins softGlueReg32_v1_0_0/in_reg44]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg45 [get_bd_pins gateDelayFast_1/Delay] [get_bd_pins gateDly_1/Delay] [get_bd_pins softGlueReg32_v1_0_0/in_reg45]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg46 [get_bd_pins gateDelayFast_1/Width] [get_bd_pins gateDly_1/Width] [get_bd_pins softGlueReg32_v1_0_0/in_reg46]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg47 [get_bd_pins gateDelayFast_2/Delay] [get_bd_pins gateDly_2/Delay] [get_bd_pins softGlueReg32_v1_0_0/in_reg47]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg48 [get_bd_pins gateDelayFast_2/Width] [get_bd_pins gateDly_2/Width] [get_bd_pins softGlueReg32_v1_0_0/in_reg48]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg49 [get_bd_pins gateDelayFast_3/Delay] [get_bd_pins gateDly_3/Delay] [get_bd_pins softGlueReg32_v1_0_0/in_reg49]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg50 [get_bd_pins gateDelayFast_3/Width] [get_bd_pins gateDly_3/Width] [get_bd_pins softGlueReg32_v1_0_0/in_reg50]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg51 [get_bd_pins gateDelayFast_4/Delay] [get_bd_pins gateDly_4/Delay] [get_bd_pins softGlueReg32_v1_0_0/in_reg51]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg52 [get_bd_pins gateDelayFast_4/Width] [get_bd_pins gateDly_4/Width] [get_bd_pins softGlueReg32_v1_0_0/in_reg52]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg53 [get_bd_pins pixelTrigger_0/PresetTrig] [get_bd_pins softGlueReg32_v1_0_0/in_reg53]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg54 [get_bd_pins pixelTrigger_0/Preset] [get_bd_pins softGlueReg32_v1_0_0/in_reg54]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg55 [get_bd_pins pixelTrigger_1/PresetTrig] [get_bd_pins softGlueReg32_v1_0_0/in_reg55]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg56 [get_bd_pins pixelTrigger_1/Preset] [get_bd_pins softGlueReg32_v1_0_0/in_reg56]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg57 [get_bd_pins pixelTrigger_0/acqTime] [get_bd_pins softGlueReg32_v1_0_0/in_reg57]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg58 [get_bd_pins pixelTrigger_1/acqTime] [get_bd_pins softGlueReg32_v1_0_0/in_reg58]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg59 [get_bd_pins pixelTrigger_0/PresetPixel] [get_bd_pins softGlueReg32_v1_0_0/in_reg59]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg60 [get_bd_pins pixelTrigger_1/PresetPixel] [get_bd_pins softGlueReg32_v1_0_0/in_reg60]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg61 [get_bd_pins fifo_generator_1/axis_prog_full_thresh] [get_bd_pins scalersToStream_0/packetWords] [get_bd_pins softGlueReg32_v1_0_0/in_reg61]
  connect_bd_net -net softGlueReg32_v1_0_0_in_reg62 [get_bd_pins softGlueReg32_v1_0_0/in_reg62] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din]
  connect_bd_net -net softGlue_300IO_v1_0_0_irq [get_bd_pins softGlue_300IO_v1_0_0/irq] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out100 [get_bd_pins AND_1/Op1] [get_bd_pins softGlue_300IO_v1_0_0/sg_out100]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out101 [get_bd_pins AND_1/Op2] [get_bd_pins softGlue_300IO_v1_0_0/sg_out101]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out102 [get_bd_pins AND_2/Op1] [get_bd_pins softGlue_300IO_v1_0_0/sg_out102]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out103 [get_bd_pins AND_2/Op2] [get_bd_pins softGlue_300IO_v1_0_0/sg_out103]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out104 [get_bd_pins AND_3/Op1] [get_bd_pins softGlue_300IO_v1_0_0/sg_out104]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out105 [get_bd_pins AND_3/Op2] [get_bd_pins softGlue_300IO_v1_0_0/sg_out105]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out106 [get_bd_pins AND_4/Op1] [get_bd_pins softGlue_300IO_v1_0_0/sg_out106]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out107 [get_bd_pins AND_4/Op2] [get_bd_pins softGlue_300IO_v1_0_0/sg_out107]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out108 [get_bd_pins OR_1/Op1] [get_bd_pins softGlue_300IO_v1_0_0/sg_out108]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out109 [get_bd_pins OR_1/Op2] [get_bd_pins softGlue_300IO_v1_0_0/sg_out109]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out110 [get_bd_pins OR_2/Op1] [get_bd_pins softGlue_300IO_v1_0_0/sg_out110]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out111 [get_bd_pins OR_2/Op2] [get_bd_pins softGlue_300IO_v1_0_0/sg_out111]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out112 [get_bd_pins OR_3/Op1] [get_bd_pins softGlue_300IO_v1_0_0/sg_out112]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out113 [get_bd_pins OR_3/Op2] [get_bd_pins softGlue_300IO_v1_0_0/sg_out113]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out114 [get_bd_pins OR_4/Op1] [get_bd_pins softGlue_300IO_v1_0_0/sg_out114]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out115 [get_bd_pins OR_4/Op2] [get_bd_pins softGlue_300IO_v1_0_0/sg_out115]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out116 [get_bd_pins XOR_1/Op1] [get_bd_pins softGlue_300IO_v1_0_0/sg_out116]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out117 [get_bd_pins XOR_1/Op2] [get_bd_pins softGlue_300IO_v1_0_0/sg_out117]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out118 [get_bd_pins XOR_2/Op1] [get_bd_pins softGlue_300IO_v1_0_0/sg_out118]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out119 [get_bd_pins XOR_2/Op2] [get_bd_pins softGlue_300IO_v1_0_0/sg_out119]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out120 [get_bd_pins softGlue_300IO_v1_0_0/sg_in010] [get_bd_pins softGlue_300IO_v1_0_0/sg_out120]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out121 [get_bd_pins softGlue_300IO_v1_0_0/sg_in011] [get_bd_pins softGlue_300IO_v1_0_0/sg_out121]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out122 [get_bd_pins softGlue_300IO_v1_0_0/sg_in012] [get_bd_pins softGlue_300IO_v1_0_0/sg_out122]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out123 [get_bd_pins softGlue_300IO_v1_0_0/sg_in013] [get_bd_pins softGlue_300IO_v1_0_0/sg_out123]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out124 [get_bd_pins DFF_1/D] [get_bd_pins softGlue_300IO_v1_0_0/sg_out124]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out125 [get_bd_pins DFF_1/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out125]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out126 [get_bd_pins DFF_1/Set] [get_bd_pins softGlue_300IO_v1_0_0/sg_out126]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out127 [get_bd_pins DFF_1/Clear] [get_bd_pins softGlue_300IO_v1_0_0/sg_out127]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out128 [get_bd_pins DFF_2/D] [get_bd_pins softGlue_300IO_v1_0_0/sg_out128]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out129 [get_bd_pins DFF_2/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out129]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out130 [get_bd_pins DFF_2/Set] [get_bd_pins softGlue_300IO_v1_0_0/sg_out130]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out131 [get_bd_pins DFF_2/Clear] [get_bd_pins softGlue_300IO_v1_0_0/sg_out131]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out132 [get_bd_pins DFF_3/D] [get_bd_pins softGlue_300IO_v1_0_0/sg_out132]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out133 [get_bd_pins DFF_3/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out133]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out134 [get_bd_pins DFF_3/Set] [get_bd_pins softGlue_300IO_v1_0_0/sg_out134]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out135 [get_bd_pins DFF_3/Clear] [get_bd_pins softGlue_300IO_v1_0_0/sg_out135]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out136 [get_bd_pins DFF_4/D] [get_bd_pins softGlue_300IO_v1_0_0/sg_out136]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out137 [get_bd_pins DFF_4/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out137]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out138 [get_bd_pins DFF_4/Set] [get_bd_pins softGlue_300IO_v1_0_0/sg_out138]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out139 [get_bd_pins DFF_4/Clear] [get_bd_pins softGlue_300IO_v1_0_0/sg_out139]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out140 [get_bd_pins DnCntr_1/En] [get_bd_pins softGlue_300IO_v1_0_0/sg_out140]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out141 [get_bd_pins DnCntr_1/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out141]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out142 [get_bd_pins DnCntr_1/Load] [get_bd_pins softGlue_300IO_v1_0_0/sg_out142]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out143 [get_bd_pins DnCntr_2/En] [get_bd_pins softGlue_300IO_v1_0_0/sg_out143]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out144 [get_bd_pins DnCntr_2/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out144]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out145 [get_bd_pins DnCntr_2/Load] [get_bd_pins softGlue_300IO_v1_0_0/sg_out145]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out146 [get_bd_pins DnCntr_3/En] [get_bd_pins softGlue_300IO_v1_0_0/sg_out146]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out147 [get_bd_pins DnCntr_3/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out147]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out148 [get_bd_pins DnCntr_3/Load] [get_bd_pins softGlue_300IO_v1_0_0/sg_out148]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out149 [get_bd_pins DnCntr_4/En] [get_bd_pins softGlue_300IO_v1_0_0/sg_out149]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out150 [get_bd_pins DnCntr_4/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out150]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out151 [get_bd_pins DnCntr_4/Load] [get_bd_pins softGlue_300IO_v1_0_0/sg_out151]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out152 [get_bd_pins UpCntr_1/En] [get_bd_pins softGlue_300IO_v1_0_0/sg_out152]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out153 [get_bd_pins UpCntr_1/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out153]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out154 [get_bd_pins UpCntr_1/Clear] [get_bd_pins softGlue_300IO_v1_0_0/sg_out154]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out155 [get_bd_pins UpCntr_2/En] [get_bd_pins softGlue_300IO_v1_0_0/sg_out155]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out156 [get_bd_pins UpCntr_2/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out156]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out157 [get_bd_pins UpCntr_2/Clear] [get_bd_pins softGlue_300IO_v1_0_0/sg_out157]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out158 [get_bd_pins UpCntr_3/En] [get_bd_pins softGlue_300IO_v1_0_0/sg_out158]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out159 [get_bd_pins UpCntr_3/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out159]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out160 [get_bd_pins UpCntr_3/Clear] [get_bd_pins softGlue_300IO_v1_0_0/sg_out160]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out161 [get_bd_pins UpCntr_4/En] [get_bd_pins softGlue_300IO_v1_0_0/sg_out161]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out162 [get_bd_pins UpCntr_4/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out162]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out163 [get_bd_pins UpCntr_4/Clear] [get_bd_pins softGlue_300IO_v1_0_0/sg_out163]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out164 [get_bd_pins demux2_1/Inp] [get_bd_pins softGlue_300IO_v1_0_0/sg_out164]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out165 [get_bd_pins demux2_1/Sel] [get_bd_pins softGlue_300IO_v1_0_0/sg_out165]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out166 [get_bd_pins demux2_2/Inp] [get_bd_pins softGlue_300IO_v1_0_0/sg_out166]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out167 [get_bd_pins demux2_2/Sel] [get_bd_pins softGlue_300IO_v1_0_0/sg_out167]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out168 [get_bd_pins mux2_1/In0] [get_bd_pins softGlue_300IO_v1_0_0/sg_out168]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out169 [get_bd_pins mux2_1/In1] [get_bd_pins softGlue_300IO_v1_0_0/sg_out169]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out170 [get_bd_pins mux2_1/Sel] [get_bd_pins softGlue_300IO_v1_0_0/sg_out170]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out171 [get_bd_pins mux2_2/In0] [get_bd_pins softGlue_300IO_v1_0_0/sg_out171]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out172 [get_bd_pins mux2_2/In1] [get_bd_pins softGlue_300IO_v1_0_0/sg_out172]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out173 [get_bd_pins mux2_2/Sel] [get_bd_pins softGlue_300IO_v1_0_0/sg_out173]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out174 [get_bd_pins divByN_1/En] [get_bd_pins softGlue_300IO_v1_0_0/sg_out174]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out175 [get_bd_pins divByN_1/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out175]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out176 [get_bd_pins divByN_1/Reset] [get_bd_pins softGlue_300IO_v1_0_0/sg_out176]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out177 [get_bd_pins divByN_2/En] [get_bd_pins softGlue_300IO_v1_0_0/sg_out177]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out178 [get_bd_pins divByN_2/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out178]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out179 [get_bd_pins divByN_2/Reset] [get_bd_pins softGlue_300IO_v1_0_0/sg_out179]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out180 [get_bd_pins divByN_3/En] [get_bd_pins softGlue_300IO_v1_0_0/sg_out180]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out181 [get_bd_pins divByN_3/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out181]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out182 [get_bd_pins divByN_3/Reset] [get_bd_pins softGlue_300IO_v1_0_0/sg_out182]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out183 [get_bd_pins divByN_4/En] [get_bd_pins softGlue_300IO_v1_0_0/sg_out183]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out184 [get_bd_pins divByN_4/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out184]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out185 [get_bd_pins divByN_4/Reset] [get_bd_pins softGlue_300IO_v1_0_0/sg_out185]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out186 [get_bd_pins softGlue_300IO_v1_0_0/sg_out186] [get_bd_pins updncntr_1/En]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out187 [get_bd_pins softGlue_300IO_v1_0_0/sg_out187] [get_bd_pins updncntr_1/Clk]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out188 [get_bd_pins softGlue_300IO_v1_0_0/sg_out188] [get_bd_pins updncntr_1/Load]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out189 [get_bd_pins softGlue_300IO_v1_0_0/sg_out189] [get_bd_pins updncntr_1/Clear]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out190 [get_bd_pins softGlue_300IO_v1_0_0/sg_out190] [get_bd_pins updncntr_1/UpDn]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out191 [get_bd_pins softGlue_300IO_v1_0_0/sg_out191] [get_bd_pins updncntr_2/En]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out192 [get_bd_pins softGlue_300IO_v1_0_0/sg_out192] [get_bd_pins updncntr_2/Clk]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out193 [get_bd_pins softGlue_300IO_v1_0_0/sg_out193] [get_bd_pins updncntr_2/Load]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out194 [get_bd_pins softGlue_300IO_v1_0_0/sg_out194] [get_bd_pins updncntr_2/Clear]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out195 [get_bd_pins softGlue_300IO_v1_0_0/sg_out195] [get_bd_pins updncntr_2/UpDn]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out196 [get_bd_pins softGlue_300IO_v1_0_0/sg_out196] [get_bd_pins updncntr_3/En]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out197 [get_bd_pins softGlue_300IO_v1_0_0/sg_out197] [get_bd_pins updncntr_3/Clk]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out198 [get_bd_pins softGlue_300IO_v1_0_0/sg_out198] [get_bd_pins updncntr_3/Load]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out199 [get_bd_pins softGlue_300IO_v1_0_0/sg_out199] [get_bd_pins updncntr_3/Clear]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out200 [get_bd_pins softGlue_300IO_v1_0_0/sg_out200] [get_bd_pins updncntr_3/UpDn]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out201 [get_bd_pins softGlue_300IO_v1_0_0/sg_out201] [get_bd_pins updncntr_4/En]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out202 [get_bd_pins softGlue_300IO_v1_0_0/sg_out202] [get_bd_pins updncntr_4/Clk]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out203 [get_bd_pins softGlue_300IO_v1_0_0/sg_out203] [get_bd_pins updncntr_4/Load]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out204 [get_bd_pins softGlue_300IO_v1_0_0/sg_out204] [get_bd_pins updncntr_4/Clear]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out205 [get_bd_pins softGlue_300IO_v1_0_0/sg_out205] [get_bd_pins updncntr_4/UpDn]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out206 [get_bd_pins fhistoScalerStream_0/En] [get_bd_pins histoScalerStream_0/En] [get_bd_pins softGlue_300IO_v1_0_0/sg_out206]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out207 [get_bd_pins fhistoScalerStream_0/Clear] [get_bd_pins histoScalerStream_0/Clear] [get_bd_pins softGlue_300IO_v1_0_0/sg_out207]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out208 [get_bd_pins histoScalerStream_0/Ck] [get_bd_pins softGlue_300IO_v1_0_0/sg_out208]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out209 [get_bd_pins histoScalerStream_0/Sync] [get_bd_pins softGlue_300IO_v1_0_0/sg_out209]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out210 [get_bd_pins quadDec_1/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out210]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out211 [get_bd_pins quadDec_1/quadA] [get_bd_pins softGlue_300IO_v1_0_0/sg_out211]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out212 [get_bd_pins quadDec_1/quadB] [get_bd_pins softGlue_300IO_v1_0_0/sg_out212]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out213 [get_bd_pins quadDec_1/missClr] [get_bd_pins softGlue_300IO_v1_0_0/sg_out213]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out214 [get_bd_pins quadDec_2/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out214]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out215 [get_bd_pins quadDec_2/quadA] [get_bd_pins softGlue_300IO_v1_0_0/sg_out215]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out216 [get_bd_pins quadDec_2/quadB] [get_bd_pins softGlue_300IO_v1_0_0/sg_out216]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out217 [get_bd_pins quadDec_2/missClr] [get_bd_pins softGlue_300IO_v1_0_0/sg_out217]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out218 [get_bd_pins gateDly_1/Inp] [get_bd_pins softGlue_300IO_v1_0_0/sg_out218]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out219 [get_bd_pins gateDly_1/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out219]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out220 [get_bd_pins gateDly_2/Inp] [get_bd_pins softGlue_300IO_v1_0_0/sg_out220]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out221 [get_bd_pins gateDly_2/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out221]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out222 [get_bd_pins gateDly_3/Inp] [get_bd_pins softGlue_300IO_v1_0_0/sg_out222]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out223 [get_bd_pins gateDly_3/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out223]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out224 [get_bd_pins gateDly_4/Inp] [get_bd_pins softGlue_300IO_v1_0_0/sg_out224]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out225 [get_bd_pins gateDly_4/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out225]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out226 [get_bd_pins histoScalerStream_0/Det] [get_bd_pins softGlue_300IO_v1_0_0/sg_out226]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out227 [get_bd_pins freqCounter_0/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out227]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out228 [get_bd_pins scalerAND/Op2] [get_bd_pins softGlue_300IO_v1_0_0/sg_out228]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out229 [get_bd_pins scalerChan_1/Load] [get_bd_pins scalerChan_10/Clear] [get_bd_pins scalerChan_11/Clear] [get_bd_pins scalerChan_2/Clear] [get_bd_pins scalerChan_3/Clear] [get_bd_pins scalerChan_4/Clear] [get_bd_pins scalerChan_5/Clear] [get_bd_pins scalerChan_6/Clear] [get_bd_pins scalerChan_7/Clear] [get_bd_pins scalerChan_8/Clear] [get_bd_pins scalerChan_9/Clear] [get_bd_pins scalerChan_9/Preset] [get_bd_pins softGlue_300IO_v1_0_0/sg_out229]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out230 [get_bd_pins scalersToFIFO_1/chanAdv] [get_bd_pins softGlue_300IO_v1_0_0/sg_out230]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out231 [get_bd_ports FO_01] [get_bd_pins softGlue_300IO_v1_0_0/sg_out231] [get_bd_pins xlconcat_2/In16]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out232 [get_bd_ports FO_02] [get_bd_pins softGlue_300IO_v1_0_0/sg_out232] [get_bd_pins xlconcat_2/In17]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out233 [get_bd_ports FO_03] [get_bd_pins softGlue_300IO_v1_0_0/sg_out233] [get_bd_pins xlconcat_2/In18]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out234 [get_bd_ports FO_04] [get_bd_pins softGlue_300IO_v1_0_0/sg_out234] [get_bd_pins xlconcat_2/In19]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out235 [get_bd_ports FO_05] [get_bd_pins softGlue_300IO_v1_0_0/sg_out235] [get_bd_pins xlconcat_2/In20]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out236 [get_bd_ports FO_06] [get_bd_pins softGlue_300IO_v1_0_0/sg_out236] [get_bd_pins xlconcat_2/In21]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out237 [get_bd_ports FO_07] [get_bd_pins softGlue_300IO_v1_0_0/sg_out237] [get_bd_pins xlconcat_2/In22]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out238 [get_bd_ports FO_08] [get_bd_pins softGlue_300IO_v1_0_0/sg_out238] [get_bd_pins xlconcat_2/In23]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out239 [get_bd_pins mux2_5/In0] [get_bd_pins softGlue_300IO_v1_0_0/sg_out239] [get_bd_pins xlconcat_2/In24]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out240 [get_bd_pins mux2_3/In0] [get_bd_pins softGlue_300IO_v1_0_0/sg_out240] [get_bd_pins xlconcat_2/In25]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out241 [get_bd_pins mux2_4/In0] [get_bd_pins softGlue_300IO_v1_0_0/sg_out241] [get_bd_pins xlconcat_2/In26]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out242 [get_bd_pins mux2_0/In0] [get_bd_pins softGlue_300IO_v1_0_0/sg_out242] [get_bd_pins xlconcat_2/In27]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out243 [get_bd_ports FO_13] [get_bd_pins softGlue_300IO_v1_0_0/sg_out243] [get_bd_pins xlconcat_2/In28]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out244 [get_bd_ports FO_14] [get_bd_pins softGlue_300IO_v1_0_0/sg_out244] [get_bd_pins xlconcat_2/In29]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out245 [get_bd_ports FO_15] [get_bd_pins softGlue_300IO_v1_0_0/sg_out245] [get_bd_pins xlconcat_2/In30]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out246 [get_bd_ports FO_16] [get_bd_pins softGlue_300IO_v1_0_0/sg_out246] [get_bd_pins xlconcat_2/In31]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out247 [get_bd_ports FO_17] [get_bd_pins softGlue_300IO_v1_0_0/sg_out247]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out248 [get_bd_ports FO_18] [get_bd_pins softGlue_300IO_v1_0_0/sg_out248]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out249 [get_bd_ports FO_19] [get_bd_pins softGlue_300IO_v1_0_0/sg_out249]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out250 [get_bd_ports FO_20] [get_bd_pins softGlue_300IO_v1_0_0/sg_out250]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out251 [get_bd_ports FO_21] [get_bd_pins softGlue_300IO_v1_0_0/sg_out251]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out252 [get_bd_ports FO_22] [get_bd_pins softGlue_300IO_v1_0_0/sg_out252]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out253 [get_bd_ports FO_23] [get_bd_pins softGlue_300IO_v1_0_0/sg_out253]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out254 [get_bd_pins mux2_6/In0] [get_bd_pins softGlue_300IO_v1_0_0/sg_out254]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out255 [get_bd_pins pixelTrigger_0/A1] [get_bd_pins softGlue_300IO_v1_0_0/sg_out255]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out256 [get_bd_pins pixelTrigger_0/B1] [get_bd_pins softGlue_300IO_v1_0_0/sg_out256]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out257 [get_bd_pins pixelTrigger_0/A2] [get_bd_pins softGlue_300IO_v1_0_0/sg_out257]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out258 [get_bd_pins pixelTrigger_0/B2] [get_bd_pins softGlue_300IO_v1_0_0/sg_out258]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out259 [get_bd_pins pixelTrigger_0/Ck] [get_bd_pins softGlue_300IO_v1_0_0/sg_out259]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out260 [get_bd_pins pixelTrigger_0/missClr] [get_bd_pins softGlue_300IO_v1_0_0/sg_out260]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out261 [get_bd_pins pixelTrigger_0/En] [get_bd_pins softGlue_300IO_v1_0_0/sg_out261]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out262 [get_bd_pins pixelTrigger_0/Load] [get_bd_pins softGlue_300IO_v1_0_0/sg_out262]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out263 [get_bd_pins pixelTrigger_0/Clear] [get_bd_pins softGlue_300IO_v1_0_0/sg_out263]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out264 [get_bd_pins pixelTrigger_1/A1] [get_bd_pins softGlue_300IO_v1_0_0/sg_out264]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out265 [get_bd_pins pixelTrigger_1/B1] [get_bd_pins softGlue_300IO_v1_0_0/sg_out265]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out266 [get_bd_pins pixelTrigger_1/A2] [get_bd_pins softGlue_300IO_v1_0_0/sg_out266]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out267 [get_bd_pins pixelTrigger_1/B2] [get_bd_pins softGlue_300IO_v1_0_0/sg_out267]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out268 [get_bd_pins pixelTrigger_1/Ck] [get_bd_pins softGlue_300IO_v1_0_0/sg_out268]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out269 [get_bd_pins pixelTrigger_1/missClr] [get_bd_pins softGlue_300IO_v1_0_0/sg_out269]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out270 [get_bd_pins pixelTrigger_1/En] [get_bd_pins softGlue_300IO_v1_0_0/sg_out270]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out271 [get_bd_pins pixelTrigger_1/Load] [get_bd_pins softGlue_300IO_v1_0_0/sg_out271]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out272 [get_bd_pins pixelTrigger_1/Clear] [get_bd_pins softGlue_300IO_v1_0_0/sg_out272]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out273 [get_bd_pins scalersToStream_0/chanAdv] [get_bd_pins softGlue_300IO_v1_0_0/sg_out273]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out274 [get_bd_pins softGlue_300IO_v1_0_0/sg_out274] [get_bd_pins ssi_master_0/rst_n]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out275 [get_bd_pins softGlue_300IO_v1_0_0/sg_out275] [get_bd_pins ssi_master_0/readdata]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out276 [get_bd_pins softGlue_300IO_v1_0_0/sg_out276] [get_bd_pins ssi_master_0/writedata]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out277 [get_bd_pins softGlue_300IO_v1_0_0/sg_out277] [get_bd_pins ssi_master_0/ssi_ser_data]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out278 [get_bd_pins fhistoScalerStream_0/read] [get_bd_pins histoScalerStream_0/read] [get_bd_pins softGlue_300IO_v1_0_0/sg_out278]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out281 [get_bd_pins scaler_or2/Op1] [get_bd_pins softGlue_300IO_v1_0_0/sg_out281]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out282 [get_bd_pins scaler_or/Op1] [get_bd_pins softGlue_300IO_v1_0_0/sg_out282]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out283 [get_bd_pins scalerChan_1/Clk] [get_bd_pins softGlue_300IO_v1_0_0/sg_out283]
  connect_bd_net -net softGlue_300IO_v1_0_0_sg_out299 [get_bd_pins rst_processing_system7_0_100M2/aux_reset_in] [get_bd_pins softGlue_300IO_v1_0_0/sg_out299]
  connect_bd_net -net softGlue_300IO_v1_0_0_softGlueRegClockOut [get_bd_pins DFF_1/regClk] [get_bd_pins DFF_2/regClk] [get_bd_pins DFF_3/regClk] [get_bd_pins DFF_4/regClk] [get_bd_pins DnCntr_1/regClk] [get_bd_pins DnCntr_2/regClk] [get_bd_pins DnCntr_3/regClk] [get_bd_pins DnCntr_4/regClk] [get_bd_pins UpCntr_1/regClk] [get_bd_pins UpCntr_2/regClk] [get_bd_pins UpCntr_3/regClk] [get_bd_pins UpCntr_4/regClk] [get_bd_pins divByN_1/regClk] [get_bd_pins divByN_2/regClk] [get_bd_pins divByN_3/regClk] [get_bd_pins divByN_4/regClk] [get_bd_pins freqCounter_0/regClk] [get_bd_pins gateDly_1/regClk] [get_bd_pins gateDly_2/regClk] [get_bd_pins gateDly_3/regClk] [get_bd_pins gateDly_4/regClk] [get_bd_pins histoScalerStream_0/regCk] [get_bd_pins pixelTrigger_0/regClk] [get_bd_pins pixelTrigger_1/regClk] [get_bd_pins quadDec_1/regClk] [get_bd_pins quadDec_2/regClk] [get_bd_pins softGlue_300IO_v1_0_0/softGlueRegClockOut] [get_bd_pins updncntr_1/regClk] [get_bd_pins updncntr_2/regClk] [get_bd_pins updncntr_3/regClk] [get_bd_pins updncntr_4/regClk]
  connect_bd_net -net ssi_master_0_ssi_clk [get_bd_pins softGlue_300IO_v1_0_0/sg_in044] [get_bd_pins ssi_master_0/ssi_clk]
  connect_bd_net -net updncntr_1_Counts [get_bd_pins scalersToStream_0/in5] [get_bd_pins softGlueReg32_v1_0_0/out_reg4] [get_bd_pins updncntr_1/Counts]
  connect_bd_net -net updncntr_1_Q [get_bd_pins OR_5/Op1] [get_bd_pins softGlue_300IO_v1_0_0/sg_in032] [get_bd_pins updncntr_1/Q]
  connect_bd_net -net updncntr_2_Counts [get_bd_pins scalersToStream_0/in6] [get_bd_pins softGlueReg32_v1_0_0/out_reg5] [get_bd_pins updncntr_2/Counts]
  connect_bd_net -net updncntr_2_Q [get_bd_pins OR_5/Op2] [get_bd_pins softGlue_300IO_v1_0_0/sg_in033] [get_bd_pins updncntr_2/Q]
  connect_bd_net -net updncntr_3_Counts [get_bd_pins scalersToStream_0/in7] [get_bd_pins softGlueReg32_v1_0_0/out_reg6] [get_bd_pins updncntr_3/Counts]
  connect_bd_net -net updncntr_3_Q [get_bd_pins OR_6/Op1] [get_bd_pins softGlue_300IO_v1_0_0/sg_in034] [get_bd_pins updncntr_3/Q]
  connect_bd_net -net updncntr_4_Counts [get_bd_pins softGlueReg32_v1_0_0/out_reg7] [get_bd_pins updncntr_4/Counts]
  connect_bd_net -net updncntr_4_Q [get_bd_pins OR_6/Op2] [get_bd_pins softGlue_300IO_v1_0_0/sg_in035] [get_bd_pins updncntr_4/Q]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins softGlue_300IO_v1_0_0/sg_in086] [get_bd_pins util_ds_buf_0/IBUF_OUT]
  connect_bd_net -net util_ds_buf_10_IBUF_OUT [get_bd_pins softGlue_300IO_v1_0_0/sg_in096] [get_bd_pins util_ds_buf_10/IBUF_OUT]
  connect_bd_net -net util_ds_buf_11_IBUF_OUT [get_bd_pins softGlue_300IO_v1_0_0/sg_in097] [get_bd_pins util_ds_buf_11/IBUF_OUT]
  connect_bd_net -net util_ds_buf_1_IBUF_OUT [get_bd_pins softGlue_300IO_v1_0_0/sg_in087] [get_bd_pins util_ds_buf_1/IBUF_OUT]
  connect_bd_net -net util_ds_buf_2_IBUF_OUT [get_bd_pins softGlue_300IO_v1_0_0/sg_in088] [get_bd_pins util_ds_buf_2/IBUF_OUT]
  connect_bd_net -net util_ds_buf_3_IBUF_OUT [get_bd_pins softGlue_300IO_v1_0_0/sg_in089] [get_bd_pins util_ds_buf_3/IBUF_OUT]
  connect_bd_net -net util_ds_buf_4_IBUF_OUT [get_bd_pins softGlue_300IO_v1_0_0/sg_in090] [get_bd_pins util_ds_buf_4/IBUF_OUT]
  connect_bd_net -net util_ds_buf_5_IBUF_OUT [get_bd_pins softGlue_300IO_v1_0_0/sg_in091] [get_bd_pins util_ds_buf_5/IBUF_OUT]
  connect_bd_net -net util_ds_buf_6_IBUF_OUT [get_bd_pins softGlue_300IO_v1_0_0/sg_in092] [get_bd_pins util_ds_buf_6/IBUF_OUT]
  connect_bd_net -net util_ds_buf_7_IBUF_OUT [get_bd_pins softGlue_300IO_v1_0_0/sg_in093] [get_bd_pins util_ds_buf_7/IBUF_OUT]
  connect_bd_net -net util_ds_buf_8_IBUF_OUT [get_bd_pins softGlue_300IO_v1_0_0/sg_in094] [get_bd_pins util_ds_buf_8/IBUF_OUT]
  connect_bd_net -net util_ds_buf_9_IBUF_OUT [get_bd_pins softGlue_300IO_v1_0_0/sg_in095] [get_bd_pins util_ds_buf_9/IBUF_OUT]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins fifo_generator_1/s_aresetn] [get_bd_pins rst_processing_system7_0_100M2/peripheral_aresetn] [get_bd_pins scalersToStream_0/tlastResetN]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins softGlue_300IO_v1_0_0/int_from_logic] [get_bd_pins xlconcat_2/dout]
  connect_bd_net -net xlconcat_3_dout [get_bd_pins scalersToStream_0/in0] [get_bd_pins xlconcat_3/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins DFF_5/D] [get_bd_pins DFF_5/Set] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins DFF_6/Clk] [get_bd_pins DFF_6/D] [get_bd_pins scalerChan_1/Clear] [get_bd_pins scalerChan_1/UpDn] [get_bd_pins scalerChan_10/Load] [get_bd_pins scalerChan_11/Load] [get_bd_pins scalerChan_12/Load] [get_bd_pins scalerChan_13/Load] [get_bd_pins scalerChan_14/Load] [get_bd_pins scalerChan_15/Load] [get_bd_pins scalerChan_16/Load] [get_bd_pins scalerChan_2/Load] [get_bd_pins scalerChan_3/Load] [get_bd_pins scalerChan_4/Load] [get_bd_pins scalerChan_5/Load] [get_bd_pins scalerChan_6/Load] [get_bd_pins scalerChan_7/Load] [get_bd_pins scalerChan_8/Load] [get_bd_pins scalerChan_9/Load] [get_bd_pins zero/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins streamMux_0/Sel] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins mux2_5/Sel] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins mux2_3/Sel] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins mux2_4/Sel] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins mux2_0/Sel] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins mux2_6/Sel] [get_bd_pins xlslice_5/Dout]

  # Create address segments
  create_bd_addr_seg -range 0x40000000 -offset 0x0 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x0 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x10000 -offset 0x40400000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] SEG_axi_dma_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C50000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs clk_wiz0_0_0/s_axi_lite/Reg] SEG_clk_wiz_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C40000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs clk_wiz1_0_0/s_axi_lite/Reg] SEG_clk_wiz_1_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C30000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs pixelFIFO_v1_0_0/s00_axi/reg0] SEG_pixelFIFO_v1_0_0_reg0
  create_bd_addr_seg -range 0x10000 -offset 0x43C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs softGlueReg32_v1_0_0/s00_axi/reg0] SEG_softGlueReg32_v1_0_0_reg0
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs softGlue_300IO_v1_0_0/s00_axi/reg0] SEG_softGlue_300IO_v1_0_0_reg0
  create_bd_addr_seg -range 0x10000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs softGlue_300IO_v1_0_0/s_axi_intr/reg0] SEG_softGlue_300IO_v1_0_0_reg01

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port FO_10 -pg 1 -y 10310 -defaultsOSRD
preplace port FO_11 -pg 1 -y 10330 -defaultsOSRD
preplace port FI_10 -pg 1 -y 9950 -defaultsOSRD
preplace port FO_12 -pg 1 -y 10350 -defaultsOSRD
preplace port FI_11 -pg 1 -y 9970 -defaultsOSRD
preplace port FI_12 -pg 1 -y 9990 -defaultsOSRD
preplace port FO_13 -pg 1 -y 10370 -defaultsOSRD
preplace port FI_13 -pg 1 -y 10010 -defaultsOSRD
preplace port FO_14 -pg 1 -y 10390 -defaultsOSRD
preplace port FO_15 -pg 1 -y 10410 -defaultsOSRD
preplace port FI_14 -pg 1 -y 10030 -defaultsOSRD
preplace port FI_15 -pg 1 -y 10050 -defaultsOSRD
preplace port FO_16 -pg 1 -y 10430 -defaultsOSRD
preplace port FI_16 -pg 1 -y 10070 -defaultsOSRD
preplace port FO_17 -pg 1 -y 10450 -defaultsOSRD
preplace port FI_17 -pg 1 -y 10090 -defaultsOSRD
preplace port FO_18 -pg 1 -y 10470 -defaultsOSRD
preplace port FI_18 -pg 1 -y 10110 -defaultsOSRD
preplace port FO_19 -pg 1 -y 10490 -defaultsOSRD
preplace port FI_19 -pg 1 -y 10130 -defaultsOSRD
preplace port FIXED_IO -pg 1 -lvl 2:120 -defaultsOSRD -bot
preplace port FO_01 -pg 1 -y 10130 -defaultsOSRD
preplace port FO_02 -pg 1 -y 10150 -defaultsOSRD
preplace port FO_03 -pg 1 -y 10170 -defaultsOSRD
preplace port FO_04 -pg 1 -y 10190 -defaultsOSRD
preplace port FO_05 -pg 1 -y 10210 -defaultsOSRD
preplace port FI_20 -pg 1 -y 10150 -defaultsOSRD
preplace port FO_06 -pg 1 -y 10230 -defaultsOSRD
preplace port FI_21 -pg 1 -y 10170 -defaultsOSRD
preplace port FO_07 -pg 1 -y 10250 -defaultsOSRD
preplace port DDR -pg 1 -lvl 2:90 -defaultsOSRD -bot
preplace port FI_22 -pg 1 -y 10190 -defaultsOSRD
preplace port FO_08 -pg 1 -y 10270 -defaultsOSRD
preplace port FO_09 -pg 1 -y 10290 -defaultsOSRD
preplace port FI_23 -pg 1 -y 10210 -defaultsOSRD
preplace port FI_24 -pg 1 -y 10230 -defaultsOSRD
preplace port FI_01 -pg 1 -y 9770 -defaultsOSRD
preplace port FO_20 -pg 1 -y 10510 -defaultsOSRD
preplace port FI_02 -pg 1 -y 9790 -defaultsOSRD
preplace port FO_21 -pg 1 -y 10530 -defaultsOSRD
preplace port FI_03 -pg 1 -y 9810 -defaultsOSRD
preplace port FO_22 -pg 1 -y 10550 -defaultsOSRD
preplace port FO_23 -pg 1 -y 10570 -defaultsOSRD
preplace port FI_04 -pg 1 -y 9830 -defaultsOSRD
preplace port FI_05 -pg 1 -y 9850 -defaultsOSRD
preplace port FO_24 -pg 1 -y 10590 -defaultsOSRD
preplace port FI_06 -pg 1 -y 9870 -defaultsOSRD
preplace port FI_07 -pg 1 -y 9890 -defaultsOSRD
preplace port FI_08 -pg 1 -y 9910 -defaultsOSRD
preplace port FI_09 -pg 1 -y 9930 -defaultsOSRD
preplace portBus FI_diff_N32 -pg 1 -y 11210 -defaultsOSRD
preplace portBus FI_diff_N26 -pg 1 -y 10910 -defaultsOSRD
preplace portBus FI_diff_N33 -pg 1 -y 11260 -defaultsOSRD
preplace portBus FI_diff_N27 -pg 1 -y 10960 -defaultsOSRD
preplace portBus FI_diff_N34 -pg 1 -y 11310 -defaultsOSRD
preplace portBus FI_diff_P30 -pg 1 -y 11090 -defaultsOSRD
preplace portBus FI_diff_N28 -pg 1 -y 11010 -defaultsOSRD
preplace portBus FI_diff_N35 -pg 1 -y 11360 -defaultsOSRD
preplace portBus FI_diff_P31 -pg 1 -y 11140 -defaultsOSRD
preplace portBus FI_diff_N29 -pg 1 -y 11060 -defaultsOSRD
preplace portBus FI_diff_P25 -pg 1 -y 10840 -defaultsOSRD
preplace portBus FI_diff_N36 -pg 1 -y 11410 -defaultsOSRD
preplace portBus FI_diff_P32 -pg 1 -y 11190 -defaultsOSRD
preplace portBus FI_diff_P26 -pg 1 -y 10890 -defaultsOSRD
preplace portBus FI_diff_P33 -pg 1 -y 11240 -defaultsOSRD
preplace portBus FI_diff_P27 -pg 1 -y 10940 -defaultsOSRD
preplace portBus FI_diff_P34 -pg 1 -y 11290 -defaultsOSRD
preplace portBus FI_diff_P28 -pg 1 -y 10990 -defaultsOSRD
preplace portBus FI_diff_P35 -pg 1 -y 11340 -defaultsOSRD
preplace portBus FI_diff_P29 -pg 1 -y 11040 -defaultsOSRD
preplace portBus FI_diff_P36 -pg 1 -y 11390 -defaultsOSRD
preplace portBus FI_diff_N30 -pg 1 -y 11110 -defaultsOSRD
preplace portBus FI_diff_N31 -pg 1 -y 11160 -defaultsOSRD
preplace portBus FI_diff_N25 -pg 1 -y 10860 -defaultsOSRD
preplace inst OR_1 -pg 1 -lvl 13 -y 7640 -defaultsOSRD
preplace inst divByN_2 -pg 1 -lvl 15 -y 9090 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 8 -y 11170 -defaultsOSRD
preplace inst OR_2 -pg 1 -lvl 15 -y 7660 -defaultsOSRD
preplace inst divByN_3 -pg 1 -lvl 25 -y 9120 -defaultsOSRD
preplace inst OR_3 -pg 1 -lvl 25 -y 7670 -defaultsOSRD
preplace inst updncntr_1 -pg 1 -lvl 13 -y 9320 -defaultsOSRD
preplace inst divByN_4 -pg 1 -lvl 27 -y 9150 -defaultsOSRD
preplace inst updncntr_2 -pg 1 -lvl 15 -y 9380 -defaultsOSRD
preplace inst OR_4 -pg 1 -lvl 27 -y 7690 -defaultsOSRD
preplace inst scalersToFIFO_1 -pg 1 -lvl 23 -y 11930 -defaultsOSRD
preplace inst updncntr_3 -pg 1 -lvl 25 -y 9400 -defaultsOSRD
preplace inst OR_5 -pg 1 -lvl 14 -y 9380 -defaultsOSRD
preplace inst scalerAND -pg 1 -lvl 19 -y 11630 -defaultsOSRD
preplace inst updncntr_4 -pg 1 -lvl 28 -y 9410 -defaultsOSRD
preplace inst OR_6 -pg 1 -lvl 26 -y 9420 -defaultsOSRD
preplace inst OR_7 -pg 1 -lvl 15 -y 10890 -defaultsOSRD
preplace inst scalerChan_1 -pg 1 -lvl 20 -y 11620 -defaultsOSRD
preplace inst scalerChan_2 -pg 1 -lvl 20 -y 11850 -defaultsOSRD
preplace inst demux2_1 -pg 1 -lvl 13 -y 8820 -defaultsOSRD
preplace inst gateDelayFast_1 -pg 1 -lvl 13 -y 10250 -defaultsOSRD
preplace inst scalerChan_3 -pg 1 -lvl 20 -y 12050 -defaultsOSRD
preplace inst demux2_2 -pg 1 -lvl 15 -y 8850 -defaultsOSRD
preplace inst AND_0 -pg 1 -lvl 19 -y 10890 -defaultsOSRD
preplace inst gateDelayFast_2 -pg 1 -lvl 15 -y 10330 -defaultsOSRD
preplace inst scalerChan_4 -pg 1 -lvl 20 -y 12260 -defaultsOSRD
preplace inst rst_processing_system7_0_100M1 -pg 1 -lvl 8 -y 10690 -defaultsOSRD
preplace inst DnCntr_1 -pg 1 -lvl 13 -y 8290 -defaultsOSRD
preplace inst AND_1 -pg 1 -lvl 13 -y 7460 -defaultsOSRD
preplace inst mux2_0 -pg 1 -lvl 30 -y 10360 -defaultsOSRD
preplace inst scalerChan_5 -pg 1 -lvl 20 -y 12460 -defaultsOSRD
preplace inst rst_processing_system7_0_100M2 -pg 1 -lvl 8 -y 10900 -defaultsOSRD
preplace inst gateDelayFast_3 -pg 1 -lvl 3 -y 11950 -defaultsOSRD
preplace inst DnCntr_2 -pg 1 -lvl 15 -y 8410 -defaultsOSRD
preplace inst AND_2 -pg 1 -lvl 15 -y 7500 -defaultsOSRD
preplace inst scalerChan_6 -pg 1 -lvl 20 -y 12660 -defaultsOSRD
preplace inst gateDelayFast_4 -pg 1 -lvl 3 -y 12130 -defaultsOSRD
preplace inst mux2_1 -pg 1 -lvl 25 -y 8870 -defaultsOSRD
preplace inst AND_3 -pg 1 -lvl 25 -y 7500 -defaultsOSRD
preplace inst DnCntr_3 -pg 1 -lvl 25 -y 8420 -defaultsOSRD
preplace inst scalerChan_7 -pg 1 -lvl 20 -y 12860 -defaultsOSRD
preplace inst mux2_2 -pg 1 -lvl 27 -y 8880 -defaultsOSRD
preplace inst AND_4 -pg 1 -lvl 27 -y 7500 -defaultsOSRD
preplace inst DnCntr_4 -pg 1 -lvl 27 -y 8450 -defaultsOSRD
preplace inst mux2_3 -pg 1 -lvl 30 -y 10060 -defaultsOSRD
preplace inst scalerChan_8 -pg 1 -lvl 20 -y 13060 -defaultsOSRD
preplace inst softGlueReg32_v1_0_0 -pg 1 -lvl 29 -y 11160 -defaultsOSRD
preplace inst mux2_4 -pg 1 -lvl 30 -y 10220 -defaultsOSRD
preplace inst scalerChan_9 -pg 1 -lvl 22 -y 11610 -defaultsOSRD
preplace inst softGlue_300IO_v1_0_0 -pg 1 -lvl 11 -y 8070 -defaultsOSRD
preplace inst mux2_5 -pg 1 -lvl 30 -y 9940 -defaultsOSRD
preplace inst gateDly_1 -pg 1 -lvl 13 -y 10050 -defaultsOSRD
preplace inst mux2_6 -pg 1 -lvl 30 -y 10620 -defaultsOSRD
preplace inst clk_wiz1_0_0 -pg 1 -lvl 9 -y 11840 -defaultsOSRD
preplace inst scalerChan_10 -pg 1 -lvl 22 -y 11810 -defaultsOSRD
preplace inst gateDly_2 -pg 1 -lvl 15 -y 10040 -defaultsOSRD
preplace inst pixelTrigger_0 -pg 1 -lvl 14 -y 10730 -defaultsOSRD
preplace inst DFF_1 -pg 1 -lvl 13 -y 8040 -defaultsOSRD
preplace inst scalerChan_11 -pg 1 -lvl 22 -y 12030 -defaultsOSRD
preplace inst histoScalerStream_0 -pg 1 -lvl 4 -y 11730 -defaultsOSRD
preplace inst ssi_master_0 -pg 1 -lvl 12 -y 9830 -defaultsOSRD
preplace inst gateDly_3 -pg 1 -lvl 25 -y 10040 -defaultsOSRD
preplace inst pixelTrigger_1 -pg 1 -lvl 14 -y 11330 -defaultsOSRD
preplace inst DFF_2 -pg 1 -lvl 15 -y 8080 -defaultsOSRD
preplace inst scalerChan_12 -pg 1 -lvl 22 -y 12230 -defaultsOSRD
preplace inst gateDly_4 -pg 1 -lvl 27 -y 10060 -defaultsOSRD
preplace inst DFF_3 -pg 1 -lvl 25 -y 8090 -defaultsOSRD
preplace inst scalerChan_13 -pg 1 -lvl 22 -y 12430 -defaultsOSRD
preplace inst DFF_4 -pg 1 -lvl 27 -y 8090 -defaultsOSRD
preplace inst scalerChan_14 -pg 1 -lvl 22 -y 12630 -defaultsOSRD
preplace inst DFF_5 -pg 1 -lvl 21 -y 10760 -defaultsOSRD
preplace inst scalerChan_15 -pg 1 -lvl 22 -y 12830 -defaultsOSRD
preplace inst UpCntr_1 -pg 1 -lvl 13 -y 8620 -defaultsOSRD
preplace inst DFF_6 -pg 1 -lvl 18 -y 11690 -defaultsOSRD
preplace inst scalerChan_16 -pg 1 -lvl 22 -y 13030 -defaultsOSRD
preplace inst UpCntr_2 -pg 1 -lvl 15 -y 8670 -defaultsOSRD
preplace inst fifo_generator_1 -pg 1 -lvl 6 -y 11540 -defaultsOSRD
preplace inst UpCntr_3 -pg 1 -lvl 25 -y 8700 -defaultsOSRD
preplace inst UpCntr_4 -pg 1 -lvl 27 -y 8680 -defaultsOSRD
preplace inst xlconcat_1 -pg 1 -lvl 8 -y 11470 -defaultsOSRD
preplace inst xlconcat_2 -pg 1 -lvl 10 -y 10830 -defaultsOSRD
preplace inst freqCounter_0 -pg 1 -lvl 29 -y 8670 -defaultsOSRD
preplace inst xlconcat_3 -pg 1 -lvl 15 -y 11340 -defaultsOSRD
preplace inst util_ds_buf_0 -pg 1 -lvl 1 -y 10340 -defaultsOSRD
preplace inst XOR_1 -pg 1 -lvl 13 -y 7850 -defaultsOSRD
preplace inst XOR_2 -pg 1 -lvl 15 -y 7910 -defaultsOSRD
preplace inst util_ds_buf_10 -pg 1 -lvl 1 -y 11800 -defaultsOSRD
preplace inst clk_wiz0_0_0 -pg 1 -lvl 9 -y 11540 -defaultsOSRD
preplace inst util_ds_buf_1 -pg 1 -lvl 1 -y 10460 -defaultsOSRD
preplace inst scaler_or1 -pg 1 -lvl 17 -y 11750 -defaultsOSRD
preplace inst scaler_or -pg 1 -lvl 16 -y 11740 -defaultsOSRD
preplace inst util_ds_buf_11 -pg 1 -lvl 1 -y 11060 -defaultsOSRD
preplace inst util_ds_buf_2 -pg 1 -lvl 1 -y 12420 -defaultsOSRD
preplace inst scaler_or2 -pg 1 -lvl 17 -y 11670 -defaultsOSRD
preplace inst util_ds_buf_3 -pg 1 -lvl 1 -y 10580 -defaultsOSRD
preplace inst xlslice_0 -pg 1 -lvl 29 -y 11800 -defaultsOSRD
preplace inst util_ds_buf_4 -pg 1 -lvl 1 -y 12300 -defaultsOSRD
preplace inst xlconstant_0 -pg 1 -lvl 19 -y 10730 -defaultsOSRD
preplace inst xlslice_1 -pg 1 -lvl 29 -y 11880 -defaultsOSRD
preplace inst zero -pg 1 -lvl 19 -y 11720 -defaultsOSRD
preplace inst util_ds_buf_5 -pg 1 -lvl 1 -y 11520 -defaultsOSRD
preplace inst xlslice_2 -pg 1 -lvl 29 -y 11960 -defaultsOSRD
preplace inst pixelFIFO_v1_0_0 -pg 1 -lvl 24 -y 11820 -defaultsOSRD
preplace inst quadDec_1 -pg 1 -lvl 13 -y 9720 -defaultsOSRD
preplace inst util_ds_buf_6 -pg 1 -lvl 1 -y 10700 -defaultsOSRD
preplace inst xlslice_3 -pg 1 -lvl 29 -y 12050 -defaultsOSRD
preplace inst scalersToStream_0 -pg 1 -lvl 4 -y 11320 -defaultsOSRD
preplace inst quadDec_2 -pg 1 -lvl 15 -y 9750 -defaultsOSRD
preplace inst util_ds_buf_7 -pg 1 -lvl 1 -y 10820 -defaultsOSRD
preplace inst xlslice_4 -pg 1 -lvl 29 -y 12130 -defaultsOSRD
preplace inst fhistoScalerStream_0 -pg 1 -lvl 4 -y 11980 -defaultsOSRD
preplace inst util_ds_buf_8 -pg 1 -lvl 1 -y 10940 -defaultsOSRD
preplace inst axi_dma_0 -pg 1 -lvl 7 -y 11460 -defaultsOSRD
preplace inst xlslice_5 -pg 1 -lvl 29 -y 12210 -defaultsOSRD
preplace inst one -pg 1 -lvl 19 -y 11870 -defaultsOSRD
preplace inst streamMux_0 -pg 1 -lvl 5 -y 11570 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 8 -y 10300 -defaultsOSRD
preplace inst util_ds_buf_9 -pg 1 -lvl 1 -y 12160 -defaultsOSRD
preplace inst divByN_1 -pg 1 -lvl 13 -y 8990 -defaultsOSRD
preplace inst axi_interconnect_0 -pg 1 -lvl 7 -y 10850 -defaultsOSRD
preplace netloc scalerChan_10_Counts 1 22 1 12180
preplace netloc softGlue_300IO_v1_0_0_sg_out104 1 11 14 NJ 6140 NJ 6140 NJ 6140 NJ 6140 NJ 6140 NJ 6140 NJ 6140 NJ 6140 NJ 6140 NJ 6140 NJ 6140 NJ 6140 NJ 6140 NJ
preplace netloc scalerChan_16_Counts 1 22 1 12290
preplace netloc softGlue_300IO_v1_0_0_sg_out105 1 11 14 NJ 6160 NJ 6160 NJ 6160 NJ 6160 NJ 6160 NJ 6160 NJ 6160 NJ 6160 NJ 6160 NJ 6160 NJ 6160 NJ 6160 NJ 6160 NJ
preplace netloc xlconstant_1_dout 1 17 5 10650 11570 NJ 11570 11180 13170 NJ 13030 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out106 1 11 16 NJ 6180 NJ 6180 NJ 6180 NJ 6180 NJ 6180 NJ 6180 NJ 6180 NJ 6180 NJ 6180 NJ 6180 NJ 6180 NJ 6180 NJ 6180 NJ 6180 NJ 6180 NJ
preplace netloc FI_23_1 1 0 11 NJ 8540 NJ 8540 NJ 8540 NJ 8540 NJ 8540 NJ 8540 NJ 8540 NJ 8540 NJ 8540 NJ 8540 N
preplace netloc softGlue_300IO_v1_0_0_sg_out107 1 11 16 NJ 6200 NJ 6200 NJ 6200 NJ 6200 NJ 6200 NJ 6200 NJ 6200 NJ 6200 NJ 6200 NJ 6200 NJ 6200 NJ 6200 NJ 6200 NJ 6200 NJ 6200 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out108 1 11 2 N 6220 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out109 1 11 2 N 6240 NJ
preplace netloc processing_system7_0_FCLK_RESET0_N 1 7 2 -1590 10810 -1100
preplace netloc xlconcat_1_dout 1 7 2 -1590 11540 -1100
preplace netloc updncntr_1_Counts 1 3 26 NJ 11560 NJ 11730 NJ 11690 NJ 11690 NJ 11690 NJ 11700 NJ 11700 NJ 11700 NJ 9160 NJ 9160 NJ 9270 NJ 9270 NJ 9270 NJ 9270 NJ 9270 NJ 9270 NJ 9270 NJ 9270 NJ 9270 NJ 9270 NJ 9270 NJ 9270 NJ 9270 NJ 9270 NJ 9270 NJ
preplace netloc DFF_6_Q 1 10 9 530 11550 NJ 11550 NJ 11550 NJ 11550 NJ 11550 NJ 11550 NJ 11550 NJ 11550 10810
preplace netloc pixelTrigger_1_Trig 1 10 5 NJ 10750 NJ 10750 NJ 10750 NJ 10520 7390
preplace netloc scalerChan_14_Counts 1 22 1 12270
preplace netloc axi_dma_0_mm2s_introut 1 7 1 -1700
preplace netloc DnCntr_1_Counts 1 13 16 NJ 8280 NJ 8280 NJ 8280 NJ 8280 NJ 8280 NJ 8280 NJ 8280 NJ 8280 NJ 8280 NJ 8280 NJ 8280 NJ 8280 NJ 8280 NJ 8280 NJ 8280 NJ
preplace netloc XOR_1_Res 1 10 4 NJ 10660 NJ 10650 NJ 10650 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out200 1 11 14 NJ 8410 NJ 8410 NJ 8320 NJ 8320 NJ 8320 NJ 8320 NJ 8320 NJ 8320 NJ 8320 NJ 8320 NJ 8320 NJ 8320 NJ 8320 NJ
preplace netloc gateDelayFast_4_Q 1 3 27 -4280 12100 NJ 12100 NJ 12100 NJ 12100 NJ 12100 NJ 12100 NJ 12100 NJ 12100 NJ 10670 NJ 10670 NJ 10390 NJ 10630 NJ 10360 NJ 10360 NJ 10360 NJ 10360 NJ 10360 NJ 10360 NJ 10360 NJ 10360 NJ 10360 NJ 10360 NJ 10360 NJ 10360 NJ 10360 NJ 10360 NJ
preplace netloc scalersToFIFO_1_wrtCk 1 10 14 NJ 10960 NJ 10960 NJ 10960 NJ 10960 NJ 10960 NJ 10940 NJ 10940 NJ 10940 NJ 10960 NJ 10960 NJ 10960 NJ 10960 NJ 10960 NJ
preplace netloc OR_1_Res 1 10 4 NJ 10640 NJ 10570 NJ 10570 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out201 1 11 17 NJ 8080 NJ 8170 NJ 8170 NJ 8190 NJ 8190 NJ 8190 NJ 8190 NJ 8190 NJ 8190 NJ 8190 NJ 8190 NJ 8190 NJ 8190 NJ 8190 NJ 8190 NJ 8190 NJ
preplace netloc IBUF_DS_P_10_1 1 0 1 NJ
preplace netloc quadDec_1_miss 1 10 4 NJ 10870 NJ 10870 NJ 10870 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out202 1 11 17 NJ 8100 NJ 8130 NJ 8120 NJ 7970 NJ 7970 NJ 7970 NJ 7970 NJ 7970 NJ 7970 NJ 7970 NJ 7970 NJ 7970 NJ 7970 NJ 7970 NJ 7970 NJ 7970 NJ
preplace netloc sg_in057_1 1 0 20 NJ 9870 NJ 9870 NJ 9870 NJ 9870 NJ 9870 NJ 9870 NJ 9870 NJ 9870 NJ 9870 NJ 9870 NJ 12640 NJ 12640 NJ 12640 NJ 12640 NJ 12640 NJ 12640 NJ 12640 NJ 12640 NJ 12640 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out203 1 11 17 NJ 8190 NJ 8190 NJ 8190 NJ 8200 NJ 8200 NJ 8200 NJ 8200 NJ 8200 NJ 8200 NJ 8200 NJ 8200 NJ 8200 NJ 8200 NJ 8200 NJ 8200 NJ 8200 NJ
preplace netloc scalersToStream_0_chanAdvDone 1 4 7 NJ 8740 NJ 8740 NJ 8740 NJ 8740 NJ 8740 NJ 8740 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out204 1 11 17 NJ 8140 NJ 8150 NJ 8150 NJ 7990 NJ 7990 NJ 7990 NJ 7990 NJ 7990 NJ 7990 NJ 7990 NJ 7990 NJ 7990 NJ 7990 NJ 7990 NJ 7990 NJ 7990 NJ
preplace netloc FI_24_1 1 0 11 NJ 8560 NJ 8560 NJ 8560 NJ 8560 NJ 8560 NJ 8560 NJ 8560 NJ 8560 NJ 8560 NJ 8560 N
preplace netloc AND_0_Res 1 10 10 NJ 10610 NJ 10430 NJ 10430 NJ 10430 NJ 10660 NJ 10660 NJ 10660 NJ 10660 NJ 10660 NJ
preplace netloc divByN_2_Q 1 10 6 NJ 10350 NJ 10350 NJ 10350 NJ 10290 NJ 10700 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out205 1 11 17 NJ 8160 NJ 8160 NJ 8160 NJ 7980 NJ 7980 NJ 7980 NJ 7980 NJ 7980 NJ 7980 NJ 7980 NJ 7980 NJ 7980 NJ 7980 NJ 7960 NJ 7960 NJ 7960 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out206 1 3 9 NJ 11860 NJ 11860 NJ 11750 NJ 11750 NJ 11750 NJ 11750 NJ 11750 NJ 11750 NJ
preplace netloc util_ds_buf_8_IBUF_OUT 1 1 10 -9690 8940 NJ 8940 NJ 8940 NJ 8940 NJ 8940 NJ 8940 NJ 8940 NJ 8940 NJ 8940 NJ
preplace netloc sg_in072_1 1 0 11 NJ 8500 NJ 8500 NJ 8500 NJ 8500 NJ 8500 NJ 8500 NJ 8500 NJ 8500 NJ 8500 NJ 8500 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out207 1 3 9 NJ 11850 NJ 11850 NJ 11760 NJ 11760 NJ 11760 NJ 11760 NJ 11760 NJ 11760 NJ
preplace netloc scalerChan_1_Counts 1 20 3 NJ 11520 NJ 11490 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out208 1 3 9 NJ 10010 NJ 10010 NJ 10010 NJ 10010 NJ 10000 NJ 10000 NJ 10000 NJ 10170 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out170 1 11 14 NJ 7550 NJ 7550 NJ 7550 NJ 7560 NJ 7560 NJ 7560 NJ 7560 NJ 7560 NJ 7560 NJ 7560 NJ 7560 NJ 7560 NJ 7560 NJ
preplace netloc scalerAND_Res 1 19 3 11280 11500 NJ 11500 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out209 1 3 9 NJ 10030 NJ 10030 NJ 10030 NJ 10030 NJ 10010 NJ 10250 NJ 10250 NJ 10250 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out171 1 11 16 NJ 7480 NJ 7540 NJ 7540 NJ 7570 NJ 7570 NJ 7570 NJ 7570 NJ 7570 NJ 7570 NJ 7570 NJ 7570 NJ 7570 NJ 7570 NJ 7570 NJ 7570 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out172 1 11 16 NJ 7500 NJ 7530 NJ 7440 NJ 7440 NJ 7440 NJ 7440 NJ 7440 NJ 7440 NJ 7440 NJ 7440 NJ 7440 NJ 7440 NJ 7440 NJ 7440 NJ 7440 NJ
preplace netloc mux2_3_Outp 1 30 1 16120
preplace netloc softGlue_300IO_v1_0_0_sg_out173 1 11 16 NJ 7520 NJ 7770 NJ 7770 NJ 7770 NJ 7770 NJ 7770 NJ 7770 NJ 7770 NJ 7770 NJ 7770 NJ 7770 NJ 7770 NJ 7770 NJ 7770 NJ 7770 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out299 1 7 5 -1600 10600 NJ 10430 NJ 10430 NJ 10430 1260
preplace netloc softGlue_300IO_v1_0_0_sg_out174 1 11 2 NJ 7540 2770
preplace netloc softGlue_300IO_v1_0_0_sg_out175 1 11 2 NJ 7570 2740
preplace netloc IBUF_DS_P_2_1 1 0 1 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out176 1 11 2 NJ 7580 2720
preplace netloc softGlue_300IO_v1_0_0_sg_out177 1 11 4 NJ 7600 NJ 7710 NJ 7710 NJ
preplace netloc processing_system7_0_FIXED_IO 1 2 7 -9330 7410 NJ 7410 NJ 7410 NJ 7410 NJ 7410 NJ 7410 -1070
preplace netloc softGlue_300IO_v1_0_0_sg_out178 1 11 4 NJ 7590 NJ 7570 NJ 7570 NJ
preplace netloc OR_3_Res 1 10 16 NJ 10590 NJ 10580 NJ 10580 NJ 10370 NJ 10520 NJ 10520 NJ 10520 NJ 10520 NJ 10500 NJ 10500 NJ 10500 NJ 10500 NJ 10500 NJ 10500 NJ 10500 NJ
preplace netloc DnCntr_2_Counts 1 15 14 NJ 8330 NJ 8330 NJ 8330 NJ 8330 NJ 8330 NJ 8330 NJ 8330 NJ 8330 NJ 8330 NJ 8330 NJ 8330 NJ 8330 NJ 8330 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out210 1 11 2 NJ 8260 2560
preplace netloc softGlue_300IO_v1_0_0_sg_out179 1 11 4 NJ 7560 NJ 7560 NJ 7560 NJ
preplace netloc fifo_generator_1_M_AXIS 1 6 1 -2190
preplace netloc scalerChan_2_Counts 1 20 3 NJ 11840 NJ 11920 NJ
preplace netloc DnCntr_1_Q 1 10 4 NJ 10520 NJ 10520 NJ 10520 NJ
preplace netloc clk_wiz_0_clk_out1 1 9 2 -650 7040 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out211 1 11 2 NJ 8280 2570
preplace netloc clk_wiz_0_clk_out2 1 9 2 -630 7960 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out212 1 11 2 NJ 8300 2550
preplace netloc UpCntr_4_Counts 1 3 26 NJ 11530 NJ 11720 NJ 11720 NJ 11720 NJ 11720 NJ 11720 NJ 11720 NJ 11720 NJ 10160 NJ 10160 NJ 10110 NJ 10580 NJ 10580 NJ 10580 NJ 10580 NJ 10580 NJ 10580 NJ 10580 NJ 10580 NJ 10580 NJ 10580 NJ 10580 NJ 10580 NJ 10580 NJ 10580 NJ
preplace netloc clk_wiz_0_clk_out3 1 9 2 -610 7980 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out213 1 11 2 NJ 8320 2520
preplace netloc clk_wiz_0_clk_out4 1 9 2 -590 8000 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out214 1 11 4 NJ 8200 NJ 8200 NJ 8200 NJ
preplace netloc IBUF_DS_N_1_1 1 0 1 NJ
preplace netloc scalersToFIFO_1_outReg 1 23 1 12550
preplace netloc clk_wiz_0_clk_out5 1 2 13 -9290 11860 NJ 11610 NJ 11790 NJ 11790 NJ 11790 NJ 11790 NJ 11660 NJ 11560 NJ 11560 1700 10360 2870 10360 NJ 10220 NJ
preplace netloc softGlue_300IO_v1_0_0_softGlueRegClockOut 1 3 26 NJ 11140 NJ 11140 NJ 11140 NJ 11140 NJ 11390 NJ 11390 NJ 11390 NJ 11390 NJ 8000 NJ 10880 NJ 10080 NJ 10170 NJ 10000 NJ 10000 NJ 10000 NJ 10000 NJ 10000 NJ 10000 NJ 10000 NJ 10000 NJ 10000 NJ 8000 NJ 8000 NJ 8600 NJ 8660 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out215 1 11 4 NJ 8180 NJ 8180 NJ 8180 NJ
preplace netloc clk_wiz_0_clk_out6 1 3 27 NJ 11870 NJ 11870 NJ 11870 NJ 11870 NJ 11870 NJ 11920 -510 11830 NJ 10830 NJ 10830 NJ 10830 NJ 10510 NJ 10620 NJ 10620 NJ 10620 NJ 10620 NJ 10620 NJ 10620 NJ 10620 NJ 10620 NJ 10620 NJ 10620 NJ 10620 NJ 10620 NJ 10620 NJ 10600 NJ 10600 NJ
preplace netloc sg_in061_1 1 0 22 NJ 9950 NJ 9950 NJ 9950 NJ 9950 NJ 9950 NJ 9950 NJ 9950 NJ 9950 NJ 9950 NJ 9950 NJ 11800 NJ 11800 NJ 11800 NJ 11800 NJ 11800 NJ 11800 NJ 11800 NJ 11780 NJ 11780 NJ 11740 NJ 11740 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out216 1 11 4 NJ 8370 NJ 8400 NJ 8400 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out160 1 11 14 NJ 7260 NJ 7260 NJ 7260 NJ 7260 NJ 7260 NJ 7260 NJ 7260 NJ 7260 NJ 7260 NJ 7260 NJ 7260 NJ 7260 NJ 7260 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out217 1 11 4 NJ 8400 NJ 8420 NJ 8420 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out161 1 11 16 NJ 7280 NJ 7280 NJ 7280 NJ 7280 NJ 7280 NJ 7280 NJ 7280 NJ 7280 NJ 7280 NJ 7280 NJ 7280 NJ 7280 NJ 7280 NJ 7280 NJ 7280 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out218 1 11 2 NJ 8420 2480
preplace netloc softGlue_300IO_v1_0_0_sg_out162 1 11 16 NJ 7300 NJ 7300 NJ 7300 NJ 7300 NJ 7300 NJ 7300 NJ 7300 NJ 7300 NJ 7300 NJ 7300 NJ 7300 NJ 7300 NJ 7300 NJ 7300 NJ 7300 NJ
preplace netloc mux2_6_Outp 1 30 1 16180
preplace netloc softGlue_300IO_v1_0_0_sg_out219 1 11 2 NJ 8430 2460
preplace netloc softGlue_300IO_v1_0_0_sg_out163 1 11 16 NJ 7320 NJ 7320 NJ 7320 NJ 7320 NJ 7320 NJ 7320 NJ 7320 NJ 7320 NJ 7320 NJ 7320 NJ 7320 NJ 7320 NJ 7320 NJ 7320 NJ 7320 NJ
preplace netloc updncntr_2_Counts 1 3 26 NJ 11550 NJ 11800 NJ 11800 NJ 11800 NJ 11800 NJ 11300 NJ 11300 NJ 11090 NJ 11090 NJ 11090 NJ 11090 NJ 11090 NJ 10980 NJ 10980 NJ 10980 NJ 10980 NJ 10940 NJ 10940 NJ 10940 NJ 10940 NJ 10940 NJ 10940 NJ 10940 NJ 10940 NJ 10940 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out164 1 11 2 NJ 7340 2800
preplace netloc histoScalerStream_0_M_AXIS 1 4 1 -3520
preplace netloc softGlueReg32_v1_0_0_in_reg60 1 13 17 6870 11520 NJ 11490 NJ 11490 NJ 11490 NJ 11490 NJ 11490 NJ 11490 NJ 11490 NJ 11480 NJ 11480 NJ 11480 NJ 11480 NJ 11480 NJ 11480 NJ 11480 NJ 11630 15700
preplace netloc softGlue_300IO_v1_0_0_sg_out165 1 11 2 NJ 7360 2780
preplace netloc softGlue_300IO_v1_0_0_sg_out180 1 11 14 NJ 7660 NJ 7580 NJ 7580 NJ 7580 NJ 7580 NJ 7580 NJ 7580 NJ 7580 NJ 7580 NJ 7580 NJ 7580 NJ 7580 NJ 7580 NJ
preplace netloc softGlueReg32_v1_0_0_in_reg61 1 3 27 NJ 11120 NJ 11120 NJ 11340 NJ 11340 NJ 11350 NJ 11350 NJ 11350 NJ 11130 NJ 11130 NJ 11130 NJ 11130 NJ 11130 NJ 11130 NJ 11130 NJ 11130 NJ 11130 NJ 11130 NJ 11130 NJ 11130 NJ 11130 NJ 11130 NJ 11130 NJ 11130 NJ 11130 NJ 11130 NJ 11600 15680
preplace netloc util_ds_buf_5_IBUF_OUT 1 1 10 -9710 8880 NJ 8880 NJ 8880 NJ 8880 NJ 8880 NJ 8880 NJ 8880 NJ 8880 NJ 8880 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out166 1 11 4 NJ 7370 NJ 7370 NJ 7370 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out181 1 11 14 NJ 7680 NJ 7700 NJ 7690 NJ 7740 NJ 7740 NJ 7740 NJ 7740 NJ 7740 NJ 7740 NJ 7740 NJ 7740 NJ 7740 NJ 7740 NJ
preplace netloc divByN_4_Q 1 10 18 NJ 10300 NJ 10300 NJ 10380 NJ 10310 NJ 10650 NJ 10640 NJ 10640 NJ 10640 NJ 10640 NJ 10640 NJ 10640 NJ 10640 NJ 10640 NJ 10640 NJ 10640 NJ 10640 NJ 10640 NJ
preplace netloc mux2_5_Outp 1 30 1 16160
preplace netloc softGlueReg32_v1_0_0_in_reg62 1 28 2 14950 11680 15690
preplace netloc softGlue_300IO_v1_0_0_sg_out167 1 11 4 NJ 7390 NJ 7390 NJ 7390 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out182 1 11 14 NJ 7700 NJ 7720 NJ 7720 NJ 7720 NJ 7720 NJ 7720 NJ 7720 NJ 7720 NJ 7720 NJ 7720 NJ 7720 NJ 7720 NJ 7720 NJ
preplace netloc sg_in068_1 1 0 11 NJ 8420 NJ 8420 NJ 8420 NJ 8420 NJ 8420 NJ 8420 NJ 8420 NJ 8420 NJ 8420 NJ 8420 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out168 1 11 14 NJ 7400 NJ 7400 NJ 7400 NJ 7400 NJ 7400 NJ 7400 NJ 7400 NJ 7400 NJ 7400 NJ 7400 NJ 7400 NJ 7400 NJ 7400 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out183 1 11 16 NJ 7720 NJ 7730 NJ 7730 NJ 7730 NJ 7730 NJ 7730 NJ 7730 NJ 7730 NJ 7730 NJ 7730 NJ 7730 NJ 7730 NJ 7730 NJ 7730 NJ 7730 NJ
preplace netloc IBUF_DS_P_5_1 1 0 1 NJ
preplace netloc sg_in055_1 1 0 20 NJ 9830 NJ 9830 NJ 9900 NJ 9900 NJ 9900 NJ 9900 NJ 9900 NJ 9900 NJ 9900 NJ 9900 NJ 12240 NJ 12240 NJ 12240 NJ 12240 NJ 12240 NJ 12240 NJ 12240 NJ 12240 NJ 12240 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out169 1 11 14 NJ 7440 NJ 7520 NJ 7430 NJ 7430 NJ 7430 NJ 7430 NJ 7430 NJ 7430 NJ 7430 NJ 7430 NJ 7430 NJ 7430 NJ 7430 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out184 1 11 16 NJ 7740 NJ 7740 NJ 7740 NJ 7750 NJ 7750 NJ 7750 NJ 7750 NJ 7750 NJ 7750 NJ 7750 NJ 7750 NJ 7750 NJ 7750 NJ 7750 NJ 7750 NJ
preplace netloc mux2_0_Outp 1 30 1 16180
preplace netloc softGlue_300IO_v1_0_0_sg_out185 1 11 16 NJ 7760 NJ 7760 NJ 7760 NJ 7760 NJ 7760 NJ 7760 NJ 7760 NJ 7760 NJ 7760 NJ 7760 NJ 7760 NJ 7760 NJ 7760 NJ 7760 NJ 7760 NJ
preplace netloc xlslice_0_Dout 1 4 26 -3470 11350 NJ 11350 NJ 11350 NJ 11360 NJ 11360 NJ 11360 NJ 11150 NJ 11150 NJ 11150 NJ 11150 NJ 11150 NJ 11150 NJ 11150 NJ 11150 NJ 11150 NJ 11150 NJ 11150 NJ 11150 NJ 11150 NJ 11150 NJ 11150 NJ 11150 NJ 11150 NJ 11150 NJ 11650 15680
preplace netloc FI_22_1 1 0 11 NJ 8520 NJ 8520 NJ 8520 NJ 8520 NJ 8520 NJ 8520 NJ 8520 NJ 8520 NJ 8520 NJ 8520 N
preplace netloc softGlue_300IO_v1_0_0_sg_out220 1 11 4 NJ 8460 NJ 8430 NJ 8430 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out186 1 11 2 NJ 7780 2680
preplace netloc sg_in059_1 1 0 20 NJ 9910 NJ 9910 NJ 9920 NJ 9920 NJ 9920 NJ 9920 NJ 9920 NJ 9920 NJ 9920 NJ 9920 NJ 13040 NJ 13040 NJ 13040 NJ 13040 NJ 13040 NJ 13040 NJ 13040 NJ 13040 NJ 13040 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out221 1 11 4 NJ 8440 NJ 8440 NJ 8440 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out187 1 11 2 NJ 7800 2660
preplace netloc softGlue_300IO_v1_0_0_sg_out222 1 11 14 NJ 8470 NJ 8470 NJ 8470 NJ 8550 NJ 8550 NJ 8550 NJ 8550 NJ 8550 NJ 8550 NJ 8550 NJ 8550 NJ 8550 NJ 8550 NJ
preplace netloc UpCntr_1_Counts 1 3 26 NJ 11520 NJ 11780 NJ 11780 NJ 11780 NJ 11780 NJ 11680 NJ 11680 NJ 11680 NJ 9120 NJ 9120 NJ 8930 NJ 8930 NJ 8930 NJ 8930 NJ 8930 NJ 8930 NJ 8930 NJ 8930 NJ 8930 NJ 8930 NJ 8930 NJ 8940 NJ 8930 NJ 8950 NJ 8940 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out188 1 11 2 NJ 7820 2640
preplace netloc softGlue_300IO_v1_0_0_sg_out189 1 11 2 NJ 7840 2630
preplace netloc softGlue_300IO_v1_0_0_sg_out223 1 11 14 NJ 8490 NJ 8460 NJ 8460 NJ 8580 NJ 8580 NJ 8580 NJ 8580 NJ 8580 NJ 8580 NJ 8580 NJ 8580 NJ 8580 NJ 8580 NJ
preplace netloc OR_7_Res 1 10 11 NJ 10650 NJ 10640 NJ 10640 NJ 10200 NJ 10800 9870 10800 NJ 10800 NJ 10800 NJ 10800 NJ 10800 NJ
preplace netloc sg_in071_1 1 0 11 NJ 8480 NJ 8480 NJ 8480 NJ 8480 NJ 8480 NJ 8480 NJ 8480 NJ 8480 NJ 8480 NJ 8480 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out150 1 11 16 NJ 7060 NJ 7060 NJ 7060 NJ 7060 NJ 7060 NJ 7060 NJ 7060 NJ 7060 NJ 7060 NJ 7060 NJ 7060 NJ 7060 NJ 7060 NJ 7060 NJ 7060 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out224 1 11 16 NJ 8450 NJ 8450 NJ 8450 NJ 8590 NJ 8590 NJ 8590 NJ 8590 NJ 8590 NJ 8590 NJ 8590 NJ 8590 NJ 8590 NJ 8590 NJ 8590 NJ 8590 NJ
preplace netloc IBUF_DS_N_3_1 1 0 1 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out151 1 11 16 NJ 7080 NJ 7080 NJ 7080 NJ 7080 NJ 7080 NJ 7080 NJ 7080 NJ 7080 NJ 7080 NJ 7080 NJ 7080 NJ 7080 NJ 7080 NJ 7080 NJ 7080 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out225 1 11 16 NJ 8530 NJ 8530 NJ 8530 NJ 8530 NJ 8530 NJ 8530 NJ 8530 NJ 8530 NJ 8540 NJ 8540 NJ 8540 NJ 8540 NJ 8540 NJ 8540 NJ 8540 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out226 1 3 9 NJ 10040 NJ 10040 NJ 10040 NJ 10040 NJ 10030 NJ 10240 NJ 10240 NJ 10280 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out152 1 11 2 NJ 7100 2840
preplace netloc softGlue_300IO_v1_0_0_sg_out227 1 11 18 NJ 8500 NJ 8500 NJ 8560 NJ 8560 NJ 8560 NJ 8560 NJ 8560 NJ 8560 NJ 8560 NJ 8560 NJ 8560 NJ 8560 NJ 8560 NJ 8560 NJ 8560 NJ 8560 NJ 8560 NJ
preplace netloc util_ds_buf_2_IBUF_OUT 1 1 10 -9700 8820 NJ 8820 NJ 8820 NJ 8820 NJ 8820 NJ 8820 NJ 8820 NJ 8820 NJ 8820 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out153 1 11 2 NJ 7120 2830
preplace netloc softGlue_300IO_v1_0_0_sg_out228 1 11 8 NJ 8510 NJ 8510 NJ 8500 NJ 8510 NJ 8500 NJ 8500 NJ 8500 10840
preplace netloc softGlue_300IO_v1_0_0_sg_out154 1 11 2 NJ 7140 2820
preplace netloc softGlue_300IO_v1_0_0_sg_out229 1 11 11 NJ 8540 NJ 8540 NJ 8540 NJ 8540 NJ 8540 NJ 8540 NJ 8540 NJ 8540 11220 11460 NJ 11480 NJ
preplace netloc util_ds_buf_0_IBUF_OUT 1 1 10 -9760 8780 NJ 8780 NJ 8780 NJ 8780 NJ 8780 NJ 8780 NJ 8780 NJ 8780 NJ 8780 NJ
preplace netloc pixelTrigger_0_Pixel 1 14 15 NJ 11400 NJ 11390 NJ 11390 NJ 11390 NJ 11390 NJ 11390 NJ 11390 NJ 11390 NJ 11390 NJ 11390 NJ 11390 NJ 11390 NJ 11390 NJ 11390 NJ
preplace netloc softGlueReg32_v1_0_0_in_reg50 1 2 28 NJ 11010 NJ 11010 NJ 11010 NJ 11010 NJ 11010 NJ 11000 NJ 11200 NJ 11200 NJ 11020 NJ 11020 NJ 11020 NJ 11020 NJ 11020 NJ 11020 NJ 11020 NJ 11020 NJ 11020 NJ 11020 NJ 11020 NJ 11020 NJ 11020 NJ 11020 NJ 10970 NJ 10970 NJ 10970 NJ 10970 NJ 11570 15730
preplace netloc softGlue_300IO_v1_0_0_sg_out155 1 11 4 NJ 7160 NJ 7160 NJ 7160 NJ
preplace netloc FI_12_1 1 0 22 NJ 9930 NJ 9930 NJ 9930 NJ 9930 NJ 9930 NJ 9930 NJ 9930 NJ 9930 NJ 10370 NJ 10370 NJ 11050 NJ 11050 NJ 11050 NJ 11050 NJ 11050 NJ 11050 NJ 11050 NJ 11050 NJ 11050 NJ 11050 NJ 11050 NJ
preplace netloc sg_in065_1 1 0 22 NJ 9980 NJ 9980 NJ 9980 NJ 9980 NJ 9980 NJ 9980 NJ 9980 NJ 9980 NJ 9980 NJ 9980 NJ 10940 NJ 10940 NJ 10940 NJ 10940 NJ 10980 NJ 10970 NJ 10970 NJ 10970 NJ 10970 NJ 10970 NJ 10970 NJ
preplace netloc softGlueReg32_v1_0_0_in_reg51 1 2 28 NJ 11110 NJ 11110 NJ 11110 NJ 11110 NJ 11110 NJ 11340 NJ 11340 NJ 11340 NJ 11120 NJ 11120 NJ 11120 NJ 11120 NJ 11120 NJ 11120 NJ 11120 NJ 11120 NJ 11120 NJ 11120 NJ 11120 NJ 11120 NJ 11120 NJ 11120 NJ 11120 NJ 11120 13860 11120 NJ 11120 NJ 11580 15720
preplace netloc softGlue_300IO_v1_0_0_sg_out156 1 11 4 NJ 7180 NJ 7180 NJ 7180 NJ
preplace netloc fifo_generator_1_axis_data_count 1 6 23 NJ 11580 NJ 11580 NJ 11210 NJ 11210 NJ 11110 NJ 11110 NJ 11110 NJ 11110 NJ 11110 NJ 11110 NJ 11110 NJ 11110 NJ 11110 NJ 11110 NJ 11110 NJ 11110 NJ 11110 NJ 11110 NJ 11110 NJ 11110 NJ 11110 NJ 11110 NJ
preplace netloc sg_in052_1 1 0 13 NJ 9770 NJ 9770 NJ 9770 NJ 9770 NJ 9770 NJ 9770 NJ 9770 NJ 9770 NJ 9770 NJ 9770 NJ 10240 NJ 10240 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out190 1 11 2 NJ 7860 2620
preplace netloc softGlueReg32_v1_0_0_in_reg52 1 2 28 NJ 11000 NJ 11000 NJ 11000 NJ 11000 NJ 11000 NJ 10990 NJ 10990 NJ 11190 NJ 11030 NJ 11030 NJ 11030 NJ 11030 NJ 11030 NJ 11030 NJ 11030 NJ 11030 NJ 11030 NJ 11030 NJ 11030 NJ 11030 NJ 11030 NJ 11030 NJ 11030 NJ 11030 13980 10980 NJ 10980 NJ 11590 15710
preplace netloc softGlue_300IO_v1_0_0_sg_out157 1 11 4 NJ 7200 NJ 7200 NJ 7200 NJ
preplace netloc softGlueReg32_v1_0_0_in_reg53 1 13 17 6860 9860 NJ 9860 NJ 9860 NJ 9860 NJ 9860 NJ 9860 NJ 9860 NJ 9870 NJ 9870 NJ 9870 NJ 9870 NJ 9870 NJ 9870 NJ 9870 NJ 9870 NJ 9870 15850
preplace netloc softGlue_300IO_v1_0_0_sg_out158 1 11 14 NJ 7220 NJ 7220 NJ 7220 NJ 7220 NJ 7220 NJ 7220 NJ 7220 NJ 7220 NJ 7220 NJ 7220 NJ 7220 NJ 7220 NJ 7220 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out191 1 11 4 NJ 7880 NJ 7910 NJ 7910 NJ
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 8 3 -1020 7000 NJ 7000 NJ
preplace netloc mux2_4_Outp 1 30 1 16080
preplace netloc AND_1_Res 1 10 4 NJ 10440 NJ 10440 NJ 10440 6250
preplace netloc IBUF_DS_P_1 1 0 1 NJ
preplace netloc softGlueReg32_v1_0_0_in_reg54 1 13 17 6870 9890 NJ 9890 NJ 9890 NJ 9890 NJ 9890 NJ 9890 NJ 9890 NJ 9890 NJ 9890 NJ 9890 NJ 9890 NJ 9890 NJ 9890 NJ 9890 NJ 9890 NJ 9890 15840
preplace netloc softGlue_300IO_v1_0_0_sg_out159 1 11 14 NJ 7240 NJ 7240 NJ 7240 NJ 7240 NJ 7240 NJ 7240 NJ 7240 NJ 7240 NJ 7240 NJ 7240 NJ 7240 NJ 7240 NJ 7240 NJ
preplace netloc divByN_1_Q 1 10 4 NJ 10410 NJ 10410 NJ 10410 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out192 1 11 4 NJ 7900 NJ 7920 NJ 7920 NJ
preplace netloc IBUF_DS_P_2 1 0 1 NJ
preplace netloc softGlueReg32_v1_0_0_in_reg55 1 13 17 6840 11530 NJ 11450 NJ 11450 NJ 11450 NJ 11450 NJ 11450 NJ 11450 NJ 11450 NJ 11450 NJ 11450 NJ 11450 NJ 11450 NJ 11450 NJ 11450 NJ 11450 NJ 11610 15770
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 7 22 NJ 10580 NJ 10020 NJ 10020 NJ 11060 NJ 11060 NJ 11060 NJ 11060 NJ 11060 NJ 11060 NJ 11060 NJ 11060 NJ 11060 NJ 11060 NJ 11060 NJ 11060 NJ 11060 NJ 11500 NJ 11500 NJ 11500 NJ 11500 NJ 11500 NJ
preplace netloc OR_5_Res 1 10 5 NJ 10620 NJ 10610 NJ 10610 NJ 9990 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out193 1 11 4 NJ 7920 NJ 7790 NJ 7790 NJ
preplace netloc softGlueReg32_v1_0_0_in_reg56 1 13 17 6860 11510 NJ 11430 NJ 11430 NJ 11430 NJ 11430 NJ 11430 NJ 11430 NJ 11460 NJ 11460 NJ 11460 NJ 11460 NJ 11460 NJ 11460 NJ 11460 NJ 11460 NJ 11620 15760
preplace netloc pixelTrigger_0_Trig 1 10 5 NJ 10730 NJ 10730 NJ 10730 NJ 10530 7410
preplace netloc DnCntr_3_Q 1 10 16 NJ 10540 NJ 10540 NJ 10540 NJ 10360 NJ 10560 NJ 10560 NJ 10560 NJ 10560 NJ 10560 NJ 10560 NJ 10560 NJ 10560 NJ 10560 NJ 10560 NJ 10560 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out194 1 11 4 NJ 7930 NJ 7930 NJ 7930 NJ
preplace netloc pixelFIFO_v1_0_0_roomForEvent 1 20 5 NJ 9860 NJ 9860 NJ 9860 NJ 9860 12860
preplace netloc softGlueReg32_v1_0_0_in_reg57 1 13 17 6840 9830 NJ 9840 NJ 9840 NJ 9840 NJ 9840 NJ 9840 NJ 9840 NJ 9840 NJ 9840 NJ 9840 NJ 9840 NJ 9840 NJ 9840 NJ 9840 NJ 9840 NJ 9840 15870
preplace netloc softGlue_300IO_v1_0_0_sg_out195 1 11 4 NJ 7940 NJ 7940 NJ 7940 NJ
preplace netloc IBUF_DS_N_10_1 1 0 1 NJ
preplace netloc softGlueReg32_v1_0_0_in_reg58 1 13 17 6850 11560 NJ 11560 NJ 11560 NJ 11560 NJ 11560 NJ 11560 NJ 11510 NJ 11510 NJ 11470 NJ 11470 NJ 11470 NJ 11470 NJ 11470 NJ 11470 NJ 11470 NJ 11640 15780
preplace netloc softGlue_300IO_v1_0_0_sg_out196 1 11 14 NJ 7980 NJ 8140 NJ 8140 NJ 8170 NJ 8170 NJ 8170 NJ 8170 NJ 8170 NJ 8170 NJ 8170 NJ 8170 NJ 8170 NJ 8170 NJ
preplace netloc IBUF_DS_N_4_1 1 0 1 NJ
preplace netloc softGlueReg32_v1_0_0_in_reg59 1 13 17 6850 9840 NJ 9850 NJ 9850 NJ 9850 NJ 9850 NJ 9850 NJ 9850 NJ 9850 NJ 9850 NJ 9850 NJ 9850 NJ 9850 NJ 9850 NJ 9850 NJ 9850 NJ 9850 15860
preplace netloc AND_4_Res 1 10 18 NJ 10470 NJ 10470 NJ 10470 NJ 10450 NJ 10550 NJ 10550 NJ 10550 NJ 10550 NJ 10550 NJ 10550 NJ 10550 NJ 10550 NJ 10550 NJ 10550 NJ 10550 NJ 10550 NJ 10550 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out197 1 11 14 NJ 8390 NJ 8390 NJ 8300 NJ 8300 NJ 8300 NJ 8300 NJ 8300 NJ 8300 NJ 8300 NJ 8300 NJ 8300 NJ 8300 NJ 8300 NJ
preplace netloc XOR_2_Res 1 10 6 NJ 10670 NJ 10660 NJ 10660 NJ 10190 NJ 10190 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out140 1 11 2 NJ 6860 2890
preplace netloc softGlue_300IO_v1_0_0_sg_out198 1 11 14 NJ 8360 NJ 8380 NJ 8310 NJ 8310 NJ 8310 NJ 8310 NJ 8310 NJ 8310 NJ 8310 NJ 8310 NJ 8310 NJ 8310 NJ 8310 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out141 1 11 2 NJ 6880 2880
preplace netloc softGlue_300IO_v1_0_0_sg_out199 1 11 14 NJ 7950 NJ 7950 NJ 7950 NJ 8180 NJ 8180 NJ 8180 NJ 8180 NJ 8180 NJ 8180 NJ 8180 NJ 8180 NJ 8180 NJ 8180 NJ
preplace netloc DFF_2_Q 1 10 6 NJ 10490 NJ 10490 NJ 10490 NJ 10160 NJ 10160 NJ
preplace netloc util_ds_buf_4_IBUF_OUT 1 1 10 -9680 8860 NJ 8860 NJ 8860 NJ 8860 NJ 8860 NJ 8860 NJ 8860 NJ 8860 NJ 8860 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out142 1 11 2 NJ 6900 2860
preplace netloc scaler_or_Res 1 16 1 10430
preplace netloc IBUF_DS_N_9_1 1 0 1 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out143 1 11 4 NJ 6920 NJ 6920 NJ 6920 NJ
preplace netloc DnCntr_4_Counts 1 27 2 NJ 8460 NJ
preplace netloc processing_system7_0_axi_periph_M04_AXI 1 6 3 NJ 7420 NJ 7420 -1100
preplace netloc util_vector_logic_0_Res 1 3 6 NJ 11480 NJ 11430 NJ 11440 NJ 11570 NJ 11570 -1080
preplace netloc softGlue_300IO_v1_0_0_sg_out144 1 11 4 NJ 6940 NJ 6940 NJ 6940 NJ
preplace netloc processing_system7_0_axi_periph_M05_AXI 1 8 1 -1000
preplace netloc IBUF_DS_P_3_1 1 0 1 NJ
preplace netloc quadDec_1_step 1 10 4 NJ 10840 NJ 10840 NJ 10840 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out145 1 11 4 NJ 6960 NJ 6960 NJ 6960 NJ
preplace netloc processing_system7_0_axi_periph_M06_AXI 1 8 1 -1020
preplace netloc scalerChan_13_Counts 1 22 1 12260
preplace netloc OR_4_Res 1 10 18 NJ 10600 NJ 10590 NJ 10590 NJ 10270 NJ 10540 NJ 10540 NJ 10540 NJ 10540 NJ 10530 NJ 10530 NJ 10530 NJ 10530 NJ 10530 NJ 10530 NJ 10530 NJ 10530 NJ 10530 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out146 1 11 14 NJ 6980 NJ 6980 NJ 6980 NJ 6980 NJ 6980 NJ 6980 NJ 6980 NJ 6980 NJ 6980 NJ 6980 NJ 6980 NJ 6980 NJ 6980 NJ
preplace netloc updncntr_3_Q 1 10 16 NJ 10150 NJ 9170 NJ 9170 NJ 9210 NJ 9210 NJ 9210 NJ 9210 NJ 9210 NJ 9210 NJ 9210 NJ 9210 NJ 9210 NJ 9210 NJ 9210 NJ 9210 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out147 1 11 14 NJ 7000 NJ 7000 NJ 7000 NJ 7000 NJ 7000 NJ 7000 NJ 7000 NJ 7000 NJ 7000 NJ 7000 NJ 7000 NJ 7000 NJ 7000 NJ
preplace netloc scalerChan_15_Counts 1 22 1 12280
preplace netloc updncntr_4_Q 1 10 19 NJ 10210 NJ 10210 NJ 9540 NJ 9540 NJ 9540 NJ 9540 NJ 9540 NJ 9540 NJ 9540 NJ 9530 NJ 9530 NJ 9530 NJ 9530 NJ 9530 NJ 9530 NJ 9530 NJ 9530 NJ 9530 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out148 1 11 14 NJ 7020 NJ 7020 NJ 7020 NJ 7020 NJ 7020 NJ 7020 NJ 7020 NJ 7020 NJ 7020 NJ 7020 NJ 7020 NJ 7020 NJ 7020 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out149 1 11 16 NJ 7040 NJ 7040 NJ 7040 NJ 7040 NJ 7040 NJ 7040 NJ 7040 NJ 7040 NJ 7040 NJ 7040 NJ 7040 NJ 7040 NJ 7040 NJ 7040 NJ 7040 NJ
preplace netloc util_ds_buf_10_IBUF_OUT 1 1 10 -9650 8980 NJ 8980 NJ 8980 NJ 8980 NJ 8980 NJ 8980 NJ 8980 NJ 8980 NJ 8980 NJ
preplace netloc updncntr_3_Counts 1 3 26 NJ 11160 NJ 11300 NJ 11300 NJ 11300 NJ 11380 NJ 11380 NJ 11380 NJ 11040 NJ 11040 NJ 11040 NJ 11040 NJ 11040 NJ 11040 NJ 11040 NJ 11040 NJ 11040 NJ 11040 NJ 11040 NJ 10970 NJ 10970 NJ 10960 NJ 10960 13520 10960 NJ 10960 NJ 10960 NJ
preplace netloc util_ds_buf_6_IBUF_OUT 1 1 10 -9730 8900 NJ 8900 NJ 8900 NJ 8900 NJ 8900 NJ 8900 NJ 8900 NJ 8900 NJ 8900 NJ
preplace netloc processing_system7_0_axi_periph_M02_AXI 1 8 21 NJ 10280 NJ 10280 NJ 10900 NJ 10900 NJ 10900 NJ 10910 NJ 10820 NJ 10820 NJ 10820 NJ 10820 NJ 10820 NJ 10820 NJ 10850 NJ 10820 NJ 10820 NJ 10820 NJ 10820 NJ 10820 NJ 10820 NJ 10820 NJ
preplace netloc DnCntr_3_Counts 1 25 4 NJ 8430 NJ 8550 NJ 8550 NJ
preplace netloc softGlueReg32_v1_0_0_in_reg40 1 12 18 NJ 10150 NJ 10130 NJ 10510 NJ 10500 NJ 10500 NJ 10500 NJ 10510 NJ 10510 NJ 10510 NJ 10510 NJ 10510 NJ 10510 NJ 10510 NJ 10510 NJ 10510 NJ 10510 NJ 10510 15710
preplace netloc softGlueReg32_v1_0_0_in_reg41 1 14 16 NJ 10200 NJ 10200 NJ 10200 NJ 10200 NJ 10200 NJ 10200 NJ 10200 NJ 10200 NJ 10200 NJ 10200 NJ 10200 NJ 10200 NJ 10200 NJ 10200 NJ 10200 15740
preplace netloc softGlueReg32_v1_0_0_in_reg42 1 24 6 NJ 10250 NJ 10250 NJ 10250 NJ 10250 NJ 10250 15730
preplace netloc softGlueReg32_v1_0_0_in_reg43 1 27 3 NJ 9580 NJ 9580 15830
preplace netloc softGlueReg32_v1_0_0_in_reg44 1 19 11 11290 11340 NJ 11340 NJ 11340 NJ 11340 NJ 11340 NJ 11340 NJ 11340 NJ 11340 NJ 11340 NJ 11550 15750
preplace netloc IBUF_DS_N_5_1 1 0 1 NJ
preplace netloc softGlueReg32_v1_0_0_in_reg45 1 12 18 NJ 10340 NJ 10340 NJ 10590 NJ 10590 NJ 10590 NJ 10590 NJ 10590 NJ 10590 NJ 10590 NJ 10590 NJ 10590 NJ 10590 NJ 10590 NJ 10590 NJ 10590 NJ 10560 NJ 10560 15720
preplace netloc xlconcat_3_dout 1 3 13 NJ 11150 NJ 11150 NJ 11150 NJ 11150 NJ 11370 NJ 11370 NJ 11370 NJ 11140 NJ 11140 NJ 11140 NJ 11140 NJ 11140 9850
preplace netloc IBUF_DS_P_8_1 1 0 1 NJ
preplace netloc pixelTrigger_0_miss 1 10 5 NJ 10740 NJ 10740 NJ 10740 NJ 10410 7380
preplace netloc softGlueReg32_v1_0_0_in_reg46 1 12 18 NJ 10330 NJ 10240 NJ 10240 NJ 10240 NJ 10240 NJ 10240 NJ 10240 NJ 10240 NJ 10240 NJ 10240 NJ 10240 NJ 10240 NJ 10240 NJ 10240 NJ 10240 NJ 10240 NJ 10240 15800
preplace netloc sg_in056_1 1 0 20 NJ 9850 NJ 9850 NJ 9850 NJ 9850 NJ 9850 NJ 9850 NJ 9850 NJ 9850 NJ 9850 NJ 9850 NJ 12440 NJ 12440 NJ 12440 NJ 12440 NJ 12440 NJ 12440 NJ 12440 NJ 12440 NJ 12440 NJ
preplace netloc softGlueReg32_v1_0_0_in_reg47 1 14 16 NJ 10410 NJ 10410 NJ 10410 NJ 10410 NJ 10410 NJ 10410 NJ 10410 NJ 10410 NJ 10410 NJ 10410 NJ 10410 NJ 10410 NJ 10410 NJ 10410 NJ 10410 15780
preplace netloc quadDec_2_step 1 10 6 NJ 10920 NJ 10920 NJ 10920 NJ 10150 NJ 10150 NJ
preplace netloc softGlueReg32_v1_0_0_in_reg48 1 14 16 NJ 10420 NJ 10420 NJ 10420 NJ 10420 NJ 10420 NJ 10420 NJ 10420 NJ 10420 NJ 10420 NJ 10420 NJ 10420 NJ 10420 NJ 10420 NJ 10420 NJ 10420 15770
preplace netloc softGlueReg32_v1_0_0_in_reg49 1 2 28 NJ 11540 NJ 11540 NJ 11750 NJ 11740 NJ 11740 NJ 11740 NJ 11740 NJ 11810 NJ 11810 NJ 11810 NJ 11810 NJ 11810 NJ 11810 NJ 11810 NJ 11810 NJ 11810 NJ 11810 NJ 11440 NJ 11440 NJ 11440 NJ 11440 NJ 11440 NJ 11440 NJ 11440 NJ 11440 NJ 11440 NJ 11560 15740
preplace netloc util_ds_buf_7_IBUF_OUT 1 1 10 -9720 8920 NJ 8920 NJ 8920 NJ 8920 NJ 8920 NJ 8920 NJ 8920 NJ 8920 NJ 8920 NJ
preplace netloc IBUF_DS_N_2_1 1 0 1 NJ
preplace netloc OR_2_Res 1 10 6 NJ 10570 NJ 10550 NJ 10550 NJ 10180 NJ 10180 NJ
preplace netloc scalersToStream_0_M_AXIS 1 4 1 NJ
preplace netloc scalerChan_4_Counts 1 20 3 11600 11380 NJ 11380 NJ
preplace netloc softGlueReg32_v1_0_0_in_reg32 1 12 18 NJ 8490 NJ 8490 NJ 8500 NJ 8490 NJ 8490 NJ 8490 NJ 8490 NJ 8530 NJ 8530 NJ 8530 NJ 8530 NJ 8530 NJ 8530 NJ 8530 NJ 8540 NJ 8540 NJ 8540 15790
preplace netloc softGlueReg32_v1_0_0_in_reg33 1 14 16 NJ 10530 NJ 10530 NJ 10530 NJ 10530 NJ 10520 NJ 10520 NJ 10520 NJ 10520 NJ 10520 NJ 10520 NJ 10520 NJ 10520 NJ 10520 NJ 10520 NJ 10520 15680
preplace netloc util_ds_buf_3_IBUF_OUT 1 1 10 -9740 8840 NJ 8840 NJ 8840 NJ 8840 NJ 8840 NJ 8840 NJ 8840 NJ 8840 NJ 8840 NJ
preplace netloc softGlueReg32_v1_0_0_in_reg34 1 24 6 NJ 9550 NJ 9550 NJ 9550 NJ 9550 NJ 9550 15760
preplace netloc softGlueReg32_v1_0_0_in_reg35 1 26 4 13970 9560 NJ 9560 NJ 9560 15750
preplace netloc scalerChan_12_Counts 1 22 1 12210
preplace netloc gateDly_3_Q 1 10 16 NJ 10700 NJ 10700 NJ 10700 NJ 10490 NJ 10670 NJ 10670 NJ 10670 NJ 10670 NJ 10650 NJ 10650 NJ 10650 NJ 10650 NJ 10650 NJ 10650 NJ 10650 NJ
preplace netloc softGlueReg32_v1_0_0_in_reg36 1 12 18 NJ 10140 NJ 10140 NJ 10830 NJ 10830 NJ 10830 NJ 10830 NJ 10830 NJ 10830 NJ 10860 NJ 10770 NJ 10770 NJ 10770 NJ 10770 NJ 10770 NJ 10770 NJ 10770 NJ 10770 15690
preplace netloc softGlueReg32_v1_0_0_in_reg37 1 14 16 NJ 8960 NJ 8960 NJ 8960 NJ 8960 NJ 8960 NJ 8960 NJ 8960 NJ 8960 NJ 8960 NJ 8960 NJ 8960 NJ 8960 NJ 8960 NJ 8960 NJ 8960 15820
preplace netloc softGlueReg32_v1_0_0_in_reg38 1 24 6 NJ 10460 NJ 10460 NJ 10460 NJ 10460 NJ 10460 15700
preplace netloc S00_AXI_1 1 6 2 -2150 10690 -1730
preplace netloc softGlueReg32_v1_0_0_in_reg39 1 26 4 14040 9570 NJ 9570 NJ 9570 15810
preplace netloc IBUF_DS_N_8_1 1 0 1 NJ
preplace netloc gateDly_2_Q 1 10 6 NJ 10690 NJ 10690 NJ 10690 NJ 10500 NJ 10500 NJ
preplace netloc pixelTrigger_1_Pixel 1 14 15 NJ 11410 NJ 11360 NJ 11360 NJ 11360 NJ 11360 NJ 11360 NJ 11360 NJ 11360 NJ 11360 NJ 11360 NJ 11360 NJ 11360 NJ 11360 NJ 11360 NJ
preplace netloc quadDec_2_miss 1 10 6 NJ 10910 NJ 10910 NJ 10910 NJ 9980 NJ 9950 NJ
preplace netloc fifo_generator_1_axis_prog_full 1 6 5 -2210 9020 NJ 9020 NJ 9020 NJ 9020 NJ
preplace netloc mux2_2_Outp 1 10 18 NJ 10890 NJ 10890 NJ 10890 NJ 10920 NJ 10810 NJ 10810 NJ 10810 NJ 10810 NJ 10810 NJ 10810 NJ 10890 NJ 10890 NJ 10890 NJ 10890 NJ 10890 NJ 10890 NJ 10890 14330
preplace netloc pixelTrigger_1_miss 1 10 5 NJ 10760 NJ 10760 NJ 10760 NJ 10550 7370
preplace netloc UpCntr_3_Counts 1 3 26 NJ 11500 NJ 11740 NJ 11680 NJ 11680 NJ 11680 NJ 11690 NJ 11690 NJ 11690 NJ 9950 NJ 9950 NJ 9950 NJ 10480 NJ 10480 NJ 10480 NJ 10480 NJ 10440 NJ 10440 NJ 10440 NJ 10440 NJ 10440 NJ 10440 NJ 10440 13530 10440 NJ 10440 NJ 10440 NJ
preplace netloc AND_3_Res 1 10 16 NJ 10460 NJ 10460 NJ 10460 NJ 10440 NJ 10490 NJ 10490 NJ 10490 NJ 10490 NJ 10490 NJ 10490 NJ 10490 NJ 10490 NJ 10490 NJ 10490 NJ 10490 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out230 1 11 12 NJ 8520 NJ 8520 NJ 8520 NJ 8520 NJ 8520 NJ 8520 NJ 8520 NJ 8520 NJ 8520 NJ 8520 NJ 8520 12240
preplace netloc IBUF_DS_N_7_1 1 0 1 NJ
preplace netloc IBUF_DS_P_4_1 1 0 1 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out231 1 9 22 NJ 10400 NJ 10780 NJ 10810 NJ 10810 NJ 10250 NJ 10250 NJ 10160 NJ 10160 NJ 10160 NJ 10160 NJ 10160 NJ 10160 NJ 10160 NJ 10160 NJ 10160 NJ 10160 NJ 10160 NJ 10160 NJ 10130 NJ 10130 NJ 10130 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out232 1 9 22 NJ 10410 NJ 10790 NJ 10790 NJ 10790 NJ 10380 NJ 10440 NJ 10140 NJ 10140 NJ 10140 NJ 10140 NJ 10140 NJ 10140 NJ 10140 NJ 10140 NJ 10140 NJ 10140 NJ 10140 NJ 10150 NJ 10150 NJ 10150 NJ 10150 NJ
preplace netloc sg_in069_1 1 0 11 NJ 8440 NJ 8440 NJ 8440 NJ 8440 NJ 8440 NJ 8440 NJ 8440 NJ 8440 NJ 8440 NJ 8440 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out233 1 9 22 NJ 10440 NJ 10800 NJ 10800 NJ 10800 NJ 10350 NJ 10430 NJ 10170 NJ 10170 NJ 10170 NJ 10170 NJ 10170 NJ 10170 NJ 10170 NJ 10170 NJ 10170 NJ 10170 NJ 10170 NJ 10170 NJ 10140 NJ 10140 NJ 10140 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out234 1 9 22 NJ 10460 NJ 10770 NJ 10780 NJ 10780 NJ 10330 NJ 10460 NJ 10290 NJ 10290 NJ 10290 NJ 10290 NJ 10290 NJ 10290 NJ 10290 NJ 10290 NJ 10290 NJ 10290 NJ 10290 NJ 10290 NJ 10290 NJ 10290 NJ 10290 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out235 1 9 22 NJ 10380 NJ 10380 NJ 9430 NJ 9430 NJ 9450 NJ 9520 NJ 9520 NJ 9520 NJ 9520 NJ 9520 NJ 9520 NJ 9520 NJ 9520 NJ 9520 NJ 9520 NJ 9520 NJ 9520 NJ 9520 NJ 9520 NJ 9520 NJ 9520 NJ
preplace netloc updncntr_1_Q 1 10 4 NJ 10160 NJ 9210 NJ 9210 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out236 1 9 22 NJ 10340 NJ 10340 NJ 9590 NJ 9590 NJ 9590 NJ 9590 NJ 9590 NJ 9590 NJ 9590 NJ 9590 NJ 9590 NJ 9590 NJ 9590 NJ 9590 NJ 9590 NJ 9590 NJ 9590 NJ 9590 NJ 9590 NJ 9590 NJ 9590 NJ
preplace netloc processing_system7_0_axi_periph_M01_AXI 1 8 3 -1000 7020 NJ 7020 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out237 1 9 22 NJ 10310 NJ 10310 NJ 9600 NJ 9600 NJ 9600 NJ 9600 NJ 9600 NJ 9600 NJ 9600 NJ 9600 NJ 9600 NJ 9600 NJ 9600 NJ 9600 NJ 9600 NJ 9600 NJ 9600 NJ 9600 NJ 9600 NJ 9600 NJ 9600 NJ
preplace netloc sg_in058_1 1 0 20 NJ 9890 NJ 9890 NJ 9910 NJ 9910 NJ 9910 NJ 9910 NJ 9910 NJ 9910 NJ 9910 NJ 9910 NJ 12840 NJ 12840 NJ 12840 NJ 12840 NJ 12840 NJ 12840 NJ 12840 NJ 12840 NJ 12840 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out238 1 9 22 NJ 10320 NJ 10320 NJ 9610 NJ 9610 NJ 9610 NJ 9610 NJ 9610 NJ 9610 NJ 9610 NJ 9610 NJ 9610 NJ 9610 NJ 9610 NJ 9610 NJ 9610 NJ 9610 NJ 9610 NJ 9610 NJ 9610 NJ 9610 NJ 9610 NJ
preplace netloc xlslice_3_Dout 1 29 1 15940
preplace netloc gateDelayFast_2_Q 1 15 15 N 10330 NJ 10330 NJ 10330 NJ 10330 NJ 10330 NJ 10330 NJ 10330 NJ 10330 NJ 10330 NJ 10330 NJ 10330 NJ 10330 NJ 10330 NJ 10330 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out239 1 9 21 NJ 10330 NJ 10330 NJ 9490 NJ 9490 NJ 9620 NJ 9620 NJ 9620 NJ 9620 NJ 9620 NJ 9620 NJ 9620 NJ 9620 NJ 9620 NJ 9620 NJ 9620 NJ 9620 NJ 9620 NJ 9620 NJ 9620 NJ 9620 NJ
preplace netloc DFF_3_Q 1 10 16 NJ 10500 NJ 10500 NJ 10500 NJ 10460 NJ 10720 NJ 10720 NJ 10720 NJ 10720 NJ 10470 NJ 10470 NJ 10470 NJ 10470 NJ 10470 NJ 10470 NJ 10470 NJ
preplace netloc sg_in053_1 1 0 20 NJ 9790 NJ 9790 NJ 9790 NJ 9790 NJ 9790 NJ 9790 NJ 9790 NJ 9790 NJ 9790 NJ 9790 NJ 10860 NJ 10860 NJ 10860 NJ 10320 NJ 10780 NJ 10780 NJ 10780 NJ 10780 NJ 10790 NJ
preplace netloc xlslice_1_Dout 1 29 1 15890
preplace netloc one_dout 1 19 3 11200 11730 NJ 11730 NJ
preplace netloc gateDelayFast_3_Q 1 3 27 -4290 12090 NJ 12090 NJ 12090 NJ 12090 NJ 12090 NJ 12090 NJ 12090 NJ 12090 NJ 9960 NJ 9960 NJ 9960 NJ 10220 NJ 10220 NJ 10220 NJ 10220 NJ 10220 NJ 10220 NJ 10220 NJ 10220 NJ 10220 NJ 10220 NJ 10220 NJ 10220 NJ 10220 NJ 10220 NJ 10220 NJ
preplace netloc sg_in066_1 1 0 22 NJ 9990 NJ 9990 NJ 9990 NJ 9990 NJ 9990 NJ 9990 NJ 9990 NJ 9970 NJ 10040 NJ 10040 NJ 11010 NJ 11010 NJ 11010 NJ 11010 NJ 11010 NJ 11000 NJ 11000 NJ 11000 NJ 11010 NJ 11010 NJ 11010 11840
preplace netloc processing_system7_0_axi_periph_M03_AXI 1 8 16 NJ 10300 NJ 10300 NJ 10930 NJ 10930 NJ 10930 NJ 10930 NJ 10950 NJ 10930 NJ 10930 NJ 10930 NJ 10950 NJ 10930 NJ 10930 NJ 10930 NJ 10930 12560
preplace netloc S01_AXI_1 1 6 2 -2140 10700 -1740
preplace netloc IBUF_DS_P_7_1 1 0 1 NJ
preplace netloc xlconcat_2_dout 1 10 1 -60
preplace netloc freqCounter_0_Counts 1 28 2 14950 8610 15750
preplace netloc updncntr_4_Counts 1 28 1 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out240 1 9 21 NJ 10360 NJ 10360 NJ 9710 NJ 9890 NJ 9910 NJ 9910 NJ 9910 NJ 9910 NJ 9910 NJ 9910 NJ 9910 NJ 9910 NJ 9910 NJ 9910 NJ 9910 NJ 9910 NJ 9910 NJ 9910 NJ 9910 NJ 9910 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out130 1 11 4 NJ 6660 NJ 6660 NJ 6660 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out241 1 9 21 NJ 10260 NJ 10260 NJ 9720 NJ 9910 NJ 9920 NJ 9920 NJ 9920 NJ 9920 NJ 9920 NJ 9920 NJ 9920 NJ 9920 NJ 9920 NJ 9920 NJ 9920 NJ 9920 NJ 9920 NJ 9920 NJ 9920 NJ 9920 NJ
preplace netloc sg_in062_1 1 0 22 NJ 9960 NJ 9960 NJ 9960 NJ 9960 NJ 9960 NJ 9960 NJ 9960 NJ 9960 NJ 9970 NJ 9970 NJ 11000 NJ 11000 NJ 11000 NJ 11000 NJ 11000 NJ 10990 NJ 10990 NJ 10990 NJ 10990 NJ 10990 NJ 10990 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out131 1 11 4 NJ 6680 NJ 6680 NJ 6680 NJ
preplace netloc scalerChan_9_Counts 1 22 1 12190
preplace netloc softGlue_300IO_v1_0_0_sg_out242 1 9 21 NJ 10270 NJ 10270 NJ 9690 NJ 9900 NJ 9900 NJ 9900 NJ 9900 NJ 9900 NJ 9900 NJ 9900 NJ 9900 NJ 9900 NJ 9900 NJ 9900 NJ 9900 NJ 9900 NJ 9900 NJ 9900 NJ 9900 NJ 9900 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out132 1 11 14 NJ 6700 NJ 6700 NJ 6700 NJ 6700 NJ 6700 NJ 6700 NJ 6700 NJ 6700 NJ 6700 NJ 6700 NJ 6700 NJ 6700 NJ 6700 NJ
preplace netloc ssi_master_0_ssi_clk 1 10 3 NJ 10230 NJ 10230 2380
preplace netloc softGlue_300IO_v1_0_0_sg_out243 1 9 22 NJ 10470 NJ 10480 NJ 9620 NJ 9620 NJ 9630 NJ 9630 NJ 9630 NJ 9630 NJ 9630 NJ 9630 NJ 9630 NJ 9630 NJ 9630 NJ 9630 NJ 9630 NJ 9630 NJ 9630 NJ 9630 NJ 9630 NJ 9630 NJ 9630 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out133 1 11 14 NJ 6720 NJ 6720 NJ 6720 NJ 6720 NJ 6720 NJ 6720 NJ 6720 NJ 6720 NJ 6720 NJ 6720 NJ 6720 NJ 6720 NJ 6720 NJ
preplace netloc quadDec_1_dir 1 10 4 NJ 10810 NJ 10820 NJ 10820 NJ
preplace netloc scalerChan_1_Q 1 10 11 520 10990 NJ 10990 NJ 10990 NJ 10990 NJ 10990 10050 11420 NJ 11420 NJ 11420 NJ 11420 NJ 11420 11560
preplace netloc softGlue_300IO_v1_0_0_sg_out244 1 9 22 NJ 10450 NJ 10450 NJ 9440 NJ 9440 NJ 9440 NJ 9490 NJ 9490 NJ 9490 NJ 9490 NJ 9490 NJ 9490 NJ 9490 NJ 9490 NJ 9490 NJ 9490 NJ 9510 NJ 9510 NJ 9510 NJ 9540 NJ 9540 NJ 9540 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out134 1 11 14 NJ 6740 NJ 6740 NJ 6740 NJ 6740 NJ 6740 NJ 6740 NJ 6740 NJ 6740 NJ 6740 NJ 6740 NJ 6740 NJ 6740 NJ 6740 NJ
preplace netloc scaler_or2_Res 1 17 1 10640
preplace netloc softGlue_300IO_v1_0_0_sg_out245 1 9 22 NJ 10290 NJ 10290 NJ 9500 NJ 9500 NJ 9500 NJ 9500 NJ 9500 NJ 9500 NJ 9500 NJ 9500 NJ 9500 NJ 9500 NJ 9500 NJ 9500 NJ 9500 NJ 9640 NJ 9640 NJ 9640 NJ 9640 NJ 9640 NJ 9640 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out135 1 11 14 NJ 6760 NJ 6760 NJ 6760 NJ 6760 NJ 6760 NJ 6760 NJ 6760 NJ 6760 NJ 6760 NJ 6760 NJ 6760 NJ 6760 NJ 6760 NJ
preplace netloc processing_system7_0_FCLK_CLK0 1 3 26 NJ 11580 NJ 11770 NJ 11460 NJ 10680 -1650 11400 -1040 11220 NJ 11220 NJ 11080 NJ 11080 NJ 11080 NJ 11080 NJ 11080 NJ 11080 NJ 11080 NJ 11370 NJ 11370 NJ 11370 NJ 11370 NJ 11370 NJ 11430 NJ 11430 NJ 11430 NJ 11430 NJ 11430 NJ 11430 NJ
preplace netloc DnCntr_4_Q 1 10 18 NJ 10560 NJ 10560 NJ 10560 NJ 10300 NJ 10570 NJ 10570 NJ 10570 NJ 10570 NJ 10570 NJ 10570 NJ 10570 NJ 10570 NJ 10570 NJ 10570 NJ 10570 NJ 10560 NJ 10560 NJ
preplace netloc util_ds_buf_1_IBUF_OUT 1 1 10 -9750 8800 NJ 8800 NJ 8800 NJ 8800 NJ 8800 NJ 8800 NJ 8800 NJ 8800 NJ 8800 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out246 1 9 22 NJ 10220 NJ 10220 NJ 9510 NJ 9510 NJ 9650 NJ 9650 NJ 9650 NJ 9650 NJ 9650 NJ 9650 NJ 9650 NJ 9650 NJ 9650 NJ 9650 NJ 9650 NJ 9650 NJ 9650 NJ 9650 NJ 9650 NJ 9650 NJ 9650 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out136 1 11 16 NJ 6780 NJ 6780 NJ 6780 NJ 6780 NJ 6780 NJ 6780 NJ 6780 NJ 6780 NJ 6780 NJ 6780 NJ 6780 NJ 6780 NJ 6780 NJ 6780 NJ 6780 NJ
preplace netloc processing_system7_0_FCLK_CLK2 1 8 1 -1070
preplace netloc softGlue_300IO_v1_0_0_irq 1 7 5 NJ 11650 NJ 11650 NJ 11650 NJ 11650 1250
preplace netloc softGlue_300IO_v1_0_0_sg_out247 1 11 20 NJ 9000 NJ 9080 NJ 8990 NJ 8990 NJ 8990 NJ 8990 NJ 8990 NJ 8990 NJ 8990 NJ 8990 NJ 8990 NJ 8990 NJ 8990 NJ 8990 NJ 8990 NJ 8990 NJ 8990 NJ 8990 NJ 8990 NJ
preplace netloc sg_in067_1 1 0 22 NJ 10000 NJ 10000 NJ 10000 NJ 10000 NJ 10000 NJ 10000 NJ 10000 NJ 9990 NJ 9990 NJ 9990 NJ 13180 NJ 13180 NJ 13180 NJ 13180 NJ 13180 NJ 13180 NJ 13180 NJ 13180 NJ 13180 NJ 13180 NJ 13010 N
preplace netloc DFF_1_Q 1 10 4 NJ 10550 NJ 10480 NJ 10480 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out137 1 11 16 NJ 6800 NJ 6800 NJ 6800 NJ 6800 NJ 6800 NJ 6800 NJ 6800 NJ 6800 NJ 6800 NJ 6800 NJ 6800 NJ 6800 NJ 6800 NJ 6800 NJ 6800 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out248 1 11 20 NJ 9020 NJ 9090 NJ 8940 NJ 8940 NJ 8940 NJ 8940 NJ 8940 NJ 8940 NJ 8940 NJ 8940 NJ 8940 NJ 8940 NJ 8940 NJ 8950 NJ 8940 NJ 9000 NJ 9000 NJ 9000 NJ 9000 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out138 1 11 16 NJ 6820 NJ 6820 NJ 6820 NJ 6820 NJ 6820 NJ 6820 NJ 6820 NJ 6820 NJ 6820 NJ 6820 NJ 6820 NJ 6820 NJ 6820 NJ 6820 NJ 6820 NJ
preplace netloc processing_system7_0_FCLK_CLK3 1 8 1 -1030
preplace netloc softGlue_300IO_v1_0_0_sg_out249 1 11 20 NJ 9040 NJ 9110 NJ 8950 NJ 8950 NJ 8970 NJ 8970 NJ 8970 NJ 8970 NJ 8970 NJ 8970 NJ 8970 NJ 8970 NJ 8970 NJ 8970 NJ 8970 NJ 8970 NJ 8970 NJ 8970 NJ 8970 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out139 1 11 16 NJ 6840 NJ 6840 NJ 6840 NJ 6840 NJ 6840 NJ 6840 NJ 6840 NJ 6840 NJ 6840 NJ 6840 NJ 6840 NJ 6840 NJ 6840 NJ 6840 NJ 6840 NJ
preplace netloc demux2_2_Out0 1 10 6 NJ 10390 NJ 10390 NJ 10390 NJ 10280 NJ 10450 NJ
preplace netloc demux2_2_Out1 1 10 6 NJ 10400 NJ 10400 NJ 10400 NJ 10260 NJ 10640 NJ
preplace netloc IBUF_DS_N_1 1 0 1 NJ
preplace netloc pixelTrigger_1_Counts 1 14 15 NJ 11280 NJ 11280 NJ 11280 NJ 11280 NJ 11280 NJ 11280 NJ 11280 NJ 11280 NJ 11280 NJ 11280 NJ 11280 NJ 11280 NJ 11280 NJ 11280 NJ
preplace netloc IBUF_DS_N_2 1 0 1 NJ
preplace netloc gateDly_4_Q 1 10 18 NJ 10710 NJ 10710 NJ 10710 NJ 10230 NJ 10230 NJ 10230 NJ 10230 NJ 10230 NJ 10230 NJ 10230 NJ 10230 NJ 10230 NJ 10230 NJ 10230 NJ 10230 NJ 10230 NJ 10230 NJ
preplace netloc xlslice_4_Dout 1 29 1 15950
preplace netloc softGlue_300IO_v1_0_0_sg_out281 1 11 6 NJ 9680 NJ 9870 NJ 9870 NJ 9870 NJ 9870 10430
preplace netloc softGlue_300IO_v1_0_0_sg_out120 1 10 2 760 5960 1350
preplace netloc softGlue_300IO_v1_0_0_sg_out282 1 11 5 NJ 9700 NJ 9880 NJ 9880 NJ 9880 10060
preplace netloc softGlue_300IO_v1_0_0_sg_out121 1 10 2 770 5970 1340
preplace netloc processing_system7_0_M_AXI_GP0 1 7 2 -1610 10780 -1090
preplace netloc softGlue_300IO_v1_0_0_sg_out283 1 11 9 NJ 9520 NJ 9520 NJ 9530 NJ 9530 NJ 9530 NJ 9530 NJ 9530 NJ 9530 11190
preplace netloc softGlue_300IO_v1_0_0_sg_out250 1 11 20 NJ 9060 NJ 9100 NJ 8970 NJ 8970 NJ 8980 NJ 8980 NJ 8980 NJ 8980 NJ 8980 NJ 8980 NJ 8980 NJ 8980 NJ 8980 NJ 8980 NJ 8980 NJ 8980 NJ 8980 NJ 8980 NJ 8980 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out122 1 10 2 780 5990 1320
preplace netloc softGlue_300IO_v1_0_0_sg_out123 1 10 2 750 5940 1360
preplace netloc softGlue_300IO_v1_0_0_sg_out251 1 11 20 NJ 9080 NJ 9140 NJ 9140 NJ 9240 NJ 9240 NJ 9240 NJ 9240 NJ 9240 NJ 9240 NJ 9240 NJ 9240 NJ 9240 NJ 9240 NJ 9240 NJ 9240 NJ 9240 NJ 9240 NJ 9240 NJ 9240 NJ
preplace netloc scalerChan_11_Counts 1 22 1 12190
preplace netloc softGlue_300IO_v1_0_0_sg_out252 1 11 20 NJ 9110 NJ 9150 NJ 9150 NJ 9250 NJ 9250 NJ 9250 NJ 9250 NJ 9250 NJ 9250 NJ 9250 NJ 9250 NJ 9250 NJ 9250 NJ 9250 NJ 9250 NJ 9250 NJ 9250 NJ 9250 NJ 9250 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out124 1 11 2 N 6540 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out253 1 11 20 NJ 9130 NJ 9130 NJ 9000 NJ 9000 NJ 9000 NJ 9000 NJ 9000 NJ 9000 NJ 9000 NJ 9000 NJ 9000 NJ 9000 NJ 9000 NJ 9000 NJ 9000 NJ 9010 NJ 9010 NJ 9010 NJ 9010 16130
preplace netloc OR_6_Res 1 10 17 NJ 10630 NJ 10620 NJ 10620 NJ 10480 NJ 10680 NJ 10430 NJ 10430 NJ 10430 NJ 10430 NJ 10430 NJ 10430 NJ 10430 NJ 10430 NJ 10430 NJ 10430 NJ 10430 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out125 1 11 2 N 6560 NJ
preplace netloc processing_system7_0_DDR 1 2 7 -9360 7390 NJ 7390 NJ 7390 NJ 7390 NJ 7390 NJ 7390 -1040
preplace netloc softGlue_300IO_v1_0_0_sg_out254 1 11 19 NJ 9140 NJ 9810 NJ 10050 NJ 10600 NJ 10600 NJ 10600 NJ 10600 NJ 10600 NJ 10600 NJ 10600 NJ 10600 NJ 10600 NJ 10600 NJ 10600 NJ 10600 NJ 10600 NJ 10590 NJ 10590 15900
preplace netloc softGlue_300IO_v1_0_0_sg_out126 1 11 2 N 6580 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out255 1 11 3 NJ 9150 NJ 9860 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out127 1 11 2 N 6600 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out256 1 11 3 NJ 10630 NJ 10630 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out128 1 11 4 NJ 6620 NJ 6620 NJ 6620 NJ
preplace netloc fhistoScalerStream_0_M_AXIS 1 4 1 -3490
preplace netloc scalerChan_6_Counts 1 20 3 11630 11410 NJ 11410 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out257 1 11 3 NJ 10600 NJ 10600 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out129 1 11 4 NJ 6640 NJ 6640 NJ 6640 NJ
preplace netloc xlslice_5_Dout 1 29 1 15960
preplace netloc softGlue_300IO_v1_0_0_sg_out258 1 11 3 NJ 10770 NJ 10770 NJ
preplace netloc IBUF_DS_N_6_1 1 0 1 NJ
preplace netloc IBUF_DS_P_1_1 1 0 1 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out259 1 11 3 NJ 9240 NJ 9570 NJ
preplace netloc axi_interconnect_0_M00_AXI 1 7 1 -1660
preplace netloc UpCntr_2_Counts 1 3 26 NJ 11490 NJ 11710 NJ 11710 NJ 11710 NJ 11710 NJ 11710 NJ 11710 NJ 11710 NJ 9970 NJ 9940 NJ 9940 NJ 10470 NJ 10460 NJ 10460 NJ 10460 NJ 10460 NJ 10480 NJ 10480 NJ 10480 NJ 10480 NJ 10480 NJ 10480 NJ 10480 NJ 10480 NJ 10480 NJ
preplace netloc IBUF_DS_P_9_1 1 0 1 NJ
preplace netloc sg_in064_1 1 0 22 NJ 9970 NJ 9970 NJ 9970 NJ 9970 NJ 9970 NJ 9970 NJ 9970 NJ 10570 NJ 10570 NJ 10390 NJ 10970 NJ 10970 NJ 10970 NJ 10970 NJ 10970 NJ 10960 NJ 10960 NJ 10960 NJ 11000 NJ 11000 NJ 11000 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out270 1 11 3 NJ 9460 NJ 9460 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out271 1 11 3 NJ 9480 NJ 9480 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out110 1 11 4 N 6260 NJ 6260 NJ 6260 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out272 1 11 3 NJ 9530 NJ 9530 NJ
preplace netloc demux2_1_Out0 1 10 4 NJ 10190 NJ 10170 NJ 10170 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out111 1 11 4 N 6280 NJ 6280 NJ 6280 NJ
preplace netloc scalerChan_3_Counts 1 20 3 11590 11330 NJ 11330 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out273 1 3 9 NJ 10020 NJ 10020 NJ 10020 NJ 10020 NJ 10020 NJ 10200 NJ 10200 NJ 10200 1240
preplace netloc demux2_1_Out1 1 10 4 NJ 10370 NJ 10370 NJ 10370 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out112 1 11 14 NJ 6300 NJ 6300 NJ 6300 NJ 6300 NJ 6300 NJ 6300 NJ 6300 NJ 6300 NJ 6300 NJ 6300 NJ 6300 NJ 6300 NJ 6300 NJ
preplace netloc updncntr_2_Q 1 10 6 NJ 10180 NJ 9940 NJ 9930 NJ 9930 NJ 9930 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out274 1 11 1 1500
preplace netloc softGlue_300IO_v1_0_0_sg_out113 1 11 14 NJ 6320 NJ 6320 NJ 6320 NJ 6320 NJ 6320 NJ 6320 NJ 6320 NJ 6320 NJ 6320 NJ 6320 NJ 6320 NJ 6320 NJ 6320 NJ
preplace netloc gateDelayFast_1_Q 1 13 17 6310 10120 NJ 10140 NJ 9940 NJ 9940 NJ 9940 NJ 9940 NJ 9940 NJ 9940 NJ 9940 NJ 9940 NJ 9940 NJ 9940 NJ 9940 NJ 9940 NJ 9940 NJ 9940 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out275 1 11 1 1490
preplace netloc softGlue_300IO_v1_0_0_sg_out260 1 11 3 NJ 9180 NJ 9180 NJ
preplace netloc DnCntr_2_Q 1 10 6 NJ 10530 NJ 10530 NJ 10530 NJ 10210 NJ 10210 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out114 1 11 16 NJ 6340 NJ 6340 NJ 6340 NJ 6340 NJ 6340 NJ 6340 NJ 6340 NJ 6340 NJ 6340 NJ 6340 NJ 6340 NJ 6340 NJ 6340 NJ 6340 NJ 6340 NJ
preplace netloc scalerChan_7_Counts 1 20 3 11660 11530 NJ 11500 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out276 1 11 1 1480
preplace netloc softGlue_300IO_v1_0_0_sg_out261 1 11 3 NJ 9190 NJ 9190 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out115 1 11 16 NJ 6360 NJ 6360 NJ 6360 NJ 6360 NJ 6360 NJ 6360 NJ 6360 NJ 6360 NJ 6360 NJ 6360 NJ 6360 NJ 6360 NJ 6360 NJ 6360 NJ 6360 NJ
preplace netloc scaler_or1_Res 1 17 1 10640
preplace netloc softGlue_300IO_v1_0_0_sg_out277 1 11 1 1330
preplace netloc softGlue_300IO_v1_0_0_sg_out262 1 11 3 NJ 9200 NJ 9200 NJ
preplace netloc quadDec_2_dir 1 10 6 NJ 10850 NJ 10850 NJ 10850 NJ 9970 NJ 9940 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out116 1 11 2 N 6380 NJ
preplace netloc DFF_4_Q 1 10 18 NJ 10510 NJ 10510 NJ 10510 NJ 10470 NJ 10610 NJ 10610 NJ 10610 NJ 10610 NJ 10610 NJ 10610 NJ 10610 NJ 10610 NJ 10610 NJ 10610 NJ 10610 NJ 10610 NJ 10610 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out278 1 3 9 NJ 11590 NJ 11760 NJ 11730 NJ 11730 NJ 11730 NJ 11730 NJ 11730 NJ 11730 1300
preplace netloc IBUF_DS_P_6_1 1 0 1 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out263 1 11 3 NJ 9320 NJ 9470 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out117 1 11 2 N 6400 NJ
preplace netloc xlslice_2_Dout 1 29 1 15910
preplace netloc ARESETN_1 1 6 3 -2160 10590 -1640 10590 -1100
preplace netloc softGlue_300IO_v1_0_0_sg_out264 1 11 3 NJ 9340 NJ 9580 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out118 1 11 4 N 6420 NJ 6420 NJ 6420 NJ
preplace netloc streamMux_0_m 1 5 1 -3070
preplace netloc pixelTrigger_0_Counts 1 14 15 NJ 10710 NJ 10630 NJ 10630 NJ 10630 NJ 10630 NJ 10630 NJ 10630 NJ 10630 NJ 10630 NJ 10630 NJ 10630 NJ 10630 NJ 10630 NJ 10630 NJ
preplace netloc sg_in060_1 1 0 22 NJ 9940 NJ 9940 NJ 9940 NJ 9940 NJ 9940 NJ 9940 NJ 9940 NJ 9940 NJ 10030 NJ 10030 NJ 11540 NJ 11540 NJ 11540 NJ 11540 NJ 11540 NJ 11540 NJ 11540 NJ 11540 NJ 11540 NJ 11470 NJ 11470 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out265 1 11 3 NJ 9360 NJ 9820 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out119 1 11 4 N 6440 NJ 6440 NJ 6440 NJ
preplace netloc AND_2_Res 1 10 6 NJ 10580 NJ 10450 NJ 10450 NJ 10090 NJ 10130 NJ
preplace netloc Net1 1 21 1 11960
preplace netloc xlconstant_0_dout 1 19 2 NJ 10730 11650
preplace netloc softGlue_300IO_v1_0_0_sg_out266 1 11 3 NJ 9560 NJ 9560 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out267 1 11 3 NJ 9550 NJ 9550 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out268 1 11 3 NJ 9630 NJ 9630 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out269 1 11 3 NJ 9450 NJ 9450 NJ
preplace netloc util_ds_buf_11_IBUF_OUT 1 1 10 -9670 9000 NJ 9000 NJ 9000 NJ 9000 NJ 9000 NJ 9000 NJ 9000 NJ 9000 NJ 9000 NJ
preplace netloc util_ds_buf_9_IBUF_OUT 1 1 10 -9660 8960 NJ 8960 NJ 8960 NJ 8960 NJ 8960 NJ 8960 NJ 8960 NJ 8960 NJ 8960 NJ
preplace netloc DFF_5_Q 1 18 4 NJ 8920 NJ 8920 NJ 8920 11820
preplace netloc softGlue_300IO_v1_0_0_sg_out100 1 11 2 N 6060 NJ
preplace netloc divByN_3_Q 1 10 16 NJ 10420 NJ 10420 NJ 10420 NJ 10400 NJ 10770 NJ 10770 NJ 10770 NJ 10770 NJ 10780 NJ 10780 NJ 10870 NJ 10870 NJ 10870 NJ 10870 NJ 10870 NJ
preplace netloc scalerChan_8_Counts 1 20 3 11640 11430 NJ 11430 NJ
preplace netloc sg_in070_1 1 0 11 NJ 8460 NJ 8460 NJ 8460 NJ 8460 NJ 8460 NJ 8460 NJ 8460 NJ 8460 NJ 8460 NJ 8460 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out101 1 11 2 N 6080 NJ
preplace netloc gateDly_1_Q 1 10 4 NJ 10680 NJ 10680 NJ 10680 NJ
preplace netloc scalerChan_5_Counts 1 20 3 11610 11400 NJ 11400 NJ
preplace netloc axi_dma_0_s2mm_introut 1 7 1 -1610
preplace netloc softGlue_300IO_v1_0_0_sg_out102 1 11 4 N 6100 NJ 6100 NJ 6100 NJ
preplace netloc mux2_1_Outp 1 10 16 NJ 10720 NJ 10720 NJ 10720 NJ 10540 NJ 10690 NJ 10680 NJ 10680 NJ 10680 NJ 10680 NJ 10680 NJ 10880 NJ 10880 NJ 10880 NJ 10880 NJ 10880 13500
preplace netloc sg_in054_1 1 0 20 NJ 9810 NJ 9810 NJ 9890 NJ 9890 NJ 9890 NJ 9890 NJ 9890 NJ 9890 NJ 9890 NJ 9890 NJ 12030 NJ 12030 NJ 12030 NJ 12030 NJ 12030 NJ 12030 NJ 12030 NJ 12030 NJ 12030 NJ
preplace netloc softGlue_300IO_v1_0_0_sg_out103 1 11 4 N 6120 NJ 6120 NJ 6120 NJ
levelinfo -pg 1 -20150 -9890 -9530 -4380 -3720 -3150 -2440 -1910 -1320 -790 -160 1060 2260 6032 7240 9740 10340 10550 10730 11090 11450 11740 12070 12420 12730 13330 13670 14180 14570 15550 16020 16300 -top -1070 -bot 15060
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


