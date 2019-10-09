module detect_bound_in_32bit_wrapper (
	i_clk,
	i_rstn,
	i_trig,
	i_32bit_raw_data,
	i_left_or_right,
	i_bram_addr_for_32bit_raw_data,
	o_bram_addr_for_32bit_raw_data_buf,
	o_bound_index,
	o_is_bound_detected,
	o_done

);
	input i_clk;
	input i_rstn;
	input i_trig;
	input [31:0] i_32bit_raw_data;
	input i_left_or_right;
	input [12:0] i_bram_addr_for_32bit_raw_data;
	output [12:0] o_bram_addr_for_32bit_raw_data_buf;
	output [4:0] o_bound_index;
	output o_is_bound_detected;
	output o_done;
	


	detect_bound_in_32bit u_detect_bound_in_32bit(
		.i_clk					(i_clk),
		.i_rstn					(i_rstn),			
		.i_trig					(i_trig),
		.i_32bit_raw_data		(i_32bit_raw_data),
		.i_left_or_right		(i_left_or_right),
		.o_bound_index			(o_bound_index),
		.o_is_bound_detected	(o_is_bound_detected),
		.o_done					(o_done)
	
	);
	
	assign o_bram_addr_for_32bit_raw_data_buf = (i_trig == 1'b1)? i_bram_addr_for_32bit_raw_data : 13'h0;



endmodule