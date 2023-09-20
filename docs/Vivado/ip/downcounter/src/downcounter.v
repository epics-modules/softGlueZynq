`timescale 1 ns / 1 ps

// clocked by softGlueRegClk
module downcounter (
	input wire regClk, En, Clk, Load,
	input [31:0] Preset,
	output reg Q,
	output reg [31:0] Counts
);
	reg [1:0] rClk;

	// detect rising edges
	always @(negedge regClk) begin
		rClk <= {rClk[0], Clk};
	end

	always @(negedge regClk) begin
		if (Load) begin
			Counts <= Preset;
		end else if (rClk==2'b01) begin
		 	if (En && (Counts != 0)) begin
				Counts <= Counts - 1;
			end
		end
	end

	always @(negedge regClk) begin
		if (Load) begin
			Q <= 0;
		end else if (rClk==2'b01) begin
			if (En) begin
				Q <= (Counts == 1);
			end
		end
	end

endmodule

//module downcounter (
//	input wire En, Clk, Load,
//	input [31:0] Preset,
//	output reg Q,
//	output reg [31:0] Counts
//);
//	reg [31:0] CountsMinusOne;
//
//	always @(negedge Clk) begin
//		CountsMinusOne <= Counts - 1;
//	end
//
//	always @(posedge Clk, posedge Load) begin
//		if (Load) begin
//			Counts <= Preset;
//			Q <= 0;
//		end else if (Clk && En && (Counts != 0)) begin
//			Counts <= CountsMinusOne;
//			Q <= (Counts == 1);
//		end else if (Clk && Q) begin
//			Q <= 0;
//		end
//	end
//endmodule

//module downcounter (
//	input wire En, Clk, Load,
//	input [31:0] Preset,
//	output Q,
//	output reg [31:0] Counts
//);
//
//	assign Q = (Counts == 1);
//
//	always @(posedge Clk, posedge Load) begin
//		if (Load) begin
//			Counts <= Preset;
//		end else if (Clk && En && (Counts != 0)) begin
//			Counts <= Counts - 1;
//		end
//	end
//endmodule
