`timescale 1ns / 1ps



module tb_dual_row_shift(

    );
	
	// UUT interface
	reg 				i_clk;
	reg 				i_rstn;
	reg 				i_trig_rd;

	wire  			o_done;
	reg [8:0] 		i_row_num_to_read;	//9bit
	reg [8:0] 		i_row_num_to_initial_setup;		//9bit
	reg 				i_init_en;			//when enabled; load 1st row reg with i_row_num_to_initial_setup; 2nd row with i_row_num_to_read; 
											//otherwise; load 2nd row with i_row_num_to_read
	wire [511:0] 	o_1st_row_512b;		//512bit
	wire [511:0] 	o_2nd_row_512b;		//512bit
	// to TOP BRAM rd controller ctrl bus
	wire [12:0]			u_rd_512b_from_bram_o_rd_from_bram_addr;
	wire  [31:0]		u_rd_512b_from_bram_i_rd_from_bram_data;
	wire 				u_rd_512b_from_bram_o_rd_from_bram_trig;
	wire 				u_rd_512b_from_bram_i_rd_from_bram_done;

	
	// Debug port
	// `define debug_mode
	// wire [7:0] uut_sm_state;
	// wire [31:0] uut_32b_data_from_bram;
	
	//uut inst
	dual_row_shift uut(
		.i_clk(i_clk),
		.i_rstn(i_rstn),
		.i_trig_rd(i_trig_rd),
		.o_done(o_done),
		.i_row_num_to_read(i_row_num_to_read),	//9bit
		.i_row_num_to_initial_setup(i_row_num_to_initial_setup),		//9bit
		.i_init_en(i_init_en),			
		.o_1st_row_512b(o_1st_row_512b),		//512bit
		.o_2nd_row_512b(o_2nd_row_512b),		//512bit
		
		// to TOP BRAM rd controller ctrl bus
		.u_rd_512b_from_bram_o_rd_from_bram_addr(u_rd_512b_from_bram_o_rd_from_bram_addr),
		.u_rd_512b_from_bram_i_rd_from_bram_data(u_rd_512b_from_bram_i_rd_from_bram_data),
		.u_rd_512b_from_bram_o_rd_from_bram_trig(u_rd_512b_from_bram_o_rd_from_bram_trig),
		.u_rd_512b_from_bram_i_rd_from_bram_done(u_rd_512b_from_bram_i_rd_from_bram_done)
	
	
    );
	
	// BRAM controller model
	BRAM_model_rd BRAM(
		.i_clk(i_clk),
		.i_rstn(i_rstn),
		.i_bram_addr(u_rd_512b_from_bram_o_rd_from_bram_addr),
		.o_bram_data(u_rd_512b_from_bram_i_rd_from_bram_data),
		.i_bram_trig(u_rd_512b_from_bram_o_rd_from_bram_trig),
		.o_bram_done(u_rd_512b_from_bram_i_rd_from_bram_done)
	
	);
	// Clock
	initial i_clk=0;
	always #1 i_clk = ~i_clk; //500MHz
	
	// Reset
	initial begin
		i_rstn = 0;
		#20;
		@(negedge i_clk) i_rstn=1;
	end
	
	// Set initial condition of uut
		// .i_clk(i_clk),
		// .i_rstn(i_rstn),
		// .i_trig_rd(i_trig_rd),
		// .o_done(o_done),
		// .i_row_num_to_read(i_row_num_to_read),	//9bit
		// .i_row_num_to_initial_setup(i_row_num_to_initial_setup),		//9bit
		// .i_init_en(i_init_en),			
		// .o_1st_row_512b(o_1st_row_512b),		//512bit
		// .o_2nd_row_512b(o_2nd_row_512b),		//512bit
	initial begin
		i_trig_rd=0;
		i_row_num_to_read=0;
		i_row_num_to_initial_setup=0;
		i_init_en=0;
		#40;
		//case#1
		@(posedge i_clk) begin
			i_trig_rd=1;
			i_row_num_to_read='hb;
			i_row_num_to_initial_setup='ha;
			i_init_en=1;
		end
		//case#2
		@(negedge o_done); #10;
			i_trig_rd=1;
			i_row_num_to_read='hc;
			i_row_num_to_initial_setup='h0;
			i_init_en=0;
		
		
	end
	
	always@(posedge i_clk) begin
		if(o_done==1'b1)
			i_trig_rd<=0;
	end
	


	
endmodule
