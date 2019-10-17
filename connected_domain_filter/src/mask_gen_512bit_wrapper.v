module mask_gen_512bit_wrapper (
	i_clk,
	i_rstn,
	i_trig,
	i_bound_index_left,		//9bit
	i_bound_index_right,	//9bit, this number is 0-511, the index# from MSB to LSB of 512b data
	o_done,
	o_mask					//512bit
);

	input i_clk;
	input i_rstn;
	input i_trig;
	input [8:0] i_bound_index_left; // Valid range 1~510
	input [8:0] i_bound_index_right; // Valid range 1-510 (510 -> {511'h0,1'b1}), 
									 //both range# works more like bit index, MSB...LSB, 0/1/.../510/511 (0,511 invalid!!!)
	output o_done;
	output [511:0] o_mask;
	
	wire o_done_left;  
	wire o_done_right; 
	wire [511:0] o_mask_left;
	wire [511:0] o_mask_right;
	
	// GUIDELINE: o_done must be pull-down when i_trig is down!!!
	assign o_done = o_done_left & o_done_right & i_trig;
	assign o_mask = o_mask_left | o_mask_right;
	
	mask_gen_512bit u_left(
		.i_clk				(i_clk),
		.i_rstn				(i_rstn),
		.i_trig				(i_trig),
		.i_left_or_right	(1'b0),	// shift in from left or right hand side
		.i_bound_index		(i_bound_index_left),  //9bit, MSB-shift_in 256bit-one, LSB-shift_in 1bit-one
		.o_done				(o_done_left),
		.o_mask				(o_mask_left)	//512bit

	);
	
	
	
	mask_gen_512bit u_right(
		.i_clk				(i_clk),
		.i_rstn				(i_rstn),
		.i_trig				(i_trig),
		.i_left_or_right	(1'b1),	// shift in from left or right hand side
		.i_bound_index		(~i_bound_index_right),  // invert=511-i_bound_index_right;
		.o_done				(o_done_right),
		.o_mask				(o_mask_right)	//512bit

	);

endmodule