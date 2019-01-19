`timescale 1ns/1ps

module TB_axis_m ();

default clocking cb @(posedge aclk);
endclocking

bit aclk, areset_n, send;
logic finish;

logic tready; 
logic tvalid, tlast;
logic [31:0] tdata;
logic [31:0] data;



axis_m inst_axis_m (.areset_n(areset_n), .aclk(aclk),
					.data(data),
					.send(send),
					.tready(tready), 
                    .tvalid(tvalid),.tlast(tlast),.tdata(tdata),
					.finish (finish)
					);
					
					
//wire pc_asserted ;
//wire [31 : 0] pc_status ;
/* axis_protocol_checker_0 inst_axiCheck (
  .aclk(aclk),                      // input wire aclk
  .aresetn(~areset_n),                // input wire aresetn
  .pc_axis_tvalid(tvalid),  // input wire pc_axis_tvalid
  .pc_axis_tready(tready),  // input wire pc_axis_tready
  .pc_axis_tdata({5'd0,tdata}),    // input wire [7 : 0] pc_axis_tdata
  .pc_asserted(pc_asserted),        // output wire pc_asserted
  .pc_status(pc_status)            // output wire [31 : 0] pc_status
); */					

initial 
 forever #2 aclk++;

initial
begin
    areset_n <= 0;
    ##4 areset_n <= 1;
end

initial
begin
##6    send = 1;
##1    send = 0;
##12    send = 1;
##1    send = 0;
end


initial
begin
    tready =0;
    ##15 tready = 1;
    ##1 tready = 0 ;
    ##8 tready = 1 ;
	##1 tready = 0 ;
end

initial
begin
data <=32'haaaa_bbbb;
##15
data <=32'hcccc_dddd;
end

initial 
##40 $finish;

endmodule
