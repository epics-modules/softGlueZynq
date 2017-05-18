`define SHIFTLATCH shiftCtrl[0]
`define SHIFTCLOCK shiftCtrl[1]
`define SHIFTINIT  shiftCtrl[2]

module filter(
	input regClk,
	input [2:0] shiftCtrl,
	output [11:0] analogValueIn, // debug
	output [11:0] analogValueOut, // debug
	input wire[31:0] parm,
	output wire yOut,
	input wire yIn
);
	reg [11:0] analogValueIn;
	wire [11:0] analogValueOut;

	reg [1:0] rShiftClock, rShiftInit, rShiftLatch;

	// detect edges
	always @(negedge regClk) begin
		rShiftClock <= {rShiftClock[0], `SHIFTCLOCK};
		rShiftInit <= {rShiftInit[0], `SHIFTINIT};
		rShiftLatch <= {rShiftLatch[0], `SHIFTLATCH};
	end

	// filter --------------------------------------------------
	wire [19:0] aIn;
	reg [19:0] aOut;


	initial begin
		aOut = 20'b0;
	end

	assign
		aIn = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, analogValueIn},
		analogValueOut = aOut[11:0];

	//always @(negedge shiftLatch) begin
	always @(negedge regClk) begin
		if (rShiftLatch==2'b10) begin
			case (parm[2:0])
			default:
				// aOut1 = aIn
				aOut <= aIn;
			3'h0:
				// aOut1 = aIn
				aOut <= aIn;
			3'h1:
				// aOut1 = (aIn + 1*aOut0)/2
				aOut <= (aIn+aOut)>>1;
			3'h2:
				// aOut1 = (aIn + 3*aOut0)/4
				aOut <= (aIn+(aOut<<2)-aOut)>>2;
			3'h3:
				// aOut1 = (aIn + 7*aOut0)/8
				aOut <= (aIn+(aOut<<3)-aOut)>>3;
			3'h4:
				// aOut1 = (aIn + 15*aOut0)/16
				aOut <= (aIn+(aOut<<4)-aOut)>>4;
			3'h5:
				// aOut1 = (aIn + 32*aOut0)/16
				aOut <= (aIn+(aOut<<5)-aOut)>>5;
			3'h6:
				// aOut1 = (aIn + 63*aOut0)/64
				aOut <= (aIn+(aOut<<6)-aOut)>>6;
			3'h7:
				// aOut1 = (aIn + 127*aOut0)/128
				aOut <= (aIn+(aOut<<7)-aOut)>>7;
			endcase
		end
	end

	// shift in ----------------------------------------
	reg [11:0] inReg;

	//always @(posedge shiftInit, negedge shiftClock)
	always @(negedge regClk) begin
		if (rShiftInit==2'b01) begin
			inReg <= 0;
		end else if (rShiftClock==2'b10) begin
			inReg <= {inReg[10:0], yIn};
		end
	end

	//always @(posedge shiftLatch)
	always @(negedge regClk)
		if (rShiftLatch==2'b01) 
			analogValueIn <= inReg;

	// shift out ---------------------------------------
	reg [12:0] outReg;

	assign yOut = outReg[12];
 
	//always @(posedge shiftInit, posedge shiftClock)
	always @(negedge regClk) begin
		if (rShiftInit==2'b01) begin
			outReg <= analogValueOut;
		end else if (rShiftClock==2'b01) begin
			outReg <= outReg<<1;
		end
	end

endmodule
