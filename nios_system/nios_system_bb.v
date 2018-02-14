
module nios_system (
	clk_clk,
	leds_export,
	line_drawer_module_0_vga_b_export,
	line_drawer_module_0_vga_blank_n_export,
	line_drawer_module_0_vga_clk_export,
	line_drawer_module_0_vga_g_export,
	line_drawer_module_0_vga_hs_export,
	line_drawer_module_0_vga_r_export,
	line_drawer_module_0_vga_sync_n_export,
	reset_reset_n,
	switches_export,
	line_drawer_module_0_vga_vs_export);	

	input		clk_clk;
	output	[7:0]	leds_export;
	output	[7:0]	line_drawer_module_0_vga_b_export;
	output		line_drawer_module_0_vga_blank_n_export;
	output		line_drawer_module_0_vga_clk_export;
	output	[7:0]	line_drawer_module_0_vga_g_export;
	output		line_drawer_module_0_vga_hs_export;
	output	[7:0]	line_drawer_module_0_vga_r_export;
	output		line_drawer_module_0_vga_sync_n_export;
	input		reset_reset_n;
	input	[7:0]	switches_export;
	output		line_drawer_module_0_vga_vs_export;
endmodule
