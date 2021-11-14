module sync_dual_mem(Clk, WE_A, WE_B, Addr_A, Addr_B, WrData_A, WrData_B, RdData_A, RdData_B);
  parameter DATA_WIDTH = 32;
  parameter ADDR_WIDTH = 10;
  
  input Clk;
  input WE_A, WE_B;
  input [ADDR_WIDTH-1:0] Addr_A, Addr_B;
  input [DATA_WIDTH-1:0] WrData_A, WrData_B;
  output reg [DATA_WIDTH-1:0] RdData_A, RdData_B;

  reg [DATA_WIDTH-1:0] mem [1<<ADDR_WIDTH];
  
  always @(posedge Clk)
    if (WE_A)
      mem[Addr_A] <= WrData_A;
  
  always @(posedge Clk)
    if (~WE_A)
      RdData_A <= mem[Addr_A];
    else
      RdData_A <= {DATA_WIDTH{1'bx}};
  
  
  always @(posedge Clk)
    if (WE_B)
      mem[Addr_B] <= WrData_B;
  
  always @(posedge Clk)
    if (~WE_B)
      RdData_B <= mem[Addr_B];
    else
      RdData_B <= {DATA_WIDTH{1'bx}};
  
endmodule