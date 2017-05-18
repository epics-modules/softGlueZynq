module comparator #
	(
		parameter integer const	= 256
	)
	(
	input [31:0] number,
	output wire greater,
	output wire same
);
	assign greater = (number>const);
	assign same = (number==const);
endmodule
