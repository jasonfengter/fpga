


module rd_512b_from_bram(
	i_clk,
	i_rstn,
	i_trig,
	o_done,
	i_rd_row_num, // 0-511, 9bit
	o_rd_data_512b, //512bit
	// Below to TOP BRAM rd controller
	o_rd_from_bram_addr, //13bit
	i_rd_from_bram_data, //32bit
	o_rd_from_bram_trig,
	i_rd_from_bram_done
    );
	
	input 				i_clk;
	input 				i_rstn;
	input 				i_trig;
	output reg 			o_done;
	input [8:0] 		i_rd_row_num; // 0-511; 9bit
	output reg [511:0] 	o_rd_data_512b; //512bit
	output reg [12:0] 	o_rd_from_bram_addr; //13bit
	input [31:0] 		i_rd_from_bram_data; //32bit
	output reg 			o_rd_from_bram_trig;
	input 				i_rd_from_bram_done;
	
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
				o_rd_from_bram_addr <= 9'd0;
				o_rd_from_bram_trig <= 1'b0;
				sm_state <= IDLE;
				o_done <= 1'b0;
			end
		else
			case (sm_state)
				IDLE: // in IDLE, done signal to be reset but o_data should not be touched!!
					begin
						if (i_trig==1'b1)
							sm_state <= DWORD1;
						else
							sm_state <= IDLE;
						o_done <= 1'b0;
						o_rd_from_bram_trig <= 1'b0;
					end
				DWORD1:
					begin
						o_rd_from_bram_trig <= 1'b1;
						o_rd_from_bram_addr <= {i_rd_row_num, 4'b0000};
						
						if (i_rd_from_bram_done == 1'b1)
							begin
								o_rd_from_bram_trig <= 1'b0;
								o_rd_data_512b[511:480] <= i_rd_from_bram_data;
								sm_state <= DWORD2;
							end
					end
				DWORD2:
					begin
						o_rd_from_bram_trig <= 1'b1;
						o_rd_from_bram_addr <= {i_rd_row_num, 4'd1};
						
						if (i_rd_from_bram_done == 1'b1)
							begin
								o_rd_from_bram_trig <= 1'b0;
								o_rd_data_512b[479:448] <= i_rd_from_bram_data;
								sm_state <= DWORD3;
							end
					end
				DWORD3:
					begin
						o_rd_from_bram_trig <= 1'b1;
						o_rd_from_bram_addr <= {i_rd_row_num, 4'd2};
					
						if (i_rd_from_bram_done == 1'b1)
							begin
								o_rd_from_bram_trig <= 1'b0;
								o_rd_data_512b[447:416] <= i_rd_from_bram_data;
								sm_state <= DWORD4;
							end
					end
				DWORD4:
					begin
						o_rd_from_bram_trig <= 1'b1;
						o_rd_from_bram_addr <= {i_rd_row_num, 4'd3};
					
						if (i_rd_from_bram_done == 1'b1)
							begin
								o_rd_from_bram_trig <= 1'b0;
								o_rd_data_512b[415:384] <= i_rd_from_bram_data;
								sm_state <= DWORD5;
							end
					end
				DWORD5:
					begin
						o_rd_from_bram_trig <= 1'b1;
						o_rd_from_bram_addr <= {i_rd_row_num, 4'd4};
					
						if (i_rd_from_bram_done == 1'b1)
							begin
								o_rd_from_bram_trig <= 1'b0;
								o_rd_data_512b[383:352] <= i_rd_from_bram_data;
								sm_state <= DWORD6;
							end
					end
				DWORD6:
					begin
						o_rd_from_bram_trig <= 1'b1;
						o_rd_from_bram_addr <= {i_rd_row_num, 4'd5};
				
						if (i_rd_from_bram_done == 1'b1)
							begin
								o_rd_from_bram_trig <= 1'b0;
								o_rd_data_512b[351:320] <= i_rd_from_bram_data;
								sm_state <= DWORD7;
							end
					end
				DWORD7:
					begin
						o_rd_from_bram_trig <= 1'b1;
						o_rd_from_bram_addr <= {i_rd_row_num, 4'd6};
			
						if (i_rd_from_bram_done == 1'b1)
							begin
								o_rd_from_bram_trig <= 1'b0;
								o_rd_data_512b[319:288] <= i_rd_from_bram_data;
								sm_state <= DWORD8;
							end
					end
				DWORD8:
					begin
						o_rd_from_bram_trig <= 1'b1;
						o_rd_from_bram_addr <= {i_rd_row_num, 4'd7};
				
						if (i_rd_from_bram_done == 1'b1)
							begin
								o_rd_from_bram_trig <= 1'b0;
								o_rd_data_512b[287:256] <= i_rd_from_bram_data;
								sm_state <= DWORD9;
							end
					end
				DWORD9:
					begin
						o_rd_from_bram_trig <= 1'b1;
						o_rd_from_bram_addr <= {i_rd_row_num, 4'd8};
			
						if (i_rd_from_bram_done == 1'b1)
							begin
								o_rd_from_bram_trig <= 1'b0;
								o_rd_data_512b[255:224] <= i_rd_from_bram_data;
								sm_state <= DWORD10;
							end
					end
				DWORD10:
					begin
						o_rd_from_bram_trig <= 1'b1;
						o_rd_from_bram_addr <= {i_rd_row_num, 4'd9};
				
						if (i_rd_from_bram_done == 1'b1)
							begin
								o_rd_from_bram_trig <= 1'b0;
								o_rd_data_512b[223:192] <= i_rd_from_bram_data;
								sm_state <= DWORD11;
							end
					end
				DWORD11:
					begin
						o_rd_from_bram_trig <= 1'b1;
						o_rd_from_bram_addr <= {i_rd_row_num, 4'd10};
	
						if (i_rd_from_bram_done == 1'b1)
							begin
								o_rd_from_bram_trig <= 1'b0;
								o_rd_data_512b[191:160] <= i_rd_from_bram_data;
								sm_state <= DWORD12;
							end
					end
				DWORD12:
					begin
						o_rd_from_bram_trig <= 1'b1;
						o_rd_from_bram_addr <= {i_rd_row_num, 4'd11};
				
						if (i_rd_from_bram_done == 1'b1)
							begin
								o_rd_from_bram_trig <= 1'b0;
								o_rd_data_512b[159:128] <= i_rd_from_bram_data;
								sm_state <= DWORD13;
							end
					end
				DWORD13:
					begin
						o_rd_from_bram_trig <= 1'b1;
						o_rd_from_bram_addr <= {i_rd_row_num, 4'd12};
					
						if (i_rd_from_bram_done == 1'b1)
							begin
								o_rd_from_bram_trig <= 1'b0;
								o_rd_data_512b[127:96] <= i_rd_from_bram_data;
								sm_state <= DWORD14;
							end
					end
				DWORD14:
					begin
						o_rd_from_bram_trig <= 1'b1;
						o_rd_from_bram_addr <= {i_rd_row_num, 4'd13};
		
						if (i_rd_from_bram_done == 1'b1)
							begin
								o_rd_from_bram_trig <= 1'b0;
								o_rd_data_512b[95:64] <= i_rd_from_bram_data;
								sm_state <= DWORD15;
							end
					end
				DWORD15:
					begin
						o_rd_from_bram_trig <= 1'b1;
						o_rd_from_bram_addr <= {i_rd_row_num, 4'd14};
					
						if (i_rd_from_bram_done == 1'b1)
							begin
								o_rd_from_bram_trig <= 1'b0;
								o_rd_data_512b[63:32] <= i_rd_from_bram_data;
								sm_state <= DWORD16;
							end
					end
				DWORD16:
					begin
						o_rd_from_bram_trig <= 1'b1;
						o_rd_from_bram_addr <= {i_rd_row_num, 4'd15};
					
						if (i_rd_from_bram_done == 1'b1)
							begin
								o_rd_from_bram_trig <= 1'b0;
								o_rd_data_512b[31:0] <= i_rd_from_bram_data;
								sm_state <= DONE;
							end
					end
				DONE:
					begin
						o_rd_from_bram_trig <= 1'b0;
						o_done <= 1'b1;
						if (i_trig == 1'b0) begin
							sm_state <= IDLE;
							o_done <= 1'b0;
						end
					end
				
			endcase
	
	end
	
	
	
endmodule
