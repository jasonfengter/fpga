`timescale 1ns / 1ps



module tb_top(

    );
	
	// UUT interface
	reg i_clk;
	reg i_rstn;
	reg i_trig;
	wire  o_done;
	
	// BRAM rd data/control bus
	wire  [12:0] 	o_rd_from_bram_addr;	// 13b
	wire [31:0] 	i_rd_from_bram_data;	// 32b
	wire  			o_rd_from_bram_trig;
	wire 			i_rd_from_bram_done;
	// BRAM wr data/control bus
	wire  [12:0] 	o_wr_to_bram_addr;		// 13b
	wire  [31:0] 	o_wr_to_bram_data;		// 32b
	wire  			o_wr_to_bram_trig;
	wire 			i_wr_to_bram_done;
	// Input start row #
	reg [8:0] 	i_start_row_num;		// 9b

	//uut inst
	top uut(
		.i_clk(i_clk),
		.i_rstn(i_rstn),
		.i_trig(i_trig),
		.o_done(o_done),
		
		// BRAM rd data/control bus
		.o_rd_from_bram_addr(o_rd_from_bram_addr),	// 13b
		.i_rd_from_bram_data(i_rd_from_bram_data),	// 32b
		.o_rd_from_bram_trig(o_rd_from_bram_trig),
		.i_rd_from_bram_done(i_rd_from_bram_done),
		// BRAM wr data/control bus
		.o_wr_to_bram_addr(o_wr_to_bram_addr),		// 13b
		.o_wr_to_bram_data(o_wr_to_bram_data),		// 32b
		.o_wr_to_bram_trig(o_wr_to_bram_trig),
		.i_wr_to_bram_done(i_wr_to_bram_done),
		
		.i_start_row_num(i_start_row_num)		// Starting row# 9b (0..511)

	);


	// BRAM controller model
	BRAM_model_rd BRAM_rd(
		.i_clk			(i_clk),
		.i_rstn			(i_rstn),
		.i_bram_addr	(o_rd_from_bram_addr),
		.o_bram_data	(i_rd_from_bram_data),
		.i_bram_trig	(o_rd_from_bram_trig),
		.o_bram_done	(i_rd_from_bram_done)
	
	);
	BRAM_model_wr BRAM_wr(
		.i_clk			(i_clk	),
		.i_rstn			(i_rstn),
		.i_bram_addr	(o_wr_to_bram_addr),
		.i_bram_data	(o_wr_to_bram_data),
		.i_bram_trig	(o_wr_to_bram_trig),
		.o_bram_done	(i_wr_to_bram_done)
	
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
		i_start_row_num=0;
		#40;
		//case#1
		@(posedge i_clk) begin
			i_trig<=1;
			i_start_row_num<=9'd20;
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
