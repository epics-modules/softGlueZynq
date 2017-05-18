// Module to define a SSI master for reading SSI encoders
//
// This module provides the SSI master clock to encoders which use this
// protocol. It assumes that a 50MHz input clock is provided.
//
// 1 MHz SSI clock is the fastest clock rate this module currently supports
// although the SSI specification states that clock rates up to 2 MHz can be
// used. At a 1 MHz SSI clock rate there is new data valid every 54us
// because there is a 21us wait time between data transfers plus for a 32-bit
// encoder it takes 32us to transfer every bit. 21us + 32us = 53us + 1 more
// rising edge of the SSI clock = 54us.
//
// The encoder data can be read at address 0x3 every time the statusreg at address
// 0x1 is non zero. For the case of this code module it only uses bit zero currently.
// Otherwise encoder data is always valid at address 0x5. If address 0x3 is read 
// continuously then you will be able to see the serial data as it is shifted into
// the data register while the statusreg is zero.
//
//	Author: Marty Smith
//	ANL-APS Controls Group
//
//	Version 1.0 
//
module ssi_master (
	input clk_in,			// Master clock input (Hopefully 50 MHz for MAX 10 dev board)
	input rst_n,			// Master reset input active low
	input readdata,			// Read operation
	input writedata,		// Write operation
	input [2:0] address,		// Address bus input
	input [31:0] wrdata,		// Write data bus
	input ssi_ser_data,		// SSI Serial data input from slave (encoder)
	output reg ssi_clk, 		// SSI Clock output
	output reg [31:0] rddata = 0,	// Read data bus
	output reg [31:0] validdata = 0	// Always valid encoder data
);

	// Internal signals
	localparam STATE_SIZE = 3;
	reg [STATE_SIZE-1:0] state;
	reg [STATE_SIZE-1:0] next_state;
	localparam IDLE_STATE = 3'b000,	// Just to wait for 21 us minimum
		   TX_STATE   = 3'b001,  // Send the SSI clks to the slave
		   RX_STATE   = 3'b010,  // Receive SSI data when SSI clk transitions to low
		   PARITYCHECK_STATE = 3'b011,  // Just wait for SSI clk transition
		   CLEAR_STATE = 3'b100;
	
	// Parity constants
	localparam EVEN = 0,	// Even Parity
		   ODD  = 1,	// Odd Parity
		   NOP  = 2;	// No Parity
		
	// Internal registers
	// ctlreg bit assignments:
	// Bit 15 - currently not used
	// Bit 14 - Start conversion when = 1 (Must leave set for continuous conversion)
	// Bits [13:8] - Number of data bits from encoder (Valid values are 0x01 - 0x20)
	//						  (0x0 and 0x21 - ox3f are not used)
	// Bit 7 - 1 = Gray code, 0 = Natural binary code
	// --------------------------------------------------------------------------------
	// Currently bit 6 is not used as the clock cycles are being controlled otherwise
	// so this bit should always be zero.
	// Bit 6 - Parity bit with zero bit, controls clock cycles for parity bit
	//         1 = 2 added clock cycles
	//	   0 = 1 added clock cycle
	// --------------------------------------------------------------------------------
	// Bit 5 - Parity (Even or Odd) 1 = odd parity, 0 = even parity
	//         Only useful if bt 4 = 1
	// Bit 4 - Use parity 1 = detect parity errors, 0 = no parity
	// Bits [3:0] - Controls clock rate for SSI clock speed in increments of 1us
	//              in the range of 1 - 15, 0x0 is not allowed and will stop SSI operation
	//		by putting the SSI clock = 1 (idle state)
	reg [15:0] ctlreg = 0;		// Address 0x0 control register (read/write)
	reg [15:0] statusreg = 0;	// Address 0x1 status register  (read only)

	reg start_convert = 0;
	
	reg [31:0] ssi_datareg = 0; 	// Address 0x2 SSI Serial data register (read only)
	// The parity error count register (pe_count_reg) only uses the LSB
	// It is set upon reading all SSI data if there is a parity error and reset when
	// the next SSI data read cycle starts.
	reg [15:0] pe_count_reg = 0;	// Address 0x3 Parity error counter register (read/write)
					// Write of any data to this register clears parity error counts
	
	reg [31:0] ssi_data_valid = 0;	// Address 0x4 SSI data always valid in this register (read only)
	reg [31:0] ssi_data_gray = 0;
	// Internal counters
	reg [5:0] wait_counter = 0; 	// Minimum 21 us wait counter
	reg [15:0] tx_counter = 0;	// SSI Clock transmit counter
	reg [15:0] ssi_data_count = 0;	// SSI data bit counter
	
	// SSI clock edge detector
	reg [1:0] ssi_low_edge_det = 0;
	// 1MHz clock edge detector
	reg [1:0] ssi_1Mhz_edge_det = 0;
	
	// Start SSI clock in idle state
	reg ssi_clk1 = 1;	
	reg [15:0] clk_counter1 = 0;  // 1 us clock count generation (fastest clock speed 1 MHz)
	reg ssi_clk2 = 1;	      // Temporary clock used to get correct SSI clock speed
	reg ssi_div_clk = 1;   	      // Divided 1MHz clock or 1MHz SSI clock for timing
	reg [3:0] pos_clk_cnt = 0;
	reg [3:0] neg_clk_cnt = 0;
	reg [5:0] edge_counter = 0; 	// Minimum 21 us wait counter
	reg [6:0] johnson_cnt = 0;

	task gray2binary;
		begin
			ssi_data_gray[31] = ssi_datareg[31];
			ssi_data_gray[30] = ssi_data_gray[31]^ssi_datareg[30];
			ssi_data_gray[29] = ssi_data_gray[30]^ssi_datareg[29];
			ssi_data_gray[28] = ssi_data_gray[29]^ssi_datareg[28];
			ssi_data_gray[27] = ssi_data_gray[28]^ssi_datareg[27];
			ssi_data_gray[26] = ssi_data_gray[27]^ssi_datareg[26];
			ssi_data_gray[25] = ssi_data_gray[26]^ssi_datareg[25];
			ssi_data_gray[24] = ssi_data_gray[25]^ssi_datareg[24];
			ssi_data_gray[23] = ssi_data_gray[24]^ssi_datareg[23];
			ssi_data_gray[22] = ssi_data_gray[23]^ssi_datareg[22];
			ssi_data_gray[21] = ssi_data_gray[22]^ssi_datareg[21];
			ssi_data_gray[20] = ssi_data_gray[21]^ssi_datareg[20];
			ssi_data_gray[19] = ssi_data_gray[20]^ssi_datareg[19];
			ssi_data_gray[18] = ssi_data_gray[19]^ssi_datareg[18];
			ssi_data_gray[17] = ssi_data_gray[18]^ssi_datareg[17];
			ssi_data_gray[16] = ssi_data_gray[17]^ssi_datareg[16];
			ssi_data_gray[15] = ssi_data_gray[16]^ssi_datareg[15];
			ssi_data_gray[14] = ssi_data_gray[15]^ssi_datareg[14];
			ssi_data_gray[13] = ssi_data_gray[14]^ssi_datareg[13];
			ssi_data_gray[12] = ssi_data_gray[13]^ssi_datareg[12];
			ssi_data_gray[11] = ssi_data_gray[12]^ssi_datareg[11];
			ssi_data_gray[10] = ssi_data_gray[11]^ssi_datareg[10];
			ssi_data_gray[9] = ssi_data_gray[10]^ssi_datareg[9];
			ssi_data_gray[8] = ssi_data_gray[9]^ssi_datareg[8];
			ssi_data_gray[7] = ssi_data_gray[8]^ssi_datareg[7];
			ssi_data_gray[6] = ssi_data_gray[7]^ssi_datareg[6];
			ssi_data_gray[5] = ssi_data_gray[6]^ssi_datareg[5];
			ssi_data_gray[4] = ssi_data_gray[5]^ssi_datareg[4];
			ssi_data_gray[3] = ssi_data_gray[4]^ssi_datareg[3];
			ssi_data_gray[2] = ssi_data_gray[3]^ssi_datareg[2];
			ssi_data_gray[1] = ssi_data_gray[2]^ssi_datareg[1];
			ssi_data_gray[0] = ssi_data_gray[1]^ssi_datareg[0];
		end
	endtask

