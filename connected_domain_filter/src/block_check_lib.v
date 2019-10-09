
module to_hard_connect(
	i_block,
	o_is_a_hit
    );
	
	input [5:0] i_block;
	output o_is_a_hit;
	
	assign o_is_a_hit = ({i_block[3],i_block[1]} == 2'b00) ? 1'b1 : 1'b0;
	
endmodule


module detecting_to_start(
	i_block,
	o_is_a_hit
    );
	
	input [5:0] i_block;
	output o_is_a_hit;
	
	assign o_is_a_hit = (i_block==6'b111_100 || i_block==6'b111_101) ? 1'b1 : 1'b0;
	
endmodule

module start_to_connect(
	i_block,
	o_is_a_hit
    );
	
	input [5:0] i_block;
	output o_is_a_hit;
	
	assign o_is_a_hit = (i_block==6'b111_000 || i_block==6'b111_001) ? 1'b1 : 1'b0;
	
endmodule

module to_pre_disconnect(
	i_block,
	o_is_a_hit
    );
	
	input [5:0] i_block;
	output o_is_a_hit;
	
	assign o_is_a_hit = ( {i_block[5:4],i_block[2:1]} == 4'b1101 ) ? 1'b1 : 1'b0;
	
endmodule

module pre_disconnect_to_connect(
	i_block,
	o_is_a_hit
    );
	
	input [5:0] i_block;
	output o_is_a_hit;
	
	assign o_is_a_hit = ( i_block==6'b111_100 || i_block==6'b111_101 ) ? 1'b1 : 1'b0;
	
endmodule

module pre_disconnect_to_self(
	i_block,
	o_is_a_hit
    );
	
	input [5:0] i_block;
	output o_is_a_hit;
	
	assign o_is_a_hit = ( {i_block[5],i_block[2:1]} == 3'b111 ) ? 1'b1 : 1'b0;
	
endmodule

module hard_pre_disconnect_to_self(
	i_block,
	o_is_a_hit
    );
	
	input [5:0] i_block;
	output o_is_a_hit;
	
	assign o_is_a_hit = ( i_block[2:1] == 2'b11 ) ? 1'b1 : 1'b0;
	
endmodule

module hard_connect_to_pre_disconnect(
	i_block,
	o_is_a_hit
    );
	
	input [5:0] i_block;
	output o_is_a_hit;
	
	assign o_is_a_hit = ( i_block[2:1] == 2'b01 ) ? 1'b1 : 1'b0;
	
endmodule

module hard_pre_disconnect_to_connect(
	i_block,
	o_is_a_hit
    );
	
	input [5:0] i_block;
	output o_is_a_hit;
	
	assign o_is_a_hit = ( i_block[2:1] == 2'b10 ) ? 1'b1 : 1'b0;
	
endmodule
