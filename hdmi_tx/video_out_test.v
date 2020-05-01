`timescale 1ns/1ps
module video_out_test
(
	input  sys_clk_p,
	input  sys_clk_n,
	output[3:0] led,
	
	inout hdmi_scl,
	inout hdmi_sda,
	output hdmi_nreset,
	
	output vout_clk,
	output vout_hs,
	output vout_vs,
	output vout_de,
	output[23:0] vout_data
);

wire      video_clk;
wire      pattern_hs;   
wire      pattern_vs;   
wire      pattern_de;   
wire[7:0] pattern_rgb_r;
wire[7:0] pattern_rgb_g;
wire[7:0] pattern_rgb_b;
reg[3:0] mode;
wire button0_negedge;
wire clk_27m;
wire rst_n;
wire locked;

wire data_out_sel;
wire [7:0] gen_r, gen_g, gen_b;
wire gen_hsync, gen_vsync, gen_de;

assign vout_clk = video_clk;
assign vout_hs = data_out_sel ? gen_hsync : pattern_hs;
assign vout_vs = data_out_sel ? gen_vsync : pattern_vs;
assign vout_de = data_out_sel ? gen_de :  pattern_de;
assign vout_data = data_out_sel ? {gen_r,gen_g,gen_b}   : {pattern_rgb_r,pattern_rgb_g,pattern_rgb_b};
assign rst_n = locked;
assign hdmi_nreset = locked;
sys_pll sys_pll_i
 (
	// Clock in ports
	.clk_in1_p(sys_clk_p),
	.clk_in1_n(sys_clk_n),
	// Clock out ports
	.clk_out1(clk_27m),
	.clk_out2(video_clk),
	// Status and control signals
	.reset(1'b0),
	.locked(locked)
 );
 wire i2c_err, i2c_done;
i2c_config i2c_config_m0(
	.rst(!rst_n),
	.clk(clk_27m),
	
	.error(i2c_err),
	.done(i2c_done),
	
	.i2c_scl(hdmi_scl),
	.i2c_sda(hdmi_sda)
);

	
color_bar color_bar_m0(
	.clk                        (video_clk                 ),
	.rst                        (~rst_n                    ),
	.hs                         (pattern_hs                ),
	.vs                         (pattern_vs                ),
	.de                         (pattern_de                ),
	.rgb_r                      (pattern_rgb_r             ),
	.rgb_g                      (pattern_rgb_g             ),
	.rgb_b                      (pattern_rgb_b             )
);
wire [7:0] probe_in0, probe_out0;
assign probe_in0 = {6'h0,i2c_err,i2c_done};
assign data_out_sel = probe_out0[0];
vio_0 u_vio (
  .clk(clk_27m),                // input wire clk
  .probe_in0(probe_in0),    // input wire [7 : 0] probe_in0
  .probe_out0(probe_out0)  // output wire [7 : 0] probe_out0
);

reg [22:0] led_cnt;
always@(posedge clk_27m) begin
		if (!locked) 
			led_cnt <= 23'd0;
		else
			led_cnt <= led_cnt + 1'b1;
	end
assign led[0] = ~locked;
assign led[1] = led_cnt[22];
assign led[3:2] = 2'b11;

wire [7:0] R,G,B;
wire [15:0] h_index,v_index;
wire data_request;
hdmi_seq_gen_wrapper u_hdmi_seq_gen_wrapper(
		.pixel_clk			(video_clk),
		.async_rstn         (locked),
		.frame_start        (1'b1),
		.frame_stop         (1'b0),
		.R                  (R),
		.G                  (G),
		.B                  (B),
		.R_o                (gen_r),
		.G_o                (gen_g),
		.B_o                (gen_b),
		.vsync              (gen_vsyn),
		.hsync              (gen_hsync),
		.pixel_d_active     (gen_de),
		.h_index            (h_index),
		.v_index            (v_index),
		.data_request       (data_request)
    );
	
	display_test_gen u_display_test_gen(
		.h_index(h_index),	// 16b
		.v_index(v_index),	// 16b
		.data_request(data_request),
		.R(R),			// 8b
		.G(G),			// 8b
		.B(B)			// 8b
	);
	
endmodule 