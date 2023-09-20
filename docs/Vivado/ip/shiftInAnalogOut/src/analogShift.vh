module shiftIn(
	input [2:0] shiftCtrl,
	input wire shiftIn,
	output reg [11:0] valueOut
);
	reg [11:0] value;
	wire shiftClock;
	wire shiftInit;
	wire shiftLatch;
	wire [11:0] nextValue;

	assign
		shiftInit	= shiftCtrl[2],
		shiftClock	= shiftCtrl[1],
		shiftLatch	= shiftCtrl[0],
		nextValue	= {value[10:0], shiftIn};

	always @(posedge shiftInit, negedge shiftClock)
		if (shiftInit)
			value <= 0;
		else
			value <= nextValue;

	always @(posedge shiftLatch)
		valueOut <= value;

endmodule

module shiftOut(
	input [2:0] shiftCtrl,
	input [11:0] valueIn,
	output wire shiftOut
);

	reg [11:0] value;
	wire shiftClock;
	wire shiftInit;
	wire shiftLatch;
	reg waitReg;
	wire [11:0] nextValue;

	initial waitReg = 0;

	assign
		shiftClock	= shiftCtrl[1],
		shiftInit	= shiftCtrl[2],
		shiftLatch	= shiftCtrl[0],
		nextValue	= value<<1;

	assign shiftOut = value[11];
	
	always @(posedge shiftInit, posedge shiftClock)
		if (shiftInit) begin
			value <= valueIn;
			waitReg <= 1;
		end	else if (shiftClock) begin
			waitReg <=0;
			if (~waitReg) value <= nextValue;
		end

endmodule

module shiftInDebug(
	input [2:0] shiftCtrl,
	input wire shiftIn,
	output reg [11:0] valueOut,
	// debug
	output [11:0] value
);
	reg [11:0] value;
	wire shiftClock;
	wire shiftInit;
	wire shiftLatch;
	wire [11:0] nextValue;
	
	assign
		shiftInit	= shiftCtrl[2],
		shiftClock	= shiftCtrl[1],
		shiftLatch	= shiftCtrl[0],
		nextValue	= {value[10:0], shiftIn};

	always @(posedge shiftInit, negedge shiftClock)
		if (shiftInit)
			value <= 0;
		else
			value <= nextValue;

	always @(posedge shiftLatch)
		valueOut <= value;
	
endmodule

