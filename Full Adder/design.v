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