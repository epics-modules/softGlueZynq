`timescale 1 ns / 1 ps

	module demux2 (
		input wire Inp, Sel,
		output reg Out0, Out1
	);
	
	always @(*)
	begin
		if (Sel == 0)
			begin
				Out0 = Inp;
				Out1 = 0;
			end
		else
			begin
				Out1 = Inp;
				Out0 = 0;
			end
	end

endmodule
