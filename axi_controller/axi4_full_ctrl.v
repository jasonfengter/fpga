module axi4_full_ctrl (
input 	[31:0] 	rd_addr,
output 	[31:0] 	rd_data,
input 			rd_valid,
output 			rd_ready,
input 	[31:0] 	wr_addr,
input 	[31:0] 	wr_data,
input  			wr_valid,
output 			wr_ready,

input 			m_aclk	,
input 			m_arst_n	,

output 	[31:0]		m_axi_araddr	,
output 				m_axi_arvalid	,
input 				m_axi_arready	,
input 	[31:0]		m_axi_rdata		,
input 	[1:0]		m_axi_rresp		,
input 				m_axi_rvalid	,
output 				m_axi_rready	,
output	[3:0] 		m_axi_arid		,
output	[7:0]		m_axi_arlen		,	
output	[2:0]		m_axi_arsize	,
output	[1:0]		m_axi_arburst	,
output				m_axi_arlock	,
output 	[3:0]		m_axi_arcache 	,
output 	[2:0]		m_axi_arprot  	,
output 	[3:0]		m_axi_arqos   	,

output	[3:0]		m_axi_awid		,
output	[31:0]		m_axi_awaddr	,
output				m_axi_awvalid	,
input				m_axi_awready	,
output	[7:0]		m_axi_awlen		,
output	[2:0]		m_axi_awsize	,
output	[1:0]		m_axi_awburst	,
output				m_axi_awlock	,
output 	[3:0]		m_axi_awcache 	,
output 	[2:0]		m_axi_awprot  	,
output 	[3:0]		m_axi_awqos   	,
output	[31:0]		m_axi_wdata		,
output 	[3:0] 		m_axi_wstrb		,
output 				m_axi_wvalid	,
input 				m_axi_wready	,
output				m_axi_wlast		,
output 	[1:0] 		m_axi_bresp		,
input 				m_axi_bvalid	,
output 				m_axi_bready	

);

axi4_lite_rd u_axi4_lite_rd (
//User Interface
// input	[31:0]		rd_addr,
// output	[31:0]		rd_data,
// input				rd_valid,
// output				rd_ready,		
// output 	[31:0]		m_axi_araddr			,    // input wire [31 : 0] m_axi_araddr
// output 				m_axi_arvalid		,  // input wire m_axi_arvalid
// input 				m_axi_arready		,  // output wire m_axi_arready
// input 	[31:0]		m_axi_rdata			,      // output wire [31 : 0] m_axi_rdata
// input 	[1:0]		m_axi_rresp			,      // output wire [1 : 0] m_axi_rresp
// input 				m_axi_rvalid			,    // output wire m_axi_rvalid
// output 				m_axi_rready			,    // input wire m_axi_rready
// output	[3:0] 		m_axi_arid,
// output	[7:0]		m_axi_arlen,		// Total # of transfers = awlen + 1
// output	[2:0]		m_axi_arsize,
// output	[1:0]		m_axi_arburst,
// output				m_axi_arlock,
// output 	[3:0]		m_axi_arcache ,
// output 	[2:0]		m_axi_arprot  ,
// output 	[3:0]		m_axi_arqos   ,
// input				m_aclk,
// input				m_arst_n

.rd_addr		(rd_addr		),
.rd_data		(rd_data		),
.rd_valid		(rd_valid		),
.rd_ready		(rd_ready		),		
.m_axi_araddr	(m_axi_araddr),
.m_axi_arvalid	(m_axi_arvalid),
.m_axi_arready	(m_axi_arready),
.m_axi_rdata	(m_axi_rdata	),	
.m_axi_rresp	(m_axi_rresp	),	
.m_axi_rvalid	(m_axi_rvalid),
.m_axi_rready	(m_axi_rready),
.m_axi_arid		(m_axi_arid		),
.m_axi_arlen	(m_axi_arlen	),	
.m_axi_arsize	(m_axi_arsize),
.m_axi_arburst	(m_axi_arburst),
.m_axi_arlock	(m_axi_arlock),
.m_axi_arcache 	(m_axi_arcache),
.m_axi_arprot  	(m_axi_arprot ),
.m_axi_arqos   	(m_axi_arqos  ),
.m_aclk			(m_aclk			),
.m_arst_n       (m_arst_n     )
);


axi4_full_wr u_axi4_full_wr (
// User Interface
// input	[31:0]		wr_addr			,
// input	[31:0]		wr_data			,
// input				wr_valid		,
// output				wr_ready		,
// output	[3:0]		m_axi_awid		,	
// output	[31:0]		m_axi_awaddr		,    // input wire [31 : 0] s_axi_awaddr
// output				m_axi_awvalid	,  // input wire s_axi_awvalid
// input				m_axi_awready	,  // output wire s_axi_awready
// output	[7:0]		m_axi_awlen		,		// Total # of transfers = awlen + 1
// output	[2:0]		m_axi_awsize	,
// output	[1:0]		m_axi_awburst	,
// output				m_axi_awlock	,
// output 	[3:0]		m_axi_awcache 	,
// output 	[2:0]		m_axi_awprot  	,
// output 	[3:0]		m_axi_awqos   	,
// output	[31:0]		m_axi_wdata		,      // input wire [31 : 0] s_axi_wdata
// output 	[3:0] 		m_axi_wstrb		,      // input wire [3 : 0] s_axi_wstrb
// output 				m_axi_wvalid		,    // input wire s_axi_wvalid
// input 				m_axi_wready		,    // output wire s_axi_wready
// output				m_axi_wlast		,
// output 	[1:0] 		m_axi_bresp		,      // output wire [1 : 0] s_axi_bresp
// input 				m_axi_bvalid		,    // output wire s_axi_bvalid
// output 				m_axi_bready		,    // input wire s_axi_bready
// input				m_aclk			,
// input				m_arst_n

.wr_addr			(wr_addr		),
.wr_data		    (wr_data		),
.wr_valid	        (wr_valid	  ),
.wr_ready	        (wr_ready	  ),
.m_axi_awid	        (m_axi_awid	  ),
.m_axi_awaddr       (m_axi_awaddr ),
.m_axi_awvalid      (m_axi_awvalid),
.m_axi_awready      (m_axi_awready),
.m_axi_awlen	    (m_axi_awlen	),
.m_axi_awsize       (m_axi_awsize ),
.m_axi_awburst      (m_axi_awburst),
.m_axi_awlock       (m_axi_awlock ),
.m_axi_awcache      (m_axi_awcache),
.m_axi_awprot       (m_axi_awprot ),
.m_axi_awqos        (m_axi_awqos  ),
.m_axi_wdata	    (m_axi_wdata	),
.m_axi_wstrb	    (m_axi_wstrb	),
.m_axi_wvalid       (m_axi_wvalid ),
.m_axi_wready       (m_axi_wready ),
.m_axi_wlast	    (m_axi_wlast	),
.m_axi_bresp	    (m_axi_bresp	),
.m_axi_bvalid       (m_axi_bvalid ),
.m_axi_bready       (m_axi_bready ),
.m_aclk		        (m_aclk		  ),
.m_arst_n           (m_arst_n     )
);

endmodule