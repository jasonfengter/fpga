


module dual_row_shift(
	i_clk,
	i_rstn,
	i_trig_rd,

	o_done,
	i_row_num_to_read,	//9bit
	i_start_row_512b_data,	//512b
	//i_row_num_to_initial_setup,		//9bit
	i_init_en,			//when enabled, load 1st row reg with i_row_num_to_initial_setup, 2nd row with i_row_num_to_read, 
						//otherwise, load 2nd row with i_row_num_to_read
	o_1st_row_512b,		//512bit
	o_2nd_row_512b,		//512bit
	
	// to TOP BRAM rd controller ctrl bus
	u_rd_512b_from_bram_o_rd_from_bram_addr,
	u_rd_512b_from_bram_i_rd_from_bram_data,
	u_rd_512b_from_bram_o_rd_from_bram_trig,
	u_rd_512b_from_bram_i_rd_from_bram_done
	
	
    );
	
	input 				i_clk;
	input 				i_rstn;
	input 				i_trig_rd;

	output  			o_done;
	input [8:0] 		i_row_num_to_read;	//9bit
	input [511:0]		i_start_row_512b_data;
	//input [8:0] 		i_row_num_to_initial_setup;		//9bit
	input 				i_init_en;			//when enabled; load 1st row reg with i_row_num_to_initial_setup; 2nd row with i_row_num_to_read; 
											//otherwise; load 2nd row with i_row_num_to_read
	output reg [511:0] 	o_1st_row_512b;		//512bit
	output reg [511:0] 	o_2nd_row_512b;		//512bit
	// to TOP BRAM rd controller ctrl bus
	output [12:0]		u_rd_512b_from_bram_o_rd_from_bram_addr;
	input  [31:0]		u_rd_512b_from_bram_i_rd_from_bram_data;
	output 				u_rd_512b_from_bram_o_rd_from_bram_trig;
	input 				u_rd_512b_from_bram_i_rd_from_bram_done;
	
	
	// Control interface to rd_512b IP below
	reg 				u_rd_512b_from_bram_i_trig;			
	wire 				u_rd_512b_from_bram_o_done;				
	reg [8:0]			u_rd_512b_from_bram_i_rd_row_num		;
	wire [511:0]		u_rd_512b_from_bram_o_rd_data_512b		;
	
	
	
	
	rd_512b_from_bram u_rd_512b_from_bram(
		.i_clk					(i_clk),
		.i_rstn					(i_rstn),
		.i_trig					(u_rd_512b_from_bram_i_trig),
		.o_done					(u_rd_512b_from_bram_o_done),
		.i_rd_row_num			(u_rd_512b_from_bram_i_rd_row_num), // 0-511, 9bit
		.o_rd_data_512b			(u_rd_512b_from_bram_o_rd_data_512b), //512bit
		.o_rd_from_bram_addr	(u_rd_512b_from_bram_o_rd_from_bram_addr), //13bit
		.i_rd_from_bram_data	(u_rd_512b_from_bram_i_rd_from_bram_data), //32bit
		.o_rd_from_bram_trig	(u_rd_512b_from_bram_o_rd_from_bram_trig),
		.i_rd_from_bram_done	(u_rd_512b_from_bram_i_rd_from_bram_done)
    );
	

	reg i_trig_rd_int;  //Trigger signal to start SM for rd_512b_bram IP


	
	reg [3:0] sm_state;
	localparam	IDLE=0, RD_INIT1=1,
				RD_INIT2=2,
				RD=3,
				SHIFT=4,
				DONE=5;
	// DualRow Shifter State machine
	// Will not support dual-row shift operation. Only row data retrieve function left.
	// Module interface

	
	// GUIDELINE: o_done must be pull-down when i_trig is down!!!
	reg o_done_pre;
	assign o_done = o_done_pre & i_trig_rd;
	
	// in IDLE, done signal to be reset but o_data should not be touched!!
	always@(posedge i_clk or negedge i_rstn) begin
		if (i_rstn==1'b0)
			begin
				o_1st_row_512b <= 512'd0;
				o_2nd_row_512b <= 512'd0;
				o_done_pre <= 1'b0;
								
				sm_state <= IDLE;
				i_trig_rd_int <= 1'b0;
				
			end
		else
			begin
				case (sm_state)
					IDLE:
						// GUIDELINE
						// (1) in IDLE, done signal to be reset but o_data should not be touched!!
						// (2) in IDLE, IP under control should pull-down trig signal
						begin
							i_trig_rd_int <= 1'b0;	//Disable IP trigger
							o_done_pre <=1'b0; 
							case ( {i_trig_rd,i_init_en}  )
								2'b11:
									sm_state <= RD_INIT1;
								2'b10:
									sm_state <= RD;
								default:
									sm_state <= IDLE;
							endcase
							
						end
					RD_INIT1:
						//GUIDELINE: after DONE asserted, should deactivate 'trig' of IP under control
						begin
							//reset module done
							o_done_pre <=1'b0; 
							//setup rd_512b_bram module
							//u_rd_512b_from_bram_i_rd_row_num <= i_row_num_to_initial_setup;
							//trigger rd_512b_bram_module
							//i_trig_rd_int <= 1'b1;
							o_1st_row_512b <= i_start_row_512b_data;	// load 1st row with initial 512b data
							sm_state <= RD_INIT2;
							// if (u_rd_512b_from_bram_o_done == 1'b1)
								// begin
									// i_trig_rd_int <= 1'b0;
									// o_1st_row_512b <= u_rd_512b_from_bram_o_rd_data_512b;
									// sm_state <= RD_INIT2;
									
								// end
						end
					RD_INIT2:
						//GUIDELINE: after DONE asserted, should deactivate 'trig' of IP under control
						begin
							//reset module done
							o_done_pre <=1'b0; 
							//setup rd_512b_bram module
							u_rd_512b_from_bram_i_rd_row_num <= i_row_num_to_read;
							//trigger rd_512b_bram_module
							i_trig_rd_int <= 1'b1;
							
							if (u_rd_512b_from_bram_o_done == 1'b1)
								begin
									i_trig_rd_int <= 1'b0;
									o_2nd_row_512b <= u_rd_512b_from_bram_o_rd_data_512b;
									sm_state <= DONE;
								end
						end
					RD:
						//GUIDELINE: after DONE asserted, should deactivate 'trig' of IP 
						begin
							o_done_pre <=1'b0;   //reset module done
							u_rd_512b_from_bram_i_rd_row_num <= i_row_num_to_read;  //setup rd_512b_bram module
							i_trig_rd_int <= 1'b1;  //trigger rd_512b_bram_module
							if (u_rd_512b_from_bram_o_done == 1'b1)
								begin
									i_trig_rd_int <= 1'b0;
									o_1st_row_512b <= o_2nd_row_512b;
									o_2nd_row_512b <= u_rd_512b_from_bram_o_rd_data_512b;
									sm_state <= DONE;
								end
						end
					
					DONE:
						begin
							o_done_pre <= 1'b1;
							if (i_trig_rd  == 1'b0) // GUIDELINE: after 'trig' deactivated, DONE signal should be de-asserted
								begin o_done_pre<=1'b0; sm_state <= IDLE; end
						end
				endcase
			end
	
	end
	
	
	reg [3:0] rd_bram_sm_state;
	localparam	CONFIG=0,
				RD_DONE=1;
				
	always@(posedge i_clk or negedge i_rstn) begin
		if (i_rstn==1'b0)
			begin
				rd_bram_sm_state <= CONFIG;
				u_rd_512b_from_bram_i_trig <= 1'b0;
			end
		else
			begin
						// GUIDELINE
						// (1) in IDLE, done signal to be reset but o_data should not be touched!!
						// (2) in IDLE, IP  should pull-down trig signal
				case (rd_bram_sm_state)
					CONFIG:
						begin
							u_rd_512b_from_bram_i_trig <= 1'b0;
							if (i_trig_rd_int ) begin
								rd_bram_sm_state <= RD_DONE;
								u_rd_512b_from_bram_i_trig <= 1'b1;
								
							end
						end
					RD_DONE:
						begin
							if (u_rd_512b_from_bram_o_done==1'b1) begin //GUIDELINE: after DONE asserted, should deactivate 'trig' of IP 
								u_rd_512b_from_bram_i_trig <= 1'b0;
								rd_bram_sm_state <= CONFIG;
							end
						end
					default:
						rd_bram_sm_state <= CONFIG;
				endcase
			end
		
		
	end
	

	
endmodule
