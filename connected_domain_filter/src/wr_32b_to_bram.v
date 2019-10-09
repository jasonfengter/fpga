module wr_32b_to_bram (

	i_trig,
	i_data_mask, //32bit
	i_orig_data, //32bit
	i_wr_bram_addr, //13bit
	o_done,
	o_wr_bram_addr, //13bit
	o_wr_bram_data, //32bit
	o_wr_bram_trig,
	i_wr_bram_ack
	

);

	input i_trig;
	input [31:0] i_data_mask; //32bit
	input [31:0] i_orig_data; //32bit
	input [12:0] i_wr_bram_addr; //13bit
	output o_done;
	
	output [12:0] o_wr_bram_addr; //13bit
	output [31:0] o_wr_bram_data; //32bit
	output o_wr_bram_trig;
	input i_wr_bram_ack;
	
	
	always@(*) begin
		if (i_trig==1'b1)
			begin
				o_wr_bram_addr = i_wr_bram_addr;
				o_wr_bram_data = (i_orig_data | i_data_mask) & i_data_mask;
				o_wr_bram_trig = 1'b1;
				o_done = i_wr_bram_ack;
			end
		else
			begin
				o_wr_bram_addr = 13'd0;
				o_wr_bram_data = 32'd0;
				o_wr_bram_trig = 1'b0;
				o_done = 1'b0;
			end
	
	end
	

endmodule