`timescale 1ns/1ps

module tb ();
  reg clk, rst, set_seed;
  reg [7:0] seed;
  wire prbs;
  
  parameter SIZE = 8; // 32
  parameter TAP1 = 7; // 31
  parameter TAP2 = 6; // 28
  
  prbs #(
    .SIZE(SIZE),
    .TAP1(TAP1),
    .TAP2(TAP2)
  )
  u_prbs (
    .clock(clk),
    .reset(rst),
    .prbs(prbs),
    .set_seed(set_seed),
    .seed(seed)
  );
  
  initial clk = 0;
  
  always
    #1 clk = ~clk;

  initial begin
    #1 
    	rst = 1;
    	set_seed <= 0;	
    
  	#1 
	    rst = 0;
    
    #4 
    	rst = 1;
    
    #10
    	set_seed <= 1;
        seed <= 8'b00001111;
    
    #20
    	set_seed <= 0;
    
    #30
    	set_seed <= 1;
        seed <= 8'b01001001;

    #50
    	set_seed <= 0;
    
    #80 
    	set_seed <= 1;
        seed <= 8'b01100010;
    
  end
  
  initial begin
    $dumpfile("dumb.vcd");
    $dumpvars;
              
    #1000 $finish();
  end
  
endmodule