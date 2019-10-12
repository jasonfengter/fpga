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
								o_bram_data<=return_bram_data(i_bram_addr);
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
	reg [511:0] RAW_DATA = {{8{1'b1}} , {496{1'b0}} , {8{1'b1}}};
	function automatic [31:0] return_bram_data;
		input [12:0] addr;
		begin
				
				
				case(addr[3:0])
					4'd0:  return_bram_data=RAW_DATA[511:480];
					4'd1:  return_bram_data=RAW_DATA[479:448];
					4'd2:  return_bram_data=RAW_DATA[447:416];
					4'd3:  return_bram_data=RAW_DATA[415:384];
					4'd4:  return_bram_data=RAW_DATA[383:352];
					4'd5:  return_bram_data=RAW_DATA[351:320];
					4'd6:  return_bram_data=RAW_DATA[319:288];
					4'd7:  return_bram_data=RAW_DATA[287:256];
					4'd8:  return_bram_data=RAW_DATA[255:224];
					4'd9:  return_bram_data=RAW_DATA[223:192];
					4'd10: return_bram_data=RAW_DATA[191:160];
					4'd11: return_bram_data=RAW_DATA[159:128];
					4'd12: return_bram_data=RAW_DATA[127:96];
					4'd13: return_bram_data=RAW_DATA[95:64];
					4'd14: return_bram_data=RAW_DATA[63:32];
					4'd15: return_bram_data=RAW_DATA[31:0];
					default: return_bram_data=32'hffff_ffff;
				endcase
		end
	endfunction

endmodule