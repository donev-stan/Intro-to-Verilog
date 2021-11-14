module tb ();
  
  reg A, B, C;
  wire [1:0] S;
  
  full_adder
  u_full_adder (
    .A(A),
    .B(B),
    .Cin(C),
    .S(S[0]),
    .Cout(S[1])
  );
  
  initial begin
    repeat (50)
      #10 {A,B,C} = $random();
    #10 $finish();
  end
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
  
endmodule