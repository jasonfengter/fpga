


module boundary_search(
	
	i_clk,
	i_rstn,
	i_trig,
	o_done,
	i_MAX_INTERVAL,	//4bit
	// to TOP BRAM rd controller ctrl bus
	u_rd_512b_from_bram_o_rd_from_bram_addr,
	u_rd_512b_from_bram_i_rd_from_bram_data,
	u_rd_512b_from_bram_o_rd_from_bram_trig,
	u_rd_512b_from_bram_i_rd_from_bram_done,
	
	row_num_to_start,	// 9bit
	
	// to TOP BRAM wr controller ctrl bus 
	u_wr_512b_to_bram_o_wr_to_bram_addr,
	u_wr_512b_to_bram_o_wr_to_bram_data,
	u_wr_512b_to_bram_o_wr_to_bram_trig,
	u_wr_512b_to_bram_i_wr_to_bram_done
	
	
	
    );
	
	input 		i_clk;
	input 		i_rstn;
	input 		i_trig;
	input [3:0] i_MAX_INTERVAL;
	output  	o_done;
	
	output [12:0]		u_rd_512b_from_bram_o_rd_from_bram_addr;
	input  [31:0]		u_rd_512b_from_bram_i_rd_from_bram_data;
	output 				u_rd_512b_from_bram_o_rd_from_bram_trig;
	input 				u_rd_512b_from_bram_i_rd_from_bram_done;
	
	input [8:0] row_num_to_start;
	
	output [12:0] 	u_wr_512b_to_bram_o_wr_to_bram_addr;
	output [31:0] 	u_wr_512b_to_bram_o_wr_to_bram_data;
	output  		u_wr_512b_to_bram_o_wr_to_bram_trig;
	input 			u_wr_512b_to_bram_i_wr_to_bram_done;
	
	
	
	
	wire [511:0] 	o_1st_row_512b_int, o_2nd_row_512b_int;
	reg [511:0] 	row_1st_latch, row_2nd_latch;
	wire [511:0] 	row_1st_latch_int, row_2nd_latch_int;
	reg 			i_trig_rd_int;
	//reg 			i_trig_shift_int;
	wire 			o_done_dual_row_module;
	reg [8:0] 		i_row_num_to_read_int;
	reg [8:0] 		i_row_num_init_int;
	reg 			i_init_en_int;
	
	assign 		row_1st_latch_int=row_1st_latch;
	assign 		row_2nd_latch_int=row_2nd_latch;
	
	
	dual_row_shift u_dual_row_shift(
		.i_clk										(i_clk),
		.i_rstn										(i_rstn),
		.i_trig_rd									(i_trig_rd_int),
		//.i_trig_shift								(i_trig_shift_int),
		.o_done										(o_done_dual_row_module),
		.i_row_num_to_read							(i_row_num_to_read_int),	//9bit
		.i_row_num_to_initial_setup					(i_row_num_init_int),		//9bit
		.i_init_en									(i_init_en_int),			
		.o_1st_row_512b								(o_1st_row_512b_int),		//512bit
		.o_2nd_row_512b								(o_2nd_row_512b_int),		//512bit
		.u_rd_512b_from_bram_o_rd_from_bram_addr	(u_rd_512b_from_bram_o_rd_from_bram_addr),
		.u_rd_512b_from_bram_i_rd_from_bram_data	(u_rd_512b_from_bram_i_rd_from_bram_data),
		.u_rd_512b_from_bram_o_rd_from_bram_trig	(u_rd_512b_from_bram_o_rd_from_bram_trig),
		.u_rd_512b_from_bram_i_rd_from_bram_done	(u_rd_512b_from_bram_i_rd_from_bram_done)
    );
	
	reg 		u_wr_512b_to_bram_i_trig;
	wire 		u_wr_512b_to_bram_o_done;
	reg [8:0]   u_wr_512b_to_bram_i_wr_row_num	;	
	reg [511:0] u_wr_512b_to_bram_i_wr_data_512b;
	wr_512b_to_bram u_wr_512b_to_bram(
		.i_clk				(i_clk),
		.i_rstn				(i_rstn),
		.i_trig				(u_wr_512b_to_bram_i_trig),
		.o_done				(u_wr_512b_to_bram_o_done),
		.i_wr_row_num		(u_wr_512b_to_bram_i_wr_row_num), // 0-511, 9bit
		.i_wr_data_512b		(u_wr_512b_to_bram_i_wr_data_512b), //512bit
		.o_wr_to_bram_addr	(u_wr_512b_to_bram_o_wr_to_bram_addr), //13bit
		.o_wr_to_bram_data	(u_wr_512b_to_bram_o_wr_to_bram_data), //32bit
		.o_wr_to_bram_trig	(u_wr_512b_to_bram_o_wr_to_bram_trig),
		.i_wr_to_bram_done	(u_wr_512b_to_bram_i_wr_to_bram_done)
	);
	
	
	wire [5:0] o_block_int;
	retrieve_block u_retrieve_block(
		.i_1st_row_512bit	(row_1st_latch_int),
		.i_2nd_row_512bit	(row_2nd_latch_int),
		.o_block			(o_block_int)
    );
	wire to_hard_connect_hit;
	to_hard_connect u_to_hard_connect(
		.i_block	(o_block_int),
		.o_is_a_hit	(to_hard_connect_hit)
    );
	wire detecting_to_start_hit;
	detecting_to_start u_detecting_to_start(
		.i_block(o_block_int),
		.o_is_a_hit(detecting_to_start_hit)
    );
	wire start_to_connect_hit;
	start_to_connect u_start_to_connect(
		.i_block(o_block_int),
		.o_is_a_hit(start_to_connect_hit)
    );
	wire to_pre_disconnect_hit;
	to_pre_disconnect u_to_pre_disconnect(
		.i_block(o_block_int),
		.o_is_a_hit(to_pre_disconnect_hit)
    );
	wire pre_disconnect_to_connect_hit;
	pre_disconnect_to_connect u_pre_disconnect_to_connect(
		.i_block(o_block_int),
		.o_is_a_hit(pre_disconnect_to_connect_hit)
    );
	wire pre_disconnect_to_self_hit;
	pre_disconnect_to_self u_pre_disconnect_to_self(
		.i_block(o_block_int),
		.o_is_a_hit(pre_disconnect_to_self_hit)
    );
	wire hard_pre_disconnect_to_self_hit;
	hard_pre_disconnect_to_self u_hard_pre_disconnect_to_self(
		.i_block(o_block_int),
		.o_is_a_hit(hard_pre_disconnect_to_self_hit)
    );
	wire hard_connect_to_pre_disconnect_hit;
	hard_connect_to_pre_disconnect u_hard_connect_to_pre_disconnect(
		.i_block(o_block_int),
		.o_is_a_hit(hard_connect_to_pre_disconnect_hit)
    );
	wire hard_pre_disconnect_to_connect_hit;
	hard_pre_disconnect_to_connect u_hard_pre_disconnect_to_connect(
		.i_block(o_block_int),
		.o_is_a_hit(hard_pre_disconnect_to_connect_hit)
    );
	
	

	
	
	
	
	reg 		u_mask_gen_512bit_wrapper_i_trig;
	reg [8:0] 	u_mask_gen_512bit_wrapper_i_bound_index_left	;
	reg [8:0] 	u_mask_gen_512bit_wrapper_i_bound_index_right;
	wire 		u_mask_gen_512bit_wrapper_o_done;
	wire [511:0]		u_mask_gen_512bit_wrapper_o_mask;
	mask_gen_512bit_wrapper u_mask_gen_512bit_wrapper(
		.i_clk					(i_clk),
		.i_rstn					(i_rstn),
		.i_trig					(u_mask_gen_512bit_wrapper_i_trig),
		.i_bound_index_left		(u_mask_gen_512bit_wrapper_i_bound_index_left),		//9bit
		.i_bound_index_right	(u_mask_gen_512bit_wrapper_i_bound_index_right),	//9bit
		.o_done					(u_mask_gen_512bit_wrapper_o_done),
		.o_mask					(u_mask_gen_512bit_wrapper_o_mask)				//512bit
	);


	
	reg [3:0] line_sm_state;
	localparam	IDLE=0,
				INIT_BOTTOM=1,
				SEARCH_BOTTOM=2,
				SEARCH_BOTTOM_LOAD=3,
				DONE=15;
				
	
	
	reg col_search_trig;
	wire col_search_done;
	
	// GUIDELINE: o_done must be pull-down when i_trig is down!!!
	reg o_done_pre;
	assign o_done = o_done_pre & i_trig;
	
	always@(posedge i_clk or negedge i_rstn) begin
		if (i_rstn==1'b0)
			begin
				line_sm_state <= IDLE;
				o_done_pre <= 1'b0;
				//col search state-machine
				col_search_trig <= 1'b0;
				//col_search_done <= 1'b0;
				
				//dual shift module control signals
				i_init_en_int 			<= 1'b0;
				i_trig_rd_int 			<= 1'b0;
				//i_trig_shift_int 		<= 1'b0;
				i_row_num_init_int 		<= 9'd0;
				i_row_num_to_read_int 	<= 9'd0;
			end
		else
			begin
				case (line_sm_state)
					IDLE:
					// GUIDELINE
					// (1) in IDLE, module o_done signal should be reset but o_data should not be touched!!
					// (2) in IDLE, IP under control should pull-down trig signal
						begin
							// Reset dual-row-shift module
							i_init_en_int 			<= 1'b0;
							i_trig_rd_int 			<= 1'b0;
							//i_trig_shift_int 		<= 1'b0;
							
							col_search_trig 		<= 1'b0;  // IP trig pull-down
							o_done_pre 				<= 1'b0;  // Module o_done down
							
							//reset 512b data
							// row_1st_latch <= 512'd0;
							// row_2nd_latch <= 512'd0;
							if (i_trig==1'b1) begin
								line_sm_state <= INIT_BOTTOM;
							end
						end
					INIT_BOTTOM:
						begin
							// Setup dual-row-shift module
							i_init_en_int <= 1'b1;
							i_trig_rd_int <= 1'b1;
							i_row_num_init_int <= row_num_to_start;
							i_row_num_to_read_int <= row_num_to_start + 1'b1;
							
							//GUIDELINE: after IP o_done asserted, should deactivate IP i_trig
							if (o_done_dual_row_module==1'b1) begin
								line_sm_state <= SEARCH_BOTTOM;
								// Reset dual-row-shift module
								i_init_en_int <= 1'b0;
								i_trig_rd_int <= 1'b0;
								
								//latch 512b data
								// row_1st_latch <= o_1st_row_512b_int;
								// row_2nd_latch <= o_2nd_row_512b_int;
							end
						end
					SEARCH_BOTTOM:
						begin //GUIDELINE: after IP o_done asserted, should deactivate IP i_trig
							col_search_trig <= 1'b1;
							if (col_search_done==1'b1) begin
								col_search_trig <= 1'b0;
								if (i_row_num_to_read_int==9'd511) 
									begin
										line_sm_state <= DONE;
									end
								else
									begin
										// Setup dual-row-shift module
										i_init_en_int <= 1'b0;
										i_trig_rd_int <= 1'b1;
										i_row_num_init_int <= 9'd0;
										i_row_num_to_read_int <= i_row_num_to_read_int + 1'b1;
										
										line_sm_state <= SEARCH_BOTTOM_LOAD;
									end
							end
						end
					SEARCH_BOTTOM_LOAD:
						begin //GUIDELINE: after IP o_done asserted, should deactivate IP i_trig
							if (o_done_dual_row_module==1'b1) begin
								line_sm_state <= SEARCH_BOTTOM;
								// Setup dual-row-shift module
								i_init_en_int 			<= 1'b0;
								i_trig_rd_int 			<= 1'b0;
								//latch 512b data
								// row_1st_latch <= o_1st_row_512b_int;
								// row_2nd_latch <= o_2nd_row_512b_int;
							end
						end
					DONE:
						begin //GUIDELINE: after 'trig' down, DONE signal should be also down
							o_done_pre <= 1'b1;
							i_init_en_int 			<= 1'b0;
							i_trig_rd_int 			<= 1'b0;
							//i_trig_shift_int 		<= 1'b0;
							if (i_trig==1'b0) begin
								line_sm_state <= IDLE;
								o_done_pre <= 1'b0;
							end
						end
				endcase
			end
	end
	
	reg [3:0] col_sm_state;
	localparam	col_IDLE=0,
				bound_detecting=1,
				bound_start=2,
				bound_connect=3,
				bound_pre_disconnect=4,
				hard_connect=5,
				hard_pre_disconnect=6,
				col_WRITE_BACK_GEN_MASK=7,
				col_WRITE_BACK=8,
				col_DONE=15;
	reg LBF,RBF;
	reg [9:0] LB, RB;
	reg [9:0] col_cnter;
	reg [7:0] discontinuity_cnter;
	reg [7:0] hard_discontinuity_cnter;
	
	// GUIDELINE: o_done must be pull-down when i_trig is down!!!
	reg col_search_done_pre;
	assign col_search_done = col_search_done_pre & col_search_trig;
	
	always@(posedge i_clk or negedge i_rstn) begin
		if (i_rstn==1'b0) begin
				col_sm_state <= col_IDLE;
				LBF <= 1'b0;
				RBF <= 1'b0;
				LB <= 9'd0;
				RB <= 9'd0;
				col_cnter <= 9'd0;
				discontinuity_cnter<=8'd0;
				hard_discontinuity_cnter<=8'd0;
				col_search_done_pre <= 1'b0;
			end
		else
			begin
				case (col_sm_state)
					col_IDLE:
					// GUIDELINE
					// (1) in IDLE, done signal to be reset but o_data should not be touched!!
					// (2) in IDLE, IP under control should pull-down trig signal
						begin 
							LBF <= 1'b0;
							RBF <= 1'b0;
							LB <= 9'd0;
							RB <= 9'd0;
							col_cnter <= 9'd0;
							discontinuity_cnter<=8'd0;
							hard_discontinuity_cnter<=8'd0;
							
							col_search_done_pre <= 1'b0;
							
							if (col_search_trig==1'b1) begin
								// for the first time, latch 512b data from 512b_rd IP
								row_1st_latch <= o_1st_row_512b_int;
								row_2nd_latch <= o_2nd_row_512b_int;
								col_sm_state <= bound_detecting;
							end
						end
					bound_detecting:
						begin
							case ({to_hard_connect_hit,detecting_to_start_hit})
								2'b10:	begin col_sm_state <= hard_connect; LBF<=1'b1; LB<=(col_cnter+1'b1); end
								2'b01:	begin col_sm_state <= bound_start; LBF<=1'b1; LB<=(col_cnter+1'b1); end
								default: 
									begin
										col_sm_state <= bound_detecting;
										// Left rotate shift 512b data
										row_1st_latch <= {row_1st_latch[510:0], row_1st_latch[511]};
										row_2nd_latch <= {row_2nd_latch[510:0], row_2nd_latch[511]};
										col_cnter 	  <= (col_cnter + 1'b1) ;
									end
							endcase
								
						end
					bound_start:
						begin
							case ({to_hard_connect_hit,start_to_connect_hit,to_pre_disconnect_hit})
								3'b100: 
									begin   
										col_sm_state<=hard_connect;
										if (LBF == 1'b0) begin
											LBF <= 1'b1; LB <= (col_cnter+1'b1);
										end
									end
								3'b010: col_sm_state<=bound_connect;
								3'b001: begin col_sm_state<=bound_pre_disconnect; discontinuity_cnter <= 1'b1; end
								default: 
									begin 
										col_sm_state <=bound_start;
										// Left rotate shift 512b data
										row_1st_latch <= {row_1st_latch[510:0], row_1st_latch[511]} ;
										row_2nd_latch <= {row_2nd_latch[510:0], row_2nd_latch[511]} ;
										col_cnter 	  <= (col_cnter + 1'b1) ;
									
									end
							endcase
						end
					bound_connect:
						begin
							case  ( {to_hard_connect_hit,to_pre_disconnect_hit}  )
								2'b10:	
									begin
										col_sm_state <= hard_connect;
										if (LBF == 1'b0) begin
											LBF <= 1'b1; LB <= (col_cnter+1'b1);
										end
									end
								2'b01: begin col_sm_state<=bound_pre_disconnect; discontinuity_cnter <= 1'b1; end
								default: 
									begin
										col_sm_state <=bound_connect;
										// Left rotate shift 512b data
										row_1st_latch <= {row_1st_latch[510:0], row_1st_latch[511]} ;
										row_2nd_latch <= {row_2nd_latch[510:0], row_2nd_latch[511]} ;
										col_cnter 	  <= (col_cnter + 1'b1) ;
									end
							endcase
						end
					bound_pre_disconnect:
						begin
							case ({to_hard_connect_hit,pre_disconnect_to_connect_hit,pre_disconnect_to_self_hit})
								3'b100:
									begin
										col_sm_state <= hard_connect;
										if (LBF == 1'b0) begin
											LBF <= 1'b1; LB <= (col_cnter+1'b1);
										end
									end
								3'b010: begin col_sm_state<=bound_connect; discontinuity_cnter <= 1'b0; end
								3'b001: 
									begin
										discontinuity_cnter <= discontinuity_cnter + 1'b1;
										if (discontinuity_cnter < i_MAX_INTERVAL)
											col_sm_state <= bound_pre_disconnect;
										else begin
											col_sm_state = bound_detecting;
											LBF = 1'b0;
										end
									end
								default: 
									begin 
										col_sm_state <= bound_pre_disconnect;
										// Left rotate shift 512b data
										row_1st_latch <= {row_1st_latch[510:0], row_1st_latch[511]} ;
										row_2nd_latch <= {row_2nd_latch[510:0], row_2nd_latch[511]} ;
										col_cnter 	  <= (col_cnter + 1'b1) ;
									end
							endcase
						end
					hard_connect:
						begin
							if (hard_connect_to_pre_disconnect_hit==1'b1) begin
								hard_discontinuity_cnter <= 8'd1;
								col_sm_state<=hard_pre_disconnect;
							end
							else begin
								col_sm_state<=hard_connect;
								// Left rotate shift 512b data
								row_1st_latch <= {row_1st_latch[510:0], row_1st_latch[511]} ;
								row_2nd_latch <= {row_2nd_latch[510:0], row_2nd_latch[511]} ;
								col_cnter 	  <= (col_cnter + 1'b1) ;
							end
						end
					hard_pre_disconnect:
						begin
							case ({hard_pre_disconnect_to_connect_hit,hard_pre_disconnect_to_self_hit})
								2'b10: begin hard_discontinuity_cnter<=8'd0;  col_sm_state<=hard_connect; end
								2'b01: 
									begin
										hard_discontinuity_cnter<=hard_discontinuity_cnter+1'd1;
										if ( hard_discontinuity_cnter < i_MAX_INTERVAL)
											col_sm_state <= hard_pre_disconnect;
										else begin
											RBF <= 1'b1; RB <= (col_cnter - i_MAX_INTERVAL + 1); 
											//finish
											col_sm_state <= col_WRITE_BACK_GEN_MASK;
										end
									end
								default: 
									begin
										col_sm_state<=hard_pre_disconnect;
										// Left rotate shift 512b data
										row_1st_latch <= {row_1st_latch[510:0], row_1st_latch[511]} ;
										row_2nd_latch <= {row_2nd_latch[510:0], row_2nd_latch[511]} ;
										col_cnter 	  <= (col_cnter + 1'b1) ;
									end
							endcase
						end
					col_WRITE_BACK_GEN_MASK: // this is where filtered data 512b being written back to BRAM
						begin
							//TODO: a wrapper to apply orig latch 512b data with mask and then write back to BRAM
							//reg u_mask_gen_512bit_wrapper_i_trig;
							//reg [8:0] u_mask_gen_512bit_wrapper_i_bound_index_left	;
							//reg [8:0] u_mask_gen_512bit_wrapper_i_bound_index_right;
							//wire u_mask_gen_512bit_wrapper_o_done;
							//wire u_mask_gen_512bit_wrapper_o_mask;
							u_mask_gen_512bit_wrapper_i_bound_index_left <= (LBF==1'b1)?LB:9'd0;
							u_mask_gen_512bit_wrapper_i_bound_index_right <= (RBF==1'b1)? RB :9'd0;  //TODO: 511-RB can be converted to simpler version?
							u_mask_gen_512bit_wrapper_i_trig <= 1'b1;
							if (u_mask_gen_512bit_wrapper_o_done) begin
								col_sm_state <= col_WRITE_BACK;
								u_mask_gen_512bit_wrapper_i_trig <= 1'b0;
							end
						end
					col_WRITE_BACK:
						begin
							//reg u_wr_512b_to_bram_i_trig;
							//reg u_wr_512b_to_bram_o_done;
							//reg [8:0]   u_wr_512b_to_bram_i_wr_row_num	;	
							//reg [511:0] u_wr_512b_to_bram_i_wr_data_512b;
							//wire [12:0] u_wr_512b_to_bram_o_wr_to_bram_addr;
							//wire [31:0] u_wr_512b_to_bram_o_wr_to_bram_data;
							//wire  u_wr_512b_to_bram_o_wr_to_bram_trig;
							//input u_wr_512b_to_bram_i_wr_to_bram_done;
							//GUIDELINE: after DONE asserted, should deactivate 'trig' of IP under control
							
							//Setup wr_512b IP
							u_wr_512b_to_bram_i_trig <= 1'b1;
							u_wr_512b_to_bram_i_wr_row_num <= i_row_num_to_read_int;
							u_wr_512b_to_bram_i_wr_data_512b <= (o_2nd_row_512b_int | u_mask_gen_512bit_wrapper_o_mask) & u_mask_gen_512bit_wrapper_o_mask;
							if (u_wr_512b_to_bram_o_done==1'b1)
								begin
									col_sm_state<=col_DONE;
									u_wr_512b_to_bram_i_trig<=1'b0;
								end
						end
					col_DONE:
						//GUIDELINE: after 'trig' deactivated, DONE signal should be de-asserted
						begin
							col_search_done_pre <= 1'b1;
							if (col_search_trig==1'b0) begin
								col_sm_state<=col_IDLE;
								col_search_done_pre <= 1'b0;
							end
						end
				endcase
				//left rotate shift, no matter what happened
				
			end
		
	end
	
				
	
	
endmodule
