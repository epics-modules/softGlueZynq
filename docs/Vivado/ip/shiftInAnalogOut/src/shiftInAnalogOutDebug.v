`include "analogShift.vh"

module shiftInAnalogOutDebug(
	input [2:0] shiftCtrl,
	output wire [11:0] analogValue,
	input wire y,
	// debug
	output [11:0] value

);

	shiftInDebug si(.shiftCtrl(shiftCtrl), .shiftIn(y), .valueOut(analogValue), .value(value));

endmodule
