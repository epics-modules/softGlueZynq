module lowPass128(
	input regClk,
	input latch,
	input [11:0] analogValueIn,
	output [11:0] analogValueOut
);
	wire [11:0] analogValueIn;
	wire [11:0] analogValueOut;

	// filter --------------------------------------------------
	reg [11:0] aIn;
	reg [19:0] aOut;
	reg [19:0] aOutPrev_x_127;
	reg firstLatch;
	reg [1:0] rLatch;

	// detect edges
	always @(negedge regClk) begin
		rLatch <= {rLatch[0], latch};
	end


	initial begin
		firstLatch <= 1;
		aOut <= 20'b0;
	end
	
	// aOut = (aIn + 127*aOutPrev)/128
	//always @(negedge latch) begin
	always @(negedge regClk) begin
		if (rLatch==2'b10) begin
			if (firstLatch) begin
				aIn <= analogValueIn;
				aOutPrev_x_127 <= aOut - {8'h00, aOut[18:7]};
			end else begin
				//aOut <= (aIn+(aOutPrev<<7)-aOutPrev)>>7;
				aOut <= aIn + aOutPrev_x_127;
			end
			firstLatch <= ~firstLatch;
		end
	end

	assign analogValueOut = aOut[18:7];

endmodule
