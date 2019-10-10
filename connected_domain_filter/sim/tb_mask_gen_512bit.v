`timescale 1ns / 1ps



module tb_mask_gen_512bit(

    );
	
	// UUT interface
	reg i_clk;
	reg i_rstn;
	reg i_trig;
	reg i_left_or_right; // 0=left, 1=right
	reg [8:0] i_bound_index;
	wire  o_done;
	wire [511:0] o_mask;

	
	// Debug port
	// `define debug_mode
	// wire [7:0] uut_sm_state;
	// wire [31:0] uut_32b_data_from_bram;
	
	//uut inst
	mask_gen_512bit uut(
		.i_clk(i_clk),
		.i_rstn(i_rstn),
		.i_trig(i_trig),
		.i_left_or_right(i_left_or_right),	// shift in from left or right hand side
		.i_bound_index(i_bound_index),  //9bit, MSB-shift_in 256bit-one, LSB-shift_in 1bit-one
		.o_done(o_done),
		.o_mask(o_mask)	//512bit

	);
	// BRAM controller model
	
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
	// reg i_left_or_right; // 0=left, 1=right
	// reg [8:0] i_bound_index;
	initial begin
		i_trig=0;
		i_left_or_right=0;
		i_bound_index=0;

		#40;
		//case#1
		@(posedge i_clk) begin
			i_trig=1;
			i_left_or_right=0;
			i_bound_index=1;
		end
		//case#2
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
		
		
	end
	
	always@(posedge i_clk) begin
		if(o_done==1'b1)
			i_trig<=0;
	end
	


	
endmodule
