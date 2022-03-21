// sync memory
module dual_port_memory(clk, we0, we1, addr0, addr1, wdata0, wdata1, rdata0, rdata1);

   parameter DATA_DEPTH = 3;
   parameter DATA_WIDTH = 8;

   input clk;
   input we0, we1;
   input [DATA_DEPTH-1:0] addr0, addr1; // [1:0]
   input [DATA_WIDTH-1:0] wdata0, wdata1; // [7:0]
   output reg [DATA_WIDTH-1:0] rdata0, rdata1; // [7:0]

   reg [DATA_WIDTH-1:0] memory [0:(1<<DATA_DEPTH)-1]; // [7:0] memory [0:7]   // (DATA_DEPTH^2)-1

   // Write data
   always @(posedge clk) begin
      if ((we0) & (we1) & (addr0 == addr1)) begin
	 memory[addr0] <= {DATA_WIDTH{1'bx}};
      end
      else begin
	 if (we0) 
	   memory[addr0] <= wdata0;

	 if (we1)
	   memory[addr1] <= wdata1;
      end
   end

   // Read data port 0
   always @(posedge clk) begin
      if ((~we0 & we1) & (addr0 == addr1))
	rdata0 <= {DATA_WIDTH{1'bx}};
      else
	rdata0 <= memory[addr0];
   end

   // Read data port 1
   always @(posedge clk) begin
      if ((~we1 & we0) & (addr0 == addr1))
	rdata1 <= {DATA_WIDTH{1'bx}};
      else
	rdata1 <= memory[addr1];
   end
   
endmodule