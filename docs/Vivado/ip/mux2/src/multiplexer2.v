`timescale 1 ns / 1 ps

	module mux2 (
		input wire In0, In1, Sel,
		output reg Outp
	);
	
	always @(*)
	begin
		if (Sel == 0)
			Outp = In0;
		else
			Outp = In1;
	end

endmodule
