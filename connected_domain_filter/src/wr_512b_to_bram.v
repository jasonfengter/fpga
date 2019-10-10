

module wr_512b_to_bram(
	i_clk,
	i_rstn,
	i_trig,
	o_done,
	i_wr_row_num, // 0-511, 9bit
	i_wr_data_512b, //512bit
	//Below signal are connected to TOP BRAM wr controller
	o_wr_to_bram_addr, //13bit
	o_wr_to_bram_data, //32bit
	o_wr_to_bram_trig,
	i_wr_to_bram_done
);

	input 				i_clk;
	input 				i_rstn;
	input 				i_trig;
	output  			o_done;
	input [8:0] 		i_wr_row_num; // 0-511; 9bit
	input [511:0] 		i_wr_data_512b; //512bit
	output reg [12:0] 	o_wr_to_bram_addr; //13bit
	output reg [31:0] 	o_wr_to_bram_data; //32bit
	output reg 			o_wr_to_bram_trig;
	input 				i_wr_to_bram_done;
	
	
	// o_done must be pull-down when i_trig is down!!!
	reg o_done_pre;
	assign o_done = o_done_pre & i_trig;

	
	reg [7:0] sm_state;
	localparam	IDLE=0,
			//	LOAD_DATA=1,
				DWORD1=2,
				DWORD2=3,
				DWORD3=4,
				DWORD4=5,
				DWORD5=6,
				DWORD6=7,
				DWORD7=8,
				DWORD8=9,
				DWORD9=10,
				DWORD10=11,
				DWORD11=12,
				DWORD12=13,
				DWORD13=14,
				DWORD14=15,
				DWORD15=16,
				DWORD16=17,
				DONE=18;

	always@(posedge i_clk or negedge i_rstn) begin
		if (i_rstn == 1'b0)
			begin
				o_wr_to_bram_addr <= 13'd0;
				o_wr_to_bram_data <= 32'd0;
				o_wr_to_bram_trig <= 1'b0;
				sm_state <= IDLE;
				o_done_pre <= 1'b0;
			end
		else
			case (sm_state)
				IDLE:
					// (1) in IDLE, done signal to be reset but o_data should not be touched!!
					// (2) in IDLE, IP under control should pull-down trig signal
					begin
						if (i_trig==1'b1)
							sm_state <= DWORD1;
						else
							sm_state <= IDLE;
						o_done_pre <= 1'b0;
						o_wr_to_bram_trig <= 1'b0;
					end
				DWORD1:
					begin
						o_wr_to_bram_trig <= 1'b1;
						o_wr_to_bram_addr <= {i_wr_row_num, 4'b0000};
						o_wr_to_bram_data <= i_wr_data_512b[511:480];
						if (i_wr_to_bram_done == 1'b1)
							//after DONE asserted, should deactivate 'trig' of IP under control
							begin
								o_wr_to_bram_trig <= 1'b0;
								sm_state <= DWORD2;
							end
					end
				DWORD2:
					begin
						o_wr_to_bram_trig <= 1'b1;
						o_wr_to_bram_addr <= {i_wr_row_num, 4'd1};
						o_wr_to_bram_data <= i_wr_data_512b[479:448];
						if (i_wr_to_bram_done == 1'b1)
							//after DONE asserted, should deactivate 'trig' of IP under control
							begin
								o_wr_to_bram_trig <= 1'b0;
								sm_state <= DWORD3;
							end
					end
				DWORD3:
					begin
						o_wr_to_bram_trig <= 1'b1;
						o_wr_to_bram_addr <= {i_wr_row_num, 4'd2};
						o_wr_to_bram_data <= i_wr_data_512b[447:416];
						if (i_wr_to_bram_done == 1'b1)
							//after DONE asserted, should deactivate 'trig' of IP under control
							begin
								o_wr_to_bram_trig <= 1'b0;
								sm_state <= DWORD4;
							end
					end
				DWORD4:
					begin
						o_wr_to_bram_trig <= 1'b1;
						o_wr_to_bram_addr <= {i_wr_row_num, 4'd3};
						o_wr_to_bram_data <= i_wr_data_512b[415:384];
						if (i_wr_to_bram_done == 1'b1)
							//after DONE asserted, should deactivate 'trig' of IP under control
							begin
								o_wr_to_bram_trig <= 1'b0;
								sm_state <= DWORD5;
							end
					end
				DWORD5:
					begin
						o_wr_to_bram_trig <= 1'b1;
						o_wr_to_bram_addr <= {i_wr_row_num, 4'd4};
						o_wr_to_bram_data <= i_wr_data_512b[383:352];
						if (i_wr_to_bram_done == 1'b1)
							//after DONE asserted, should deactivate 'trig' of IP under control
							begin
								o_wr_to_bram_trig <= 1'b0;
								sm_state <= DWORD6;
							end
					end
				DWORD6:
					begin
						o_wr_to_bram_trig <= 1'b1;
						o_wr_to_bram_addr <= {i_wr_row_num, 4'd5};
						o_wr_to_bram_data <= i_wr_data_512b[351:320];
						if (i_wr_to_bram_done == 1'b1)
							//after DONE asserted, should deactivate 'trig' of IP under control
							begin
								o_wr_to_bram_trig <= 1'b0;
								sm_state <= DWORD7;
							end
					end
				DWORD7:
					begin
						o_wr_to_bram_trig <= 1'b1;
						o_wr_to_bram_addr <= {i_wr_row_num, 4'd6};
						o_wr_to_bram_data <= i_wr_data_512b[319:288];
						if (i_wr_to_bram_done == 1'b1)
							//after DONE asserted, should deactivate 'trig' of IP under control
							begin
								o_wr_to_bram_trig <= 1'b0;
								sm_state <= DWORD8;
							end
					end
				DWORD8:
					begin
						o_wr_to_bram_trig <= 1'b1;
						o_wr_to_bram_addr <= {i_wr_row_num, 4'd7};
						o_wr_to_bram_data <= i_wr_data_512b[287:256];
						if (i_wr_to_bram_done == 1'b1)
							//after DONE asserted, should deactivate 'trig' of IP under control
							begin
								o_wr_to_bram_trig <= 1'b0;
								sm_state <= DWORD9;
							end
					end
				DWORD9:
					begin
						o_wr_to_bram_trig <= 1'b1;
						o_wr_to_bram_addr <= {i_wr_row_num, 4'd8};
						o_wr_to_bram_data <= i_wr_data_512b[255:224];
						if (i_wr_to_bram_done == 1'b1)
							//after DONE asserted, should deactivate 'trig' of IP under control
							begin
								o_wr_to_bram_trig <= 1'b0;
								sm_state <= DWORD10;
							end
					end
				DWORD10:
					begin
						o_wr_to_bram_trig <= 1'b1;
						o_wr_to_bram_addr <= {i_wr_row_num, 4'd9};
						o_wr_to_bram_data <= i_wr_data_512b[223:192];
						if (i_wr_to_bram_done == 1'b1)
							//after DONE asserted, should deactivate 'trig' of IP under control
							begin
								o_wr_to_bram_trig <= 1'b0;
								sm_state <= DWORD11;
							end
					end
				DWORD11:
					begin
						o_wr_to_bram_trig <= 1'b1;
						o_wr_to_bram_addr <= {i_wr_row_num, 4'd10};
						o_wr_to_bram_data <= i_wr_data_512b[191:160];
						if (i_wr_to_bram_done == 1'b1)
							//after DONE asserted, should deactivate 'trig' of IP under control
							begin
								o_wr_to_bram_trig <= 1'b0;
								sm_state <= DWORD12;
							end
					end
				DWORD12:
					begin
						o_wr_to_bram_trig <= 1'b1;
						o_wr_to_bram_addr <= {i_wr_row_num, 4'd11};
						o_wr_to_bram_data <= i_wr_data_512b[159:128];
						if (i_wr_to_bram_done == 1'b1)
							//after DONE asserted, should deactivate 'trig' of IP under control
							begin
								o_wr_to_bram_trig <= 1'b0;
								sm_state <= DWORD13;
							end
					end
				DWORD13:
					begin
						o_wr_to_bram_trig <= 1'b1;
						o_wr_to_bram_addr <= {i_wr_row_num, 4'd12};
						o_wr_to_bram_data <= i_wr_data_512b[127:96];
						if (i_wr_to_bram_done == 1'b1)
							//after DONE asserted, should deactivate 'trig' of IP under control
							begin
								o_wr_to_bram_trig <= 1'b0;
								sm_state <= DWORD14;
							end
					end
				DWORD14:
					begin
						o_wr_to_bram_trig <= 1'b1;
						o_wr_to_bram_addr <= {i_wr_row_num, 4'd13};
						o_wr_to_bram_data <= i_wr_data_512b[95:64];
						if (i_wr_to_bram_done == 1'b1)
							//after DONE asserted, should deactivate 'trig' of IP under control
							begin
								o_wr_to_bram_trig <= 1'b0;
								sm_state <= DWORD15;
							end
					end
				DWORD15:
					begin
						o_wr_to_bram_trig <= 1'b1;
						o_wr_to_bram_addr <= {i_wr_row_num, 4'd14};
						o_wr_to_bram_data <= i_wr_data_512b[63:32];
						if (i_wr_to_bram_done == 1'b1)
							//after DONE asserted, should deactivate 'trig' of IP under control
							begin
								o_wr_to_bram_trig <= 1'b0;
								sm_state <= DWORD16;
							end
					end
				DWORD16:
					begin
						o_wr_to_bram_trig <= 1'b1;
						o_wr_to_bram_addr <= {i_wr_row_num, 4'd15};
						o_wr_to_bram_data <= i_wr_data_512b[31:0];
						if (i_wr_to_bram_done == 1'b1)
							//after DONE asserted, should deactivate 'trig' of IP under control
							begin
								o_wr_to_bram_trig <= 1'b0;
								sm_state <= DONE;
							end
					end
				DONE:
					begin
						o_wr_to_bram_trig <= 1'b0;
						o_done_pre <= 1'b1;
						if (i_trig == 1'b0) begin
							// after 'trig' deactivated, DONE signal should be de-asserted
							sm_state <= IDLE;
							o_done_pre <= 1'b0;
						end
					end
				
			endcase
	
	end
	


endmodule
