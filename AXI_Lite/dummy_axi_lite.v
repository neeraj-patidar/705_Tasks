
module dummy_axi_lite( input axi_aclk,
					   input axi_aresetn,
					   input [3:0] axi_araddr,
					   input axi_arvalid,
					   input axi_rready,
					   output [31:0] axi_rdata,
					   output axi_rvalid,
					   output axi_arready);


integer i;

reg [31:0] data_rom [0:15];
reg r_rvalid, r_arready;
reg [3:0] r_addr;
reg [31:0] r_rdata;

localparam st_put_addr = 0;
localparam st_received_addr = 1;
localparam st_data_valid = 2;

reg [1:0] curr_st, next_st;

initial
begin
	data_rom[0] = 32'hAAAAAAAA;
	data_rom[1] = 32'h55555555;
	for(i=2;i<16;i=i+1)
	begin
		data_rom[i] = 32'h00000000;
	end
end


always @(posedge axi_aclk or negedge axi_aresetn) begin
	if (!axi_aresetn) 
	begin
		curr_st <= 2'b00;
	end

	else 
	begin
		curr_st <= next_st;
	end	
end

always @* begin

	next_st = curr_st;
	case(curr_st)
	
		st_put_addr:
		begin
			if (axi_arvalid) 
			begin
		      r_arready = 1'b1;
				next_st = st_received_addr;
			end
			
			else if(!axi_arvalid)
			begin
			   r_rvalid = 1'b0;
				r_arready = 1'b0;
				next_st = st_put_addr;
			end
		end

		st_received_addr:
		begin
			if(axi_arvalid && r_arready) 
			begin
				r_addr = axi_araddr;
			end
			
			else if(!axi_arvalid)
			begin
				r_arready = 1'b0;
				next_st = st_data_valid;
			end
		end

		st_data_valid:
		begin
			r_rdata = data_rom[r_addr];
			r_rvalid = 1'b1;
			next_st = st_put_addr;
		end

		
	endcase
	
end

assign axi_rdata = r_rdata;
assign axi_rvalid = r_rvalid;
assign axi_arready = r_arready;

endmodule
