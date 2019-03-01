// Simple AXI-Stream Master
// Takes the data and sends it through the AXIS interface
// When send posedge happens, sends the data


`timescale 1us/1us

module axis_m ( input areset_n, 
				input aclk, 
				input [31:0] data, 
				input send,
				
				input tready, 
				output reg tvalid,
				output tlast, 
				output reg [31:0] tdata,
				
				output reg finish
			);


reg [31:0] data_buf; // buffer to keep the send data from change
always @ (posedge send or negedge areset_n)
	if (~areset_n)
		data_buf <= 0;
	else
		data_buf <= data;
		
reg send_pulse_1d,send_pulse_2d;
// just delay the send signal 
always @ (posedge aclk)
    if (~areset_n)
		{send_pulse_1d,send_pulse_2d } <= 2'b00;
	else 
		{send_pulse_1d,send_pulse_2d } <= {send, send_pulse_1d};
	
	
// handshake happened between master and slave
wire handshake;	
assign handshake  = tvalid & tready;
	
// tdata
always @ (posedge aclk)
    if (~areset_n)
        tdata <= 1'b0;	
	else
		if (handshake)
			tdata <= 0;
		else if (send_pulse_1d)
				tdata <= data_buf;
			else
				tdata <= tdata;
	
// tvalid
// as soon as the fifo becomes no empty the tvalid goes high
always @ (posedge aclk)
    if (~areset_n)
        tvalid <= 1'b0;
    else
		if (handshake)
			tvalid <= 1'b0;
		else
			if (send_pulse_1d )
				tvalid <= 1'b1;
			else 
				tvalid <= tvalid;
		
// tlast
// same behavioral as tvalid
assign tlast = tvalid;

// finish
always @ (posedge aclk)
    if (~areset_n)
        finish <= 1'b0;
	else
		if (send_pulse_1d)
			finish <= 1'b0;
		else
			if (handshake)
				finish <= 1'b1;
			else
				finish <= 1'b0;
	

endmodule
