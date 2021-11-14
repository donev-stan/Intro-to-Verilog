module tb ();
  parameter N = 5;
  
  reg [N-1:0] X;
  wire [(1<<N)-1:0] Y;
  
  decoder 
  #(.N(N))
  u_decoder (
    .X(X),
    .Y(Y)
  );
  
  initial begin
    repeat (10)
      #10 X = $random();
    #10 $finish();
  end
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
  
endmodule