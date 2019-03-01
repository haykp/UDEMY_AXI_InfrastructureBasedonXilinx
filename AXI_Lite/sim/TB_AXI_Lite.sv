
import axi_vip_pkg::*;
import axi_vip_0_pkg::*;


module TB_AXI_Lite ();

// Clock signal
bit                   clock;
// Reset signal
bit                   reset;

// for AXIS-L slave VIP to work
//axi_vip_0_slv_t slv_agent; // define the agent, without memory
axi_vip_0_slv_mem_t slv_agent; // define the agent

initial
begin
	slv_agent = new("slv_agent",TB_AXI_Lite.inst_axil_s.inst.IF);
	slv_agent.start_slave();
end


axil_itf itf (.aclk(clock), .aresetn(~reset) );

axis_lite_m  inst_axil_m ( 
			  /**************** System Signals *******************************/
			 .aclk 				(	itf.aclk			),
			 .aresetn			(	itf.aresetn			),
			 /**************** Write Address Channel Signals ******************/
			 .m_axi_awaddr		(	itf.axi_awaddr	),
			 .m_axi_awprot		(	itf.axi_awprot	),
			 .m_axi_awvalid		(	itf.axi_awvalid  	),
			 .m_axi_awready		(	itf.axi_awready  	),
			  /**************** Write Data Channel Signals *******************/
			 .m_axi_wdata		(	itf.axi_wdata		),
			 .m_axi_wstrb		(	itf.axi_wstrb		),
			 .m_axi_wvalid		(	itf.axi_wvalid	),
			 .m_axi_wready		(	itf.axi_wready	),
			  /**************** Write Response Channel Signals ***************/
			 .m_axi_bresp		(	itf.axi_bresp		),
			 .m_axi_bvalid		(	itf.axi_bvalid   	),
			 .m_axi_bready		(	itf.axi_bready   	),
			  /**************** Read Address Channel Signals ****************/
			 .m_axi_araddr		(	itf.axi_araddr	),
			 .m_axi_arprot		(	itf.axi_arprot	),
			 .m_axi_arvalid		(	itf.axi_arvalid  	),
			 .m_axi_arready		(	itf.axi_arready  	),
			  /**************** Read Data Channel Signals ********************/
			 .m_axi_rdata		(	itf.axi_rdata		),
			 .m_axi_rresp		(	itf.axi_rresp    	),
			 .m_axi_rvalid		(	itf.axi_rvalid   	),
			 .m_axi_rready		(	itf.axi_rready   	),
			  /**************** User Signals *******************************/
			 .app_waddr			(	itf.app_waddr		),
			 .app_wdata			(	itf.app_wdata		),
			 .app_wen			(	itf.app_wen			),	
			 .app_wdone 		(	itf.app_wdone		),
			 .app_werror		(	itf.app_werror		),
			 
			 .app_raddr			(	itf.app_raddr		),
			 .app_ren			(	itf.app_ren			),	
			 .app_rdata			(	itf.app_rdata		),
			 .app_rdone 		(	itf.app_rdone		),
			 .app_rerror 		(	itf.app_rerror		)
			);