// ---------------------------------------------------------------------------------------------
// This section of code is for reading and writing of registers within the module
	always @ (posedge clk_in) begin
		if (rst_n == 0) begin	// System reset clears registers (synchronous clear)
			rddata <= 0;    // and stops encoder reading
			ctlreg <= 0;
			start_convert <= 0;
		end else begin	// If not being reset then do other stuff
			if (writedata == 1) begin	// Write registers
				case (address)
					0: // Control register (Read/Write reg)
					begin
						ctlreg <= wrdata[15:0];
						start_convert <= wrdata[14];
					end
					
/*					3: // Parity error count register
					begin	// just clear the error counter no matter the write data
						pe_count_reg <= 0;
					end
*/				endcase
			end
			if (readdata == 1) begin	// Read registers
				// Set upper 16-bits to zero and use only lower 16-bits
				case (address)
				// Control register read
					0: rddata <= {16'd0,ctlreg};
				// Status register read
					1: rddata <= {16'd0,statusreg};
				// SSI data register read
					2: rddata <= ssi_datareg;
				// Parity error count
					3: rddata <= {16'd0,pe_count_reg};
				// Always valid SSI data register
					4: rddata <= ssi_data_valid;
					default: rddata <= 0;
				endcase
			end
		end
	end

// ---------------------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------------------
// This section of the code derives the 1MHz clock from the 50MHz input clock
// If your input clock is other than 50MHz the you will need to modify clk_counter1.
// The control register (ctlreg) bits 0 - 3 configure the clock speed 
// There is a section for detecting both positive and negative edges of the 1MHz clock
// which is used for dividing the clock.
// This section handles dividing the 1MHz clock to arrive at ssi_clk2
// There is a section for division by an odd integer and a section for even integers
	always @ (posedge clk_in) begin
		if (rst_n == 0) begin	// System reset clears registers (synchronous clear)
			johnson_cnt <= 0;
			pos_clk_cnt <= 0;
			neg_clk_cnt <= 0;
		// Start SSI clock in idle state
			ssi_clk1 = 1;
		end else begin
			// SSI clock output
			// Create SSI clock from master clock
			// Master clock for the FPGA itself it is 50 MHz (20 ps) (MAX 10 dev kit)
			// SSI clock setting is found in control register [3:0]
			// Can be adjusted in steps of 1us in the range 1 - 15.
			// Setting control register bits [3:0] to zero is ignored and stops SSI clock
		
			// Master SSI clock 1 us (1 MHz) assuming a 50 MHz system clock
			// 1MHz is the fastest clock rate that this module supports
			// This clock should always run as long as ctlreg[3:0] > 0
			if ( ctlreg[3:0] > 0 ) begin
				// Here is the 1MHz clock derived from the incoming 50MHz clock
				// This is the clock from which all other code in this module runs
				// for the SSI channel other than the 50MHz system clock which clocks
				// all of the always statements
				clk_counter1 <= clk_counter1 + 1'b1;
				if (clk_counter1 >= 24) begin // Divides incoming clock by 50
					ssi_clk1 <= ~ssi_clk1;
					clk_counter1 <= 0;
				end
				// -----------------------------------------------------------------------
				// Edge detection of 1MHz clock generated above
				// Here we need to have ctlreg[3:0]-1 in order to still get a 50% duty cycle
				// on the derived divided clock below (ssi_div_clk or ssi_clk2)
				if ((pos_clk_cnt == (ctlreg[3:0]-1)) && ssi_1Mhz_edge_det == 2'b01) begin
					pos_clk_cnt <= 0;
				end else if (ssi_1Mhz_edge_det == 2'b01) begin
					pos_clk_cnt <= pos_clk_cnt + 1'b1;
				end			
				if ((neg_clk_cnt == (ctlreg[3:0]-1)) && ssi_1Mhz_edge_det == 2'b10) begin
					neg_clk_cnt <= 0;
				end else if (ssi_1Mhz_edge_det == 2'b10)begin
					neg_clk_cnt <= neg_clk_cnt + 1'b1;
				end
				// -----------------------------------------------------------------------
				// Special case where we want a 1MHz clock so here we just assign the clock
				if (ctlreg[3:0] == 1) begin
					ssi_clk2 <= ssi_clk1; // 1MHz SSI clock
				end
				// -----------------------------------------------------------------------
				// -----------------------------------------------------------------------
				// This section divides the 1MHz clock by odd integers
				// Here we know the number in ctlreg[3:0] is odd if bit 0 = 1 other than above
				// where we are looking at exactly bit 0 = 1 and only bit 0 is set.
				if (ctlreg[0] == 1 && ctlreg[3:1] > 0) begin // Divide by odd number
				// This math below needs some explanation:
				// If ctlreg[3:0] were an even number then >> 1 would be divide by 2
				// But here we are looking for odd numbers so for example when ctlreg[3:0] == 7
				// right shift by 1 means we now have 3. So when the pos_clk_cnt | neg_clk_cnt
				// is > 3 we have a 1 on ssi_clk2.
					ssi_clk2 <= ((pos_clk_cnt > (ctlreg[3:0]>>1))|(neg_clk_cnt > (ctlreg[3:0]>>1)));
				// -----------------------------------------------------------------------
				// -----------------------------------------------------------------------
				// This section provides division by even integers
				end else if (ctlreg[0] == 0 && ctlreg[3:1] >= 1) begin // Divide by even numbers
				// Here we use a johnson counter to do division by even numbers on the rising edge
				// of the 1MHz clock generated above.
				// Keep in mind that we are dividing the 1MHz clock ssi_clk1
					if ( ssi_1Mhz_edge_det == 2'b01 ) begin
						if (ctlreg[3:0] == 2) begin
							johnson_cnt <= {johnson_cnt[0],~johnson_cnt[0]}; // Divide by 2
						end else if (ctlreg[3:0] == 4) begin
							johnson_cnt <= {johnson_cnt[0],~johnson_cnt[1]}; // Divide by 4
						end else if (ctlreg[3:0] == 6) begin
							johnson_cnt <= {johnson_cnt[1:0],~johnson_cnt[2]}; // Divide by 6
						end else if (ctlreg[3:0] == 8) begin
							johnson_cnt <= {johnson_cnt[2:0],~johnson_cnt[3]}; // Divide by 8
						end else if (ctlreg[3:0] == 10) begin
							johnson_cnt <= {johnson_cnt[3:0],~johnson_cnt[4]}; // Divide by 10
						end else if (ctlreg[3:0] == 12) begin
							johnson_cnt <= {johnson_cnt[4:0],~johnson_cnt[5]}; // Divide by 12
						end else if (ctlreg[3:0] == 14) begin
							johnson_cnt <= {johnson_cnt[5:0],~johnson_cnt[6]}; // Divide by 14
						end
						ssi_clk2 <= johnson_cnt[0]; // Finally we assign the divided odd clock
					end
				// -----------------------------------------------------------------------
				end
			end else begin 
				ssi_clk2 <= 1; // Put SSI clock in idle state
			end
				ssi_div_clk = ssi_clk2; // This is the divided clock assignement
		end
	end
	
	// ---------------------------------------------------------
	// State Machine
	// ---------------------------------------------------------

	// State transition logic (combinatorial)
	always @(*) begin
		next_state = state;	// Always remain in the same state unless changed
		case (state)
			IDLE_STATE: // 0x0
			begin
				// Here we will start to get the data from the encoder if 
				// start_convert is true, we have waited at least 21us, and
				// the control register clock speed is non-zero
				if (start_convert>=1 && wait_counter>=21 && ctlreg[13:8]>0 &&  
				    (ssi_low_edge_det == 2'b10) && ssi_ser_data == 1 ) begin
					next_state = CLEAR_STATE;
				// This is a case where we need to read the encoder data again
				// because there was a parity error
				end else if (start_convert>=1 && wait_counter>=21 && ctlreg[13:8]>0 && statusreg[1]==1 &&
				     (ssi_low_edge_det == 2'b10)) begin
					next_state = CLEAR_STATE;
				end
			end
		
			TX_STATE: // 0x1 This is where we transmit the SSI clk to the encoder
			begin
//				wait_counter <= 0;
				// If the ssi data is not ready we want to get the data
				// when the ssi_clk goes low (trailing edge of clk)
				if (statusreg[0] == 0 && ssi_clk == 0 && ssi_low_edge_det == 2'b01 && ctlreg[4] == 0) begin
					next_state = RX_STATE;
				end else if (statusreg[0] == 0 && ssi_clk == 0 && ssi_low_edge_det == 2'b01 && ctlreg[4] == 1) begin
					next_state = RX_STATE;
				end
			end
			
			RX_STATE: // 0x2 This is where we read the data sent back by the encoder
			begin
				if (statusreg[0] == 0 && ssi_clk == 1 && ssi_low_edge_det == 2'b10 && ssi_data_count < (ctlreg[13:8]+1)) begin
					next_state = TX_STATE;
					// (ctlreg[13:8]+1) is the number of data bits + 1
				end else if (ssi_data_count == (ctlreg[13:8]+1) && ssi_ser_data == 0 && ssi_clk == 1 && ctlreg[4] == 0 ) begin
					next_state = IDLE_STATE; // If no parity then we have all bits from encoder
				end else if (ssi_data_count == (ctlreg[13:8]+1) && ssi_low_edge_det == 2'b10 && ctlreg[4] == 1) begin
					next_state = TX_STATE; // We need to get the parity bit now so send 1 more clock
				end else if (ssi_data_count > (ctlreg[13:8]+1) && ctlreg[4] == 1 && statusreg[0] == 0) begin
					next_state = PARITYCHECK_STATE; // Check the parity to see if we have valid data
				end else if (pe_count_reg == 1 && ctlreg[4] == 1 && ssi_data_count > ctlreg[13:8] && ssi_low_edge_det == 2'b10) begin
					// We have a parity error so maybe we need to get the position data again ???
					// SSI retransmission or should we just get new data and wait 54us for new data
					// rather than just waiting for 33us for old 32-bit data
					// I chose to just get new position data rather than old data
					next_state = IDLE_STATE;
				end
			end
			
			PARITYCHECK_STATE: //0x3 Wait for next ssi clk transition 
			begin
				next_state = IDLE_STATE; // From here we always end up back at the IDLE_STATE
			end
			
			CLEAR_STATE: // 0x4
			begin
				next_state = TX_STATE;
			end
		endcase
	end

	// State machine engine (synchronous)
	always @(posedge clk_in) begin
		if (rst_n == 0) begin
			state <= IDLE_STATE;
			ssi_data_count <= 0;
			tx_counter <= 0;
			ssi_clk <= 1;
			pe_count_reg <= 0;
			statusreg <= 0;
			wait_counter <= 0;
		end else begin
	// This is used for edge detection of the 1MHz generated clock to derive the divided clocks
			// --------- NOTE: This is a 2-bit shift register ---------------
			ssi_1Mhz_edge_det <= {ssi_1Mhz_edge_det[0],ssi_clk1};
			// --------------------------------------------------------------
			if (state == IDLE_STATE && ssi_1Mhz_edge_det == 2'b01) begin
				wait_counter <= wait_counter + 1'b1;
				// Here we use ssi_low_edge_det == 2'b10 because this wait counter
				// is the minimum wait time between encoder reads and the counter
				// does not always line up with the SSI output clock at exactly
				// 21us.
				if (wait_counter >= 21 && ssi_low_edge_det == 2'b01) begin
					wait_counter <= 0;
				end
			end
			state <= next_state;
			if (state != next_state) begin
			// SSI data is valid on low SSI clk edge
				case (next_state)
					IDLE_STATE: // 0x000
					begin
						ssi_clk <= 1;
						if (ssi_data_count >= (ctlreg[13:8]+1) && pe_count_reg == 0) begin
							statusreg[0] <= 1;
							ssi_data_count = 0;	// Clear data bit counter
							statusreg[1] = 0;	// clear parity bit register
							if (ctlreg[7] == 0) begin // Binary data
								ssi_data_valid <= ssi_datareg; // make sure we update always valid reg
								validdata <= ssi_datareg; // for encoder output data from module
							end else begin // Gray code data to convert to binary
								gray2binary();
								ssi_data_valid <= ssi_data_gray;
								validdata <= ssi_data_gray;	// for encoder output data from module
							end
						end else
							statusreg[0] <= 0;
					end
					
					TX_STATE:  // 0x001
					begin
						ssi_clk <= 0;	// Set SSI clock low
						if (ssi_data_count == 0 && statusreg[0] == 1) begin
							wait_counter <= 0; // Make sure wait counter starts at zero
							statusreg[0] <= 0; // Reset status register as data is no longer valid
							tx_counter <= 0;
						// This means that the last read was with parity and there was a parity error
						end else if (ssi_data_count >= (ctlreg[13:8]+2) && statusreg[0] == 0 && pe_count_reg >= 1) begin
							wait_counter <= 0; // Make sure wait counter starts at zero
							tx_counter <= 0;
							ssi_data_count <= 0;					
							statusreg[0] <= 0; // Reset status register as data is no longer valid
							pe_count_reg <= 0; // Reset parity error counter to get new data
						end
						
						if ( ((ctlreg[6:4] == 1)||(ctlreg[6:4] == 3)) && statusreg[0] == 0 && pe_count_reg == 0 ) begin
						// We need 1 extra clock cycle for the parity bit
							if (tx_counter > ctlreg[13:8]+1) begin
								tx_counter <= 0;
								statusreg[0] <= 1;	// Set data ready bit
							end
						end else if ( ((ctlreg[6:4] == 5)||(ctlreg[6:4] == 7)) && statusreg[0] == 0 && pe_count_reg == 0 ) begin
						// We need 2 extra clock cycles for parity and zero bit
							if (tx_counter > ctlreg[13:8]+2) begin
								tx_counter <= 0;
								statusreg[0] <= 1;	// Set data ready bit
							end
						end else begin
						// We are not using parity so we don't need extra clocks
							if (tx_counter > ctlreg[13:8] && statusreg[0] == 0 && pe_count_reg == 0) begin
								tx_counter <= 0;
								statusreg[0] <= 1;	// Set data ready bit
							end
						end
					end
					
					RX_STATE:  // 0x010
					begin
						// Only start shifting data if this is not the first SSI clock
						// because the SSI specification states that the SSI idle state
						// is when the clock is high and the data is high. Then the slave
						// continously updates its position data. The first falling edge
						// of the SSI clock the slave freezes its data. The next rising
						// edge of the SSI clock the slave shift out the MSB of the position
						// data. This data can be read on the falling edge of the SSI clock
						// providing that the clock has a 50% duty cycle.
						// Therefore we muct ignore the first falling edge of the SSI clock.
						if (ssi_data_count > 0) begin
							if (ssi_data_count < (ctlreg[13:8]+1)) begin
								// NOTE: This is a 32-bit shift register
								ssi_datareg[31:0] <= {ssi_datareg[30:0],ssi_ser_data};
								ssi_data_count <= ssi_data_count + 1'b1;
								ssi_clk <= 1;	// Set SSI clk high
							end else if (ssi_data_count == (ctlreg[13:8]+1) && tx_counter == (ctlreg[13:8]+1)) begin
								statusreg[1] <= ssi_ser_data; // This is the parity bit
								ssi_clk <= 1;	// Set SSI clk high
								ssi_data_count <= ssi_data_count + 1'b1;
							end 
							tx_counter <= tx_counter + 1'b1; // Count SSI Clks
						end else begin
							ssi_data_count <= ssi_data_count + 1'b1;
							ssi_clk <= 1;
						end 					
					end
					
					PARITYCHECK_STATE:  // 0x011
					begin
					//	ssi_clk <= 0; // Need one more clock to get the parity bit
					// If statusreg[0] == 0 then we now have all the data
					// Check if we are to detect parity errors (bit 4 of ctlreg = 1)
						if (statusreg[0] == 0 && ctlreg[4] == 1 && tx_counter >= ctlreg[13:8]+1 ) begin
							// Even parity check
							if ( ctlreg[5] == EVEN ) begin // Are we looking for even parity or odd
								if ( (statusreg[1] ^ (^ssi_datareg[31:0])) != 0 ) begin
					// Even parity is not ok so we need to get the data again
					// by retransmitting the clocks after a wait and leave statusreg[0] = 0
									ssi_datareg[31:0] <= 0; // Clear data register
									pe_count_reg = pe_count_reg + 1'b1;
									statusreg[1] <= 1; // Parity error
								end else begin
								// Even parity is ok
									statusreg[0] <= 1;
									ssi_data_count <= (ctlreg[13:8]+1'b1);
									if (ctlreg[7] == 0) begin // Binary data
										ssi_data_valid <= ssi_datareg; // make sure we update always valid reg
										validdata <= ssi_datareg;
									end else begin // Gray code data to convert to binary
										gray2binary();
										ssi_data_valid <= ssi_data_gray;
										validdata <= ssi_data_gray;
									end
									statusreg[1] <= 0;
								end
							end else begin // Odd parity check
								if ( (statusreg[1] ^ (^ssi_datareg[31:0])) != 1 ) begin
					// Odd parity is not ok so we need to get the data again
					// by retransmitting the clocks after a wait and leave statusreg[0] = 0
									ssi_datareg[31:0] <= 0; // Clear data register
									pe_count_reg = pe_count_reg + 1'b1;
									statusreg[1] <= 1; // Parity error
								end else begin
								// Odd parity is ok
									statusreg[0] <= 1;
									ssi_data_count <= (ctlreg[13:8]+1'b1);
									if (ctlreg[7] == 0) begin // Binary data
										ssi_data_valid <= ssi_datareg; // make sure we update always valid reg
										validdata <= ssi_datareg;
									end else begin // Gray code data to convert to binary
										gray2binary();
										ssi_data_valid <= ssi_data_gray;
										validdata <= ssi_data_gray;
									end
									statusreg[0] <= 0;
								end
							end
						end
					end
					
					CLEAR_STATE: // 0x100
					begin
						ssi_datareg <= 0;
					end
				endcase
			end
		end
	end
	// The difference between this shift register and the one at the beginning of the
	// code is that this one is detecting edges of the divided clock and the previous
	// one is detecting edges of the 1 MHz clock. These may or may not be the same
	// depending on the selected clock frequency in ctlreg[3:0]
	always @(posedge clk_in) begin
		// --------- NOTE: This is a 2-bit shift register ---------------
		ssi_low_edge_det <= {ssi_low_edge_det[0],ssi_div_clk};
		// --------------------------------------------------------------
		// Need to wait for at least 21us before starting ssi master clk
		// ssi_clk1 is 1us and currently clk_in is 20ns period (50 MHz)
		// We need a count of 526 rather than 525 because detected edge
		// is 1 clock cycle later in the shift register.
		// This shift register is in sync with the output SSI clock
		if (state == IDLE_STATE && ssi_low_edge_det == 2'b01) begin
			edge_counter <= edge_counter + 1'b1;
			if (edge_counter >= 21 || rst_n == 0) begin
				edge_counter <= 0;
			end
		end
	end
endmodule
