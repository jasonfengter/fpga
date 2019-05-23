
module axi4_lite_rd (
// User Interface
input	[31:0]	rd_addr,
output	[31:0]	rd_data,
input			rd_valid,
output			rd_ready,

// AXI4-Lite Read Interface, reverse direction wrt. AXI device slave side			
output 	[31:0]	m_axi_araddr			,    // input wire [31 : 0] m_axi_araddr
output 			m_axi_arvalid		,  // input wire m_axi_arvalid
input 			m_axi_arready		,  // output wire m_axi_arready
input 	[31:0]	m_axi_rdata			,      // output wire [31 : 0] m_axi_rdata
input 	[1:0]	m_axi_rresp			,      // output wire [1 : 0] m_axi_rresp
input 			m_axi_rvalid			,    // output wire m_axi_rvalid
output 			m_axi_rready			,    // input wire m_axi_rready

output	[3:0] 		m_axi_arid,
output	[7:0]		m_axi_arlen,		// Total # of transfers = awlen + 1
output	[2:0]		m_axi_arsize,
output	[1:0]		m_axi_arburst,
output				m_axi_arlock,
output 	[3:0]		m_axi_arcache ,
output 	[2:0]		m_axi_arprot  ,
output 	[3:0]		m_axi_arqos   ,
// Clock and reset
input				m_aclk,
input				m_arst_n


);

assign m_axi_arid = 4'h0;
assign m_axi_arlen = 8'h0;
assign m_axi_arsize = 3'b010;
assign m_axi_arburst = 2'b00;
assign m_axi_arlock = 1'b0;
assign m_axi_arcache = 4'd0;
assign m_axi_arprot = 3'd0;
assign m_axi_arqos = 4'd0;

// State machine declaration
localparam 
		SM_IDLE		= 4'b0001,
		SM_RD_ADDR 	= 4'b0010,
		SM_WT_DATA 	= 4'b0100,
		SM_ACK_DATA = 4'b1000
		;

// State machine transition
reg [3:0] current_state;

always@(posedge m_aclk or negedge m_arst_n) begin
	if (m_arst_n == 1'b0)
		current_state <= SM_IDLE;
	else begin
		case (current_state)
			SM_IDLE:
				if (rd_valid == 1'b1)
					current_state <= SM_RD_ADDR;
			SM_RD_ADDR:
				if (m_axi_arready == 1'b1)
					current_state <= SM_WT_DATA;
			SM_WT_DATA:
				if (m_axi_rvalid == 1'b1)
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
always@(posedge m_aclk or negedge m_arst_n) begin
	if (m_arst_n == 1'b0) 
		rd_data_r <= 32'h0;
	else
		if (m_axi_rvalid == 1'b1)
			rd_data_r <= m_axi_rdata;
end
assign rd_data = (current_state_is_SM_ACK_DATA)? rd_data_r : 32'h0;
assign rd_ready = (current_state_is_SM_ACK_DATA);
assign m_axi_araddr = (current_state_is_SM_RD_ADDR)? rd_addr : 32'h0;
assign m_axi_arvalid = current_state_is_SM_RD_ADDR;
assign m_axi_rready = (current_state_is_SM_ACK_DATA);

endmodule