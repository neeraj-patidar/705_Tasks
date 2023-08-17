module vga_controller (clk25mz, hsync, vsync, red,green,blue );
  input clk25mz; output reg [2:0] red=0, green=0; output reg [1:0] blue=0;
  output reg hsync=1, vsync=1;   
  localparam DISPLAY_W=128; localparam DISPLAY_H=128; localparam WidthTotal=288; localparam HeightTotal=173; 
  localparam FrontPorchH=16; localparam BackPorchH=48; localparam W_Hsync=96; 
  localparam FrontPorchV=10; localparam BackPorchV=33; localparam W_Vsync=2;
  integer frame = 0; 
  reg [10:0] hcount=0; reg [10:0] vcount=0; reg paint_flag=0;
  localparam [7:0] pixel=8'hAA ;
  always@(posedge clk25mz) begin
    if (hcount < WidthTotal-1) hcount <= hcount+1;
    else begin hcount<=0;  if (vcount < HeightTotal-1) vcount <= vcount+1; else begin vcount <= 0; frame <= frame+1; end end 
  end 
  always@(posedge clk25mz) begin
    if (hcount > (DISPLAY_W+FrontPorchH) && hcount <=(DISPLAY_W+FrontPorchH+W_Hsync)) begin
      hsync <= 0; // $display("hsync pulse active-low") ;
    end else hsync <= 1;
  end
  always@(posedge clk25mz) begin
    if ( vcount > FrontPorchV  && vcount < (FrontPorchV+W_Vsync)) vsync <= 0; else vsync <= 1;
  end
  always@(posedge clk25mz) begin
    if ( vcount <= FrontPorchV+W_Vsync+BackPorchV + 60+frame*10 || vcount > FrontPorchV+W_Vsync+BackPorchV + 20 + 60+frame*10) begin 
      paint_flag <= 0;
    end else begin if (hcount > 60+frame*10 && hcount < 60 +20+frame*10) paint_flag <= 1; else paint_flag <= 0; end
  end
  always@(posedge clk25mz) begin
    if (paint_flag) begin {red, green, blue} <= pixel ; end
    else  begin red   <= 3'b0; green <= 3'b0; blue  <= 2'b0; end              
  end
endmodule

module test_VGA_top_module ;
  reg clk25mz = 0; wire hsync; wire vsync; wire [2:0] red; wire [2:0] green; wire [1:0] blue; 
  vga_controller  dut (clk25mz, hsync, vsync, red,green, blue); 
  always #20 clk25mz = ~ clk25mz ;
  integer fp ;
  initial begin
    //$dumpvars() ;
    fp = $fopen("write_vga_log1.txt","w") ;
    //$display( "fp is %d ", fp ); //$display( "Hello");
    clk25mz=0 ;
    //$fdisplay(fp,"hello") ;
    repeat ( 500000 ) begin
      #10 ;
      $fdisplay(fp, "%08t ns: %b %b %03b %03b %02b", $time, hsync, vsync, red, green, blue  ) ; 
      @( posedge clk25mz) ;
    end 
    #100 ;
    //$fclose(fp) ;
    #100 $finish;
  end
endmodule 
