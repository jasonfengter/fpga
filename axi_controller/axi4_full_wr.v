
module axi4_full_wr (
// User Interface
input	[31:0]	wr_addr,
input	[31:0]	wr_data,
input			wr_valid,
output			wr_ready,

// AXI4-Full Write Interface, reverse direction wrt. AXI device slave side			

output	[3:0]		m_axi_awid,
output	[31:0]		m_axi_awaddr		,    // input wire [31 : 0] s_axi_awaddr
output				m_axi_awvalid	,  // input wire s_axi_awvalid
input				m_axi_awready	,  // output wire s_axi_awready
output	[7:0]		m_axi_awlen,		// Total # of transfers = awlen + 1
output	[2:0]		m_axi_awsize,
output	[1:0]		m_axi_awburst,
output				m_axi_awlock,
output 	[3:0]		m_axi_awcache ,
output 	[2:0]		m_axi_awprot  ,
output 	[3:0]		m_axi_awqos   ,



output	[31:0]		m_axi_wdata		,      // input wire [31 : 0] s_axi_wdata
output 	[3:0] 		m_axi_wstrb		,      // input wire [3 : 0] s_axi_wstrb
output 				m_axi_wvalid		,    // input wire s_axi_wvalid
input 				m_axi_wready		,    // output wire s_axi_wready
output				m_axi_wlast,


output 	[1:0] 		m_axi_bresp		,      // output wire [1 : 0] s_axi_bresp
input 				m_axi_bvalid		,    // output wire s_axi_bvalid
output 				m_axi_bready		,    // input wire s_axi_bready

// Clock and reset
input				m_aclk,
input				m_arst_n


);

// State machine declaration
localparam 
		SM_IDLE		= 5'b00001,
		SM_WR_ADDR 	= 5'b00010,
		SM_WR_DATA 	= 5'b00100,
		SM_WAIT_ACK = 5'b01000,
		SM_WR_DONE 	= 5'b10000
		;

// State machine transition
reg [4:0] current_state;

always@(posedge m_aclk or negedge m_arst_n) begin
	if (m_arst_n == 1'b0)
		current_state <= SM_IDLE;
	else begin
		case (current_state)
			SM_IDLE:
				if (wr_valid == 1'b1)
					current_state <= SM_WR_ADDR;
			SM_WR_ADDR:
				if (m_axi_awready == 1'b1)
					current_state <= SM_WR_DATA;
			SM_WR_DATA:
				if (m_axi_wready == 1'b1)
					current_state <= SM_WAIT_ACK;
			SM_WAIT_ACK:
				if (m_axi_bvalid == 1'b1)
					current_state <= SM_WR_DONE;
			SM_WR_DONE:
				current_state <= SM_IDLE;
			default:
				current_state <= SM_IDLE;
		endcase
	end
	
	
end

// State machine flag
wire current_state_is_SM_IDLE 		= (current_state == SM_IDLE);
wire current_state_is_SM_WR_ADDR  	= (current_state == SM_WR_ADDR );
wire current_state_is_SM_WR_DATA  	= (current_state == SM_WR_DATA );
wire current_state_is_SM_WAIT_ACK 	= (current_state == SM_WAIT_ACK);
wire current_state_is_SM_WR_DONE  	= (current_state == SM_WR_DONE );

// State machine output

// wr_ready
assign wr_ready = (current_state_is_SM_WR_DONE);

// s_axi_awaddr (32bit)
assign m_axi_awaddr = (current_state_is_SM_WR_ADDR)? wr_addr : 32'h0;

// s_axi_awvalid
assign m_axi_awvalid = current_state_is_SM_WR_ADDR;

// s_axi_wdata (32bit)
assign m_axi_wdata = (current_state_is_SM_WR_DATA)? wr_data : 32'h0;
assign m_axi_wlast = current_state_is_SM_WR_DATA;

// s_axi_wstrb
assign m_axi_wstrb = 4'b1111;

// s_axi_wvalid
assign m_axi_wvalid = current_state_is_SM_WR_DATA;

//s_axi_bresp
// ?

//s_axi_bready
assign m_axi_bready = current_state_is_SM_WR_DATA | current_state_is_SM_WAIT_ACK;

assign m_axi_awid = 4'h0;
assign m_axi_awlen = 8'd0;  //Total = awlen + 1
assign m_axi_awsize = 3'b010; // Each transfer = 2^2 = 4Byte
assign m_axi_awburst = 2'b00; // Fixed address
assign m_axi_awlock = 1'b0;
assign m_axi_awcache = 4'b0000;  //Non-buffer Non-cache
assign m_axi_awprot  = 3'b000;
assign m_axi_awqos   = 4'b0000;


endmodule