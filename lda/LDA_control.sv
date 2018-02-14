module LDA_control
(
	input logic clk,
	input logic reset,
	
	// FROM AVALON SLAVE CONTROLLER
	input logic i_GO,
	
	// FROM DP
	input logic i_CONDITION,
	
	// TO DP
	output logic o_START,
	output logic o_RUN,
	output logic o_DONE
);

	// Declare two objects, 'state' and 'nextstate'
	// that are of enum type.
	typedef enum logic
	{
		S_IDLE,
		S_RUN
	} LDA_STATES;
	LDA_STATES state, nextstate;
	
	// Clocked always block for changing state registers
	always_ff @ (posedge clk) begin
		if (reset) state <= S_IDLE;
		else state <= nextstate;
	end
	
	always_comb begin
		nextstate = state;
		o_START = 1'b0;
		o_RUN = 1'b0;
		o_DONE = 1'b0;
		
		case(state)
			S_IDLE: begin
				if (i_GO) begin
					nextstate = S_RUN;
					o_START = 1'b1;
				end
			end
			
			S_RUN: begin
				if (i_CONDITION) begin
					nextstate = S_IDLE;
					o_DONE = 1'b1;
				end
				else o_RUN = 1'b1;
			end
			
			default: begin
				nextstate = S_IDLE;
			end
		endcase
	end
	
endmodule
