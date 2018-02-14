module AVSC_datapath
(
	// CLOCK & RESET
	input logic clk,
	input logic reset,
	
	// AVALON MASTER COMMUNICATION SIGNALS
	output logic [31:0] avs_s1_readdata,
	input logic [31:0] avs_s1_writedata,
	
	// FROM CTRL
	input logic [2:0] i_ADDRSEL,
	input logic i_READ,
	input logic i_WRITE,
	input logic i_START,
	input logic i_DONE,
	
	// TO CTRL
	output logic o_MODE,
	output logic o_GO,
	
	// TO LDA
	output logic [8:0] o_X0,
	output logic [8:0] o_Y0,
	output logic [8:0] o_X1,
	output logic [8:0] o_Y1,
	output logic [2:0] o_COLOR
);

	/*
	 * pmem description:
	 *
	 * 0 -> mode_reg
	 * 1 -> status_reg
	 * 2 -> go_reg
	 * 3 -> line_starting_point
	 * 4 -> line_end_point
	 * 5 -> line_color
	*/
	reg [31:0] pmem[0:5];	// 6 x 32bit array

	always_ff @ (posedge clk) begin
		if (reset) begin
			pmem[0] = 32'd1;	// STALL MODE by default
			pmem[1] = 32'd0;
			pmem[2] = 32'd0;
			pmem[3] = 32'd0;
			pmem[4] = 32'd0;
			pmem[5] = 32'd7;	// WHITE by default - 0b0111
		end
		else begin
			if (i_READ) avs_s1_readdata <= pmem[i_ADDRSEL];
			if (i_WRITE) pmem[i_ADDRSEL] <= avs_s1_writedata;
			if (i_START) pmem[1] <= 32'd1;	// POLL MODE - BUSY
			if (i_DONE) pmem[1] <= 32'd0;	// POLL MODE - FREE
		end
	end
	
	// assigning items: TO CTRL
	assign o_MODE = pmem[0][0];
	assign o_GO = (pmem[2] > 32'd0) ? 1'b1 : 1'b0;
	
	// assigning items: TO LDA
	assign o_X0 = pmem[3][8:0];
	assign o_Y0 = pmem[3][16:9];
	assign o_X1 = pmem[4][8:0];
	assign o_Y1 = pmem[4][16:9];
	assign o_COLOR = pmem[5][2:0];
endmodule
