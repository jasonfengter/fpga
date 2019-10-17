module start_line_search (
	i_clk,
	i_rstn,
	i_trig,
	o_done,
	
	// Input start row #
	i_start_row_num,		// 9b
	
	// BRAM rd data/ctrl bus
	o_rd_from_bram_addr,	// 13b
	i_rd_from_bram_data,	// 32b
	o_rd_from_bram_trig,
	i_rd_from_bram_done,
	
	// BRAM wr data/ctrl bus
	o_wr_to_bram_addr,		// 13b
	o_wr_to_bram_data,		// 32b
	o_wr_to_bram_trig,
	i_wr_to_bram_done,

	// Output 512b mask data
	o_512b_mask				//512b
);

	input 			i_clk,
	input 			i_rstn,
	input 			i_trig,
	output 			o_done,
	
	// Input start row #
	input [8:0] 	i_start_row_num,		// 9b
	
	// BRAM rd data/ctrl bus
	output [12:0] 	o_rd_from_bram_addr,	// 13b
	input [31:0] 	i_rd_from_bram_data,	// 32b
	output 			o_rd_from_bram_trig,
	input 			i_rd_from_bram_done,

	// Output 512b mask data
	output reg [511:0] 	o_512b_mask				//512b
	
	
	reg r_i_trig_u_512b_rd;
	wire w_o_done_u_512b_rd;
	wire [511:0] w_o_rd_data_512b_u_512b_rd;
	// 512b rd controller IP
	rd_512b_from_bram u_512b_rd(
		.i_clk(i_clk),
		.i_rstn(i_rstn),
		.i_trig(r_i_trig_u_512b_rd),
		.o_done(w_o_done_u_512b_rd),
		.i_rd_row_num(i_start_row_num), // 0-511(), 9bit
		.o_rd_data_512b(w_o_rd_data_512b_u_512b_rd), //512bit
		// Below to TOP BRAM rd controller
		.o_rd_from_bram_addr(o_rd_from_bram_addr), //13bit
		.i_rd_from_bram_data(i_rd_from_bram_data), //32bit
		.o_rd_from_bram_trig(o_rd_from_bram_trig),
		.i_rd_from_bram_done(i_rd_from_bram_done)

    );
	
	// 512b mask gen IP
	reg 			r_i_trig_u_512b_mask_gen
	reg [8:0] 		r_i_bound_index_left_u_512b_mask_gen;
	reg [8:0] 		r_i_bound_index_right_u_512b_mask_gen
	wire 			w_o_done_u_512b_mask_gen;
	wire [511:0]	w_o_mask_u_512b_mask_gen;
	mask_gen_512bit_wrapper u_512b_mask_gen(
		.i_clk(i_clk),
		.i_rstn(i_rstn),
		.i_trig(r_i_trig_u_512b_mask_gen),
		.i_bound_index_left(r_i_bound_index_left_u_512b_mask_gen),		//9bit
		.i_bound_index_right(r_i_bound_index_right_u_512b_mask_gen),	//9bit(), this number is 0-511(), the index# from MSB to LSB of 512b data
		.o_done(w_o_done_u_512b_mask_gen),
		.o_mask(w_o_mask_u_512b_mask_gen)					//512bit
	);
	
	reg			r_i_trig_u_512b_wr;
	wire 		w_o_done_u_512b_wr;
	reg [8:0] 	r_i_wr_row_num_u_512b_wr;
	reg [511:0] r_i_wr_data_512b_u_512b_wr;
		
	// 512b wr IP
	wr_512b_to_bram u_512b_wr(
		.i_clk(i_clk),
		.i_rstn(i_rstn),
		.i_trig(r_i_trig_u_512b_wr),
		.o_done(w_o_done_u_512b_wr),
		.i_wr_row_num(r_i_wr_row_num_u_512b_wr), //  9bit
		.i_wr_data_512b(r_i_wr_data_512b_u_512b_wr), //512bit
		//Below signal are connected to TOP BRAM wr controller
		.o_wr_to_bram_addr(o_wr_to_bram_addr), //13bit
		.o_wr_to_bram_data(o_wr_to_bram_data), //32bit
		.o_wr_to_bram_trig(o_wr_to_bram_trig),
		.i_wr_to_bram_done(i_wr_to_bram_done)
	);


	reg [3:0] sm_state;
	localparam 
				IDLE=0,
				LOAD_512B=1,
				SEARCH_LEFT_BOUND=2,
				SEARCH_RIGHT_BOUND=3,
				MASK_GEN=4,
				WRITE_BACK=5,
				DONE=15;
	// GUIDELINE: o_done must be pull-down when i_trig is down!!!
	reg o_done_pre;
	assign o_done = o_done_pre & i_trig;
	
	reg [511:0] r_512b_data_latch;
	wire [9:0] w_10b_slide_window;
	assign w_10b_slide_window = r_512b_data_latch[511:502];
	
	wire [2:0] w_o_num_of_one;
	return_num_of_one u_get_num_of_one(
		.i_5b_data(w_10b_slide_window[4:0]),
		.o_num_of_one(w_o_num_of_one)

	);
	
	reg [8:0] col_cnter,LB,RB;
	reg LBF,RBF;
	
	always@(posedge i_clk or negedge i_rstn) begin
		if(i_rstn==1'b0)
			begin
				o_done_pre<=1'b0;
				sm_state<=IDLE;
				// Reset 512b rd IP
				r_i_trig_u_512b_rd<=1'b0;
				// Reset module output 
				o_512b_mask <= 511'd0;
				// Reset boundary flag and pointer
				col_cnter<=9'd0; LB<=9'd0; RB<=9'd0;
				LBF<=1'b0; RBF<=1'b0;
				// Reset 512b mask gen IP
				r_i_trig_u_512b_mask_gen<=1'b0;
				r_i_bound_index_left_u_512b_mask_gen<=9'd0;
				r_i_bound_index_right_u_512b_mask_gen<=9'd0;
			end
		else
			begin
				case(sm_state)
					IDLE:
					// GUIDELINE
					// (1) in IDLE, module o_done signal should be reset but o_data should not be touched!!
					// (2) in IDLE, IP under control should pull-down trig signal
						begin
							// Reset 512b latch
							r_512b_data_latch<=512'd0;
							// Reset 512b rd IP
							r_i_trig_u_512b_rd<=1'b0;
							// Reset module o_done
							o_done_pre<=1'b0;
							// Reset boundary flag and pointer
							col_cnter<=9'd0; LB<=9'd0; RB<=9'd0;
							LBF<=1'b0; RBF<=1'b0;
							// Reset 512b mask gen IP
							r_i_trig_u_512b_mask_gen<=1'b0;
							r_i_bound_index_left_u_512b_mask_gen<=9'd0;
							r_i_bound_index_right_u_512b_mask_gen<=9'd0;
							// When i_trig up, goto next state
							if(i_trig==1'b1) begin
								sm_state<=LOAD_512B;
							end
						end
					LOAD_512B:
						begin
							// Setup 512b_rd IP (row# to read is already setup by input wire)
							r_i_trig_u_512b_rd<=1'b1;
							
							// Wait till done signal
							if(w_o_done_u_512b_rd==1'b1) begin  //GUIDELINE: after IP o_done asserted, should deactivate IP i_trig
								r_i_trig_u_512b_rd<=1'b0;  // Reset 512b rd IP
								// Latch output
								r_512b_data_latch <= w_o_rd_data_512b_u_512b_rd;
								// Reset boundary flag and pointer
								col_cnter<=9'd5; // This is because initially the mid point of 10b_window is bit#5
								LB<=9'd0; RB<=9'd0;
								LBF<=1'b0; RBF<=1'b0;
								sm_state<=SEARCH_LEFT_BOUND;
							end
						end
					SEARCH_LEFT_BOUND:
						begin
							// If 10b_window[4:0] = 5'd0 for 1st time, then LBF=1, LB=col_cnter
							if (LBF==1'b0) begin
								if (w_10b_slide_window[4:0]=5'd0) begin
									LBF<=1'b1; LB<=col_cnter;
									sm_state<=SEARCH_RIGHT_BOUND;
								end
							end
							// No matter what window happens, LEFT shift 'r_512b_data_latch'
							r_512b_data_latch <= {r_512b_data_latch[510:0],1'b0};
							col_cnter<=col_cnter+1'd1;
						end
					SEARCH_RIGHT_BOUND:
						begin
							// If 10b_window[9:5] = 5'd0 and [4:0] has logic '1' count >=3 for 1st time, then RBF=1, RB=col_cnter
							if (RBF==1'b0) begin
								if (w_10b_slide_window[9:5]=5'd0 && (w_o_num_of_one==3'd3 || w_o_num_of_one==3'd4 || w_o_num_of_one==3'd5)) begin
									RBF<=1'b1; RB<=col_cnter;
									sm_state<=MASK_GEN;
								end
							end
							// No matter what window happens, LEFT shift 'r_512b_data_latch'
							r_512b_data_latch <= {r_512b_data_latch[510:0],1'b0};
							col_cnter<=col_cnter+1'd1;
						end
					MASK_GEN:
						begin
							// If LBF/RBF=1, then generate 512b mask with LB, RB
							//reg 				r_i_trig_u_512b_mask_gen
							//reg [8:0] 		r_i_bound_index_left_u_512b_mask_gen;
							//reg [8:0] 		r_i_bound_index_right_u_512b_mask_gen
							if(LBF==1'b1 && RBF==1'b1) begin
								// Setup 512b mask gen IP
								r_i_bound_index_left_u_512b_mask_gen<=LB;
								r_i_bound_index_right_u_512b_mask_gen<=RB;
								r_i_trig_u_512b_mask_gen<=1'b1;
							
								// Wait till mask IP done
								if (w_o_done_u_512b_mask_gen==1'b1) begin
									r_i_trig_u_512b_mask_gen<=1'b0; // Pull-down IP trig
									sm_state<=WRITE_BACK;
								end
								end
							else 
								begin
									// TODO: If LBF or RBF not found, goto Error handler
									sm_state<=DONE;
									
								end
						end
					WRITE_BACK:
						begin
							//reg			r_i_trig_u_512b_wr;
							//wire 		w_o_done_u_512b_wr;
							//reg [8:0] 	r_i_wr_row_num_u_512b_wr;
							//reg [511:0] r_i_wr_data_512b_u_512b_wr;
							// Setup 512b wr IP
							r_i_wr_row_num_u_512b_wr <= i_start_row_num;
							r_i_wr_data_512b_u_512b_wr<=w_o_mask_u_512b_mask_gen;  // Mask is in fact the best filtered data
							r_i_trig_u_512b_wr<=1'b1;
							
							// Wait till IP o_done
							if(w_o_done_u_512b_mask_gen==1'b1) begin
								// Pull-down 512b wr IP trig
								r_i_trig_u_512b_wr<=1'b0;
								sm_state<=DONE;
							end
						end
					DONE:
						begin
							o_done_pre<=1'b1;
							if(i_trig==1'b0) begin
								o_done_pre<=1'b0;
								sm_state<=IDLE;
							end
						end
					default:
					
				endcase
			end
	end

endmodule

module return_num_of_one (
	i_5b_data,
	o_num_of_one

);
	input [4:0] i_5b_data;
	output [2:0] o_num_of_one;
	
	always@(*) begin
		case (i_5b_data)
			5'b11111: o_num_of_one=5;
			5'b01111,5'b10111,5'b11011,5'b11101,5'b11110: o_num_of_one=4;
			5'b10011,5'b11001,5'b11100,5'b10101,5'b10110,5'b11010: o_num_of_one=3;
			default: o_num_of_one=0; // 0 here is no-meaningful, just a return for not being qualified.
		
		endcase
	end

endmodule
