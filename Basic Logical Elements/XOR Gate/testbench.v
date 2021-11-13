`timescale 1ns/1ps

module test_bench ();
  
  reg  tb_A, tb_B;
  wire tb_C;

  my_xor_gate u_my_xor_gate (
    .A(tb_A),
    .B(tb_B),
    .C(tb_C)
  );
  
  initial begin
    tb_A = 0;
    tb_B = 0;
    #10
    tb_A = 1;
    #20
    tb_B = 1;
    #10
    tb_B = 0;
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