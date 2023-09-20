// histogramming scaler connected to softGlie signal bus
module	histoScaler(
	input wire regClk, 
	input wire En,
	input wire Clk,
	input wire Sync,
	input wire Det,
	input wire Clear,
	output reg [19:0] d,
	output wire [31:0]
		s00, s01, s02, s03, s04, s05, s06, s07, s08, s09,
		s10, s11, s12, s13, s14, s15, s16, s17, s18, s19
);
    reg [19:0] d;
	reg [1:0] rClk, rDet, rSync;
	reg detC, syncC;

	initial begin
		detC <= 0;
		syncC <= 0;
	end

	// detect rising edges
	always @(negedge regClk) begin
		rClk <= {rClk[0], Clk};
		rDet = {rDet[0], Det};
		rSync = {rSync[0], Sync};
	end

	// On rising edge of Det, set detC==1 for one regClk period
	always @(negedge regClk) begin
		if (rDet==2'b01) begin
			detC <= 1;
		end else begin
			detC <= 0;
		end
	end

	// On rising edge of Sync, set syncC==1 for one regClk period
	always @(negedge regClk) begin
		if (rSync==2'b01) begin
			syncC <= 1;
		end else begin
			syncC <= 0;
		end
	end

	// If synC==1, set LSB of shift register to 1, all else to 0.
	// Else, clock thst bit through the shift register.
	always @(negedge regClk) begin
		if (syncC) begin
			d <= 20'h00001;
		end else if (rClk==2'b01 && En) begin
			d <= d<<1;
		end
	end

	// Send detC to the scaler selected by d[]
	scaler sc00(.regClk(regClk), .clk(d[0]&detC), .Clear(Clear), .En(En), .c(s00));
	scaler sc01(.regClk(regClk), .clk(d[1]&detC), .Clear(Clear), .En(En), .c(s01));
	scaler sc02(.regClk(regClk), .clk(d[2]&detC), .Clear(Clear), .En(En), .c(s02));
	scaler sc03(.regClk(regClk), .clk(d[3]&detC), .Clear(Clear), .En(En), .c(s03));
	scaler sc04(.regClk(regClk), .clk(d[4]&detC), .Clear(Clear), .En(En), .c(s04));
	scaler sc05(.regClk(regClk), .clk(d[5]&detC), .Clear(Clear), .En(En), .c(s05));
	scaler sc06(.regClk(regClk), .clk(d[6]&detC), .Clear(Clear), .En(En), .c(s06));
	scaler sc07(.regClk(regClk), .clk(d[7]&detC), .Clear(Clear), .En(En), .c(s07));
	scaler sc08(.regClk(regClk), .clk(d[8]&detC), .Clear(Clear), .En(En), .c(s08));
	scaler sc09(.regClk(regClk), .clk(d[9]&detC), .Clear(Clear), .En(En), .c(s09));
	scaler sc10(.regClk(regClk), .clk(d[10]&detC), .Clear(Clear), .En(En), .c(s10));
	scaler sc11(.regClk(regClk), .clk(d[11]&detC), .Clear(Clear), .En(En), .c(s11));
	scaler sc12(.regClk(regClk), .clk(d[12]&detC), .Clear(Clear), .En(En), .c(s12));
	scaler sc13(.regClk(regClk), .clk(d[13]&detC), .Clear(Clear), .En(En), .c(s13));
	scaler sc14(.regClk(regClk), .clk(d[14]&detC), .Clear(Clear), .En(En), .c(s14));
	scaler sc15(.regClk(regClk), .clk(d[15]&detC), .Clear(Clear), .En(En), .c(s15));
	scaler sc16(.regClk(regClk), .clk(d[16]&detC), .Clear(Clear), .En(En), .c(s16));
	scaler sc17(.regClk(regClk), .clk(d[17]&detC), .Clear(Clear), .En(En), .c(s17));
	scaler sc18(.regClk(regClk), .clk(d[18]&detC), .Clear(Clear), .En(En), .c(s18));
	scaler sc19(.regClk(regClk), .clk(d[19]&detC), .Clear(Clear), .En(En), .c(s19));
endmodule

module scaler(
	input regClk,
	input clk,
	input Clear,
	input En,
	output reg [31:0] c
);
	reg [1:0] rClk;
	// detect rising edges
	always @(negedge regClk) begin
		rClk <= {rClk[0], clk};
	end

	always @(negedge regClk)
		if (Clear)
			c <= 0;
		else if (En && rClk==2'b01)
			c <= c+1;
endmodule
