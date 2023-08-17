
`timescale 1ns/1ps

module dummy_axi_lite_tb;

reg r_axi_aclk, r_axi_aresetn;
reg [3:0] r_axi_araddr;
reg r_axi_arvalid, r_axi_rready;

wire [31:0] w_axi_rdata;
wire w_axi_rvalid, w_axi_arready;

dummy_axi_lite  dut(.axi_aclk(r_axi_aclk),
				    .axi_aresetn(r_axi_aresetn),
				    .axi_araddr(r_axi_araddr),
				    .axi_arvalid(r_axi_arvalid),
				    .axi_rready(r_axi_rready),
				    .axi_rdata(w_axi_rdata),
				    .axi_rvalid(w_axi_rvalid),
				    .axi_arready(w_axi_arready));
initial 
begin
	r_axi_aclk = 0;
	forever #10 r_axi_aclk = ~ r_axi_aclk;
end

initial
begin
	r_axi_aresetn = 1'b1;
	#20;
	r_axi_aresetn = 1'b0;
	#40;
	r_axi_aresetn = 1'b1;
end

initial
begin
	r_axi_arvalid = 1'b0;
	#70;
	r_axi_arvalid = 1'b1;
	#40;
	r_axi_arvalid = 1'b0;
	#150;
	r_axi_arvalid = 1'b1;
	#40;
	r_axi_arvalid = 1'b0;
	
end

initial
begin
	r_axi_araddr = 4'b0000;
	#250;
	r_axi_araddr = 4'b0001;
end

initial
begin
	r_axi_rready = 1'b0;
end


endmodule 
