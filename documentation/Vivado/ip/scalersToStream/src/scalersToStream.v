

module scalersToStream (
	input [30:0] in0,
	input [30:0] in1,
	input [30:0] in2,
	input [30:0] in3,
	input [30:0] in4,
	input [30:0] in5,
	input [30:0] in6,
	input [30:0] in7,
	output reg chanAdvDone,
	input chanAdv,
	input tlastResetN,
	input [16:0] packetWords,

	input wire M_AXIS_ACLK,
	// stream interface
	output [31:0] M_AXIS_TDATA,
	output reg M_AXIS_TVALID,
	output reg M_AXIS_TLAST,
	input wire M_AXIS_TREADY

);
	reg [1:0] rChanAdv;
	reg transferInProg;
	reg [3:0] currInReg;
	reg [31:0] inReg0;
	reg [31:0] inReg1;
	reg [31:0] inReg2;
	reg [31:0] inReg3;
	reg [31:0] inReg4;
	reg [31:0] inReg5;
	reg [31:0] inReg6;
	reg [31:0] inReg7;
	reg [31:0] outReg;
	reg [10:0] eventCounter;
	reg [31:0] prevPixel;
	reg [31:0] pixel;
	reg havePrevPixel;

	assign M_AXIS_TDATA = outReg;

	initial begin
		transferInProg <= 0;
		currInReg <= 0;
		chanAdvDone <= 0;
		M_AXIS_TVALID <= 0;
		M_AXIS_TLAST <= 0;
		eventCounter <= 0;
		havePrevPixel <= 0;
	end

	// detect rising and falling edges
	always @(posedge M_AXIS_ACLK) begin
		rChanAdv <= {rChanAdv[0], chanAdv};
	end

	always @(posedge M_AXIS_ACLK) begin
		chanAdvDone <= 0;
		M_AXIS_TLAST <= 0;
		if (tlastResetN == 0) begin
			eventCounter <= 0;
			havePrevPixel <= 0;
		end

		if (transferInProg) begin
			M_AXIS_TVALID <= 1;
			// put data to output register
			case (currInReg)
			4'h0: outReg <= inReg0;
			4'h1: outReg <= inReg1;
			4'h2: outReg <= inReg2;
			4'h3: outReg <= inReg3;
			4'h4: outReg <= inReg4;
			4'h5: outReg <= inReg5;
			4'h6: outReg <= inReg6;
			4'h7: outReg <= inReg7;
			4'h8: begin M_AXIS_TVALID <= 0; transferInProg <= 0; end
			default: outReg <= outReg;
			endcase

			if (M_AXIS_TREADY) begin
				/* We just transferred a register.  Setup for next register. */
				currInReg <= currInReg + 1;
				if (currInReg == 7) begin
					if (eventCounter == packetWords/8-1) begin
						// tlast every packetWords/8 events
						M_AXIS_TLAST <= 1;
						eventCounter <= 0;
					end else begin
						eventCounter <= eventCounter+1;
					end
				end
			end
		end else if (rChanAdv==2'b01) begin
			pixel <= {1, in0};
			prevPixel <= pixel;
			havePrevPixel <= 1;
			if (transferInProg==0 && havePrevPixel==1) begin
				// take snapshot of input values, and start transfer to output reg
				transferInProg <= 1;
				currInReg <= 0;
				inReg0 <= prevPixel;
				inReg1 <= in1;
				inReg2 <= in2;
				inReg3 <= in3;
				inReg4 <= in4;
				inReg5 <= in5;
				inReg6 <= in6;
				inReg7 <= in7;
				// Tell whomever is interested that we have cached the data
				chanAdvDone <= 1;
			end
		end
	end
endmodule
