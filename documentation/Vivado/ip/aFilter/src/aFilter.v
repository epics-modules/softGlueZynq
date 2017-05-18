module aFilter(
  input regClk, latch,
  input [11:0] analogValueIn,
  output [11:0] analogValueOut,
  input wire[31:0] parm
);
  wire [11:0] analogValueIn;
  reg [11:0] analogValueOut;
  reg [1:0] rLatch;
  
  // detect edge of latch
  always @(negedge regClk) begin
	  rLatch <= {rLatch[0], latch};
  end

  // filter --------------------------------------------------
  reg [11:0] aIn;
  reg [19:0] aOut;
  reg [19:0] aOutPrev;
  reg firstLatch;


  initial begin
	  firstLatch <= 1;
	  aOut = 20'b0;
  end

  always @(negedge regClk) begin
	  //always @(negedge latch) begin
	  if (rLatch==2'b10) begin
		  case (parm[2:0])
		  default:
			  // aOut = aIn
			  if (firstLatch) aIn <= analogValueIn;
			  else aOut <= aIn;
		  3'h0:
			  // aOut = aIn
			  if (firstLatch) aIn <= analogValueIn;
			  else aOut <= aIn;
		  3'h1:
			  // aOut = (aIn + aOutPrev)/2
			  if (firstLatch) begin
				  aIn <= analogValueIn;
				  aOutPrev <= {8'h00, aOut[11:0]};
			  end else begin
				  aOut <= aIn + aOutPrev;
			  end
		  3'h2:
			  // aOut = (aIn + 3*aOutPrev)/4
			  if (firstLatch) begin
				  aIn <= analogValueIn;
				  aOutPrev <= aOut - {8'h00, aOut[13:2]};
			  end else begin
				  aOut <= aIn + aOutPrev;
			  end
		  3'h3:
			  // aOut = (aIn + 7*aOutPrev)/8
			  if (firstLatch) begin
				  aIn <= analogValueIn;
				  aOutPrev <= aOut - {8'h00, aOut[14:3]};
			  end else begin
				  aOut <= aIn + aOutPrev;
			  end
		  3'h4:
			  // aOut = (aIn + 15*aOutPrev)/16
			  if (firstLatch) begin
				  aIn <= analogValueIn;
				  aOutPrev <= aOut - {8'h00, aOut[15:4]};
			  end else begin
				  aOut <= aIn + aOutPrev;
			  end
		  3'h5:
			  // aOut = (aIn + 32*aOutPrev)/16
			  if (firstLatch) begin
				  aIn <= analogValueIn;
				  aOutPrev <= aOut - {8'h00, aOut[16:5]};
			  end else begin
				  aOut <= aIn + aOutPrev;
			  end
		  3'h6:
			  // aOut = (aIn + 63*aOutPrev)/64
			  if (firstLatch) begin
				  aIn <= analogValueIn;
				  aOutPrev <= aOut - {8'h00, aOut[17:6]};
			  end else begin
				  aOut <= aIn + aOutPrev;
			  end
		  3'h7:
			  // aOut = (aIn + 127*aOutPrev)/128
			  if (firstLatch) begin
				  aIn <= analogValueIn;
				  aOutPrev <= aOut - {8'h00, aOut[18:7]};
			  end else begin
				  aOut <= aIn + aOutPrev;
			  end
		  endcase
		  firstLatch <= ~firstLatch;
	  end
  end

  always @(*) begin
	  case (parm[2:0])
	  default:
		  analogValueOut = aOut[11:0];
	  3'h0:
		  analogValueOut = aOut[11:0];
	  3'h1:
		  analogValueOut = aOut[12:1];
	  3'h2:
		  analogValueOut = aOut[13:2];
	  3'h3:
		  analogValueOut = aOut[14:3];
	  3'h4:
		  analogValueOut = aOut[15:4];
	  3'h5:
		  analogValueOut = aOut[16:5];
	  3'h6:
		  analogValueOut = aOut[17:6];
	  3'h7:
		  analogValueOut = aOut[18:7];
	  endcase
  end

endmodule
