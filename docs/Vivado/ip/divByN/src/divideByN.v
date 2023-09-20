`timescale 1 ns / 1 ps

module divByN (
  input wire regClk, En, Clk, Reset,
  input [31:0] N,
  output wire Q
);
	reg [31:0] counter;
	reg Q_clocked;
	reg [1:0] rClk;

	// detect rising edges
	always @(negedge regClk) begin
		rClk <= {rClk[0], Clk};
	end

	// Handle N=1 by simply passing the clock to Q
	assign Q = (N==1) ? (En==1 ? Clk : 0) : Q_clocked;


	always @(negedge regClk) begin
		if (Reset) begin
			counter <= N;
		end else if (rClk==2'b01) begin
			if (En) begin
				if (counter == 1) begin
					counter <= N;
				end else begin
					counter <= counter-1;
				end
			end
		end
	end

	always @(negedge regClk) begin
		if (Reset) begin
			Q_clocked = 0;
		end else if (rClk==2'b01) begin
			if (En) begin
				Q_clocked <= (counter == 1);
			end else begin
				Q_clocked <= 0;
			end
		end
	end

endmodule
