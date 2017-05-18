`timescale 1 ns / 1 ps

module quadDec(
	input regClk, quadA, quadB, Clk, missClr,
	output reg step, dir, miss
);
	reg [1:0] rClk;
	reg quadA_delayed, quadB_delayed;

	// detect rising edges
	always @(negedge regClk) begin
		rClk <= {rClk[0], Clk};
	end

	always @(negedge regClk) begin
		if (rClk==2'b01) begin
			dir <= quadA ^ quadB_delayed;
			step <= quadA ^ quadA_delayed ^ quadB ^ quadB_delayed;
			quadA_delayed <= quadA;
			quadB_delayed <= quadB;
		end
	end

	always @(negedge regClk) begin
		if (rClk==2'b01) begin
			if (missClr)
				miss <= 0;
			else
				miss <= miss | ((quadA_delayed ^ quadA) & (quadB_delayed ^ quadB));
		end
	end

endmodule


//module quadDec(
//	input quadA, quadB, clk,
//	output reg step, dir
//);
//
//  reg [2:0] quadA_delayed, quadB_delayed;
//
//	always @(posedge clk)
//		begin
//		step = quadA_delayed[1] ^ quadA_delayed[2] ^ quadB_delayed[1] ^ quadB_delayed[2];
//		dir = quadA_delayed[1] ^ quadB_delayed[2];
//		quadA_delayed = {quadA_delayed[1:0], quadA};
//		quadB_delayed = {quadB_delayed[1:0], quadB};
//		end
//
//endmodule


//module quadDec(
//  input clk, quadA, quadB, missClr,
//  output reg step, dir, miss
//);
//  reg [2:0] quadA_delayed, quadB_delayed;
//  //reg stepPrompt;
//
//  always @(posedge clk) quadA_delayed <= {quadA_delayed[1:0], quadA};
//  always @(posedge clk) quadB_delayed <= {quadB_delayed[1:0], quadB};
//
//  //wire count_enable = quadA_delayed[1] ^ quadA_delayed[2] ^ quadB_delayed[1] ^ quadB_delayed[2];
//  wire count_enable = (quadA_delayed[1] ^ quadA_delayed[2]) | (quadB_delayed[1] ^ quadB_delayed[2]);
//  wire count_dir = quadA_delayed[1] ^ quadB_delayed[2];
//
//  always @(posedge clk) begin
//	  //stepPrompt <= count_enable;
//	  step <= count_enable;
//	  dir <= count_dir;
//	  if (missClr)
//		  miss <= 0;
//	  else
//		  miss <= miss | ((quadA_delayed[0] ^ quadA) & (quadB_delayed[0] ^ quadB));
//	  
//  end
//
//  // When step is asserted late, it can't be used in a circuit to enable a counter,
//  // but must instead clock the counter.
//  //always @(negedge clk)
//  //begin
//  //  step <= stepPrompt;
//  //end
//
//endmodule
