
`timescale 1 ns / 1 ps

	module registerToStream_v1_0_M00_AXIS #
	(
		// Users to add parameters here
		parameter integer FIFO_POINTER_BITS = 5,
		localparam integer FIFO_LENGTH = 2**FIFO_POINTER_BITS,

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		parameter integer C_M_AXIS_TDATA_WIDTH	= 32,
		// Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.
		parameter integer C_M_START_COUNT	= 32
	)
	(
		// Users to add ports here
		input wire [C_M_AXIS_TDATA_WIDTH-1 : 0] inData,
		input wire writeCk,
		
		// user debug stuff
		output reg [1:0] mst_exec_state,
		output reg [FIFO_POINTER_BITS-1:0] FIFO_cnt,

		// User ports ends
		// Do not modify the ports beyond this line

		// Global ports
		input wire M_AXIS_ACLK,
		// 
		input wire M_AXIS_ARESETN,
		// Master Stream Ports. TVALID indicates that the master is driving a valid transfer,
		// A transfer takes place when both TVALID and TREADY are asserted. 
		output wire M_AXIS_TVALID,
		// TDATA is the data we're sending.
		output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA,
		// TSTRB is the byte qualifier that indicates whether the content of the associated
		// byte of TDATA is processed as a data byte or a position byte.
		output wire [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] M_AXIS_TSTRB,
		// TLAST indicates the boundary of a packet.
		output wire M_AXIS_TLAST,
		// TREADY indicates that the slave can accept a transfer in the current cycle.
		input wire M_AXIS_TREADY
	);

	// function called clogb2 that returns an integer which has the
	// value of the ceiling of the log base 2.
	function integer clogb2 (input integer bit_depth);
		begin
			for (clogb2=0; bit_depth>0; clogb2=clogb2+1)
				bit_depth = bit_depth >> 1;
		end
	endfunction

	// WAIT_COUNT_BITS is the width of the wait counter.
	localparam integer WAIT_COUNT_BITS = clogb2(C_M_START_COUNT-1);

	// Define the states of state machine
	// The control state machine oversees the writing of input streaming data to the FIFO,
	// and outputs the streaming data from the FIFO
	parameter [1:0]	IDLE         = 2'b00,
					INIT_COUNTER = 2'b01,
					SEND_STREAM  = 2'b10;
	// State variable
	reg [1:0] mst_exec_state;

	// AXI Stream internal signals
	// wait counter. The master waits for the user defined number of clock cycles before
	// initiating a transfer.
	reg [WAIT_COUNT_BITS-1 : 0] count;
	// streaming data valid
	wire axis_tvalid;
	// streaming data valid delayed by one clock cycle
	reg axis_tvalid_delay;
	// Last of the streaming data 
	wire axis_tlast;
	// Last of the streaming data delayed by one clock cycle
	reg axis_tlast_delay;
	// FIFO implementation signals
	reg [C_M_AXIS_TDATA_WIDTH-1 : 0] stream_data_out;
	wire tx_en;
	// The master has issued all the streaming data stored in FIFO
	reg tx_done;


	// I/O Connections assignments

	assign M_AXIS_TVALID = axis_tvalid_delay;
	assign M_AXIS_TDATA  = stream_data_out;
	assign M_AXIS_TLAST  = axis_tlast_delay;
	assign M_AXIS_TSTRB  = {(C_M_AXIS_TDATA_WIDTH/8){1'b1}};


	// Control state machine implementation
	always @(posedge M_AXIS_ACLK) begin
		if (!M_AXIS_ARESETN) begin
			// Synchronous reset (active low)
			mst_exec_state <= IDLE;
			count <= 0;
		end else begin
			case (mst_exec_state)
				IDLE:
					mst_exec_state <= INIT_COUNTER;

				INIT_COUNTER:
					if (count == C_M_START_COUNT-1) begin
						if (FIFO_cnt > 4) begin
							mst_exec_state <= SEND_STREAM;
						end else begin
							mst_exec_state <= INIT_COUNTER;
						end
					end else begin
						count <= count + 1;
						mst_exec_state <= INIT_COUNTER;
					end

				SEND_STREAM:
					if (tx_done) begin
						mst_exec_state <= IDLE;
					end else begin
						mst_exec_state <= SEND_STREAM;
					end
			endcase
		end
	end


	// tvalid generation
	assign axis_tvalid = ((mst_exec_state == SEND_STREAM) && (FIFO_cnt > 0));

	// AXI tlast generation
	assign axis_tlast = axis_tvalid && (FIFO_cnt == 1);

	// Delay the axis_tvalid and axis_tlast signal by one clock cycle
	// to match the latency of M_AXIS_TDATA
	always @(posedge M_AXIS_ACLK) begin
		if (!M_AXIS_ARESETN) begin
			axis_tvalid_delay <= 1'b0;
			axis_tlast_delay <= 1'b0;
		end else begin
			axis_tvalid_delay <= axis_tvalid;
			axis_tlast_delay <= axis_tlast;
		end
	end


	// FIFO read enable generation 
	assign tx_en = M_AXIS_TREADY && axis_tvalid;
	// Streaming output data is read from FIFO
	always @( posedge M_AXIS_ACLK ) begin
		if (!M_AXIS_ARESETN) begin
			stream_data_out <= 1;
		///end else if (tx_en) begin
		end else begin
			// We put data into stream_data_out on the clock pulse after axis_tvalid gets set,
			// so we're going to have to delay the copy of axis_tvalid we send to the slave.
			stream_data_out <= fifo_ram[rd_ptr];
		end
	end

	// FIFO_read, clearedFIFO, tx_done
	always @(posedge M_AXIS_ACLK) begin
		if (!M_AXIS_ARESETN) begin
			clearedFIFO <= {clearedFIFO[0], 1'b1};
			tx_done <= 1'b0;
			FIFO_read <= 1'b0;
		end else begin
			clearedFIFO <= {clearedFIFO[0], 1'b0};
			if (FIFO_cnt > 0) begin
				if (tx_en) begin
					FIFO_read <= 1'b1;
					tx_done <= 1'b0;
				end else begin
					FIFO_read <= 1'b1;
				end
			end else begin
				tx_done <= 1'b1;
				FIFO_read <= 1'b0;
			end
		end
	end



	// Add user logic here
	reg [31:0] fifo_ram[0:FIFO_LENGTH-1];
	reg [FIFO_POINTER_BITS-1:0] rd_ptr, wr_ptr;
	reg [FIFO_POINTER_BITS-1:0] FIFO_cnt;
	reg [1:0] rWriteCk;
	reg [1:0] clearedFIFO;
	wire FIFO_write, FIFO_clear;
	reg FIFO_read;

	assign FIFO_write	= (rWriteCk==2'b01);
	assign FIFO_clear	= (clearedFIFO==2'b01);

	always @(posedge M_AXIS_ACLK) begin
		rWriteCk <= {rWriteCk[0], writeCk};

		if (FIFO_write && FIFO_read) begin
			fifo_ram[wr_ptr] <= inData;
			wr_ptr <= wr_ptr + 1;
			rd_ptr <= rd_ptr + 1;
			FIFO_cnt <= FIFO_cnt;
		end else if (FIFO_write) begin
			if (FIFO_cnt!=FIFO_LENGTH-1) begin
				fifo_ram[wr_ptr] <= inData;
				wr_ptr <= wr_ptr + 1;
				FIFO_cnt <= FIFO_cnt + 1;
			end
		end else if (FIFO_read) begin
			if (FIFO_cnt!=0) begin
				rd_ptr <= rd_ptr + 1;
				FIFO_cnt <= FIFO_cnt - 1; 
			end
		end else if (FIFO_clear) begin
			wr_ptr <= 0; 
			rd_ptr <= 0;
			FIFO_cnt <= 0;
		end
	end

	// User logic ends

	endmodule
