module mask_gen_512bit (
	i_clk,
	i_rstn,
	i_trig,
	i_left_or_right,	// shift in from left or right hand side
	i_bound_index,  //9bit, MSB-shift_in 256bit-one, LSB-shift_in 1bit-one
	o_done,
	o_mask	//512bit

);

	input i_clk;
	input i_rstn;
	input i_trig;
	input i_left_or_right; // 0=left, 1=right
	input [8:0] i_bound_index;
	output  o_done;
	output [511:0] o_mask;
	
	
	
	
	

	reg [8:0] i_bound_index_latch;
	reg [511:0] o_mask_pre;
	
	// State machine definition
	reg [4:0] sm_state;
	localparam	IDLE=0,
				LEFT1=1,
				LEFT2=2,
				LEFT3=3,
				LEFT4=4,
				LEFT5=5,
				LEFT6=6,
				LEFT7=7,
				LEFT8=8,
				LEFT9=9,

				RIGHT1=10,
				RIGHT2=11,
				RIGHT3=12,
                RIGHT4=13,
                RIGHT5=14,
				RIGHT6=15,
				RIGHT7=16,
				RIGHT8=17,
                RIGHT9=18,

				DONE	=19;
	// GUIDELINE: o_done must be pull-down when i_trig is down!!!
	assign o_done = (sm_state == DONE) & i_trig;
				
	// State machine transition
	always@(posedge i_clk or negedge i_rstn) begin
		if (i_rstn == 1'b0)
			sm_state <= IDLE;
		else
			begin
				case (sm_state)
					IDLE:
						// GUIDELINE
						// (1) in IDLE, done signal to be reset but o_data should not be touched!!
						// (2) in IDLE, IP under control should pull-down trig signal
						begin
							if (i_trig == 1'b1)
								sm_state <= (i_left_or_right == 1'b0)? LEFT1 : RIGHT1;
							else
								sm_state <= IDLE;
						end
					LEFT1:
						sm_state <= LEFT2;
					LEFT2:
						sm_state <= LEFT3;
					LEFT3:
						sm_state <= LEFT4;
					LEFT4:
						sm_state <= LEFT5;
					LEFT5:
						sm_state <= LEFT6;
					LEFT6:
						sm_state <= LEFT7;
					LEFT7:
						sm_state <= LEFT8;
					LEFT8:
						sm_state <= LEFT9;
					LEFT9:
						sm_state <= DONE;
					RIGHT1:
						sm_state <= RIGHT2;
					RIGHT2:
						sm_state <= RIGHT3;
					RIGHT3:
						sm_state <= RIGHT4;
					RIGHT4:
						sm_state <= RIGHT5;
					RIGHT5:
						sm_state <= RIGHT6;
					RIGHT6:
						sm_state <= RIGHT7;
					RIGHT7:
						sm_state <= RIGHT8;
					RIGHT8:
						sm_state <= RIGHT9;
					RIGHT9:
						sm_state <= DONE;
					DONE:
						begin
							sm_state <= (i_trig == 1'b0)? IDLE : DONE;
						end
					default:
						sm_state <= IDLE;
				endcase
			end
	end
	
	// State machine output

	
	assign o_mask = (sm_state == DONE)? o_mask_pre : 512'h0;
	
	
	
	always@(posedge i_clk or negedge i_rstn) begin
		if(i_rstn == 1'b0)
			begin
				o_mask_pre <= 512'h0;
				i_bound_index_latch <= 9'h0;
			end
		else	
			begin
				case (sm_state)
					IDLE:
						// GUIDELINE
						// (1) in IDLE, done signal to be reset but o_data should not be touched!!
						// (2) in IDLE, IP under control should pull-down trig signal
						if (i_trig == 1'b1) begin
							i_bound_index_latch <= i_bound_index;
							o_mask_pre <= {512{1'b0}};
						end
					LEFT1:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index_latch[8]==1'b1)
								o_mask_pre <= {{256{1'b1}},o_mask_pre[511:256]};
						end
					LEFT2:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index_latch[8]==1'b1)
								o_mask_pre <= {{128{1'b1}},o_mask_pre[511:128]};
						end
					LEFT3:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index_latch[8]==1'b1)
								o_mask_pre <= {{64{1'b1}},o_mask_pre[511:64]};
						end
					LEFT4:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index_latch[8]==1'b1)
								o_mask_pre <= {{32{1'b1}},o_mask_pre[511:32]};
						end
					LEFT5:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index_latch[8]==1'b1)
								o_mask_pre <= {{16{1'b1}},o_mask_pre[511:16]};
						end
					LEFT6:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index_latch[8]==1'b1)
								o_mask_pre <= {{8{1'b1}},o_mask_pre[511:8]};
						end
					LEFT7:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index_latch[8]==1'b1)
								o_mask_pre <= {{4{1'b1}},o_mask_pre[511:4]};
						end
					LEFT8:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index_latch[8]==1'b1)
								o_mask_pre <= {{2{1'b1}},o_mask_pre[511:2]};
						end
					LEFT9:
						begin
							//i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index_latch[8]==1'b1)
								o_mask_pre <= {1'b1,o_mask_pre[511:1]};
						end
					RIGHT1:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index_latch[8]==1'b1)
								o_mask_pre <= {o_mask_pre[255:0],{256{1'b1}}};
						end
					RIGHT2:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index_latch[8]==1'b1)
								o_mask_pre <= {o_mask_pre[383:0],{128{1'b1}}};
						end
					RIGHT3:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index_latch[8]==1'b1)
								o_mask_pre <= {o_mask_pre[447:0],{64{1'b1}}};
						end
					RIGHT4:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index_latch[8]==1'b1)
								o_mask_pre <= {o_mask_pre[479:0],{32{1'b1}}};
						end
					RIGHT5:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index_latch[8]==1'b1)
								o_mask_pre <= {o_mask_pre[495:0],{16{1'b1}}};
						end	
					RIGHT6:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index_latch[8]==1'b1)
								o_mask_pre <= {o_mask_pre[503:0],{8{1'b1}}};
						end
					RIGHT7:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index_latch[8]==1'b1)
								o_mask_pre <= {o_mask_pre[507:0],{4{1'b1}}};
						end
					RIGHT8:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index_latch[8]==1'b1)
								o_mask_pre <= {o_mask_pre[509:0],{2{1'b1}}};
						end
					RIGHT9:
						begin
							//i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index_latch[8]==1'b1)
								o_mask_pre <= {o_mask_pre[510:0],1'b1};
						end	
					DONE:  // DONE included
						begin
							o_mask_pre <= o_mask_pre;
							//i_bound_index_latch <= i_bound_index_latch;
						end
					default:
						begin
							o_mask_pre <= 512'h0;
							i_bound_index_latch <= 9'h0;
						end
				endcase
			end
		
	end
	
	
endmodule