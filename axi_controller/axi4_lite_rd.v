
module axi4_lite_rd (
// User Interface
input	[31:0]	rd_addr,
output	[31:0]	rd_data,
input			rd_valid,
output			rd_ready,

// AXI4-Lite Read Interface, reverse direction wrt. AXI device slave side			
output 	[31:0]	s_axi_araddr			,    // input wire [31 : 0] s_axi_araddr
output 			s_axi_arvalid		,  // input wire s_axi_arvalid
input 			s_axi_arready		,  // output wire s_axi_arready
input 	[31:0]	s_axi_rdata			,      // output wire [31 : 0] s_axi_rdata
input 	[1:0]	s_axi_rresp			,      // output wire [1 : 0] s_axi_rresp
input 			s_axi_rvalid			,    // output wire s_axi_rvalid
output 			s_axi_rready			,    // input wire s_axi_rready

// Clock and reset
input				clk,
input				arst_n


);

// State machine declaration
localparam 
		SM_IDLE		= 4'b0001,
		SM_RD_ADDR 	= 4'b0010,
		SM_WT_DATA 	= 4'b0100,
		SM_ACK_DATA = 4'b1000
		;

// State machine transition
reg [3:0] current_state;

always@(posedge clk or negedge arst_n) begin
	if (arst_n == 1'b0)
		current_state <= SM_IDLE;
	else begin
		case (current_state)
			SM_IDLE:
				if (rd_valid == 1'b1)
					current_state <= SM_RD_ADDR;
			SM_RD_ADDR:
				if (s_axi_arready == 1'b1)
					current_state <= SM_WT_DATA;
			SM_WT_DATA:
				if (s_axi_rvalid == 1'b1)
					current_state <= SM_ACK_DATA;
			SM_ACK_DATA:
				current_state <= SM_IDLE;
			default:
				current_state <= SM_IDLE;
		endcase
	end
	
	
end

// State machine flag
wire current_state_is_SM_IDLE		= (current_state == SM_IDLE	);
wire current_state_is_SM_RD_ADDR  	= (current_state == SM_RD_ADDR 	);
wire current_state_is_SM_WT_DATA  	= (current_state == SM_WT_DATA 	);
wire current_state_is_SM_ACK_DATA 	= (current_state == SM_ACK_DATA	);


// State machine output
reg [31:0] rd_data_r;
always@(posedge clk or negedge arst_n) begin
	if (arst_n == 1'b0) 
		rd_data_r <= 32'h0;
	else
		if (s_axi_rvalid == 1'b1)
			rd_data_r <= s_axi_rdata;
end
assign rd_data = (current_state_is_SM_ACK_DATA)? rd_data_r : 32'h0;
assign rd_ready = (current_state_is_SM_ACK_DATA);
assign s_axi_araddr = (current_state_is_SM_RD_ADDR)? rd_addr : 32'h0;
assign s_axi_arvalid = current_state_is_SM_RD_ADDR;
assign s_axi_rready = (current_state_is_SM_ACK_DATA);

endmodule