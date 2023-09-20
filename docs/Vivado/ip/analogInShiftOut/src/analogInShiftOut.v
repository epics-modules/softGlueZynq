`define SHIFTCLOCK shiftCtrl[1]
`define SHIFTINIT  shiftCtrl[2]

module analogInShiftOut(
	input regClk,
	input [2:0] shiftCtrl,
	input wire [11:0] analogValue,
	output wire y
);
	reg [12:0] value;
	reg [1:0] rShiftClock, rShiftInit;

	// detect edges
	always @(negedge regClk) begin
		rShiftClock <= {rShiftClock[0], `SHIFTCLOCK};
		rShiftInit <= {rShiftInit[0], `SHIFTINIT};
	end

	assign y = value[12];
	
	//always @(posedge `SHIFTINIT, posedge `SHIFTCLOCK)
	always @(negedge regClk) begin
		if (rShiftInit==2'b01) begin
			value <= {1'b0, analogValue};
		end else if (rShiftClock==2'b01) begin
			value <= {value[11:0], 1'b0};;
		end
	end
endmodule


//module analogInShiftOut(
//	input [2:0] shiftCtrl,
//	input wire [11:0] analogValue,
//	output wire y
//);
//	reg [12:0] value;
//	assign y = value[12];
//	
//	always @(posedge `SHIFTINIT, posedge `SHIFTCLOCK)
//		if (`SHIFTINIT) begin
//			value <= {1'b0, analogValue};
//		end else if (`SHIFTCLOCK) begin
//			value <= {value[11:0], 1'b0};;
//		end
//
//endmodule
