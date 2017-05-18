`timescale 1ns / 1ps

`define IDLE	0
`define DELAY1	1
`define DELAY0	2
`define DELAYX	3

module gateDelay (
	input wire regClk, Inp, Clk,
	input [31:0] Delay,
	input [31:0] Width,
	output reg Q
);
	reg [2:0] state;
	reg [31:0] delay_counter;
	reg [31:0] width_counter;
	reg [1:0] rClk;

	initial begin
		state <= 0;
		Q <= 0;
	end

	// detect rising and falling edges
	always @(negedge regClk) begin
		rClk <= {rClk[0], Clk};
	end

	always @(negedge regClk) begin
		if (rClk==2'b01) begin
			if (Inp) begin
				if (state == `IDLE) begin
					width_counter <= 0;
				end else begin
					width_counter <= width_counter + 1;
				end
			end
		end
	end

	always @(negedge regClk) begin
		if (rClk==2'b01) begin
			if (state == `IDLE) begin
				// Wait for input signal to begin (rise)
				if (Inp) begin
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
				if (Inp==0) state <= `IDLE;
			end
		end
	end

endmodule
