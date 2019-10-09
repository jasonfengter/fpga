`timescale 1ns / 1ps



module tb_rd_512b_from_bram(

    );
	
	// UUT interface
	reg 				i_clk;
	reg 				i_rstn;
	reg 				i_trig;
	wire 				o_done;
	reg [8:0] 			i_rd_row_num; // 0-511; 9bit
	wire [511:0] 		o_rd_data_512b; //512bit
	wire [12:0] 		o_rd_from_bram_addr; //13bit
	wire [31:0] 		i_rd_from_bram_data; //32bit
	wire 				o_rd_from_bram_trig;
	wire 				i_rd_from_bram_done;
	
	// Debug port
	`define debug_mode
	wire [7:0] uut_sm_state;
	wire [31:0] uut_32b_data_from_bram;
	
	rd_512b_from_bram uut(
		.i_clk(i_clk),
		.i_rstn(i_rstn),
		.i_trig(i_trig),
		.o_done(o_done),
		.i_rd_row_num(i_rd_row_num), // 0-511, 9bit
		.o_rd_data_512b(o_rd_data_512b), //512bit
	// Below to TOP BRAM rd controller
		.o_rd_from_bram_addr(o_rd_from_bram_addr), //13bit
		.i_rd_from_bram_data(i_rd_from_bram_data), //32bit
		.o_rd_from_bram_trig(o_rd_from_bram_trig),
		.i_rd_from_bram_done(i_rd_from_bram_done),
		.debug_port({uut_32b_data_from_bram,uut_sm_state})
    );
	
	BRAM_model_rd BRAM(
		.i_clk(i_clk),
		.i_rstn(i_rstn),
		.i_bram_addr(o_rd_from_bram_addr),
		.o_bram_data(i_rd_from_bram_data),
		.i_bram_trig(o_rd_from_bram_trig),
		.o_bram_done(i_rd_from_bram_done)
	
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
		i_rd_row_num=0;
		#40;
		@(posedge i_clk) begin
			i_trig=1;
			i_rd_row_num=0;
		end
		
		
	end
	
	always@(posedge i_clk) begin
		if(o_done==1'b1)
			i_trig<=0;
	end
	


	
endmodule
