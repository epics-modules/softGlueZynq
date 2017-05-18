`timescale 1 ns / 1 ps

module flipflop (
	input wire regClk, D, Clk, Set, Clear,
	output reg Q
);
	reg [1:0] rClk;
	
	// detect rising edges
	always @(negedge regClk) begin
		rClk <= {rClk[0], Clk};
	end

	always @(negedge regClk) begin
		if (~Set)
			Q <= 1;
		else if (~Clear)
			Q <= 0;
		else if (rClk==2'b01)
			Q <= D;
	end

endmodule