axi_vip_0 inst_axil_s (
			  .aclk				(itf.aclk),                    // input wire aclk
			  .aresetn			(itf.aresetn),              // input wire aresetn
			  .s_axi_awaddr		(itf.axi_awaddr),    // input wire [31 : 0] s_axi_awaddr
			  .s_axi_awprot		(itf.axi_awprot),    // input wire [2 : 0] s_axi_awprot
			  .s_axi_awvalid	(itf.axi_awvalid),  // input wire s_axi_awvalid
			  .s_axi_awready	(itf.axi_awready),  // output wire s_axi_awready
			  .s_axi_wdata		(itf.axi_wdata),      // input wire [31 : 0] s_axi_wdata
			  .s_axi_wstrb		(itf.axi_wstrb),      // input wire [3 : 0] s_axi_wstrb
			  .s_axi_wvalid		(itf.axi_wvalid),    // input wire s_axi_wvalid
			  .s_axi_wready		(itf.axi_wready),    // output wire s_axi_wready
			  .s_axi_bresp		(itf.axi_bresp),      // output wire [1 : 0] s_axi_bresp
			  .s_axi_bvalid		(itf.axi_bvalid),    // output wire s_axi_bvalid
			  .s_axi_bready		(itf.axi_bready),    // input wire s_axi_bready
			  .s_axi_araddr		(itf.axi_araddr),    // input wire [31 : 0] s_axi_araddr
			  .s_axi_arprot		(itf.axi_arprot),    // input wire [2 : 0] s_axi_arprot
			  .s_axi_arvalid	(itf.axi_arvalid),  // input wire s_axi_arvalid
			  .s_axi_arready	(itf.axi_arready),  // output wire s_axi_arready
			  .s_axi_rdata		(itf.axi_rdata),      // output wire [31 : 0] s_axi_rdata
			  .s_axi_rresp		(itf.axi_rresp),      // output wire [1 : 0] s_axi_rresp
			  .s_axi_rvalid		(itf.axi_rvalid),    // output wire s_axi_rvalid
			  .s_axi_rready		(itf.axi_rready)    // input wire s_axi_rready
);
   
	
task write_data (input logic [31:0] w_addr=32'haaaa_bbbb,
				 input logic [31:0] w_data=32'h5aa5_a55a);
	$display ("[INFO] Calling write_data task, addr=%h, data=%h", w_addr, w_data);
	
	itf.app_waddr <= w_addr;
	itf.app_wdata <= w_data;
	@ ( posedge itf.aclk);
	itf.app_wen <= 1'b1;
	@ ( posedge itf.aclk);
	itf.app_wen <= 1'b0;
	@ ( posedge itf.app_wdone);
	@ ( posedge itf.aclk);
	
	$display ("[INFO] END Calling write_data task");
endtask


task read_data ( input logic [31:0] r_addr=0 );
	$display ("[INFO]Calling read_data task for the address: %h", r_addr);
	
	itf.app_raddr <= r_addr;
	@ ( posedge itf.aclk);
		itf.app_ren <= 1'b1;
	@ ( posedge itf.aclk);
		itf.app_ren <= 1'b0;
	@ ( posedge itf.app_rdone);	
	@ ( posedge itf.aclk);
	
	$display ("[INFO] END Calling read_data task, read_data=%h", itf.app_rdata);
endtask	
	
	
////// MAIN	////
  initial begin
    reset <= 1'b1;
    repeat (5) @(negedge clock);
	reset <= 1'b0;
  end

    always #10 clock <= ~clock;	
	
	
	initial
	begin
		itf.app_ren <= 1'b0;
		itf.app_wen <= 1'b0;
		
		@ ( negedge reset);
		repeat (3) 
			@ ( posedge itf.aclk);
		
		
		//fork
			write_data (.w_addr (32'h1010_1111) ,
						.w_data (32'hdead_beef) );
			
			write_data (.w_addr (32'h0101_0000) ,
						.w_data (32'hfeed_c0de) );
						
			read_data (32'h1010_1111);
			read_data (32'h0101_0000);
			
			// read from previously backdoor initialized address
			read_data (32'haaaa_bbbb);
			read_data (32'h1111_0000);
		// join
		
		repeat (3) 
			@ ( posedge itf.aclk);
		
		$finish;
		
		
	end

// backdoor write to AXIL VIP memory
wire [3:0] wstrb_bd;
assign wstrb_bd = (itf.axi_awvalid && itf.axi_awready) ? 4'b1111 : 4'b0000;
	
	initial
	begin
		$display ("[INFO] Calling backdoor write strobe task");
		slv_agent.mem_model.backdoor_memory_write  (
			.addr (32'haaaa_bbbb),
			.payload (32'haaaa_bbbb),
			.strb (4'b1111)
	   );
	   slv_agent.mem_model.backdoor_memory_write  (
			.addr (32'h1111_0000),
			.payload (32'h1111_0000),
			.strb (4'b1111)
	   );
	   
	end
	
endmodule


// function void backdoor_memory_write(	
// input 	xil_axi_ulong 	addr,
// input logic 	[C_AXI_WDATA_WIDTH-1:0] 	payload,
// input logic 	[C_AXI_WDATA_WIDTH/8-1:0] 	strb 
// )

