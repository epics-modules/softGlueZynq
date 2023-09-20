
`timescale 1 ns / 1 ps

	module registerToStream_v1_0 #
	(
		// Users to add parameters here
		parameter integer FIFO_POINTER_BITS = 5,

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Master Bus Interface M00_AXIS
		parameter integer C_M00_AXIS_TDATA_WIDTH	= 32,
		parameter integer C_M00_AXIS_START_COUNT	= 32
	)
	(
		// Users to add ports here
		input wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] inData,
		input wire writeCk,
		// user debug stuff
		output wire [1:0] mst_exec_state,
		output wire [FIFO_POINTER_BITS-1:0] FIFO_cnt,

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Master Bus Interface M00_AXIS
		input wire  m00_axis_aclk,
		input wire  m00_axis_aresetn,
		output wire  m00_axis_tvalid,
		output wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
		output wire [(C_M00_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb,
		output wire  m00_axis_tlast,
		input wire  m00_axis_tready
	);
// Instantiation of Axi Bus Interface M00_AXIS
	registerToStream_v1_0_M00_AXIS # (
		.FIFO_POINTER_BITS(FIFO_POINTER_BITS),
		.C_M_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH),
		.C_M_START_COUNT(C_M00_AXIS_START_COUNT)
	) registerToStream_v1_0_M00_AXIS_inst (
		// my stuff
		.inData(inData),
		.writeCk(writeCk),
		.mst_exec_state(mst_exec_state),
		.FIFO_cnt(FIFO_cnt),
		// standard stuff
		.M_AXIS_ACLK(m00_axis_aclk),
		.M_AXIS_ARESETN(m00_axis_aresetn),
		.M_AXIS_TVALID(m00_axis_tvalid),
		.M_AXIS_TDATA(m00_axis_tdata),
		.M_AXIS_TSTRB(m00_axis_tstrb),
		.M_AXIS_TLAST(m00_axis_tlast),
		.M_AXIS_TREADY(m00_axis_tready)
	);

	// Add user logic here

	// User logic ends

	endmodule
