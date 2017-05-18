`define SHIFTLATCH shiftCtrl[0]
`define SHIFTCLOCK shiftCtrl[1]
`define SHIFTINIT  shiftCtrl[2]

module shiftInAnalogOut(
	input regClk,
	input [2:0] shiftCtrl,
	output [2:0] shiftCtrlOut,
	output wire latch,
	output [11:0] analogValue,
	input wire y,

	// debug
	output [11:0] inReg
);
	wire shiftInit;
	wire shiftClock;
	wire shiftLatch;
	reg [11:0] analogValue;
	wire latch;

	reg [1:0] rShiftClock, rShiftInit, rShiftLatch;

	// detect edges
	always @(negedge regClk) begin
		rShiftClock <= {rShiftClock[0], `SHIFTCLOCK};
		rShiftInit <= {rShiftInit[0], `SHIFTINIT};
		rShiftLatch <= {rShiftLatch[0], `SHIFTLATCH};
	end

	assign
		shiftCtrlOut = shiftCtrl,
		latch = `SHIFTLATCH;


//	// shift in ----------------------------------------
//	reg [11:0] inReg;
//	reg [10:0] nextInReg;
//
//	always @(posedge shiftInit, negedge shiftClock)
//		if (shiftInit)
//			inReg <= 0;
//		else
//			inReg <= {nextInReg, y};
//
//	always @(posedge shiftClock)
//		nextInReg <= inReg[10:0];
//
//	always @(posedge shiftLatch)
//		analogValue <= inReg;

	// shift in ----------------------------------------
	reg [11:0] inReg;

	//always @(posedge shiftInit, negedge shiftClock)
	always @(negedge regClk) begin
		if (rShiftInit==2'b01) begin
			inReg <= 0;
		end else if (rShiftClock==2'b10) begin
			inReg <= {inReg[10:0], y};
		end
	end

	//always @(posedge shiftLatch)
	always @(negedge regClk)
		if (rShiftLatch==2'b01) 
			analogValue <= inReg;

endmodule
