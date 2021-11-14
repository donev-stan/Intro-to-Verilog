module counter (
  input clock, reset,
  output reg [3:0] cntr
);
  
  wire [3:0] adder_output;
  
  always @(posedge clock)
    // Ресет сигналът е винаги първо условие в такова уравнение и в това условие участва само той
  if (reset == 0)
    cntr <= 0;
  else
    cntr <= adder_output;
  
  assign adder_output = cntr + 1;
  
endmodule