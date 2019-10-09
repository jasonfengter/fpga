module mask_gen_512bit_wrapper (
	i_clk,
	i_rstn,
	i_trig,
	i_bound_index_left,		//9bit
	i_bound_index_right,	//9bit
	o_done,
	o_mask					//512bit
);

	input i_clk;
	input i_rstn;
	input i_trig;
	input [8:0] i_bound_index_left;
	input [8:0] i_bound_index_right;
	output o_done;
	output [511:0] o_mask;
	
	wire o_done_left;
	wire o_done_right;
	wire [511:0] o_mask_left;
	wire [511:0] o_mask_right;
	
	assign o_done = o_done_left & o_done_right;
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
		.i_bound_index		(i_bound_index_right),  //9bit, MSB-shift_in 256bit-one, LSB-shift_in 1bit-one
		.o_done				(o_done_right),
		.o_mask				(o_mask_right)	//512bit

	);

endmodule