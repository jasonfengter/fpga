module BRAM_model_rd(
	i_clk,
	i_rstn,
	i_bram_addr,
	o_bram_data,
	i_bram_trig,
	o_bram_done
	
);
	parameter READ_LATENCY=1;  // Defined as: cyc# after 'trig' assertion being accepted
	input i_clk;
	input i_rstn;
	
	input [12:0] i_bram_addr;
	output reg [31:0] o_bram_data;
	input i_bram_trig;
	output o_bram_done;
	
	reg o_bram_done_pre;
	
	// IMPORTANT! 'done' signal must be suppressed when i_trig is down!
	assign o_bram_done = o_bram_done_pre & i_bram_trig;
	
	
	reg [7:0] latency_cnter;
	
	always@(posedge i_clk or negedge i_rstn) begin
		if(~i_rstn) begin
			o_bram_data <= 32'd0;
			o_bram_done_pre <= 1'b0;
			latency_cnter<=8'd0;
			end
		else 
			begin
				if(i_bram_trig)
					begin
						
						if(latency_cnter==READ_LATENCY)
							begin
								o_bram_done_pre<=1'b1;
								o_bram_data<=i_bram_addr; //return_bram_data(i_bram_addr);
							end
						else
							begin
								o_bram_done_pre<=1'b0;
								latency_cnter<=latency_cnter+1'b1;
								//do not touch o_bram_data
							end
					end
				else
					begin
						o_bram_done_pre<=1'b0;
						latency_cnter<=0;
					end
			end
	
	end
	
	function return_bram_data;
		input [12:0] addr;
		begin
				case(addr)
					12'h0: return_bram_data=32'h1234_5678;
					12'h1: return_bram_data=32'h8765_4321;
					default: return_bram_data=32'hffff_ffff;
				endcase
		end
	endfunction

endmodule