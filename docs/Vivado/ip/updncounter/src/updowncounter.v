`timescale 1 ns / 1 ps

// clocked by softGlueRegClk
module updowncounter (
  input wire regClk, En, Clk, Load, Clear, UpDn,
  input [31:0] Preset,
  output reg [31:0] Counts,
  output reg Q
);
	reg [1:0] rClk;

	// detect rising edges
	always @(negedge regClk) begin
		rClk <= {rClk[0], Clk};
	end


	always @(negedge regClk) begin
		if (Load) begin
			Counts <= Preset;
		end else if (Clear) begin
			Counts <= 0;
		end else if (rClk==2'b01) begin
			if (En) begin
				if (UpDn) begin
					Counts <= Counts + 1;
				end else begin
					Counts <= Counts - 1;
				end
			end
		end
	end

	always @(negedge regClk) begin
		if (Load) begin
			Q <= 0;
		end else if (Clear) begin
			Q <= 1;
		end else if (rClk==2'b01) begin
			if (En) begin
				if (UpDn) begin
					Q <= (Counts == -1);
				end else begin
					Q <= (Counts == 1);
				end
			end
		end
	end

endmodule

// asynchronous load and clear
//module updowncounter (
//  input wire En, Clk, Load, Clear, UpDn,
//  input [31:0] Preset,
//  output reg [31:0] Counts,
//  output reg Q
//);
//
//  always @(posedge Clk, posedge Load, posedge Clear) begin
//	if (Load) begin
//		Counts <= Preset;
//	end else if (Clear) begin
//		Counts <= 0;
//	end else if (Clk) begin
//		if (En) begin
//			if (UpDn) begin
//				Counts <= Counts + 1;
//			end else begin
//				Counts <= Counts - 1;
//			end
//		end
//	end
//  end
//
//  always @(posedge Clk, posedge Load, posedge Clear) begin
//	if (Load) begin
//		Q <= 0;
//	end else if (Clear) begin
//		Q <= 1;
//	end else if (Clk) begin
//		if (En) begin
//			if (UpDn) begin
//				Q <= (Counts == -1);
//			end else begin
//				Q <= (Counts == 1);
//			end
//		end
//	end
//  end
//
//endmodule

// asynchronous load and clear, clock Counts +/- 1
//module updowncounter (
//  input wire En, Clk, Load, Clear, UpDn,
//  input [31:0] Preset,
//  output reg [31:0] Counts,
//  output reg Q
//);
//
//  reg [31:0] CountsPlusOne, CountsMinusOne;
//  reg Q_plusCounter, Q_minusCounter;
//
//  always @(negedge Clk) begin
//	  CountsPlusOne <= Counts + 1;
//	  CountsMinusOne <= Counts - 1;
//	  Q_plusCounter <= (Counts == -1);
//	  Q_minusCounter <= (Counts == 1);
//  end
//
//  always @(posedge Clk, posedge Load, posedge Clear) begin
//	  if (Load) begin
//		  Counts <= Preset;
//	  end else if (Clear) begin
//		  Counts <= 0;
//	  end else if (Clk) begin
//		  if (En) begin
//			  if (UpDn) begin
//				  Counts <= CountsPlusOne;
//			  end else begin
//				  Counts <= CountsMinusOne;
//			  end
//		  end
//	  end
//  end
//
//  always @(posedge Clk, posedge Load, posedge Clear) begin
//	  if (Load) begin
//		  Q <= 0;
//	  end else if (Clear) begin
//		  Q <= 1;
//	  end else if (Clk) begin
//		  if (En) begin
//			  if (UpDn) begin
//				  Q <= Q_plusCounter;
//			  end else begin
//				  Q <= Q_minusCounter;
//			  end
//		  end
//	  end
//  end
//
//endmodule
