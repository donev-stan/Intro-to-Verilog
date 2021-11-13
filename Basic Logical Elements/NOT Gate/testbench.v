`timescale 1ns/1ps

module test_bench ();
  
  reg  tb_A;
  wire tb_C;

  my_not_gate u_my_not_gate (
    .A(tb_A),
    .C(tb_C)
  );
  
  initial begin
    tb_A = 0;
    #10
    tb_A = 1;
    #30
    tb_A = 0;
    #10
    $finish();
  end
  
  initial begin
 	$dumpfile("dump.vcd");
    $dumpvars;
  end
    
endmodule