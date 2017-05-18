

module scalersToFIFO (
	input regClk,
	input [31:0] in0,
	input [31:0] in1,
	input [31:0] in2,
	input [31:0] in3,
	input [31:0] in4,
	input [31:0] in5,
	input [31:0] in6,
	input [31:0] in7,
	input [31:0] in8,
	input [31:0] in9,
	input [31:0] in10,
	input [31:0] in11,
	input [31:0] in12,
	input [31:0] in13,
	input [31:0] in14,
	input [31:0] in15,
	output reg [31:0] outReg,
	output reg wrtCk,
	output reg chanAdvDone,
	input chanAdv
);
	reg [1:0] rChanAdv;
	reg transferInProg;
	reg [3:0] currInReg;
	reg [31:0] inReg0;
	reg [31:0] inReg1;
	reg [31:0] inReg2;
	reg [31:0] inReg3;
	reg [31:0] inReg4;
	reg [31:0] inReg5;
	reg [31:0] inReg6;
	reg [31:0] inReg7;
	reg [31:0] inReg8;
	reg [31:0] inReg9;
	reg [31:0] inReg10;
	reg [31:0] inReg11;
	reg [31:0] inReg12;
	reg [31:0] inReg13;
	reg [31:0] inReg14;
	reg [31:0] inReg15;

	initial begin
		transferInProg <= 0;
		currInReg <= 0;
		chanAdvDone <= 0;
	end

	// detect rising and falling edges
	always @(negedge regClk) begin
		rChanAdv <= {rChanAdv[0], chanAdv};
	end

	always @(negedge regClk) begin
		chanAdvDone <= 0;
		if (transferInProg) begin
			if (wrtCk) begin
				// finish transfer of current input register
				wrtCk <= 0;
				if (currInReg==15) begin
					transferInProg <= 0;
				end else begin
					currInReg <= currInReg + 1;
				end
			end else begin
				// start transfer of current input register
				case (currInReg)
				3'h0: outReg <= inReg0;
				3'h1: outReg <= inReg1;
				3'h2: outReg <= inReg2;
				3'h3: outReg <= inReg3;
				3'h4: outReg <= inReg4;
				3'h5: outReg <= inReg5;
				3'h6: outReg <= inReg6;
				3'h7: outReg <= inReg7;
				3'h8: outReg <= inReg8;
				3'h9: outReg <= inReg9;
				3'ha: outReg <= inReg10;
				3'hb: outReg <= inReg11;
				3'hc: outReg <= inReg12;
				3'hd: outReg <= inReg13;
				3'he: outReg <= inReg14;
				3'hf: outReg <= inReg15;
				default: outReg <= outReg;
				endcase
				wrtCk <= 1;
			end
		end else if (rChanAdv==2'b01 && (transferInProg==0)) begin
			// take snapshot of input values, and start transfer to output reg
			transferInProg <= 1;
			currInReg <= 0;
			wrtCk <= 0;
			inReg0 <= in0;
			inReg1 <= in1;
			inReg2 <= in2;
			inReg3 <= in3;
			inReg4 <= in4;
			inReg5 <= in5;
			inReg6 <= in6;
			inReg7 <= in7;
			inReg8 <= in8;
			inReg9 <= in9;
			inReg10 <= in10;
			inReg11 <= in11;
			inReg12 <= in12;
			inReg13 <= in13;
			inReg14 <= in14;
			inReg15 <= in15;
			// Tell whomever is interested that we have cached the data
			chanAdvDone <= 1;
		end
	end
endmodule
