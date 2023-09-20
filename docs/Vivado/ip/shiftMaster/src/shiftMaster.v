module shiftMaster(
	input regClk,
	input shiftStateClock,
	output [2:0] shiftCtrl,
	output [4:0] state
);
	reg [2:0] shiftCtrl;
	reg [4:0] state;
	reg [1:0] rshiftStateClock;
	
	// detect rising edges of shiftStateClock
	always @(negedge regClk) begin
		rshiftStateClock <= {rshiftStateClock[0], shiftStateClock};
	end

	parameter	// bits: init, clock, latch
		init		= 3'b100,
		shiftout	= 3'b010,
		shiftin		= 3'b000,
		latch		= 3'b001,
		rest		= 3'b000;

	parameter	initState	= 0,
				rest1		= 1,
				startState	= 2,
				latchState1	= 26,
				latchState2	= 27,
				latchState3	= 28,
				endState	= 29;

	initial begin
		shiftCtrl	= rest;
		state		= 0;
	end

	always @(negedge regClk) begin
		if (rshiftStateClock==2'b01) begin
			if (state != endState)
				state <= state + 1;
			else
				state <= initState;

			case (state)
			initState:		shiftCtrl <= init;
			rest1:			shiftCtrl <= rest;
			startState:		shiftCtrl <= shiftout;
			default:		shiftCtrl <= shiftCtrl ^ 3'b010;
			latchState1:	shiftCtrl <= latch;
			latchState2:	shiftCtrl <= rest;
			latchState3:	shiftCtrl <= latch;
			endState:		shiftCtrl <= rest;
			endcase
		end
	end
endmodule
//cycle	reg	bitOut	bitIn
//00	100			
//01	000			
//02	010	1		
//03	000			1
//04	010	2		
//05	000			2
//06	010	3		
//07	000			3
//08	010	4		
//09	000			4
//10	010	5		
//11	000			5
//12	010	6		
//13	000			6
//14	010	7		
//15	000			7
//16	010	8		
//17	000			8
//18	010	9		
//19	000			9
//20	010	10		
//21	000			10
//22	010	11		
//23	000			11
//24	010	12		
//25	000			12
//26	001	client latches inputs
//27	000	
//28	001	client latches outputs
//29	000	
