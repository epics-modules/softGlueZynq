`timescale 1ns / 1ps
module xadcDriver (
	output wire [6:0] m_drp_DADDR,
	output wire m_drp_DEN,
	output wire [15:0] m_drp_DI,
	input wire [15:0] m_drp_DO,
	input wire m_drp_DRDY,
	output wire m_drp_DWE,
	input dclk,
	input reset,
	input eoc, eos, busy,
	output reg [15:0] V_aux0, V_aux1, 
	output reg [15:0] V_aux2, V_aux3
	);
	reg [1:0]  dEnable_reg;
	reg [1:0]  dWriteEnable_reg;
	reg [7:0]  state = init_read;
	reg [15:0] dIn;
	wire [15:0] dOut;
	wire dReady;
	reg [6:0] dAddr;

	parameter init_read		= 8'h00,
			  read_wait		= 8'h01,
			  write_wait	= 8'h02,
			  read_aux0		= 8'h03,
			  aux0_wait		= 8'h04,
			  read_aux1		= 8'h05,
			  aux1_wait		= 8'h06,
			  read_aux2		= 8'h07,
			  aux2_wait		= 8'h08,
			  read_aux3		= 8'h09,
			  aux3_wait		= 8'h0a,
			  read_aux4		= 8'h0b,
			  aux4_wait		= 8'h0c,
			  read_aux5		= 8'h0d,
			  aux5_wait		= 8'h0e,
			  read_aux6		= 8'h0f,
			  aux6_wait		= 8'h10,
			  read_aux7		= 8'h11,
			  aux7_wait		= 8'h12,
			  read_aux8		= 8'h13,
			  aux8_wait		= 8'h14,
			  read_aux9		= 8'h15,
			  aux9_wait		= 8'h16,
			  read_aux10	= 8'h17,
			  aux10_wait	= 8'h18,
			  read_aux11	= 8'h19,
			  aux11_wait	= 8'h1a,
			  read_aux12	= 8'h1b,
			  aux12_wait	= 8'h1c,
			  read_aux13	= 8'h1d,
			  aux13_wait	= 8'h1e,
			  read_aux14	= 8'h1f,
			  aux14_wait	= 8'h20,
			  read_aux15	= 8'h21,
			  aux15_wait	= 8'h22;

	parameter	aux0_reg	= 7'h10,
				aux1_reg	= 7'h11,
				aux2_reg	= 7'h12,
				aux3_reg	= 7'h13,
				aux4_reg	= 7'h14,
				aux5_reg	= 7'h15,
				aux6_reg	= 7'h16,
				aux7_reg	= 7'h17,
				aux8_reg	= 7'h18,
				aux9_reg	= 7'h19,
				aux10_reg	= 7'h1a,
				aux11_reg	= 7'h1b,
				aux12_reg	= 7'h1c,
				aux13_reg	= 7'h1d,
				aux14_reg	= 7'h1e,
				aux15_reg	= 7'h1f,
				configReg0	= 7'h40;

	assign	m_drp_DI = dIn,
			m_drp_DO = dOut,
			m_drp_DEN = dEnable_reg[0],
			m_drp_DWE = dWriteEnable_reg[0],
			m_drp_DRDY = dReady,
			m_drp_DADDR = dAddr;

	always @(posedge dclk)
		if (reset) begin
			state   <= init_read;
			dEnable_reg <= 2'h0;
			dWriteEnable_reg <= 2'h0;
			dIn  <= 16'h0000;
		end
		else
			case (state)
			init_read : begin
				dAddr = 7'h40;
				dEnable_reg = 2'h2; // performing read
				if (busy == 0 ) state <= read_wait;
				end

			read_wait : 
				if (dReady ==1)  begin
					dIn = dOut  & 16'h03_FF; //Clearing AVG bits for configReg0
					dAddr = 7'h40;
					dEnable_reg = 2'h2;
					dWriteEnable_reg = 2'h2; // performing write
					state = write_wait;
				end
				else begin
					dEnable_reg = { 1'b0, dEnable_reg[1] } ;
					dWriteEnable_reg = { 1'b0, dWriteEnable_reg[1] } ;
					state = state;
				end

			write_wait : 
				if (dReady ==1) begin
					state = read_aux0;
					end
				else begin
					dEnable_reg = { 1'b0, dEnable_reg[1] } ;
					dWriteEnable_reg = { 1'b0, dWriteEnable_reg[1] } ;
					state = state;
				end


			read_aux0 : begin
					dAddr	= aux0_reg;
					dEnable_reg = 2'h2; // performing read
					state	<= aux0_wait;
				end
			aux0_wait : 
				if (dReady ==1)  begin
					V_aux0 = dOut; 
					state <= read_aux1;
				end
				else begin
					dEnable_reg = { 1'b0, dEnable_reg[1] } ;
					dWriteEnable_reg = { 1'b0, dWriteEnable_reg[1] } ;
					state = state;
				end

			read_aux1 : begin
				dAddr	= aux1_reg;
				dEnable_reg = 2'h2; // performing read
				state	<= aux1_wait;
				end
			aux1_wait : 
				if (dReady ==1)  begin
					V_aux1 = dOut; 
					state <= read_aux2;
					end
				else begin
					dEnable_reg = { 1'b0, dEnable_reg[1] } ;
					dWriteEnable_reg = { 1'b0, dWriteEnable_reg[1] } ;
					state = state;
				end

			read_aux2 : begin
				dAddr	= aux2_reg;
				dEnable_reg = 2'h2; // performing read
				state	<= aux2_wait;
				end
			aux2_wait : 
				if (dReady ==1)  begin
					V_aux2= dOut; 
					state <= read_aux3;
					end
				else begin
					dEnable_reg = { 1'b0, dEnable_reg[1] } ;
					dWriteEnable_reg = { 1'b0, dWriteEnable_reg[1] } ;
					state = state;
				end

			read_aux3 : begin
				dAddr	= aux3_reg;
				dEnable_reg = 2'h2; // performing read
				state	<= aux3_wait;
				end
			aux3_wait :
				if (dReady ==1)  begin
					V_aux3= dOut; 
					state <=read_aux0;
					dAddr	= 7'h00;
				end
				else begin
					dEnable_reg = { 1'b0, dEnable_reg[1] } ;
					dWriteEnable_reg = { 1'b0, dWriteEnable_reg[1] } ;
					state = state;
				end
			endcase
endmodule
