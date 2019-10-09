`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/08 13:20:01
// Design Name: 
// Module Name: retrieve_block
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module retrieve_block(
	i_1st_row_512bit,
	i_2nd_row_512bit,
	o_block
    );
	
	input [511:0] i_1st_row_512bit;
	input [511:0] i_2nd_row_512bit;
	output [5:0] o_block;
	
	assign o_block = {i_1st_row_512bit[511:509],i_2nd_row_512bit[511:509]};
	
endmodule
