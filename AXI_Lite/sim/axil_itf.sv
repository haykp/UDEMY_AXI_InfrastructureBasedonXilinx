
interface axil_itf (
			input bit     aclk,
			input bit     aresetn
	  );
	  
	 /**************** Write Address Channel Signals ******************/
	  logic [32-1:0]         		   axi_awaddr;
	  logic [3-1:0]                    axi_awprot;
	  logic                            axi_awvalid;
	  logic                            axi_awready;
	  /**************** Write Data Channel Signals *******************/
	  logic [32-1:0]      			   axi_wdata;
	  logic [32/8-1:0]    			   axi_wstrb;
	  logic                            axi_wvalid;
	  logic                            axi_wready;
	  /**************** Write Response Channel Signals ***************/
	  logic [2-1:0]                    axi_bresp;
	  logic                            axi_bvalid;
	  logic                            axi_bready ;
	  /**************** Read Address Channel Signals ****************/
	  logic [32-1:0]       			   axi_araddr;
	  logic [3-1:0]                    axi_arprot;
	  logic                            axi_arvalid ;
	  logic                            axi_arready;
	  /**************** Read Data Channel Signals ********************/
	  logic [32-1:0]      			   axi_rdata;
	  logic [2-1:0]                    axi_rresp;
	  logic                            axi_rvalid;
	  logic                            axi_rready;
	  /**************** User Signals *******************************/
	  logic [32-1:0]					 app_waddr;
	  logic [32-1:0]					 app_wdata;
	  logic         					 app_wen;
	  
	  logic [32-1:0]					 app_raddr;
	  logic         					 app_ren;
	  logic [32-1:0]					 app_rdata;
	  logic                              app_wdone ;
	  logic                              app_werror ;
	  logic                              app_rdone ;
	  logic                              app_rerror ;
			  
endinterface

