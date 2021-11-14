module tb ();
  
  reg clock, reset;
  wire [3:0] cntr;
  
  counter
  u_counter (
    .clock(clock),
    .reset(reset),
    .cntr(cntr)
  );
  
  initial begin
    clock = 0;
  end
  
  always
    #5 clock = ~clock;
  
  initial begin
    #10 reset = 0;
    #20 reset = 1;
  end
  
  initial
    #500 $finish();
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
  
endmodule