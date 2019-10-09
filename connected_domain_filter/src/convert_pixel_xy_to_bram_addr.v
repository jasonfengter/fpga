module convert_pixel_xy_to_bram_addr(
	i_clk,
	i_rstn,
	i_trigger,
	i_pixel_row_num,
	i_pixel_col_num,
	o_bram_addr,
	o_bram_addr_valid

);
	input i_clk;
	input i_rstn;
	input i_trigger;
	input [8:0] i_pixel_row_num;
	input [8:0] i_pixel_col_num;
	output reg [12:0] o_bram_addr;
	output reg o_bram_addr_valid;
	
	wire [12:0] o_bram_addr_pre;
	wire o_bram_addr_valid_pre;
	always@(*) begin
		if (i_trigger == 1'b1)
			begin
				o_bram_addr_pre = (i_pixel_row_num << 4) | (i_pixel_col_num >> 5) ;
				o_bram_addr_valid_pre = 1'b1;
			end
		else
			begin
				o_bram_addr_pre = 13'h0;
				o_bram_addr_valid_pre = 1'b0;
			end
	end
	
	
	always@(posedge i_clk or negedge i_rstn) begin
		if (i_rstn == 1'b0) begin
			o_bram_addr <= 13'h0;
			o_bram_addr_valid <= 1'b0;
		end else if (o_bram_addr_valid_pre == 1'b1) begin
			o_bram_addr <= o_bram_addr_pre;
			o_bram_addr_valid <= o_bram_addr_valid_pre;
		end	else begin
			o_bram_addr <= 13'h0;
			o_bram_addr_valid <= 1'b0;
		end
			
	end


endmodule