
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
			SM_IDLE:
				if (wr_valid == 1'b1)
					current_state <= SM_WR_ADDR;
			SM_WR_ADDR:
				if (s_axi_awready == 1'b1)
					current_state <= SM_WR_DATA;
			SM_WR_DATA:
				if (s_axi_wready == 1'b1)
					current_state <= SM_WAIT_ACK;
			SM_WAIT_ACK:
				if (s_axi_bvalid == 1'b1)
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
assign s_axi_awaddr = (current_state_is_SM_WR_ADDR)? wr_addr : 32'h0;

// s_axi_awvalid
assign s_axi_awvalid = current_state_is_SM_WR_ADDR;

// s_axi_wdata (32bit)
assign s_axi_wdata = (current_state_is_SM_WR_DATA)? wr_data : 32'h0;

// s_axi_wstrb
assign s_axi_wstrb = 4'b1111;

// s_axi_wvalid
assign s_axi_wvalid = current_state_is_SM_WR_DATA;

//s_axi_bresp
// ?

//s_axi_bready
assign s_axi_bready = current_state_is_SM_WR_DATA | current_state_is_SM_WAIT_ACK;

endmodule