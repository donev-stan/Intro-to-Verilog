module test_bench ();
  
  reg clock, reset;
  reg serial_line;
  wire match;
  
  serial_line_fsm u_serial_line_fsm(
    .clock(clock),
    .reset(reset),
    .serial_line(serial_line),
    .match(match)
  );
  
  always @(posedge clock)
    serial_line = $random;
    
  initial
    clock = 0;

  always
    #1 clock = ~clock;

  
  initial begin
    reset = 1'b0;
    #10 reset = 1'b1;
  end
 
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #2000 $finish();
  end
 
endmodule