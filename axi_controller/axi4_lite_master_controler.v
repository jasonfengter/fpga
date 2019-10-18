module axi4_lite_master_controler (
	input clk,
	input arst_n  ,
	
	input [31:0] wr_addr ,
	input [31:0] wr_data ,
	input wr_valid,
	output wr_ready,
	
	input [31:0] rd_addr,
	output [31:0] rd_data,
	input rd_valid,
	output rd_ready,
	
	
	// AXI4-Lite Master interface
	//output 			m_aclk					,      // input wire s_aclk
	//output 		 	m_aresetn			,      // input wire s_aresetn
	output [31:0] 	m_axi_awaddr		,   // input wire [31 : 0] s_axi_awaddr
	output 			m_axi_awvalid			,  // input wire s_axi_awvalid
	input 			m_axi_awready				,  // output wire s_axi_awready
	output [31:0] 	m_axi_wdata		,    // input wire [31 : 0] s_axi_wdata
	output [3:0] 	m_axi_wstrb		,    // input wire [3 : 0] s_axi_wstrb
	output 			m_axi_wvalid				,  // input wire s_axi_wvalid
	input			m_axi_wready				,  // output wire s_axi_wready
	input [1:0] 	m_axi_bresp			,    // output wire [1 : 0] s_axi_bresp
	input 			m_axi_bvalid				,   // output wire s_axi_bvalid
	output 			m_axi_bready				,   // input wire s_axi_bready
	output [31:0] 	m_axi_araddr		,   // input wire [31 : 0] s_axi_araddr
	output 			m_axi_arvalid			, // input wire s_axi_arvalid
	input 			m_axi_arready				, // output wire s_axi_arready
	input [31:0] 	m_axi_rdata		,    // output wire [31 : 0] s_axi_rdata
	input [1:0] 	m_axi_rresp			,    // output wire [1 : 0] s_axi_rresp
	input 			m_axi_rvalid				,   // output wire s_axi_rvalid
	output 			m_axi_rready				  // input wire s_axi_rready
	
	
);

//assign m_aclk = clk;
//assign m_aresetn = arst_n ;

// axi4-lite write controller
axi4_lite_wr u_axi4_lite_wr (
// User Interface
.wr_addr			(wr_addr),
.wr_data			(wr_data),
.wr_valid			(wr_valid),
.wr_ready			(wr_ready),

// AXI4-Lite Write Interface, reverse direction wrt. AXI device slave side			
.s_axi_awaddr		(m_axi_awaddr	),    // input wire [31 : 0] s_axi_awaddr
.s_axi_awvalid		(m_axi_awvalid	),  // input wire s_axi_awvalid
.s_axi_awready		(m_axi_awready	),  // output wire s_axi_awready
.s_axi_wdata		(m_axi_wdata	),      // input wire [31 : 0] s_axi_wdata
.s_axi_wstrb		(m_axi_wstrb	),      // input wire [3 : 0] s_axi_wstrb
.s_axi_wvalid		(m_axi_wvalid	),    // input wire s_axi_wvalid
.s_axi_wready		(m_axi_wready	),    // output wire s_axi_wready
.s_axi_bresp		(m_axi_bresp	),      // output wire [1 : 0] s_axi_bresp
.s_axi_bvalid		(m_axi_bvalid	),    // output wire s_axi_bvalid
.s_axi_bready		(m_axi_bready	),    // input wire s_axi_bready

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
.s_axi_araddr			(m_axi_araddr	),    // input wire [31 : 0] s_axi_araddr
.s_axi_arvalid			(m_axi_arvalid	),  // input wire s_axi_arvalid
.s_axi_arready			(m_axi_arready	),  // output wire s_axi_arready
.s_axi_rdata			(m_axi_rdata	),      // output wire [31 : 0] s_axi_rdata
.s_axi_rresp			(m_axi_rresp	),      // output wire [1 : 0] s_axi_rresp
.s_axi_rvalid			(m_axi_rvalid	),    // output wire s_axi_rvalid
.s_axi_rready			(m_axi_rready	),    // input wire s_axi_rready

// Clock and reset
.clk					(clk),
.arst_n					(arst_n)


);




endmodule