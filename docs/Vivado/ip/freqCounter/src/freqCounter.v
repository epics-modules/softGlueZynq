`timescale 1 ns / 1 ps

module freqCounter (
	input wire regClk, Clk,
	output reg [31:0] Counts
);
	reg [1:0] rClk;
	reg [31:0] timeCounter;
	reg [31:0] clkCounter;

	// detect rising edges
	always @(negedge regClk) begin
		rClk <= {rClk[0], Clk};
	end

	always @(negedge regClk) begin
		timeCounter <= timeCounter - 1;
		if (timeCounter==1) begin
			Counts <= clkCounter;
			timeCounter <= 100000000;
			clkCounter <= 0;
		end else if (timeCounter > 100000000) begin
			timeCounter <= 100000000;
		end
		if (rClk==2'b01) begin
			clkCounter <= clkCounter+1;
		end
	end

endmodule
