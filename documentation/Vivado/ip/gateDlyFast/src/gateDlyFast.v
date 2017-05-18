`timescale 1ns / 1ps

`define IDLE	0
`define DELAY1	1
`define DELAY0	2
`define DELAYX	3

module gateDelayFast # (
	parameter integer N=32
) (
	input wire Clk, Inp,
	input [N-1:0] Delay,
	input [N-1:0] Width,
	output reg Q
);
	reg [2:0] state;
	reg [N-1:0] delay_counter;
	reg [N-1:0] width_counter;
	reg [1:0] InpR;

	initial begin
		state <= 0;
		Q <= 0;
		InpR <= 2'b00;
	end

	always @(posedge Clk) begin
		InpR <= {InpR[0], Inp};
	end

	always @(posedge Clk) begin
		if ((state == `IDLE) && (InpR == 2'b01)) begin
			width_counter <= 0;
		end else if ((state != `IDLE) && Inp) begin
			width_counter <= width_counter + 1;
		end
	end

	always @(posedge Clk) begin
		if (state == `IDLE) begin
			// Wait for input signal to begin (rise)
			if (InpR == 2'b01) begin
				if (Delay == 0) begin
					Q <= 1;
					delay_counter <= Width;
					state <= `DELAY0;
				end else begin
					delay_counter <= Delay;
					state <= `DELAY1;
				end
			end
		end else if (state == `DELAY1) begin
			// Wait to set Q
			delay_counter <= delay_counter - 1;
			if (delay_counter == 0) begin
				Q <= 1;
				delay_counter <= Width;
				state <= `DELAY0;
			end
		end else if (state == `DELAY0) begin
			// Wait to clear Q
			if (Width != 0) begin
				delay_counter <= delay_counter - 1;
				if (delay_counter == 0) begin
					delay_counter <= 0;
					Q <= 0;
					state <= `DELAYX;
				end
			end else begin
				delay_counter <= delay_counter + 1;
				if (delay_counter==width_counter) begin
					Q <= 0;
					state <= `DELAYX;
				end
			end
		end else begin
			// Wait for input signal to end (fall)
			if (Inp == 0) state <= `IDLE;
		end
	end

endmodule
