// histogramming scaler connected directly to field I/O and to dedicated clock,
// and writing output to AXI stream
module	fhistoScalerStream(
	input wire En,
	input wire Ck,
	input wire Sync,
	input wire Det,
	input wire Clear,

	input read,
	input wire M_AXIS_ACLK,
	// stream interface
	output [31:0] M_AXIS_TDATA,
	output reg M_AXIS_TVALID,
	output reg M_AXIS_TLAST,
	input wire M_AXIS_TREADY
);
	reg [1:0] rDet, rSync;

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

	reg [30:0] s00;
	reg [30:0] s01;
	reg [30:0] s02;
	reg [30:0] s03;
	reg [30:0] s04;
	reg [30:0] s05;
	reg [30:0] s06;
	reg [30:0] s07;
	reg [30:0] s08;
	reg [30:0] s09;
	reg [30:0] s10;
	reg [30:0] s11;
	reg [30:0] s12;
	reg [30:0] s13;
	reg [30:0] s14;
	reg [30:0] s15;
	reg [30:0] s16;
	reg [30:0] s17;
	reg [30:0] s18;
	reg [30:0] s19;
	reg [30:0] s20;
	reg [30:0] s21;
	reg [30:0] s22;
	reg [30:0] s23;
	reg [30:0] s24;
	reg [30:0] s25;
	reg [30:0] s26;
	reg [30:0] s27;
	reg [30:0] s28;
	reg [30:0] s29;
	reg [30:0] s30;
	reg [30:0] s31;
	reg [30:0] s32;
	reg [30:0] s33;
	reg [30:0] s34;
	reg [30:0] s35;
	reg [30:0] s36;
	reg [30:0] s37;
	reg [30:0] s38;
	reg [30:0] s39;
	reg [30:0] s40;
	reg [30:0] s41;
	reg [30:0] s42;
	reg [30:0] s43;
	reg [30:0] s44;
	reg [30:0] s45;
	reg [30:0] s46;
	reg [30:0] s47;
	reg [30:0] s48;
	reg [30:0] s49;
	reg [30:0] s50;
	reg [30:0] s51;
	reg [30:0] s52;
	reg [30:0] s53;
	reg [30:0] s54;
	reg [30:0] s55;
	reg [30:0] s56;
	reg [30:0] s57;
	reg [30:0] s58;
	reg [30:0] s59;
	reg [30:0] s60;
	reg [30:0] s61;
	reg [30:0] s62;
	reg [30:0] s63;

	reg d00;
	reg d01;
	reg d02;
	reg d03;
	reg d04;
	reg d05;
	reg d06;
	reg d07;
	reg d08;
	reg d09;
	reg d10;
	reg d11;
	reg d12;
	reg d13;
	reg d14;
	reg d15;
	reg d16;
	reg d17;
	reg d18;
	reg d19;
	reg d20;
	reg d21;
	reg d22;
	reg d23;
	reg d24;
	reg d25;
	reg d26;
	reg d27;
	reg d28;
	reg d29;
	reg d30;
	reg d31;
	reg d32;
	reg d33;
	reg d34;
	reg d35;
	reg d36;
	reg d37;
	reg d38;
	reg d39;
	reg d40;
	reg d41;
	reg d42;
	reg d43;
	reg d44;
	reg d45;
	reg d46;
	reg d47;
	reg d48;
	reg d49;
	reg d50;
	reg d51;
	reg d52;
	reg d53;
	reg d54;
	reg d55;
	reg d56;
	reg d57;
	reg d58;
	reg d59;
	reg d60;
	reg d61;
	reg d62;
	reg d63;
	reg d64;

	// detect rising edges
	always @(posedge Ck) begin
		rDet = {rDet[0], Det};
		rSync = {rSync[0], Sync};
	end

	always @(posedge Ck) begin
		if (rSync==2'b01) begin
			d00 <= 1;
			d01 <= 0;
			d02 <= 0;
			d03 <= 0;
			d04 <= 0;
			d05 <= 0;
			d06 <= 0;
			d07 <= 0;
			d08 <= 0;
			d09 <= 0;
			d10 <= 0;
			d11 <= 0;
			d12 <= 0;
			d13 <= 0;
			d14 <= 0;
			d15 <= 0;
			d16 <= 0;
			d17 <= 0;
			d18 <= 0;
			d19 <= 0;
			d20 <= 0;
			d21 <= 0;
			d22 <= 0;
			d23 <= 0;
			d24 <= 0;
			d25 <= 0;
			d26 <= 0;
			d27 <= 0;
			d28 <= 0;
			d29 <= 0;
			d30 <= 0;
			d31 <= 0;
			d32 <= 0;
			d33 <= 0;
			d34 <= 0;
			d35 <= 0;
			d36 <= 0;
			d37 <= 0;
			d38 <= 0;
			d39 <= 0;
			d40 <= 0;
			d41 <= 0;
			d42 <= 0;
			d43 <= 0;
			d44 <= 0;
			d45 <= 0;
			d46 <= 0;
			d47 <= 0;
			d48 <= 0;
			d49 <= 0;
			d50 <= 0;
			d51 <= 0;
			d52 <= 0;
			d53 <= 0;
			d54 <= 0;
			d55 <= 0;
			d56 <= 0;
			d57 <= 0;
			d58 <= 0;
			d59 <= 0;
			d60 <= 0;
			d61 <= 0;
			d62 <= 0;
			d63 <= 0;
			d64 <= 0;
		end else if (Ck && En && !d64) begin
			d00 <= 0;
			d01 <= d00;
			d02 <= d01;
			d03 <= d02;
			d04 <= d03;
			d05 <= d04;
			d06 <= d05;
			d07 <= d06;
			d08 <= d07;
			d09 <= d08;
			d10 <= d09;
			d11 <= d10;
			d12 <= d11;
			d13 <= d12;
			d14 <= d13;
			d15 <= d14;
			d16 <= d15;
			d17 <= d16;
			d18 <= d17;
			d19 <= d18;
			d20 <= d19;
			d21 <= d20;
			d22 <= d21;
			d23 <= d22;
			d24 <= d23;
			d25 <= d24;
			d26 <= d25;
			d27 <= d26;
			d28 <= d27;
			d29 <= d28;
			d30 <= d29;
			d31 <= d30;
			d32 <= d31;
			d33 <= d32;
			d34 <= d33;
			d35 <= d34;
			d36 <= d35;
			d37 <= d36;
			d38 <= d37;
			d39 <= d38;
			d40 <= d39;
			d41 <= d40;
			d42 <= d41;
			d43 <= d42;
			d44 <= d43;
			d45 <= d44;
			d46 <= d45;
			d47 <= d46;
			d48 <= d47;
			d49 <= d48;
			d50 <= d49;
			d51 <= d50;
			d52 <= d51;
			d53 <= d52;
			d54 <= d53;
			d55 <= d54;
			d56 <= d55;
			d57 <= d56;
			d58 <= d57;
			d59 <= d58;
			d60 <= d59;
			d61 <= d60;
			d62 <= d61;
			d63 <= d62;
			d64 <= d63;
		end
	end

	always @(posedge Ck) begin
		if (Clear) begin
			s00 <= 0;
			s01 <= 0;
			s02 <= 0;
			s03 <= 0;
			s04 <= 0;
			s05 <= 0;
			s06 <= 0;
			s07 <= 0;
			s08 <= 0;
			s09 <= 0;
			s10 <= 0;
			s11 <= 0;
			s12 <= 0;
			s13 <= 0;
			s14 <= 0;
			s15 <= 0;
			s16 <= 0;
			s17 <= 0;
			s18 <= 0;
			s19 <= 0;
			s20 <= 0;
			s21 <= 0;
			s22 <= 0;
			s23 <= 0;
			s24 <= 0;
			s25 <= 0;
			s26 <= 0;
			s27 <= 0;
			s28 <= 0;
			s29 <= 0;
			s30 <= 0;
			s31 <= 0;
			s32 <= 0;
			s33 <= 0;
			s34 <= 0;
			s35 <= 0;
			s36 <= 0;
			s37 <= 0;
			s38 <= 0;
			s39 <= 0;
			s40 <= 0;
			s41 <= 0;
			s42 <= 0;
			s43 <= 0;
			s44 <= 0;
			s45 <= 0;
			s46 <= 0;
			s47 <= 0;
			s48 <= 0;
			s49 <= 0;
			s50 <= 0;
			s51 <= 0;
			s52 <= 0;
			s53 <= 0;
			s54 <= 0;
			s55 <= 0;
			s56 <= 0;
			s57 <= 0;
			s58 <= 0;
			s59 <= 0;
			s60 <= 0;
			s61 <= 0;
			s62 <= 0;
			s63 <= 0;
		end else if (En && rDet==2'b01) begin
			s00 <= s00 + d00;
			s01 <= s01 + d01;
			s02 <= s02 + d02;
			s03 <= s03 + d03;
			s04 <= s04 + d04;
			s05 <= s05 + d05;
			s06 <= s06 + d06;
			s07 <= s07 + d07;
			s08 <= s08 + d08;
			s09 <= s09 + d09;
			s10 <= s10 + d10;
			s11 <= s11 + d11;
			s12 <= s12 + d12;
			s13 <= s13 + d13;
			s14 <= s14 + d14;
			s15 <= s15 + d15;
			s16 <= s16 + d16;
			s17 <= s17 + d17;
			s18 <= s18 + d18;
			s19 <= s19 + d19;
			s20 <= s20 + d20;
			s21 <= s21 + d21;
			s22 <= s22 + d22;
			s23 <= s23 + d23;
			s24 <= s24 + d24;
			s25 <= s25 + d25;
			s26 <= s26 + d26;
			s27 <= s27 + d27;
			s28 <= s28 + d28;
			s29 <= s29 + d29;
			s30 <= s30 + d30;
			s31 <= s31 + d31;
			s32 <= s32 + d32;
			s33 <= s33 + d33;
			s34 <= s34 + d34;
			s35 <= s35 + d35;
			s36 <= s36 + d36;
			s37 <= s37 + d37;
			s38 <= s38 + d38;
			s39 <= s39 + d39;
			s40 <= s40 + d40;
			s41 <= s41 + d41;
			s42 <= s42 + d42;
			s43 <= s43 + d43;
			s44 <= s44 + d44;
			s45 <= s45 + d45;
			s46 <= s46 + d46;
			s47 <= s47 + d47;
			s48 <= s48 + d48;
			s49 <= s49 + d49;
			s50 <= s50 + d50;
			s51 <= s51 + d51;
			s52 <= s52 + d52;
			s53 <= s53 + d53;
			s54 <= s54 + d54;
			s55 <= s55 + d55;
			s56 <= s56 + d56;
			s57 <= s57 + d57;
			s58 <= s58 + d58;
			s59 <= s59 + d59;
			s60 <= s60 + d60;
			s61 <= s61 + d61;
			s62 <= s62 + d62;
			s63 <= s63 + d63;
		end
	end


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
