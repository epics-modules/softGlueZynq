module aMul(
	input regClk,
	input latch1,
	input [11:0] analogValue1,
	input latch2,
	input [11:0] analogValue2,
	output reg [11:0] analogValueOut
);
	reg [11:0] a1, a2;
	reg firstLatch1, firstLatch2;
	wire [11:0] product;
	reg [1:0] rLatch1, rLatch2;

	// detect edges
	always @(negedge regClk) begin
		rLatch1 <= {rLatch1[0], latch1};
		rLatch2 <= {rLatch2[0], latch2};
	end

	initial begin
		firstLatch1 <= 1;
		firstLatch2 <= 1;
	end

	assign product = a1*a2;

	always @(negedge regClk) begin
		//always @(negedge latch1) begin
		if (rLatch1==2'b10) begin
			if (firstLatch1)
				a1 <= analogValue1;
			firstLatch1 <= ~firstLatch1;
		end
	end
	
	always @(negedge regClk) begin
		//always @(negedge latch2) begin
		if (rLatch2==2'b10) begin
			if (firstLatch2)
				a2 <= analogValue2;
			else
				analogValueOut <= product;
			firstLatch2 <= ~firstLatch2;
		end
	end
endmodule
