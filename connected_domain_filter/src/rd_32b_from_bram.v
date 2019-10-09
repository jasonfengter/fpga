module rd_32b_from_bram (
	i_clk,
	i_rstn,
	i_rd_trig,  // read transaction signal 
	i_rd_addr,
	o_rd_data,
	o_rd_ack,	// read transaction signal  END
	
	o_bram_access_type,	// to top bram read controller 0=512bit, 1=32bit
	o_bram_rd_addr,		// bram direct read addr
	o_bram_rd_addr_ready,	// handshake ready signal
	i_bram_data_valid,	// handshake valid signal
	i_bram_data
	
);
	input i_clk;
	input i_rstn;
	input i_rd_trig;  // read transaction signal 
	input [12:0] i_rd_addr;
	output reg [31:0] o_rd_data;
	output reg o_rd_ack;	// read transaction signal  END
	
	output o_bram_access_type;	// to top bram read controller 0=512bit, 1=32bit
	output reg [12:0] o_bram_rd_addr;		// bram direct read addr
	output reg o_bram_rd_addr_ready;	// handshake ready signal
	input i_bram_data_valid;	// handshake valid signal
	input [31:0] i_bram_data;
	
	// State machine definition
	reg [3:0] sm_state;
	localparam	IDLE = 0,
				SEND_RD_CMD = 1,
				RCV_ACK = 2;
				
	assign o_bram_access_type = 1'b1;  // tied to 1
	
	// State machine transition
	always@(posedge i_clk or negedge i_rstn) begin
		if (i_rstn == 1'b0)
			begin
				sm_state <= IDLE;
				
				o_bram_rd_addr <= 13'h0;
				o_bram_rd_addr_ready <= 1'b0;
				
				o_rd_ack <= 1'b0;
				o_rd_data <= 32'h0;
			end
		else
			begin
				case (sm_state)
					IDLE:
						begin
							
							o_bram_rd_addr <= 13'h0;
							o_bram_rd_addr_ready <= 1'b0;
							
							o_rd_ack <= 1'b0;
							o_rd_data <= 32'h0;
							
							if (i_rd_trig == 1'b1)
								sm_state <= SEND_RD_CMD;
							else
								sm_state <= IDLE;

						end
					SEND_RD_CMD:
						begin
							// in this state, push signal: o_bram_access_type=1, o_bram_rd_addr=i_rd_addr, o_bram_rd_addr_ready=1
							
							o_bram_rd_addr <= i_rd_addr;
							o_bram_rd_addr_ready <= 1'b1;
							
							o_rd_ack <= 1'b0;
							o_rd_data <= 32'h0;
							
							if (i_bram_data_valid == 1'b1)
								sm_state <= RCV_ACK;
						end
					RCV_ACK:
						begin
							// in this state, o_rd_ack=1, o_rd_data=i_bram_data
							o_bram_rd_addr <= i_rd_addr;
							o_bram_rd_addr_ready <= 1'b1;
							
							o_rd_ack <= 1'b1;
							o_rd_data <= i_bram_data;
							
							if (i_rd_trig == 1'b0)
								sm_state <= IDLE;
						end
				
					default:
						begin
							sm_state <= IDLE;
						end
				endcase
			end
	
	end


endmodule