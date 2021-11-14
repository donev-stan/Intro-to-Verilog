module sync_mem(Clk, WE, Addr, WrData, RdData);
  parameter DATA_WIDTH = 32;
  parameter ADDR_WIDTH = 10;
  
  input Clk;
  input WE;
  input [ADDR_WIDTH-1:0] Addr;
  input [DATA_WIDTH-1:0] WrData;
  output reg [DATA_WIDTH-1:0] RdData;

  reg [DATA_WIDTH-1:0] mem [1<<ADDR_WIDTH];
  
  always @(posedge Clk)
    if (WE)
      mem[Addr] <= WrData;
  
  always @(posedge Clk)
    if (~WE)
      RdData <= mem[Addr];
    else
      RdData <= {DATA_WIDTH{1'bx}};
  
endmodule