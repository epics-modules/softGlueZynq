`define SHIFTLATCH shiftCtrl[0]
`define SHIFTCLOCK shiftCtrl[1]
`define SHIFTINIT  shiftCtrl[2]

module shiftInShiftOut(
	input regClk,
	input [2:0] shiftCtrl,
	output [11:0] analogValueIn, // debug
	output wire yOut,
	input wire yIn
);
	reg [11:0] analogValueIn;
	reg [11:0] analogValueOut;

	reg [1:0] rShiftClock, rShiftInit, rShiftLatch;

	// detect edges
	always @(negedge regClk) begin
		rShiftClock <= {rShiftClock[0], `SHIFTCLOCK};
		rShiftInit <= {rShiftInit[0], `SHIFTINIT};
		rShiftLatch <= {rShiftLatch[0], `SHIFTLATCH};
	end

	//always @(negedge shiftLatch)
	always @(negedge regClk)
		if (rShiftLatch==2'b10)
			analogValueOut <= analogValueIn;

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
