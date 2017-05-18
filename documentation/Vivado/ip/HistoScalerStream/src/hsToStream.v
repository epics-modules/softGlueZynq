// histogramming scaler connected to softGlue signal bus, and writing output
// to AXI stream
module	histoScalerStream(
	input wire regCk, 
	input wire En,
	input wire Ck,
	input wire Sync,
	input wire Det,
	input wire Clear,
	output reg [63:0] d,

	input read,
	input wire M_AXIS_ACLK,
	// stream interface
	output [31:0] M_AXIS_TDATA,
	output reg M_AXIS_TVALID,
	output reg M_AXIS_TLAST,
	input wire M_AXIS_TREADY
);
	reg [1:0] rClk, rDet, rSync;
	reg detC, syncC;

	// for stream out: take snapshot of scalers
	reg [1:0] rRead;
	reg transferInProg;
	reg [6:0] currScaler;
	// scaler snapshot registers
	reg [30:0] rs00;
	reg [30:0] rs01;
	reg [30:0] rs02;
	reg [30:0] rs03;
	reg [30:0] rs04;
	reg [30:0] rs05;
	reg [30:0] rs06;
	reg [30:0] rs07;
	reg [30:0] rs08;
	reg [30:0] rs09;
	reg [30:0] rs10;
	reg [30:0] rs11;
	reg [30:0] rs12;
	reg [30:0] rs13;
	reg [30:0] rs14;
	reg [30:0] rs15;
	reg [30:0] rs16;
	reg [30:0] rs17;
	reg [30:0] rs18;
	reg [30:0] rs19;
	reg [30:0] rs20;
	reg [30:0] rs21;
	reg [30:0] rs22;
	reg [30:0] rs23;
	reg [30:0] rs24;
	reg [30:0] rs25;
	reg [30:0] rs26;
	reg [30:0] rs27;
	reg [30:0] rs28;
	reg [30:0] rs29;
	reg [30:0] rs30;
	reg [30:0] rs31;
	reg [30:0] rs32;
	reg [30:0] rs33;
	reg [30:0] rs34;
	reg [30:0] rs35;
	reg [30:0] rs36;
	reg [30:0] rs37;
	reg [30:0] rs38;
	reg [30:0] rs39;
	reg [30:0] rs40;
	reg [30:0] rs41;
	reg [30:0] rs42;
	reg [30:0] rs43;
	reg [30:0] rs44;
	reg [30:0] rs45;
	reg [30:0] rs46;
	reg [30:0] rs47;
	reg [30:0] rs48;
	reg [30:0] rs49;
	reg [30:0] rs50;
	reg [30:0] rs51;
	reg [30:0] rs52;
	reg [30:0] rs53;
	reg [30:0] rs54;
	reg [30:0] rs55;
	reg [30:0] rs56;
	reg [30:0] rs57;
	reg [30:0] rs58;
	reg [30:0] rs59;
	reg [30:0] rs60;
	reg [30:0] rs61;
	reg [30:0] rs62;
	reg [30:0] rs63;
	reg [31:0] outReg;

	wire [30:0] s00;
	wire [30:0] s01;
	wire [30:0] s02;
	wire [30:0] s03;
	wire [30:0] s04;
	wire [30:0] s05;
	wire [30:0] s06;
	wire [30:0] s07;
	wire [30:0] s08;
	wire [30:0] s09;
	wire [30:0] s10;
	wire [30:0] s11;
	wire [30:0] s12;
	wire [30:0] s13;
	wire [30:0] s14;
	wire [30:0] s15;
	wire [30:0] s16;
	wire [30:0] s17;
	wire [30:0] s18;
	wire [30:0] s19;
	wire [30:0] s20;
	wire [30:0] s21;
	wire [30:0] s22;
	wire [30:0] s23;
	wire [30:0] s24;
	wire [30:0] s25;
	wire [30:0] s26;
	wire [30:0] s27;
	wire [30:0] s28;
	wire [30:0] s29;
	wire [30:0] s30;
	wire [30:0] s31;
	wire [30:0] s32;
	wire [30:0] s33;
	wire [30:0] s34;
	wire [30:0] s35;
	wire [30:0] s36;
	wire [30:0] s37;
	wire [30:0] s38;
	wire [30:0] s39;
	wire [30:0] s40;
	wire [30:0] s41;
	wire [30:0] s42;
	wire [30:0] s43;
	wire [30:0] s44;
	wire [30:0] s45;
	wire [30:0] s46;
	wire [30:0] s47;
	wire [30:0] s48;
	wire [30:0] s49;
	wire [30:0] s50;
	wire [30:0] s51;
	wire [30:0] s52;
	wire [30:0] s53;
	wire [30:0] s54;
	wire [30:0] s55;
	wire [30:0] s56;
	wire [30:0] s57;
	wire [30:0] s58;
	wire [30:0] s59;
	wire [30:0] s60;
	wire [30:0] s61;
	wire [30:0] s62;
	wire [30:0] s63;

	initial begin
		detC <= 0;
		syncC <= 0;
	end

	// detect rising edges
	always @(negedge regCk) begin
		rClk <= {rClk[0], Ck};
		rDet = {rDet[0], Det};
		rSync = {rSync[0], Sync};
	end

	// On rising edge of Det, set detC==1 for one regCk period
	always @(negedge regCk) begin
		if (rDet==2'b01) begin
			detC <= 1;
		end else begin
			detC <= 0;
		end
	end

	// On rising edge of Sync, set syncC==1 for one regCk period
	always @(negedge regCk) begin
		if (rSync==2'b01) begin
			syncC <= 1;
		end else begin
			syncC <= 0;
		end
	end

	// If synC==1, set LSB of shift register to 1, all else to 0.
	// Else, clock that bit through the shift register.
	always @(negedge regCk) begin
		if (syncC) begin
			d <= 64'h0000000000000001;
		end else if (rClk==2'b01 && En) begin
			d <= d<<1;
		end
	end

	// Send detC to the scaler selected by d[]
	hs_scaler sc00(.regCk(regCk), .clk(d[0]&detC), .Clear(Clear), .En(En), .c(s00));
	hs_scaler sc01(.regCk(regCk), .clk(d[1]&detC), .Clear(Clear), .En(En), .c(s01));
	hs_scaler sc02(.regCk(regCk), .clk(d[2]&detC), .Clear(Clear), .En(En), .c(s02));
	hs_scaler sc03(.regCk(regCk), .clk(d[3]&detC), .Clear(Clear), .En(En), .c(s03));
	hs_scaler sc04(.regCk(regCk), .clk(d[4]&detC), .Clear(Clear), .En(En), .c(s04));
	hs_scaler sc05(.regCk(regCk), .clk(d[5]&detC), .Clear(Clear), .En(En), .c(s05));
	hs_scaler sc06(.regCk(regCk), .clk(d[6]&detC), .Clear(Clear), .En(En), .c(s06));
	hs_scaler sc07(.regCk(regCk), .clk(d[7]&detC), .Clear(Clear), .En(En), .c(s07));
	hs_scaler sc08(.regCk(regCk), .clk(d[8]&detC), .Clear(Clear), .En(En), .c(s08));
	hs_scaler sc09(.regCk(regCk), .clk(d[9]&detC), .Clear(Clear), .En(En), .c(s09));
	hs_scaler sc10(.regCk(regCk), .clk(d[10]&detC), .Clear(Clear), .En(En), .c(s10));
	hs_scaler sc11(.regCk(regCk), .clk(d[11]&detC), .Clear(Clear), .En(En), .c(s11));
	hs_scaler sc12(.regCk(regCk), .clk(d[12]&detC), .Clear(Clear), .En(En), .c(s12));
	hs_scaler sc13(.regCk(regCk), .clk(d[13]&detC), .Clear(Clear), .En(En), .c(s13));
	hs_scaler sc14(.regCk(regCk), .clk(d[14]&detC), .Clear(Clear), .En(En), .c(s14));
	hs_scaler sc15(.regCk(regCk), .clk(d[15]&detC), .Clear(Clear), .En(En), .c(s15));
	hs_scaler sc16(.regCk(regCk), .clk(d[16]&detC), .Clear(Clear), .En(En), .c(s16));
	hs_scaler sc17(.regCk(regCk), .clk(d[17]&detC), .Clear(Clear), .En(En), .c(s17));
	hs_scaler sc18(.regCk(regCk), .clk(d[18]&detC), .Clear(Clear), .En(En), .c(s18));
	hs_scaler sc19(.regCk(regCk), .clk(d[19]&detC), .Clear(Clear), .En(En), .c(s19));
	hs_scaler sc20(.regCk(regCk), .clk(d[20]&detC), .Clear(Clear), .En(En), .c(s20));
	hs_scaler sc21(.regCk(regCk), .clk(d[21]&detC), .Clear(Clear), .En(En), .c(s21));
	hs_scaler sc22(.regCk(regCk), .clk(d[22]&detC), .Clear(Clear), .En(En), .c(s22));
	hs_scaler sc23(.regCk(regCk), .clk(d[23]&detC), .Clear(Clear), .En(En), .c(s23));
	hs_scaler sc24(.regCk(regCk), .clk(d[24]&detC), .Clear(Clear), .En(En), .c(s24));
	hs_scaler sc25(.regCk(regCk), .clk(d[25]&detC), .Clear(Clear), .En(En), .c(s25));
	hs_scaler sc26(.regCk(regCk), .clk(d[26]&detC), .Clear(Clear), .En(En), .c(s26));
	hs_scaler sc27(.regCk(regCk), .clk(d[27]&detC), .Clear(Clear), .En(En), .c(s27));
	hs_scaler sc28(.regCk(regCk), .clk(d[28]&detC), .Clear(Clear), .En(En), .c(s28));
	hs_scaler sc29(.regCk(regCk), .clk(d[29]&detC), .Clear(Clear), .En(En), .c(s29));
	hs_scaler sc30(.regCk(regCk), .clk(d[30]&detC), .Clear(Clear), .En(En), .c(s30));
	hs_scaler sc31(.regCk(regCk), .clk(d[31]&detC), .Clear(Clear), .En(En), .c(s31));
	hs_scaler sc32(.regCk(regCk), .clk(d[32]&detC), .Clear(Clear), .En(En), .c(s32));
	hs_scaler sc33(.regCk(regCk), .clk(d[33]&detC), .Clear(Clear), .En(En), .c(s33));
	hs_scaler sc34(.regCk(regCk), .clk(d[34]&detC), .Clear(Clear), .En(En), .c(s34));
	hs_scaler sc35(.regCk(regCk), .clk(d[35]&detC), .Clear(Clear), .En(En), .c(s35));
	hs_scaler sc36(.regCk(regCk), .clk(d[36]&detC), .Clear(Clear), .En(En), .c(s36));
	hs_scaler sc37(.regCk(regCk), .clk(d[37]&detC), .Clear(Clear), .En(En), .c(s37));
	hs_scaler sc38(.regCk(regCk), .clk(d[38]&detC), .Clear(Clear), .En(En), .c(s38));
	hs_scaler sc39(.regCk(regCk), .clk(d[39]&detC), .Clear(Clear), .En(En), .c(s39));
	hs_scaler sc40(.regCk(regCk), .clk(d[40]&detC), .Clear(Clear), .En(En), .c(s40));
	hs_scaler sc41(.regCk(regCk), .clk(d[41]&detC), .Clear(Clear), .En(En), .c(s41));
	hs_scaler sc42(.regCk(regCk), .clk(d[42]&detC), .Clear(Clear), .En(En), .c(s42));
	hs_scaler sc43(.regCk(regCk), .clk(d[43]&detC), .Clear(Clear), .En(En), .c(s43));
	hs_scaler sc44(.regCk(regCk), .clk(d[44]&detC), .Clear(Clear), .En(En), .c(s44));
	hs_scaler sc45(.regCk(regCk), .clk(d[45]&detC), .Clear(Clear), .En(En), .c(s45));
	hs_scaler sc46(.regCk(regCk), .clk(d[46]&detC), .Clear(Clear), .En(En), .c(s46));
	hs_scaler sc47(.regCk(regCk), .clk(d[47]&detC), .Clear(Clear), .En(En), .c(s47));
	hs_scaler sc48(.regCk(regCk), .clk(d[48]&detC), .Clear(Clear), .En(En), .c(s48));
	hs_scaler sc49(.regCk(regCk), .clk(d[49]&detC), .Clear(Clear), .En(En), .c(s49));
	hs_scaler sc50(.regCk(regCk), .clk(d[50]&detC), .Clear(Clear), .En(En), .c(s50));
	hs_scaler sc51(.regCk(regCk), .clk(d[51]&detC), .Clear(Clear), .En(En), .c(s51));
	hs_scaler sc52(.regCk(regCk), .clk(d[52]&detC), .Clear(Clear), .En(En), .c(s52));
	hs_scaler sc53(.regCk(regCk), .clk(d[53]&detC), .Clear(Clear), .En(En), .c(s53));
	hs_scaler sc54(.regCk(regCk), .clk(d[54]&detC), .Clear(Clear), .En(En), .c(s54));
	hs_scaler sc55(.regCk(regCk), .clk(d[55]&detC), .Clear(Clear), .En(En), .c(s55));
	hs_scaler sc56(.regCk(regCk), .clk(d[56]&detC), .Clear(Clear), .En(En), .c(s56));
	hs_scaler sc57(.regCk(regCk), .clk(d[57]&detC), .Clear(Clear), .En(En), .c(s57));
	hs_scaler sc58(.regCk(regCk), .clk(d[58]&detC), .Clear(Clear), .En(En), .c(s58));
	hs_scaler sc59(.regCk(regCk), .clk(d[59]&detC), .Clear(Clear), .En(En), .c(s59));
	hs_scaler sc60(.regCk(regCk), .clk(d[60]&detC), .Clear(Clear), .En(En), .c(s60));
	hs_scaler sc61(.regCk(regCk), .clk(d[61]&detC), .Clear(Clear), .En(En), .c(s61));
	hs_scaler sc62(.regCk(regCk), .clk(d[62]&detC), .Clear(Clear), .En(En), .c(s62));
	hs_scaler sc63(.regCk(regCk), .clk(d[63]&detC), .Clear(Clear), .En(En), .c(s63));

	// for stream out
	assign M_AXIS_TDATA = outReg;

	initial begin
		transferInProg <= 0;
		currScaler <= 0;
		M_AXIS_TVALID <= 0;
		M_AXIS_TLAST <= 0;
	end

	always @(posedge M_AXIS_ACLK) begin
		rRead <= {rRead[0], read};
		if (M_AXIS_TREADY) M_AXIS_TLAST <= 0;

		if (transferInProg) begin
			M_AXIS_TVALID <= 1;
			// put data to output register
			case (currScaler)
			0: outReg <= {1, rs00};	// Mark first channel, so EPICS can be sure.
			1: outReg <= rs01;
			2: outReg <= rs02;
			3: outReg <= rs03;
			4: outReg <= rs04;
			5: outReg <= rs05;
			6: outReg <= rs06;
			7: outReg <= rs07;
			8: outReg <= rs08;
			9: outReg <= rs09;
			10: outReg <= rs10;
			11: outReg <= rs11;
			12: outReg <= rs12;
			13: outReg <= rs13;
			14: outReg <= rs14;
			15: outReg <= rs15;
			16: outReg <= rs16;
			17: outReg <= rs17;
			18: outReg <= rs18;
			19: outReg <= rs19;
			20: outReg <= rs20;
			21: outReg <= rs21;
			22: outReg <= rs22;
			23: outReg <= rs23;
			24: outReg <= rs24;
			25: outReg <= rs25;
			26: outReg <= rs26;
			27: outReg <= rs27;
			28: outReg <= rs28;
			29: outReg <= rs29;
			30: outReg <= rs30;
			31: outReg <= rs31;
			32: outReg <= rs32;
			33: outReg <= rs33;
			34: outReg <= rs34;
			35: outReg <= rs35;
			36: outReg <= rs36;
			37: outReg <= rs37;
			38: outReg <= rs38;
			39: outReg <= rs39;
			40: outReg <= rs40;
			41: outReg <= rs41;
			42: outReg <= rs42;
			43: outReg <= rs43;
			44: outReg <= rs44;
			45: outReg <= rs45;
			46: outReg <= rs46;
			47: outReg <= rs47;
			48: outReg <= rs48;
			49: outReg <= rs49;
			50: outReg <= rs50;
			51: outReg <= rs51;
			52: outReg <= rs52;
			53: outReg <= rs53;
			54: outReg <= rs54;
			55: outReg <= rs55;
			56: outReg <= rs56;
			57: outReg <= rs57;
			58: outReg <= rs58;
			59: outReg <= rs59;
			60: outReg <= rs60;
			61: outReg <= rs61;
			62: outReg <= rs62;
			63: outReg <= rs63;
			64: begin M_AXIS_TVALID <= 0; transferInProg <= 0; end
			default: outReg <= outReg;
			endcase

			if (M_AXIS_TREADY) begin
				/* We just transferred a register.  Setup for next register. */
				currScaler <= currScaler + 1;
				if (currScaler == 63) begin
					M_AXIS_TLAST <= 1;
				end
			end
		end else if (rRead==2'b01) begin
			if (transferInProg==0) begin
				// take snapshot of input values, and start transfer to output reg
				transferInProg <= 1;
				currScaler <= 0;
				rs00 <= s00;
				rs01 <= s01;
				rs02 <= s02;
				rs03 <= s03;
				rs04 <= s04;
				rs05 <= s05;
				rs06 <= s06;
				rs07 <= s07;
				rs08 <= s08;
				rs09 <= s09;
				rs10 <= s10;
				rs11 <= s11;
				rs12 <= s12;
				rs13 <= s13;
				rs14 <= s14;
				rs15 <= s15;
				rs16 <= s16;
				rs17 <= s17;
				rs18 <= s18;
				rs19 <= s19;
				rs20 <= s20;
				rs21 <= s21;
				rs22 <= s22;
				rs23 <= s23;
				rs24 <= s24;
				rs25 <= s25;
				rs26 <= s26;
				rs27 <= s27;
				rs28 <= s28;
				rs29 <= s29;
				rs30 <= s30;
				rs31 <= s31;
				rs32 <= s32;
				rs33 <= s33;
				rs34 <= s34;
				rs35 <= s35;
				rs36 <= s36;
				rs37 <= s37;
				rs38 <= s38;
				rs39 <= s39;
				rs40 <= s40;
				rs41 <= s41;
				rs42 <= s42;
				rs43 <= s43;
				rs44 <= s44;
				rs45 <= s45;
				rs46 <= s46;
				rs47 <= s47;
				rs48 <= s48;
				rs49 <= s49;
				rs50 <= s50;
				rs51 <= s51;
				rs52 <= s52;
				rs53 <= s53;
				rs54 <= s54;
				rs55 <= s55;
				rs56 <= s56;
				rs57 <= s57;
				rs58 <= s58;
				rs59 <= s59;
				rs60 <= s60;
				rs61 <= s61;
				rs62 <= s62;
				rs63 <= s63;
			end
		end
	end

endmodule

module hs_scaler(
	input regCk,
	input clk,
	input Clear,
	input En,
	output reg [30:0] c
);
	reg [1:0] rClk;
	// detect rising edges
	always @(negedge regCk) begin
		rClk <= {rClk[0], clk};
	end

	always @(negedge regCk)
		if (Clear)
			c <= 0;
		else if (En && rClk==2'b01)
			c <= c+1;
endmodule
