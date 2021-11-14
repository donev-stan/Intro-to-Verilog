`timescale 1ns/1ps

module test_bench ();
  
  parameter TB_WIDTH = 4;
  
  reg                 clock;
  reg  [TB_WIDTH-1:0] tb_a, tb_b;
  wire [TB_WIDTH-1:0]   tb_c;

  my_sync_module #(.WIDTH(TB_WIDTH)) u_my_sync_module (
    .clk(clock),
    .a(tb_a),
    .b(tb_b),
    .c(tb_c)
  );
  
  initial begin
    tb_a <= 0;
    tb_b <= 0;
    repeat (50) begin
      @(posedge clock);
      tb_a <= $random();
      tb_b <= $random();
    end
  end
  
  initial
    clock = 0;
  
  always
    #5 clock = ~clock;
  
  initial
    #1000 $finish();
  
  initial begin
 	$dumpfile("dump.vcd");
    $dumpvars;
  end
    
endmodule