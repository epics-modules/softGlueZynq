# If only inputs are clocked, measure from clock input of all registers that drive a softGlue component to the D input of all those same registers:
# (Note that "input" means input from the viewpoint of a softGlue component, such as an AND gate.)
#set_max_delay 10 -datapath_only -from [get_pins */softGlue_300IO_*/inst/softGlue_300IO_*/in*/y_reg/C] -to [get_pins */softGlue_300IO_*/inst/softGlue_300IO_*/in*/y_reg/D] 10.000

### From "Tools/Timing/Report Timing Summary" (when flow "Implementation" is selected) Options: 5000 paths per group, report_unconstrained_paths
# example: -from "design_1_i/divByN_2/inst/counterMinusOne_reg[3]/C" -to "design_1_i/divByN_2/inst/counter_reg[6]_C/D"
# Can check these by entering, e.g., "puts [get_pins "*/divByN_1/inst/*/C"]" into the Tcl Console
# Note can use regexp to match ../C and ../G : [get_pins -regexp ".*/divByN_1/inst/counter.*_reg.*/\[CG\]"]



# Stuff we don't care about #############################################################################
# We don't care about Reg32 stuff.  The data will arrive eventually.
# Somehow, there are no valid startpoints or endpoints in these pin collections, so we don't need them.
#set_false_path -from [get_pins -hier "softGlueReg32_*/slv_reg*"]
# example: design_1_i/softGlueReg32_v1_0_0/inst/softGlueReg32_v1_0_S00_AXI_inst/slv_reg32_reg[0]
#set_false_path -to [get_pins -hier "softGlueReg32_*/slv_reg*"]
# example: design_1_i/softGlueReg32_v1_0_0/inst/softGlueReg32_v1_0_S00_AXI_inst/slv_reg32[6]_i_2

# if outputs are clocked, and we don't care about timing to them
#set_false_path -from * -to [get_pins */softGlue_*/inst/softGlue_*/out*/y_clocked_reg/*]

# We don't care how long it takes to write new control information to softGlue
set_false_path -from [get_pins {*/softGlue_*/inst/softGlue_*/slv_reg*[*]/C}]
set_false_path -to [get_pins {*/softGlue_*/inst/softGlue_*/slv_reg*[*]/D}]

# Misc stuff that has failed timing, and that we don't care about.
set_false_path -to [get_pins {*/softGlueReg32_*/inst/softGlueReg32_*/axi_rdata_reg[*]/D}]
set_false_path -to [get_pins {*/softGlueReg32_*/inst/softGlueReg32_*/axi_rdata_reg[*]/D}]
set_false_path -from [get_pins {*/softGlue_300IO_*/inst/softGlue_300IO_*/slv_reg*[*]/C}] 
set_false_path -from [get_pins {*/softGlue_300IO_*/inst/softGlue_300IO_*/slv_reg*[*]/C}]

set_false_path -to [get_pins */softGlue_300IO_*/inst/softGlue_300IO_*/intr_*/* -filter {NAME!~*/C && NAME!~*/O && NAME!~*/I* && NAME!~*/Q}]

# We don't care how long it takes for readbacks to get to the registers software will read.
set_false_path -from [get_pins */softGlue_300IO_*/inst/softGlue_300IO_*/in*/y_reg/C] -to [get_pins {*/softGlue_300IO_*/inst/softGlue_300IO_*/r_RB_reg[*][*]/D}]
set_false_path -from [get_pins {*/softGlue_300IO_*/inst/softGlue_300IO_*/in*/s_RB_reg[*]/C}] -to [get_pins {*/softGlue_300IO_*/inst/softGlue_300IO_*/r_RB_reg[*][*]/D}]
set_false_path -from [get_pins {*/softGlue_300IO_*/inst/softGlue_300IO_*/out*/s_RB_reg[*]/C}] -to [get_pins {*/softGlue_300IO_*/inst/softGlue_300IO_*/r_RB_reg[*][*]/D}]
set_false_path -from [get_pins {*/softGlue_300IO_*/inst/softGlue_300IO_*/r_RB_reg[*][*]/C}] -to [get_pins {*/softGlue_300IO_*/inst/softGlue_300IO_*/axi_rdata_reg[*]/D}]
set_false_path -from [get_pins */softGlue_300IO_*/inst/softGlue_300IO_*/out*/y_clocked_reg/C] -to [get_pins */softGlue_300IO_*/inst/softGlue_300IO_*/r_RB_reg[*][*]/D]
set_false_path -from */softGlue_300IO_*/inst/softGlue_300IO_*/in*/y_reg/C -to */softGlue_300IO_*/inst/softGlue_300IO_*/out*/s_RB_reg[*]/D

#set_clock_groups -name async_clk0_clk1 -asynchronous -group {clk_out1_design_1_clk_wiz_0_0} -group {clk_out2_design_1_clk_wiz_0_0} -group {clk_out3_design_1_clk_wiz_0_0} -group {clk_out4_design_1_clk_wiz_0_0}
#set_clock_groups -asynchronous -group clk_out1_design_1_clk_wiz0_0_0_0 -group clk_out2_design_1_clk_wiz0_0_0_0 -group clk_out3_design_1_clk_wiz0_0_0_0 -group clk_out4_design_1_clk_wiz0_0_0_0 -group clk_out5_design_1_clk_wiz0_0_0_0 -group clk_out6_design_1_clk_wiz0_0_0_0 -group clk_fpga_0
set_clock_groups -asynchronous -group [get_clocks clk_out1*wiz0*] -group [get_clocks clk_out2*wiz0*] -group [get_clocks clk_out3*wiz0*] -group [get_clocks clk_out4*wiz0*] -group [get_clocks clk_out5*wiz0*] -group [get_clocks clk_out1*wiz1*] -group clk_fpga_0

# See http://www.xilinx.com/support/answers/62136.html for how wildcard (*) works.  In short, it doesn't cross '/' unless you say "-hier"
# See http://www.xilinx.com/support/documentation/sw_manuals/xilinx2013_1/ug835-vivado-tcl-commands.pdf

# For a timing check with ALL the information: "check_timing -verbose -file my_timing_report.txt"

# connected FI_12 to input of clk_wiz_1.  Make it a 50 MHz clock for now.
# Maybe I don't have to or shouldn't do this.  Vivado makes the file
# design_1_clk_wiz_1_0.xdc, and complains that the following command overrides
# the create_clock command in that file
#create_clock -period 20.000 -name input_bunchClk_44 -waveform {0.000 10.000} [get_ports FI_22]
