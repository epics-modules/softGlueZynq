
`timescale 1 ns / 1 ps

	module softGlueReg32_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 8
	)
	(
		// Users to add ports here
		input [31:0] out_reg0,  out_reg1,  out_reg2,  out_reg3,
				out_reg4,  out_reg5,  out_reg6,  out_reg7,
				out_reg8,  out_reg9,  out_reg10, out_reg11,
				out_reg12, out_reg13, out_reg14, out_reg15,
				out_reg16, out_reg17, out_reg18, out_reg19,
				out_reg20, out_reg21, out_reg22, out_reg23,
				out_reg24, out_reg25, out_reg26, out_reg27,
				out_reg28, out_reg29, out_reg30, out_reg31,

		output [31:0] in_reg32, in_reg33, in_reg34, in_reg35,
				in_reg36, in_reg37, in_reg38, in_reg39,
				in_reg40, in_reg41, in_reg42, in_reg43,
				in_reg44, in_reg45, in_reg46, in_reg47,
				in_reg48, in_reg49, in_reg50, in_reg51,
				in_reg52, in_reg53, in_reg54, in_reg55,
				in_reg56, in_reg57, in_reg58, in_reg59,
				in_reg60, in_reg61, in_reg62, in_reg63,

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);
// Instantiation of Axi Bus Interface S00_AXI
	softGlueReg32_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) softGlueReg32_v1_0_S00_AXI_inst (

		.out_reg0(out_reg0),  .out_reg1(out_reg1),  .out_reg2(out_reg2),  .out_reg3(out_reg3),
		.out_reg4(out_reg4),  .out_reg5(out_reg5),  .out_reg6(out_reg6),  .out_reg7(out_reg7),
		.out_reg8(out_reg8),  .out_reg9(out_reg9),  .out_reg10(out_reg10), .out_reg11(out_reg11),
		.out_reg12(out_reg12), .out_reg13(out_reg13), .out_reg14(out_reg14), .out_reg15(out_reg15),
		.out_reg16(out_reg16), .out_reg17(out_reg17), .out_reg18(out_reg18), .out_reg19(out_reg19),
		.out_reg20(out_reg20), .out_reg21(out_reg21), .out_reg22(out_reg22), .out_reg23(out_reg23),
		.out_reg24(out_reg24), .out_reg25(out_reg25), .out_reg26(out_reg26), .out_reg27(out_reg27),
		.out_reg28(out_reg28), .out_reg29(out_reg29), .out_reg30(out_reg30), .out_reg31(out_reg31),

		.in_reg32(in_reg32), .in_reg33(in_reg33), .in_reg34(in_reg34), .in_reg35(in_reg35),
		.in_reg36(in_reg36), .in_reg37(in_reg37), .in_reg38(in_reg38), .in_reg39(in_reg39),
		.in_reg40(in_reg40), .in_reg41(in_reg41), .in_reg42(in_reg42), .in_reg43(in_reg43),
		.in_reg44(in_reg44), .in_reg45(in_reg45), .in_reg46(in_reg46), .in_reg47(in_reg47),
		.in_reg48(in_reg48), .in_reg49(in_reg49), .in_reg50(in_reg50), .in_reg51(in_reg51),
		.in_reg52(in_reg52), .in_reg53(in_reg53), .in_reg54(in_reg54), .in_reg55(in_reg55),
		.in_reg56(in_reg56), .in_reg57(in_reg57), .in_reg58(in_reg58), .in_reg59(in_reg59),
		.in_reg60(in_reg60), .in_reg61(in_reg61), .in_reg62(in_reg62), .in_reg63(in_reg63),

		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready)
	);

	// Add user logic here

	// User logic ends

	endmodule
