`timescale 1ns/1ps

module tb ();
  reg clk, rst;
  wire prbs;
  
  prbs #(
    .SIZE(32),
    .TAP1(31),
    .TAP2(28)
  )
  u_prbs (
    .clock(clk),
    .reset(rst),
    .prbs(prbs)
  );
  
  initial clk = 0;
  
  always
    #1 clk = ~clk;

  initial begin
    #1 rst = 1;
  	#1 rst = 0;
    #4 rst = 1;
  end
  
  initial begin
    $dumpfile("dumb.vcd");
    $dumpvars;
              
    #10000 $finish();
  end
  
endmodule