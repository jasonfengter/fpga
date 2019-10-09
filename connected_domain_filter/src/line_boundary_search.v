


module line_boundary_search(

    );
	
	mask_gen_32bit u_mask_gen_32bit(
		.i_clk				(),
		.i_rstn				(),
		.i_trig				(),
		.i_left_or_right	(),
		.i_bound_index		(),
		.o_done				(),
		.o_mask				()

	);
	
	
	convert_pixel_xy_to_bram_addr u_convert_pixel_xy_to_bram_addr(
		.i_clk				(),
		.i_rstn				(),
		.i_trigger			(),
		.i_pixel_row_num	(),
		.i_pixel_col_num	(),
		.o_bram_addr		(),
		.o_bram_addr_valid	()

	);
	
	rd_32b_from_bram u_rd_32b_from_bram(
		.i_clk					(),
		.i_rstn					(),
		.i_rd_trig				(),  // read transaction signal 
		.i_rd_addr				(),
		.o_rd_data				(),
		.o_rd_ack				(),	// read transaction signal  END
		.o_bram_access_type		(),	// to top bram read controller 0=512bit, 1=32bit
		.o_bram_rd_addr			(),		// bram direct read addr
		.o_bram_rd_addr_ready	(),	// handshake ready signal
		.i_bram_data_valid		(),	// handshake valid signal
		.i_bram_data			()
		
	);	
	
	wr_32b_to_bram u_wr_32b_to_bram(
	
		.i_trig			(),
		.i_data_mask	(), //32bit
		.i_orig_data	(), //32bit
		.i_wr_bram_addr	(), //13bit
		.o_done			(),
		.o_wr_bram_addr	(), //13bit
		.o_wr_bram_data	(), //32bit
		.o_wr_bram_trig	(),
		.i_wr_bram_ack	()
		
	
	);
	
detect_bound_in_32bit_wrapper u_detect_bound_in_32bit_wrapper(
	.i_clk									,
	.i_rstn									,
	.i_trig									,
	.i_32bit_raw_data						,
	.i_left_or_right						,
	.i_bram_addr_for_32bit_raw_data			,
	.o_bram_addr_for_32bit_raw_data_buf		,
	.o_bound_index							,
	.o_is_bound_detected,
	.o_done

);	
endmodule
