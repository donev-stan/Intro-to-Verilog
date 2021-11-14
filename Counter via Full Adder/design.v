module my_and (
	output y,
  	input x1, x2
);
  assign y = x1 & x2;
endmodule

module my_or (
	output y,
  	input x1, x2
);
  assign y = x1 | x2;
endmodule

module my_xor (
	output y,
  	input x1, x2
);
  assign y = x1 ^ x2;
endmodule

module full_adder (
	input A, B, Cin,
  	output S, Cout
);
  
  wire W0, W1, W2;
  
  xor u_xor0 (W0,A,B);
  xor u_xor1 (S,W0,Cin);
  and u_and0 (W2,A,B);
  and u_and1 (W1,Cin,W0);
  or u_or0 (Cout,W1,W2);
  
endmodule

module counter (
  input clock, reset,
  output reg [3:0] cntr
);
  
  wire [3:0] adder_output, carry;
  
  always @(posedge clock)
    if (reset == 0)
      cntr <= 0;
    else
      cntr <= adder_output;
  
  full_adder u_full_adder0 (
    .Cout(carry[0]),
    .S(adder_output[0]),
    .A(cntr[0]),
    .B(1),
    .Cin(0)
  );
  
  full_adder u_full_adder1 (
    .Cout(carry[1]),
    .S(adder_output[1]),
    .A(cntr[1]),
    .B(0),
    .Cin(carry[0])
  );
  
  full_adder u_full_adder2 (
    .Cout(carry[2]),
    .S(adder_output[2]),
    .A(cntr[2]),
    .B(0),
    .Cin(carry[1])
  );
  
  full_adder u_full_adder3 (
    .Cout(carry[3]),
    .S(adder_output[3]),
    .A(cntr[3]),
    .B(0),
    .Cin(carry[2])
  );
  
endmodule