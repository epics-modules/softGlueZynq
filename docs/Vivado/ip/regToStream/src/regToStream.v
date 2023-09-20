
`timescale 1 ns / 1 ps

	module regToStream_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		parameter integer C_M_AXIS_TDATA_WIDTH	= 32
	)
	(
		// Users to add ports here
		input wire [C_M_AXIS_TDATA_WIDTH-1 : 0] inData,
		input wire writeCk,
		output wire xfer,

		// User ports ends
		// Do not modify the ports beyond this line

		// Global ports
		input wire M_AXIS_ACLK,
		// 
		input wire M_AXIS_ARESETN,
		// Master Stream Ports. TVALID indicates that the master is driving a valid transfer,
		// A transfer takes place when both TVALID and TREADY are asserted. 
		output wire M_AXIS_TVALID,
		output wire M_AXIS_TLAST,
		// TDATA is the data we're sending.
		output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA,
		// TREADY indicates that the slave can accept a transfer in the current cycle.
		input wire M_AXIS_TREADY
	);
	reg [1:0] writeCkReg;
	reg [31:0] inDataReg;
	reg valid;

	assign M_AXIS_TDATA = inDataReg;
	assign M_AXIS_TVALID = valid;
	assign M_AXIS_TLAST = 1;
	assign xfer = M_AXIS_TVALID & M_AXIS_TREADY;
	
	always @(posedge M_AXIS_ACLK) begin
		if (!M_AXIS_ARESETN) begin
			// Synchronous reset (active low)
			writeCkReg <= 2'b00;
			valid <= 0;
		end else begin
			writeCkReg <= {writeCkReg[0], writeCk};
			if (writeCkReg == 2'b01) begin
				inDataReg <= inData;
				valid <= 1;
			end else begin
				valid <= 0;
			end
		end
	end

	endmodule
