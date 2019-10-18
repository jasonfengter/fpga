module top(
	i_clk,
	i_rstn,
	i_trig,
	o_done,
	
	// BRAM rd data/control bus
	o_rd_from_bram_addr,	// 13b
	i_rd_from_bram_data,	// 32b
	o_rd_from_bram_trig,
	i_rd_from_bram_done,
	// BRAM wr data/control bus
	o_wr_to_bram_addr,		// 13b
	o_wr_to_bram_data,		// 32b
	o_wr_to_bram_trig,
	i_wr_to_bram_done,
	
	i_start_row_num		// Starting row# 9b (0..511)

);
	input i_clk;
	input i_rstn;
	input i_trig;
	output  o_done;
	
	// BRAM rd data/control bus
	output [12:0] o_rd_from_bram_addr;	// 13b
	input [31:0] i_rd_from_bram_data;	// 32b
	output o_rd_from_bram_trig;
	input i_rd_from_bram_done;
	// BRAM wr data/control bus
	output [12:0] o_wr_to_bram_addr;		// 13b
	output [31:0] o_wr_to_bram_data;		// 32b
	output o_wr_to_bram_trig;
	input i_wr_to_bram_done;
	// Input start row #
	input [8:0] 	i_start_row_num;		// 9b
	
	
	
	
	// Inst for start line search IP
	reg r_i_trig_u_start_line_search;
	wire w_o_done_u_start_line_search;
	
	// Below wire will be connected a mux
	wire [12:0] o_rd_from_bram_addr_u_sls;
	//wire [31:0] i_rd_from_bram_data_u_sls;
	wire 		o_rd_from_bram_trig_u_sls;
	//wire 		i_rd_from_bram_done_u_sls;
	
	wire [12:0] o_wr_to_bram_addr_u_sls;
	wire [31:0] o_wr_to_bram_data_u_sls;
	wire 		o_wr_to_bram_trig_u_sls;
	//wire 		i_wr_to_bram_done_u_sls;
	// END
	
	// Output 512b mask data
	wire [511:0] 	w_o_512b_mask	;			//512b
	
	start_line_search u_start_line_search(
		.i_clk(i_clk),
		.i_rstn(i_rstn),
		.i_trig(r_i_trig_u_start_line_search),
		.o_done(w_o_done_u_start_line_search),
		// Input start row #
		.i_start_row_num(i_start_row_num),		// 9b
		// BRAM rd data/ctrl bus
		.o_rd_from_bram_addr(o_rd_from_bram_addr_u_sls),	// 13b
		.i_rd_from_bram_data(i_rd_from_bram_data),	// 32b
		.o_rd_from_bram_trig(o_rd_from_bram_trig_u_sls),
		.i_rd_from_bram_done(i_rd_from_bram_done),
		// BRAM wr data/ctrl bus
		.o_wr_to_bram_addr(o_wr_to_bram_addr_u_sls),		// 13b
		.o_wr_to_bram_data(o_wr_to_bram_data_u_sls),		// 32b
		.o_wr_to_bram_trig(o_wr_to_bram_trig_u_sls),
		.i_wr_to_bram_done(i_wr_to_bram_done),
	
		// Output 512b mask data
		.o_512b_mask(w_o_512b_mask)			//512b
	);

	// Inst for boundary_search IP
	
	wire [12:0] o_rd_from_bram_addr_u_bs;
	//wire [31:0] i_rd_from_bram_data_u_bs;
	wire 		o_rd_from_bram_trig_u_bs;
	//wire 		i_rd_from_bram_done_u_bs;
	
	wire [12:0] o_wr_to_bram_addr_u_bs;
	wire [31:0] o_wr_to_bram_data_u_bs;
	wire 		o_wr_to_bram_trig_u_bs;
	//wire 		i_wr_to_bram_done_u_bs;
	
	reg r_i_trig_u_bs;
	wire w_o_done_u_bs;
	
	boundary_search u_boundary_search(
	
		.i_clk(i_clk),
		.i_rstn(i_rstn),
		.i_trig(r_i_trig_u_bs),
		.o_done(w_o_done_u_bs),
		.i_MAX_INTERVAL(4'd5),	//4bit
		// to TOP BRAM rd controller ctrl bus
		.u_rd_512b_from_bram_o_rd_from_bram_addr(o_rd_from_bram_addr_u_bs),
		.u_rd_512b_from_bram_i_rd_from_bram_data(i_rd_from_bram_data),
		.u_rd_512b_from_bram_o_rd_from_bram_trig(o_rd_from_bram_trig_u_bs),
		.u_rd_512b_from_bram_i_rd_from_bram_done(i_rd_from_bram_done),
		
		.row_num_to_start(i_start_row_num),	// 9bit
		.i_start_row_512b_data(w_o_512b_mask),
		
		// to TOP BRAM wr controller ctrl bus 
		.u_wr_512b_to_bram_o_wr_to_bram_addr(o_wr_to_bram_addr_u_bs),
		.u_wr_512b_to_bram_o_wr_to_bram_data(o_wr_to_bram_data_u_bs),
		.u_wr_512b_to_bram_o_wr_to_bram_trig(o_wr_to_bram_trig_u_bs),
		.u_wr_512b_to_bram_i_wr_to_bram_done(i_wr_to_bram_done)

    );
	
	reg r_sel_for_sls_or_bs; // mux select port for start-line-search and boundary_search BRAM rd/wr output ports
	assign o_rd_from_bram_addr = (r_sel_for_sls_or_bs==1'b0) ? o_rd_from_bram_addr_u_sls : o_rd_from_bram_addr_u_bs;
	assign o_rd_from_bram_trig = (r_sel_for_sls_or_bs==1'b0) ? o_rd_from_bram_trig_u_sls : o_rd_from_bram_trig_u_bs;
	assign o_wr_to_bram_addr   = (r_sel_for_sls_or_bs==1'b0) ? o_wr_to_bram_addr_u_sls : o_wr_to_bram_addr_u_bs;
	assign o_wr_to_bram_data   = (r_sel_for_sls_or_bs==1'b0) ? o_wr_to_bram_data_u_sls : o_wr_to_bram_data_u_bs;
	assign o_wr_to_bram_trig   = (r_sel_for_sls_or_bs==1'b0) ? o_wr_to_bram_trig_u_sls : o_wr_to_bram_trig_u_bs;
	
	
	// GUIDELINE: o_done must be pull-down when i_trig is down!!!
	reg o_done_pre;
	assign o_done = o_done_pre & i_trig;
	
	reg [3:0] sm_state;
	localparam	IDLE=0,
				START_LINE_SEARCH=1,
				BOUNDARY_SEARCH=2,
				DONE=15;
				
	always@(posedge i_clk or negedge i_rstn) begin
		if(i_rstn==1'b0)
			begin
				sm_state<=IDLE;
				o_done_pre<=1'b0;
				//Reset BRAM output port swtich
				r_sel_for_sls_or_bs<=1'b0;	//0-start-line-search
				//Reset sls IP
				r_i_trig_u_start_line_search<=1'b0;
				// Reset bs IP
				r_i_trig_u_bs<=1'b0;
				
			end
		else
			begin
				case(sm_state)
					IDLE:
						begin
							//Reset BRAM output port swtich
							r_sel_for_sls_or_bs<=1'b0;	//0-start-line-search
							//Reset sls IP
							r_i_trig_u_start_line_search<=1'b0;
							// Reset bs IP
							r_i_trig_u_bs<=1'b0;
							// Reset module o_done
							o_done_pre<=1'b0;
							// Wait till module trig
							if(i_trig==1'b1) begin
								sm_state<=START_LINE_SEARCH;
							end
						end
					START_LINE_SEARCH:
						begin
							// Setup sls IP
							r_sel_for_sls_or_bs<=1'b0;	//0-start-line-search
							r_i_trig_u_start_line_search<=1'b1;
							// Wait till done signal
							if(w_o_done_u_start_line_search==1'b1) begin
								//Pull-down IP i_trig
								r_i_trig_u_start_line_search<=1'b0;
								sm_state<=BOUNDARY_SEARCH;
							end
						end
					BOUNDARY_SEARCH:
						begin
							// Setup bs IP
							r_i_trig_u_bs<=1'b1;
							r_sel_for_sls_or_bs<=1'b1;	//1-boundary_search
							// Wait till IP done signal
							if(w_o_done_u_bs==1'b1) begin
								// Pull-down IP trig
								r_i_trig_u_bs<=1'b0;
								sm_state<=DONE;
							end
							
						end
					DONE:
						begin
							o_done_pre<=1'b1;
							//Wait till trig pulled down
							if(i_trig==1'b0) begin
								o_done_pre<=1'b0;
								sm_state<=IDLE;
							end
						end
					default:
						sm_state<=IDLE;
				endcase
			end
			
	
	end
	
endmodule