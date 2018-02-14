module avalon_slave_controller
(
	// CLOCK & RESET
	input logic clk,
	input logic reset,
	
	// AVALON MASTER COMMUNICATION SIGNALS
	input logic [3:0] avs_s1_address,	// selecting 1 of the 6, 32 bits registers
	input logic avs_s1_read,
	output logic [31:0] avs_s1_readdata,
	output logic avs_s1_waitrequest,
	input logic avs_s1_write,
	input logic [31:0] avs_s1_writedata,
	
	// LDA COMMUNICATION SIGNALS
	output logic [8:0] o_X0,
	output logic [8:0] o_Y0,
	output logic [8:0] o_X1,
	output logic [8:0] o_Y1,
	output logic [2:0] o_COLOR,
	input logic i_DONE,
	output logic o_START
);
	
	logic ctrl_MODE, ctrl_GO;
	logic dp_ADDRSEL, dp_READ, dp_WRITE, dp_START, dp_DONE;
	
	AVSC_control ctrl_inst
	(
		// CLOCK & RESET
		.clk(clk),
		.reset(reset),
		
		// AVALON MASTER COMMUNICATION SIGNALS
		.avs_s1_address(avs_s1_address),
		.avs_s1_read(avs_s1_read),
		.avs_s1_waitrequest(avs_s1_waitrequest),
		.avs_s1_write(avs_s1_write),
		
		// FROM DP
		.i_MODE(ctrl_MODE),
		.i_GO(ctrl_GO),
		
		// FROM LDA
		.i_DONE(i_DONE),
		
		// TO DP
		.o_ADDRSEL(dp_ADDRSEL),
		.o_READ(dp_READ),
		.o_WRITE(dp_WRITE),
		.o_DONE(dp_DONE),
			
		// TO LDA & DP
		.o_START(dp_START)
	);
	
	AVSC_datapath dp_inst
	(
		// CLOCK & RESET
		.clk(clk),
		.reset(reset),
		
		// AVALON MASTER COMMUNICATION SIGNALS
		.avs_s1_readdata(avs_s1_readdata),
		.avs_s1_writedata(avs_s1_writedata),
		
		// FROM CTRL
		.i_ADDRSEL(dp_ADDRSEL),
		.i_READ(dp_READ),
		.i_WRITE(dp_WRITE),
		.i_START(dp_START),
		.i_DONE(dp_DONE),
		
		// TO CTRL
		.o_MODE(ctrl_MODE),
		.o_GO(ctrl_GO),
		
		// TO LDA
		.o_X0(o_X0),
		.o_Y0(o_Y0),
		.o_X1(o_X1),
		.o_Y1(o_Y1),
		.o_COLOR(o_COLOR)
	);
	
	assign o_START = dp_START;
	
endmodule
