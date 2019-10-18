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
	reg [511:0] RAW_DATA_18 = 512'hffffffff_ffffffff_fffeffff_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_ffffffff_ffffffff_0fffffff_ffffffff	; //{{8{1'b1}} , {496{1'b0}} , {8{1'b1}}};
	reg [511:0] RAW_DATA_19 = 512'hffffffff_ffffffff_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_0fffffff_ffffffff_ffffffff	; //{{8{1'b1}} , {496{1'b0}} , {8{1'b1}}};
	reg [511:0] RAW_DATA_20 = 512'hffffffff_ffffffff_ffffffcf_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_fcffffff_ffffffff_ffffffff_ffffffff	; //{{8{1'b1}} , {496{1'b0}} , {8{1'b1}}};
	reg [511:0] RAW_DATA_21 = 512'hfffeffff_00000000_00001000_00000000_00000000_00000000_00000000_00000000_00000000_00000100_00000000_00000000_00000000_00000000_00000000_ffffffff	; //{{8{1'b1}} , {496{1'b0}} , {8{1'b1}}};
	reg [511:0] RAW_DATA_22 = 512'hffffffff_ffffffff_ffffffff_ffffffff_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_ffffffff_ffffffff_ffffffff_ffffffff	; //{{8{1'b1}} , {496{1'b0}} , {8{1'b1}}};
	reg [511:0] RAW_DATA_23 = 512'hffffffff_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_ffffffff	; //{{8{1'b1}} , {496{1'b0}} , {8{1'b1}}};
	function automatic [31:0] return_bram_data;
		input [12:0] addr;
		begin
			// TODO: Need to read raw data from a file!	
			case(addr[12:4])
				9'd18:
					case(addr[3:0]) //ref row data
						4'd0:  return_bram_data=RAW_DATA_18[511:480];
						4'd1:  return_bram_data=RAW_DATA_18[479:448];
						4'd2:  return_bram_data=RAW_DATA_18[447:416];
						4'd3:  return_bram_data=RAW_DATA_18[415:384];
						4'd4:  return_bram_data=RAW_DATA_18[383:352];
						4'd5:  return_bram_data=RAW_DATA_18[351:320];
						4'd6:  return_bram_data=RAW_DATA_18[319:288];
						4'd7:  return_bram_data=RAW_DATA_18[287:256];
						4'd8:  return_bram_data=RAW_DATA_18[255:224];
						4'd9:  return_bram_data=RAW_DATA_18[223:192];
						4'd10: return_bram_data=RAW_DATA_18[191:160];
						4'd11: return_bram_data=RAW_DATA_18[159:128];
						4'd12: return_bram_data=RAW_DATA_18[127:96];
						4'd13: return_bram_data=RAW_DATA_18[95:64];
						4'd14: return_bram_data=RAW_DATA_18[63:32];
						4'd15: return_bram_data=RAW_DATA_18[31:0];
						default: return_bram_data=32'hffff_ffff;
					endcase
				9'd19:
					case(addr[3:0]) //ref row data
						4'd0:  return_bram_data=RAW_DATA_19[511:480];
						4'd1:  return_bram_data=RAW_DATA_19[479:448];
						4'd2:  return_bram_data=RAW_DATA_19[447:416];
						4'd3:  return_bram_data=RAW_DATA_19[415:384];
						4'd4:  return_bram_data=RAW_DATA_19[383:352];
						4'd5:  return_bram_data=RAW_DATA_19[351:320];
						4'd6:  return_bram_data=RAW_DATA_19[319:288];
						4'd7:  return_bram_data=RAW_DATA_19[287:256];
						4'd8:  return_bram_data=RAW_DATA_19[255:224];
						4'd9:  return_bram_data=RAW_DATA_19[223:192];
						4'd10: return_bram_data=RAW_DATA_19[191:160];
						4'd11: return_bram_data=RAW_DATA_19[159:128];
						4'd12: return_bram_data=RAW_DATA_19[127:96];
						4'd13: return_bram_data=RAW_DATA_19[95:64];
						4'd14: return_bram_data=RAW_DATA_19[63:32];
						4'd15: return_bram_data=RAW_DATA_19[31:0];
						default: return_bram_data=32'hffff_ffff;
					endcase
				9'd20:
					case(addr[3:0]) //ref row data
						4'd0:  return_bram_data=RAW_DATA_20[511:480];
						4'd1:  return_bram_data=RAW_DATA_20[479:448];
						4'd2:  return_bram_data=RAW_DATA_20[447:416];
						4'd3:  return_bram_data=RAW_DATA_20[415:384];
						4'd4:  return_bram_data=RAW_DATA_20[383:352];
						4'd5:  return_bram_data=RAW_DATA_20[351:320];
						4'd6:  return_bram_data=RAW_DATA_20[319:288];
						4'd7:  return_bram_data=RAW_DATA_20[287:256];
						4'd8:  return_bram_data=RAW_DATA_20[255:224];
						4'd9:  return_bram_data=RAW_DATA_20[223:192];
						4'd10: return_bram_data=RAW_DATA_20[191:160];
						4'd11: return_bram_data=RAW_DATA_20[159:128];
						4'd12: return_bram_data=RAW_DATA_20[127:96];
						4'd13: return_bram_data=RAW_DATA_20[95:64];
						4'd14: return_bram_data=RAW_DATA_20[63:32];
						4'd15: return_bram_data=RAW_DATA_20[31:0];
						default: return_bram_data=32'hffff_ffff;
					endcase
				9'd21:
					case(addr[3:0]) //ref row data
						4'd0:  return_bram_data=RAW_DATA_21[511:480];
						4'd1:  return_bram_data=RAW_DATA_21[479:448];
						4'd2:  return_bram_data=RAW_DATA_21[447:416];
						4'd3:  return_bram_data=RAW_DATA_21[415:384];
						4'd4:  return_bram_data=RAW_DATA_21[383:352];
						4'd5:  return_bram_data=RAW_DATA_21[351:320];
						4'd6:  return_bram_data=RAW_DATA_21[319:288];
						4'd7:  return_bram_data=RAW_DATA_21[287:256];
						4'd8:  return_bram_data=RAW_DATA_21[255:224];
						4'd9:  return_bram_data=RAW_DATA_21[223:192];
						4'd10: return_bram_data=RAW_DATA_21[191:160];
						4'd11: return_bram_data=RAW_DATA_21[159:128];
						4'd12: return_bram_data=RAW_DATA_21[127:96];
						4'd13: return_bram_data=RAW_DATA_21[95:64];
						4'd14: return_bram_data=RAW_DATA_21[63:32];
						4'd15: return_bram_data=RAW_DATA_21[31:0];
						default: return_bram_data=32'hffff_ffff;
					endcase
				9'd22:
					case(addr[3:0]) //ref row data
						4'd0:  return_bram_data=RAW_DATA_22[511:480];
						4'd1:  return_bram_data=RAW_DATA_22[479:448];
						4'd2:  return_bram_data=RAW_DATA_22[447:416];
						4'd3:  return_bram_data=RAW_DATA_22[415:384];
						4'd4:  return_bram_data=RAW_DATA_22[383:352];
						4'd5:  return_bram_data=RAW_DATA_22[351:320];
						4'd6:  return_bram_data=RAW_DATA_22[319:288];
						4'd7:  return_bram_data=RAW_DATA_22[287:256];
						4'd8:  return_bram_data=RAW_DATA_22[255:224];
						4'd9:  return_bram_data=RAW_DATA_22[223:192];
						4'd10: return_bram_data=RAW_DATA_22[191:160];
						4'd11: return_bram_data=RAW_DATA_22[159:128];
						4'd12: return_bram_data=RAW_DATA_22[127:96];
						4'd13: return_bram_data=RAW_DATA_22[95:64];
						4'd14: return_bram_data=RAW_DATA_22[63:32];
						4'd15: return_bram_data=RAW_DATA_22[31:0];
						default: return_bram_data=32'hffff_ffff;
					endcase
				9'd23:
					case(addr[3:0]) //ref row data
						4'd0:  return_bram_data=RAW_DATA_23[511:480];
						4'd1:  return_bram_data=RAW_DATA_23[479:448];
						4'd2:  return_bram_data=RAW_DATA_23[447:416];
						4'd3:  return_bram_data=RAW_DATA_23[415:384];
						4'd4:  return_bram_data=RAW_DATA_23[383:352];
						4'd5:  return_bram_data=RAW_DATA_23[351:320];
						4'd6:  return_bram_data=RAW_DATA_23[319:288];
						4'd7:  return_bram_data=RAW_DATA_23[287:256];
						4'd8:  return_bram_data=RAW_DATA_23[255:224];
						4'd9:  return_bram_data=RAW_DATA_23[223:192];
						4'd10: return_bram_data=RAW_DATA_23[191:160];
						4'd11: return_bram_data=RAW_DATA_23[159:128];
						4'd12: return_bram_data=RAW_DATA_23[127:96];
						4'd13: return_bram_data=RAW_DATA_23[95:64];
						4'd14: return_bram_data=RAW_DATA_23[63:32];
						4'd15: return_bram_data=RAW_DATA_23[31:0];
						default: return_bram_data=32'hffff_ffff;
					endcase
				default:
					case(addr[3:0])
						4'd0:  return_bram_data=RAW_DATA_20[511:480];
						4'd1:  return_bram_data=RAW_DATA_20[479:448];
						4'd2:  return_bram_data=RAW_DATA_20[447:416];
						4'd3:  return_bram_data=RAW_DATA_20[415:384];
						4'd4:  return_bram_data=RAW_DATA_20[383:352];
						4'd5:  return_bram_data=RAW_DATA_20[351:320];
						4'd6:  return_bram_data=RAW_DATA_20[319:288];
						4'd7:  return_bram_data=RAW_DATA_20[287:256];
						4'd8:  return_bram_data=RAW_DATA_20[255:224];
						4'd9:  return_bram_data=RAW_DATA_20[223:192];
						4'd10: return_bram_data=RAW_DATA_20[191:160];
						4'd11: return_bram_data=RAW_DATA_20[159:128];
						4'd12: return_bram_data=RAW_DATA_20[127:96];
						4'd13: return_bram_data=RAW_DATA_20[95:64];
						4'd14: return_bram_data=RAW_DATA_20[63:32];
						4'd15: return_bram_data=RAW_DATA_20[31:0];
						default: return_bram_data=32'hffff_ffff;
					endcase
					
			endcase
		end
	endfunction

endmodule