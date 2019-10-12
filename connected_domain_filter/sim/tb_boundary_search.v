`timescale 1ns / 1ps



module tb_boundary_search(

    );
	
	// UUT interface
	reg 		i_clk;
	reg 		i_rstn;
	reg 		i_trig;
	reg [3:0] i_MAX_INTERVAL; initial i_MAX_INTERVAL=2;
	wire  	o_done;
	// to TOP BRAM rd controller ctrl bus
	wire [12:0]		u_rd_512b_from_bram_o_rd_from_bram_addr;
	wire  [31:0]	u_rd_512b_from_bram_i_rd_from_bram_data;
	wire 			u_rd_512b_from_bram_o_rd_from_bram_trig;
	wire 			u_rd_512b_from_bram_i_rd_from_bram_done;
	
	reg [8:0] row_num_to_start;
	// to TOP BRAM wr controller ctrl bus
	wire [12:0] 	u_wr_512b_to_bram_o_wr_to_bram_addr;
	wire [31:0] 	u_wr_512b_to_bram_o_wr_to_bram_data;
	wire  			u_wr_512b_to_bram_o_wr_to_bram_trig;
	wire 			u_wr_512b_to_bram_i_wr_to_bram_done;
	
	
	// Debug port
	// `define debug_mode
	// wire [7:0] uut_sm_state;
	// wire [31:0] uut_32b_data_from_bram;
	
	//uut inst
	boundary_search uut(
	
		.i_clk (i_clk),
		.i_rstn(i_rstn),
		.i_trig(i_trig),
		.o_done(o_done),
		.i_MAX_INTERVAL(i_MAX_INTERVAL),	//4bit
		// to TOP BRAM rd controller ctrl bus
		.u_rd_512b_from_bram_o_rd_from_bram_addr(u_rd_512b_from_bram_o_rd_from_bram_addr),
		.u_rd_512b_from_bram_i_rd_from_bram_data(u_rd_512b_from_bram_i_rd_from_bram_data),
		.u_rd_512b_from_bram_o_rd_from_bram_trig(u_rd_512b_from_bram_o_rd_from_bram_trig),
		.u_rd_512b_from_bram_i_rd_from_bram_done(u_rd_512b_from_bram_i_rd_from_bram_done),
		
		.row_num_to_start(row_num_to_start),	// 9bit
		
		// to TOP BRAM wr controller ctrl bus 
		.u_wr_512b_to_bram_o_wr_to_bram_addr(u_wr_512b_to_bram_o_wr_to_bram_addr),
		.u_wr_512b_to_bram_o_wr_to_bram_data(u_wr_512b_to_bram_o_wr_to_bram_data),
		.u_wr_512b_to_bram_o_wr_to_bram_trig(u_wr_512b_to_bram_o_wr_to_bram_trig),
		.u_wr_512b_to_bram_i_wr_to_bram_done(u_wr_512b_to_bram_i_wr_to_bram_done)

    );


	// BRAM controller model
	BRAM_model_rd BRAM_rd(
		.i_clk			(i_clk),
		.i_rstn			(i_rstn),
		.i_bram_addr	(u_rd_512b_from_bram_o_rd_from_bram_addr),
		.o_bram_data	(u_rd_512b_from_bram_i_rd_from_bram_data),
		.i_bram_trig	(u_rd_512b_from_bram_o_rd_from_bram_trig),
		.o_bram_done	(u_rd_512b_from_bram_i_rd_from_bram_done)
	
	);
	BRAM_model_wr BRAM_wr(
		.i_clk			(i_clk	),
		.i_rstn			(i_rstn),
		.i_bram_addr	(u_wr_512b_to_bram_o_wr_to_bram_addr),
		.i_bram_data	(u_wr_512b_to_bram_o_wr_to_bram_data),
		.i_bram_trig	(u_wr_512b_to_bram_o_wr_to_bram_trig),
		.o_bram_done	(u_wr_512b_to_bram_i_wr_to_bram_done)
	
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
	// reg i_trig;
	// reg [8:0] i_bound_index_left;
	// reg [8:0] i_bound_index_right;
	initial begin
		// Reset uut
		i_trig=0;
		row_num_to_start=0;
		#40;
		//case#1
		@(posedge i_clk) begin
			i_trig<=1;
			row_num_to_start<=9'd20;
		end
	/*	//case#2
		@(negedge o_done); #10;
			i_trig=1;
			i_left_or_right=1;
			i_bound_index=1;
			
		//case#3
		@(negedge o_done); #10;
			i_trig=1;
			i_left_or_right=0;
			i_bound_index=511;
			
		//case#4
		@(negedge o_done); #10;
			i_trig=1;
			i_left_or_right=1;
			i_bound_index=511;
		*/
		
	end
	
	always@(posedge i_clk) begin
		if(o_done==1'b1)
			i_trig<=0;
	end
	


	
endmodule
