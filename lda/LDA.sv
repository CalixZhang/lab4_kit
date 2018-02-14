module LDA
(
	input logic clk,
	input logic reset,
	
	// FROM AVALON SLAVE CONTROLLER
	input logic [8:0] i_X0, 
	input logic [8:0] i_Y0, 
	input logic [8:0] i_X1,
	input logic [8:0] i_Y1,
	input logic [2:0] i_COLOR,
	input logic i_GO,
	
	// TO VGA
	output logic o_PLOT,
	output logic [8:0] o_X,
	output logic [8:0] o_Y,
	output logic [2:0] o_COLOR,
	
	// TO AVALON SLAVE CONTROLLER
	output logic o_DONE
);

	logic dp_START, dp_RUN, dp_CONDITION;

	LDA_control ctrl_inst
	(
		.clk(clk),
		.reset(reset),	
		.i_GO(i_GO),
		.i_CONDITION(dp_CONDITION),	
		.o_START(dp_START),
		.o_RUN(dp_RUN),
		.o_DONE(o_DONE)
	);
	
	LDA_datapath dp_inst
	(
		.clk(clk),
		.reset(reset),
		.i_START(dp_START),
		.i_RUN(dp_RUN),
		.X0(i_X0), 
		.Y0(i_Y0), 
		.X1(i_X1),
		.Y1(i_Y1),
		.COLOR(i_COLOR),	
		.o_CONDITION(dp_CONDITION),
		.o_PLOT(o_PLOT),
		.o_X(o_X),
		.o_Y(o_Y),
		.o_COLOR(o_COLOR)
	);

endmodule
