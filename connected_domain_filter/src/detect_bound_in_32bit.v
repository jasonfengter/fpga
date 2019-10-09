module detect_bound_in_32bit (
	i_clk,
	i_rstn,
	i_trig,
	i_32bit_raw_data,
	i_left_or_right,
	o_bound_index,
	o_is_bound_detected,
	o_done

);

	input i_clk;
	input i_rstn;
	input i_trig;
	input [31:0] i_32bit_raw_data;
	input i_left_or_right;			// 0-left, 1-right
	output reg [4:0] o_bound_index;
	output reg o_is_bound_detected;
	output reg o_done;

	// State machine definition
	reg [3:0] sm_state;
	localparam	IDLE		= 0,	
				IS_ALL_0	= 1,
				LEFT_BOUND	= 2,
				RIGHT_BOUND	= 3,
				DONE		= 4;
				
	// State machine transition
	reg [31:0] i_32bit_raw_data_latch;
	reg i_left_or_right_latch;
	reg [4:0] shift_cnter;
	always@(posedge i_clk or negedge i_rstn) begin
		if (i_rstn == 1'b0)
			begin
				sm_state <= IDLE;
				i_32bit_raw_data_latch <= 32'h0;
				i_left_or_right_latch <= 1'b0;
				shift_cnter <= 5'h0;
				o_is_bound_detected <= 1'b0;
				o_done <= 1'b0;
				o_bound_index <= 5'h0;
			end
		else
			begin
				case (sm_state)
					IDLE:
						begin
							if (i_trig == 1'b1)
								begin
									sm_state <= IS_ALL_0;
									i_32bit_raw_data_latch <= i_32bit_raw_data;
									i_left_or_right_latch <= i_left_or_right;
									o_is_bound_detected <= 1'b0;
								end
							else
								sm_state <= IDLE;
						end
					IS_ALL_0:
						begin
							if (i_32bit_raw_data_latch == 32'h0)
								begin
									sm_state <= DONE;
									o_is_bound_detected <= 1'b0;
									o_bound_index <= 5'd0;
								end
							else	
								begin
									sm_state <= (i_left_or_right_latch == 1'b0)? LEFT_BOUND : RIGHT_BOUND;
									shift_cnter <= 5'h0;
								end
						end
					LEFT_BOUND:
						begin
							if (i_32bit_raw_data_latch[0] == 1'b1)
								begin
									if (shift_cnter == 5'd0) // this is error handler
										begin
											sm_state <= LEFT_BOUND;
											shift_cnter <= shift_cnter + 5'd1;
											i_32bit_raw_data_latch <= {1'b1,i_32bit_raw_data_latch[31:1]}; // right shift
										end
									else
										begin
											sm_state <= DONE;
											o_is_bound_detected <= 1'b1;
											o_bound_index <= shift_cnter;
										end
								end
							else
								begin
									shift_cnter <= shift_cnter + 1'b1;
									i_32bit_raw_data_latch <= {1'b1,i_32bit_raw_data_latch[31:1]}; // right shift
									
								end
						end
					RIGHT_BOUND:
						begin
							if (i_32bit_raw_data_latch[31] == 1'b1)
								begin
									if (shift_cnter == 5'd0) // this is error handler
										begin
											sm_state <= RIGHT_BOUND;
											shift_cnter <= shift_cnter + 5'd1;
											i_32bit_raw_data_latch <= {i_32bit_raw_data_latch[30:0],1'b1}; // left shift
										end
									else
										begin
											sm_state <= DONE;
											o_is_bound_detected <= 1'b1;
											o_bound_index <= shift_cnter;
										end
								end
							else
								begin
									shift_cnter <= shift_cnter + 1'b1;
									i_32bit_raw_data_latch <= {i_32bit_raw_data_latch[30:0],1'b1}; // left shift
									
								end
						end
					DONE:
						begin
							o_done <= 1'b1;
							if (i_trig == 1'b0)
								sm_state <= IDLE;
						end
					default:
						sm_state <= IDLE;
				endcase
			end
	
	end



endmodule