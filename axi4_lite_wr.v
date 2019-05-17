
module axi4_lite_wr (
// User Interface
input	[31:0]	wr_addr,
input	[31:0]	wr_data,
input			wr_valid,
output			wr_ready,

// AXI4-Lite Write Interface, reverse direction wrt. AXI device slave side			


output	[31:0]		s_axi_awaddr		,    // input wire [31 : 0] s_axi_awaddr
output				s_axi_awvalid	,  // input wire s_axi_awvalid
input				s_axi_awready	,  // output wire s_axi_awready
output	[31:0]		s_axi_wdata		,      // input wire [31 : 0] s_axi_wdata
output 	[3:0] 		s_axi_wstrb		,      // input wire [3 : 0] s_axi_wstrb
output 				s_axi_wvalid		,    // input wire s_axi_wvalid
input 				s_axi_wready		,    // output wire s_axi_wready
output 	[1:0] 		s_axi_bresp		,      // output wire [1 : 0] s_axi_bresp
input 				s_axi_bvalid		,    // output wire s_axi_bvalid
output 				s_axi_bready		,    // input wire s_axi_bready

// Clock and reset
input				clk,
input				arst_n


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

always@(posedge clk or negedge arst_n) begin
	if (arst_n == 1'b0)
		current_state <= SM_IDLE;
	else begin
		case (current_state)
		
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


endmodule