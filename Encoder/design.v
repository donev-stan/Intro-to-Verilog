module encoder #(parameter N = 3) (
  input [(1<<N)-1:0] X,
  output reg [N-1:0] Y
);
  
  integer i;
  
  always @(*) begin 
    // При always уравнение типът е винаги reg
    // * това означава при промяна на който и да е входен сигнал.
    Y = 0;
    for (i=0; i<(1<<N); i=i+1) 
      if (X[i])
        Y = i;
  end
endmodule