module async_mem(WE, Addr, WrData, RdData);
  parameter DATA_WIDTH = 32;
  parameter ADDR_WIDTH = 10;
  
  input WE;
  input [ADDR_WIDTH-1:0] Addr;
  input [DATA_WIDTH-1:0] WrData;
  output [DATA_WIDTH-1:0] RdData;

  reg [DATA_WIDTH-1:0] mem [1<<ADDR_WIDTH];
  
  always @(*)
    if (WE)
      mem[Addr] <= WrData;
  
  assign RdData = mem[Addr];
  
endmodule