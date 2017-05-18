`timescale 1 ns / 1 ps

module upcounter (
	input wire regClk, En, Clk, Clear,
	output reg [31:0] Counts
);
	reg [1:0] rClk;

	// detect rising edges
	always @(negedge regClk) begin
		rClk <= {rClk[0], Clk};
	end

	always @(negedge regClk) begin
		if (Clear) begin
			Counts = 0;
		end else if ((rClk==2'b01) && En) begin
			Counts = Counts+1;
		end
	end

endmodule
