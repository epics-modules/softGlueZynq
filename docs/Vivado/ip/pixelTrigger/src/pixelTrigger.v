`timescale 1 ns / 1 ps

// Count the difference between two encoders.
module pixelTrigger(
	input regClk, A1, B1, A2, B2, Ck, missClr,
	input En, Load, Clear,
	input [31:0] PresetTrig, Preset,
	input [15:0] PresetPixel,
	input [31:0] acqTime,
	output reg [31:0] Counts, Counts1, Counts2,
	output reg [15:0] Pixel,
	output reg Trig,
	output reg miss
);
	reg [1:0] rClk;
	reg A1_delayed, B1_delayed;
	reg A2_delayed, B2_delayed;
	reg step1, dir1, step2, dir2;
	reg Q1, Q2;
	wire [3:0] stepDir;
	reg [1:0] inc;
	reg incDir;
	reg protoTrig;	// Trig not limited by acqTime
	reg [1:0] rProtoTrig;	// catch edges of protoTrig
	reg [31:0] acqTimeCounter;

	// detect edges of Ck
	always @(negedge regClk) begin
		rClk <= {rClk[0], Ck};
	end

	// Keep delayed copies of A and B encoder signals
	always @(negedge regClk) begin
		if (rClk==2'b01) begin
			A1_delayed <= A1;
			B1_delayed <= B1;
			A2_delayed <= A2;
			B2_delayed <= B2;
		end
	end

	// decode A/B encoder signals into step/dir signals
	always @(negedge regClk) begin
		if (rClk==2'b01) begin
			dir1 <= A1 ^ B1_delayed;
			step1 <= A1 ^ A1_delayed ^ B1 ^ B1_delayed;
			dir2 <= A2 ^ B2_delayed;
			step2 <= A2 ^ A2_delayed ^ B2 ^ B2_delayed;
		end
	end

	// Check for A/B transitions that can't happen unless we missed
	// a transition.
	always @(negedge regClk) begin
		if (rClk==2'b01) begin
			if (missClr)
				miss <= 0;
			else
				miss <= miss | ((A1_delayed ^ A1) & (B1_delayed ^ B1)) | ((A2_delayed ^ A2) & (B2_delayed ^ B2));
		end 
	end

	// Decide how to increment counters from step/dir signals
	assign stepDir = {step1, step2, dir1, dir2};
	always @(negedge regClk) begin
		case (stepDir)
		// only encoder 1 stepped
		4'b1000: begin inc <= 1; incDir <= 0; end
		4'b1010: begin inc <= 1; incDir <= 1; end
		// only encoder 2 stepped
		4'b0100: begin inc <= 1; incDir <= 1; end
		4'b0101: begin inc <= 1; incDir <= 0; end
		// both encoders stepped
		4'b1100: begin inc <= 0; end
		4'b1101: begin inc <= 2; incDir <= 0; end
		4'b1110: begin inc <= 2; incDir <= 1; end
		4'b1111: begin inc <= 0; end
		// neither encoder stepped
		default: inc = 0;
		endcase
	end

	// Tracking counter count
	always @(negedge regClk) begin
		if (Load) begin
			Counts <= Preset;
		end else if (Clear) begin
			Counts <= 0;
		end else if (En && (rClk==2'b01) && (inc != 0)) begin
			if (incDir) begin
				Counts <= Counts + inc;
			end else begin
				Counts <= Counts - inc;
			end
		end
	end

	// Trigger counters count and generate protoTrig --------------

	// Pixel counter
	always @(negedge regClk) begin
		if (Load | Clear) begin
			Counts1 <= PresetTrig;
			Counts2 <= PresetTrig;
			protoTrig <= 0;
			Pixel <= PresetPixel;			
		end else if (En && (rClk==2'b01) && (inc != 0)) begin
			if (incDir) begin
				// Counts1++, Counts2--
				if (Counts2 == 1) begin
					protoTrig <= 1;
					Counts1 <= PresetTrig;
					Counts2 <= PresetTrig;
					Pixel <= Pixel + 1;
				end else begin
					protoTrig <= 0;
					Counts1 <= Counts1 + inc;
					Counts2 <= Counts2 - inc;
				end
			end else begin
				// Counts1--, Counts2++
				if (Counts1 == 1) begin
					protoTrig <= 1;
					Counts1 <= PresetTrig;
					Counts2 <= PresetTrig;
					Pixel <= Pixel - 1;
				end else begin
					protoTrig <= 0;
					Counts1 <= Counts1 - inc;
					Counts2 <= Counts2 + inc;
				end
			end
		end
	end

	// Trigger output ------------

	// detect edges of protoTrig
	always @(negedge regClk) begin
		if (rClk==2'b01) begin
			rProtoTrig <= {rProtoTrig[0], protoTrig};
		end
	end

	// generate period limited triggers from protoTrig
	always @(negedge regClk) begin
		if (rClk==2'b01) begin
			if (Trig) begin
				// count down until we can clear Trig
				acqTimeCounter <= acqTimeCounter - 1;
				if (acqTimeCounter == 0) begin
					Trig <= 0;
				end
			end else if (rProtoTrig==2'b01) begin
				// Set Trig and init counter that tells us when we can clear it
				Trig <= 1;
				acqTimeCounter <= acqTime;
			end
		end
	end

endmodule
