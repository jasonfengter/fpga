module bram_top (
	input clk,
	input arst_n  ,
	
	input [31:0] wr_addr ,
	input [31:0] wr_data ,
	input wr_valid,
	output wr_ready,
	
	input [31:0] rd_addr,
	output [31:0] rd_data,
	input rd_valid,
	output rd_ready
	
	
);

wire [31:0] s_axi_awaddr	;wire s_axi_awvalid	;
wire s_axi_awready	;
wire [31:0] s_axi_wdata	;
wire [3:0] s_axi_wstrb	;
wire s_axi_wvalid	;
wire s_axi_wready	;
wire [1:0] s_axi_bresp	;
wire s_axi_bvalid	;
wire s_axi_bready	;
wire [31:0] s_axi_araddr	;
wire s_axi_arvalid  ;
wire s_axi_arready  ;
wire [31:0] s_axi_rdata	;
wire [1:0] s_axi_rresp	;
wire s_axi_rvalid	;
wire s_axi_rready	;

// axi4-lite write controller
axi4_lite_wr u_axi4_lite_wr (
// User Interface
.wr_addr			(wr_addr),
.wr_data			(wr_data),
.wr_valid			(wr_valid),
.wr_ready			(wr_ready),

// AXI4-Lite Write Interface, reverse direction wrt. AXI device slave side			
.s_axi_awaddr		(s_axi_awaddr	),    // input wire [31 : 0] s_axi_awaddr
.s_axi_awvalid		(s_axi_awvalid	),  // input wire s_axi_awvalid
.s_axi_awready		(s_axi_awready	),  // output wire s_axi_awready
.s_axi_wdata		(s_axi_wdata	),      // input wire [31 : 0] s_axi_wdata
.s_axi_wstrb		(s_axi_wstrb	),      // input wire [3 : 0] s_axi_wstrb
.s_axi_wvalid		(s_axi_wvalid	),    // input wire s_axi_wvalid
.s_axi_wready		(s_axi_wready	),    // output wire s_axi_wready
.s_axi_bresp		(s_axi_bresp	),      // output wire [1 : 0] s_axi_bresp
.s_axi_bvalid		(s_axi_bvalid	),    // output wire s_axi_bvalid
.s_axi_bready		(s_axi_bready	),    // input wire s_axi_bready

// Clock and reset
.clk				(clk),
.arst_n             (arst_n)
);


//axi4-lite read controller
axi4_lite_rd u_axi4_lite_rd(
// User Interface
.rd_addr				(rd_addr),
.rd_data				(rd_data),
.rd_valid				(rd_valid),
.rd_ready				(rd_ready),

// AXI4-Lite Read Interface, reverse direction wrt. AXI device slave side			
.s_axi_araddr			(s_axi_araddr	),    // input wire [31 : 0] s_axi_araddr
.s_axi_arvalid			(s_axi_arvalid	),  // input wire s_axi_arvalid
.s_axi_arready			(s_axi_arready	),  // output wire s_axi_arready
.s_axi_rdata			(s_axi_rdata	),      // output wire [31 : 0] s_axi_rdata
.s_axi_rresp			(s_axi_rresp	),      // output wire [1 : 0] s_axi_rresp
.s_axi_rvalid			(s_axi_rvalid	),    // output wire s_axi_rvalid
.s_axi_rready			(s_axi_rready	),    // input wire s_axi_rready

// Clock and reset
.clk					(clk),
.arst_n					(arst_n)


);

//BRAM
blk_mem_gen_0 u_bram_0 (
  .rsta_busy			(),          // output wire rsta_busy
  .rstb_busy			(),          // output wire rstb_busy
  .s_aclk				(clk),                // input wire s_aclk
  .s_aresetn			(arst_n),          // input wire s_aresetn
  .s_axi_awaddr			(s_axi_awaddr),    // input wire [31 : 0] s_axi_awaddr
  .s_axi_awvalid		(s_axi_awvalid),  // input wire s_axi_awvalid
  .s_axi_awready		(s_axi_awready),  // output wire s_axi_awready
  .s_axi_wdata			(s_axi_wdata),      // input wire [31 : 0] s_axi_wdata
  .s_axi_wstrb			(s_axi_wstrb),      // input wire [3 : 0] s_axi_wstrb
  .s_axi_wvalid			(s_axi_wvalid),    // input wire s_axi_wvalid
  .s_axi_wready			(s_axi_wready),    // output wire s_axi_wready
  .s_axi_bresp			(s_axi_bresp),      // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid			(s_axi_bvalid),    // output wire s_axi_bvalid
  .s_axi_bready			(s_axi_bready),    // input wire s_axi_bready
  .s_axi_araddr			(s_axi_araddr),    // input wire [31 : 0] s_axi_araddr
  .s_axi_arvalid		(s_axi_arvalid),  // input wire s_axi_arvalid
  .s_axi_arready		(s_axi_arready),  // output wire s_axi_arready
  .s_axi_rdata			(s_axi_rdata),      // output wire [31 : 0] s_axi_rdata
  .s_axi_rresp			(s_axi_rresp),      // output wire [1 : 0] s_axi_rresp
  .s_axi_rvalid			(s_axi_rvalid),    // output wire s_axi_rvalid
  .s_axi_rready			(s_axi_rready)    // input wire s_axi_rready
);
endmodule