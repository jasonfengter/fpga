`timescale 1ns / 1ps



module tb_wr_512b_to_bram(

    );
	
	// UUT interface

	reg 				i_clk;
	reg 				i_rstn;
	reg 				i_trig;
	wire  				o_done;
	reg [8:0] 			i_wr_row_num; // 0-511; 9bit
	reg [511:0] 		i_wr_data_512b; //512bit
	
	wire [12:0] 		o_wr_to_bram_addr; //13bit
	wire [31:0] 		o_wr_to_bram_data; //32bit
	wire 				o_wr_to_bram_trig;
	wire 				i_wr_to_bram_done;
	
	// Debug port
	// `define debug_mode
	// wire [7:0] uut_sm_state;
	// wire [31:0] uut_32b_data_from_bram;
	
	//uut inst
	wr_512b_to_bram uut(
		.i_clk				(i_clk),
		.i_rstn				(i_rstn),
		.i_trig				(i_trig),
		.o_done				(o_done),
		.i_wr_row_num		(i_wr_row_num), // 0-511, 9bit
		.i_wr_data_512b		(i_wr_data_512b), //512bit
		.o_wr_to_bram_addr	(o_wr_to_bram_addr), //13bit
		.o_wr_to_bram_data	(o_wr_to_bram_data), //32bit
		.o_wr_to_bram_trig	(o_wr_to_bram_trig),
		.i_wr_to_bram_done	(i_wr_to_bram_done)
	);
	
	// BRAM controller model
	BRAM_model_wr BRAM(
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
	initial begin
		i_trig=0;
		i_wr_row_num=0;
		i_wr_data_512b=0;
		#40;
		@(posedge i_clk) begin
			i_trig=1;
			i_wr_row_num=13'h123;
			i_wr_data_512b={16'h0000,16'h0001,16'h0002,16'h0003,16'h0004,16'h0005,16'h0006,16'h0007,16'h0008,16'h0009,16'h000a,16'h000b,16'h000c,16'h000d,16'h000e,16'h000f};
		end
		
		
	end
	
	always@(posedge i_clk) begin
		if(o_done==1'b1)
			i_trig<=0;
	end
	


	
endmodule
