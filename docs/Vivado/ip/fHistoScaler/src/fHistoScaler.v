module	fHistoScaler(
	input wire en,
	input wire clk,
	input wire sync,
	input wire det,
	input wire clear,
	output wire [31:0]
		s00, s01, s02, s03, s04, s05, s06, s07, s08, s09,
		s10, s11, s12, s13, s14, s15, s16, s17, s18, s19
);
    reg [19:0] d;
	reg [1:0] rDet, rSync;
	reg detC, syncC;

	initial begin
		detC <= 0;
		syncC <= 0;
	end

	// On rising edge of det, set detC==1 for one clock period
	always @(posedge clk) begin
		rDet = {rDet[0], det};
		if (rDet==2'b01) begin
			detC <= 1;
		end else begin
			detC <= 0;
		end
	end

	// On rising edge of sync, set syncC==1 for one clock period
	always @(posedge clk) begin
		rSync = {rSync[0], sync};
		if (rSync==2'b01) begin
			syncC <= 1;
		end else begin
			syncC <= 0;
		end
	end

	// If synC==1, set LSB of shift register to 1, all else to 0.
	// Else, clock thst bit through the shift register.
	always @(posedge clk) begin
		if (syncC) begin
			d <= 20'h00001;
		end else if (clk && en) begin
			d <= d<<1;
		end
	end

	// Send detC to the scaler selected by d[]
	scaler sc00(.sysClk(clk), .clk(d[0]&detC), .clear(clear), .en(en), .c(s00));
	scaler sc01(.sysClk(clk), .clk(d[1]&detC), .clear(clear), .en(en), .c(s01));
	scaler sc02(.sysClk(clk), .clk(d[2]&detC), .clear(clear), .en(en), .c(s02));
	scaler sc03(.sysClk(clk), .clk(d[3]&detC), .clear(clear), .en(en), .c(s03));
	scaler sc04(.sysClk(clk), .clk(d[4]&detC), .clear(clear), .en(en), .c(s04));
	scaler sc05(.sysClk(clk), .clk(d[5]&detC), .clear(clear), .en(en), .c(s05));
	scaler sc06(.sysClk(clk), .clk(d[6]&detC), .clear(clear), .en(en), .c(s06));
	scaler sc07(.sysClk(clk), .clk(d[7]&detC), .clear(clear), .en(en), .c(s07));
	scaler sc08(.sysClk(clk), .clk(d[8]&detC), .clear(clear), .en(en), .c(s08));
	scaler sc09(.sysClk(clk), .clk(d[9]&detC), .clear(clear), .en(en), .c(s09));
	scaler sc10(.sysClk(clk), .clk(d[10]&detC), .clear(clear), .en(en), .c(s10));
	scaler sc11(.sysClk(clk), .clk(d[11]&detC), .clear(clear), .en(en), .c(s11));
	scaler sc12(.sysClk(clk), .clk(d[12]&detC), .clear(clear), .en(en), .c(s12));
	scaler sc13(.sysClk(clk), .clk(d[13]&detC), .clear(clear), .en(en), .c(s13));
	scaler sc14(.sysClk(clk), .clk(d[14]&detC), .clear(clear), .en(en), .c(s14));
	scaler sc15(.sysClk(clk), .clk(d[15]&detC), .clear(clear), .en(en), .c(s15));
	scaler sc16(.sysClk(clk), .clk(d[16]&detC), .clear(clear), .en(en), .c(s16));
	scaler sc17(.sysClk(clk), .clk(d[17]&detC), .clear(clear), .en(en), .c(s17));
	scaler sc18(.sysClk(clk), .clk(d[18]&detC), .clear(clear), .en(en), .c(s18));
	scaler sc19(.sysClk(clk), .clk(d[19]&detC), .clear(clear), .en(en), .c(s19));
endmodule

module scaler(
	input sysClk,
	input clk,
	input clear,
	input en,
	output reg [31:0] c
);
	reg [1:0] rClk;
	// detect rising edges
	always @(posedge sysClk) begin
		rClk <= {rClk[0], clk};
	end

	always @(posedge sysClk)
		if (clear)
			c <= 0;
		else if (en && rClk==2'b01)
			c <= c+1;
endmodule
