module LDM	// Line Drawer Module
(
	// CLOCK & RESET
	clk,
	reset,
	
	// AVALON SLAVE SIGNALS
	avs_s1_address,
	avs_s1_read,
	avs_s1_readdata,
	avs_s1_waitrequest,
	avs_s1_write,
	avs_s1_writedata,
	
	// VGA SIGNALS
	coe_VGA_B_export,
	coe_VGA_BLANK_N_export,
	coe_VGA_CLK_export,
	coe_VGA_G_export,
	coe_VGA_HS_export,
	coe_VGA_R_export,
	coe_VGA_SYNC_N_export,
	coe_VGA_VS_export
);

	input logic clk;
	input logic reset;
	
	input logic [2:0] avs_s1_address;
	input logic avs_s1_read;
	output logic [31:0] avs_s1_readdata;
	output logic avs_s1_waitrequest;
	input logic avs_s1_write;
	input logic [31:0] avs_s1_writedata;
	
	output logic [7:0] coe_VGA_B_export;
	output logic coe_VGA_BLANK_N_export;
	output logic coe_VGA_CLK_export;
	output logic [7:0] coe_VGA_G_export;
	output logic coe_VGA_HS_export;
	output logic [7:0] coe_VGA_R_export;
	output logic coe_VGA_SYNC_N_export;
	output logic coe_VGA_VS_export;
	
	logic avsc_DONE;
	
	logic [8:0] lda_X0, lda_Y0, lda_X1, lda_Y1;
	logic [2:0] lda_COLOR;
	logic lda_GO;
	
	logic vga_PLOT;
	logic [8:0] vga_X, vga_Y;
	logic [2:0] vga_COLOR;
	
	avalon_slave_controller avsc_inst
	(
		// CLOCK & RESET
		.clk(clk),
		.reset(reset),
		
		// AVALON MASTER COMMUNICATION SIGNALS
		.avs_s1_address(avs_s1_address),	// selecting 1 of the 6, 32 bits registers
		.avs_s1_read(avs_s1_read),
		.avs_s1_readdata(avs_s1_readdata),
		.avs_s1_waitrequest(avs_s1_waitrequest),
		.avs_s1_write(avs_s1_write),
		.avs_s1_writedata(avs_s1_writedata),
		
		// LDA COMMUNICATION SIGNALS
		.o_X0(lda_X0),
		.o_Y0(lda_Y0),
		.o_X1(lda_X1),
		.o_Y1(lda_Y1),
		.o_COLOR(lda_COLOR),
		.i_DONE(avsc_DONE),
		.o_START(lda_GO)
	);
	
	LDA lda_inst
	(
		// CLOCK & RESET
		.clk(clk),
		.reset(reset),
		
		// FROM AVALON SLAVE CONTROLLER
		.i_X0(lda_X0), 
		.i_Y0(lda_Y0),
		.i_X1(lda_X1),
		.i_Y1(lda_Y1),
		.i_COLOR(lda_COLOR),
		.i_GO(lda_GO),
		
		// TO VGA
		.o_PLOT(vga_PLOT),
		.o_X(vga_X),
		.o_Y(vga_Y),
		.o_COLOR(vga_COLOR),
		
		// TO AVALON SLAVE CONTROLLER
		.o_DONE(avsc_DONE)
	);
	
	vga_adapter #
	(
		.BITS_PER_CHANNEL(1)
	)
	vga_inst
	(
		.clk(clk),
		.VGA_R(coe_VGA_R_export),
		.VGA_G(coe_VGA_G_export),
		.VGA_B(coe_VGA_B_export),
		.VGA_HS(coe_VGA_HS_export),
		.VGA_VS(coe_VGA_VS_export),
		.VGA_SYNC_N(coe_VGA_SYNC_N_export),
		.VGA_BLANK_N(coe_VGA_BLANK_N_export),
		.VGA_CLK(coe_VGA_CLK_export),
		.x(vga_X),
		.y(vga_Y),
		.color(vga_COLOR),
		.plot(vga_PLOT)
	);
	
endmodule
