module LDA_datapath
(
	input logic clk,
	input logic reset,
	
	// FROM LDA CTRL
	input logic i_START,	// X0, X1, Y0, Y1, and COLOR are valid
	input logic i_RUN,
	
	// FROM AVALON SLAVE CONTROLLER
	input logic [8:0] X0, 
	input logic [8:0] Y0, 
	input logic [8:0] X1,
	input logic [8:0] Y1,
	input logic [2:0] COLOR,
	
	// TO LDA CTRL
	output logic o_CONDITION,
	
	// TO VGA
	output logic o_PLOT,
	output logic [8:0] o_X,
	output logic [8:0] o_Y,
	output logic [2:0] o_COLOR
);

	logic signed [9:0] dx, dy, err, e2;
	logic right, down;
	
	always_ff @ (posedge clk) begin
		o_CONDITION <= 1'b0;
		o_PLOT <= 1'b0;
		if (i_START) begin
			dx = X1 - X0;
			right = dx >= 0;
			if (~right) dx = -dx;
			dy = Y1 - Y0;
			down = dy >= 0;
			if (down) dy = -dy;
			err = dx + dy;
			o_X <= X0;
			o_Y <= Y0;
			o_COLOR <= COLOR;
			o_PLOT <= 1'b1;
		end
		else if (i_RUN) begin
			if (o_X == X1 && o_Y == Y1) begin
				o_CONDITION <= 1'b1;
			end
			else begin
				o_PLOT <= 1'b1;
				e2 = err << 1;
				if (e2 > dy) begin
					err += dy;
					if (right) o_X <= o_X + 9'd1;
					else o_X <= o_X - 9'b1;
				end
				if (e2 < dx) begin
					err += dx;
					if (down) o_Y <= o_Y + 9'd1;
					else o_Y <= o_Y - 9'd1;
				end
			end
		end
	end
	
endmodule
