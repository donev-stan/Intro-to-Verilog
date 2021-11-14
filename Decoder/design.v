module decoder #(parameter N = 3) (
  input [N-1:0] X,
  output reg [(1<<N)-1:0] Y 
  // [(1<<N)-1:0] = [7:0] при N = 3
  // example:
  // 2^3 == 1 << 3 (единица shift-ната 3 бита наляво) -> 1000
  // 2^4 == 1 << 4 (единица shift-ната 4 бита наляво) -> 10000
);
  
  always @(*) begin
    Y = 0;
    Y[X] = 1;
  end
endmodule