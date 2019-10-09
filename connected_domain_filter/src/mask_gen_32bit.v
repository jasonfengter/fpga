module mask_gen_32bit (
	i_clk,
	i_rstn,
	i_trig,
	i_left_or_right,
	i_bound_index,
	o_done,
	o_mask

);

	input i_clk;
	input i_rstn;
	input i_trig;
	input i_left_or_right; // 0=left, 1=right
	input [4:0] i_bound_index;
	output reg o_done;
	output reg [31:0] o_mask;
	

	reg [4:0] i_bound_index_latch;
	reg [31:0] o_mask_pre;
	
	// State machine definition
	reg [3:0] sm_state;
	localparam	IDLE=0,
				LEFT1=1,
				LEFT2=2,
				LEFT3=3,
				LEFT4=4,
				LEFT5=5,
				RIGHT1=7,
				RIGHT2=8,
				RIGHT3=9,
                RIGHT4=10,
                RIGHT5=11,
				DONE=12;
				
	// State machine transition
	always@(posedge i_clk or negedge i_rstn) begin
		if (i_rstn == 1'b0)
			sm_state <= IDLE;
		else
			begin
				case (sm_state)
					IDLE:
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

	
	always@(posedge i_clk or negedge i_rstn) begin
		if(i_rstn == 1'b0)
			o_mask <= 32'h0;
		else
			if (sm_state == DONE)
				o_mask <= o_mask_pre;
			else
				o_mask <= 32'h0;
	end
	
	always@(posedge i_clk or negedge i_rstn) begin
		if(i_rstn == 1'b0)
			o_done <= 1'b0;
		else
			o_done <= (sm_state == DONE)? 1'b1 : 1'b0;
	end
	
	always@(posedge i_clk or negedge i_rstn) begin
		if(i_rstn == 1'b0)
			begin
				o_mask_pre <= 32'h0;
				i_bound_index_latch <= 5'h0;
			end
		else	
			begin
				case (sm_state)
					IDLE:
						if (i_trig == 1'b1) begin
							i_bound_index_latch <= i_bound_index;
							o_mask_pre <= 32'h0;
						end
					LEFT1:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index[4]==1'b1)
								o_mask_pre <= {{16{1'b1}},o_mask_pre[31:16]};
						end
					LEFT2:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index[4]==1'b1)
								o_mask_pre <= {{8{1'b1}},o_mask_pre[31:8]};
						end
					LEFT3:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index[4]==1'b1)
								o_mask_pre <= {{4{1'b1}},o_mask_pre[31:4]};
						end
					LEFT4:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index[4]==1'b1)
								o_mask_pre <= {{2{1'b1}},o_mask_pre[31:2]};
						end
					LEFT5:
						begin
							//i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index[4]==1'b1)
								o_mask_pre <= {1'b1,o_mask_pre[31:1]};
						end
					RIGHT1:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index[4]==1'b1)
								o_mask_pre <= {o_mask_pre[15:0],{16{1'b1}}};
						end
					RIGHT2:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index[4]==1'b1)
								o_mask_pre <= {o_mask_pre[23:0],{8{1'b1}}};
						end
					RIGHT3:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index[4]==1'b1)
								o_mask_pre <= {o_mask_pre[27:0],{4{1'b1}}};
						end
					RIGHT4:
						begin
							i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index[4]==1'b1)
								o_mask_pre <= {o_mask_pre[29:0],{2{1'b1}}};
						end
					RIGHT5:
						begin
							//i_bound_index_latch <= i_bound_index_latch << 1;
							if (i_bound_index[4]==1'b1)
								o_mask_pre <= {o_mask_pre[30:0],1'b1};
						end	
					DONE:  // DONE included
						begin
							o_mask_pre <= o_mask_pre;
							i_bound_index_latch <= i_bound_index_latch;
						end
					default:
						begin
							o_mask_pre <= 32'h0;
							i_bound_index_latch <= 5'h0;
						end
				endcase
			end
		
	end
	
	
endmodule