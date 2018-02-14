module AVSC_control
(
	// CLOCK & RESET
	input logic clk,
	input logic reset,
	
	// AVALON MASTER COMMUNICATION SIGNALS
	input logic [2:0] avs_s1_address,	// selecting 1 of the 6, 32 bits registers
	input logic avs_s1_read,
	output logic avs_s1_waitrequest,
	input logic avs_s1_write,

	// FROM DP
	input logic i_MODE,
	input logic i_GO,
	
	// FROM LDA
	input logic i_DONE,
	
	// TO DP
	output logic [2:0] o_ADDRSEL,
	output logic o_READ,
	output logic o_WRITE,
	output logic o_DONE,
	
	// TO LDA & DP
	output logic o_START
);

	typedef enum logic
	{
		S_UNOCCUPIED,
		S_OCCUPIED
	} LDS_STATES;
	LDS_STATES state, nextstate;
	
	// Clocked always block for changing state registers
	always_ff @ (posedge clk) begin
		if (reset) state <= S_UNOCCUPIED;
		else state <= nextstate;
	end
	
	always_comb begin
		nextstate = state;
		o_ADDRSEL = 3'b0;
		o_READ = 1'b0;
		o_WRITE = 1'b0;
		o_START = 1'b0;
		o_DONE = 1'b0;
		avs_s1_waitrequest = 1'b0;
		
		case(state)
			S_UNOCCUPIED: begin
				if (avs_s1_read) begin
					o_ADDRSEL = avs_s1_address;
					o_READ = 1'b1;
				end
				
				if (avs_s1_write) begin
					o_ADDRSEL = avs_s1_address;
					o_WRITE = 1'b1;
				end
				
				if (i_GO) begin
					o_START = 1'b1;
					nextstate = S_OCCUPIED;
				end
			end
			
			S_OCCUPIED: begin
				if (avs_s1_read) begin
					o_ADDRSEL = avs_s1_address;
					o_READ = 1'b1;
				end
				
				// If in STALL MODE, where the hardware is responsible for LDA timing
				if (avs_s1_write & ~i_MODE) avs_s1_waitrequest = 1'b1;
				
				/*
				 * In POLL MODE, it is up to the programmer to wait for the LDA.
				 * Therefore, write should not be available when the LDA is occupied.
				 *
				*/
				
				if (i_DONE) begin
					o_DONE = 1'b1;
					nextstate = S_UNOCCUPIED;
				end
			end
		endcase
	end
endmodule
