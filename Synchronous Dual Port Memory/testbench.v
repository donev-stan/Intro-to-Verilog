module tb ();
  
  parameter DATA_WIDTH = 32;
  parameter ADDR_WIDTH = 10;
  
  reg Clk;
  reg WE_A, WE_B;
  reg [ADDR_WIDTH-1:0] Addr_A, Addr_B;
  reg [DATA_WIDTH-1:0] WrData_A, WrData_B;
  wire [DATA_WIDTH-1:0] RdData_A, RdData_B;
  
  initial Clk = 0;
  always #1 Clk = ~Clk;
  
  sync_dual_mem #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
  )
  u_sync_dual_mem(
    .Clk(Clk),
    .WE_A(WE_A),
    .WE_B(WE_B),
    .Addr_A(Addr_A),
    .Addr_B(Addr_B),
    .WrData_A(WrData_A),
    .WrData_B(WrData_B),
    .RdData_A(RdData_A),
    .RdData_B(RdData_B)
  );
  
  initial begin
    WE_A <= 0;
    WE_B <= 0;
    
    WrData_A <= 0;
    WrData_B <= 0;
    
    for (int ii=0; ii<(1<<ADDR_WIDTH)-1; ii++)
      mem_write(ii);
    for (int ii=0; ii<(1<<ADDR_WIDTH)-1; ii++)
      mem_read(ii);
    $finish();
  end
  
  task mem_read(input [ADDR_WIDTH-1:0] read_addr);
    @(posedge Clk);
    WE_A <= 0;
    WE_B <= 0;
    
    Addr_A <= read_addr;
    Addr_B <= read_addr;
  endtask
  
  task mem_write(input [ADDR_WIDTH-1:0] write_addr);
    @(posedge Clk);
    WE_A <= 1;
    WE_B <= 1;
    
    WrData_A <= $random;
    WrData_B <= $random;
    
    Addr_A <= write_addr;
    Addr_B <= write_addr;
  endtask
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
  
endmodule