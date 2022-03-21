module memory_wrapper(clk, we0, we1, addr0, addr1, wdata0, wdata1, rdata0, rdata1);

   parameter DATA_DEPTH = 4; // 4'b == a total of 16 addresses in memory
   parameter DATA_WIDTH = 16;

   parameter ADDR_MSB = DATA_DEPTH - 1; // 4-1=3 => addr[3] 
   parameter ADDR_BITS = DATA_DEPTH - 2; // in this case 4-2=2 => [2:0] => 3'b for addressing a location
   parameter HALF_DATA_WIDTH = DATA_WIDTH / 2;

   input clk;
   input we0, we1;
   input [DATA_DEPTH-1:0] addr0, addr1;
   input [DATA_WIDTH-1:0] wdata0, wdata1;
   output [DATA_WIDTH-1:0] rdata0, rdata1;

   reg addr0_MSB_reg;
   reg addr1_MSB_reg;

   always @(posedge clk) begin
      addr0_MSB_reg <= addr0[ADDR_MSB];
      addr1_MSB_reg <= addr1[ADDR_MSB];
   end

   wire [DATA_WIDTH-1:0] rdata0Instances01, rdata0Instances23, rdata1Instances01, rdata1Instances23;
   
   assign rdata0 = (addr0_reg) ? rdata0Instances23 : rdata0Instances01;
   assign rdata1 = (addr1_reg) ? rdata1Instances23 : rdata1Instances01;

   /*
   wire we0Instances01, we0Instances23, we1Instances01, we1Instances23;
 
   assign we0Instances01 = we0 & ~addr0[ADDR_MSB];
   assign we1Instances01 = we1 & ~addr1[ADDR_MSB];
   assign we0Instances23 = we0 & addr0[ADDR_MSB];
   assign we1Instances23 = we1 & addr1[ADDR_MSB];
   */
   
   dual_port_memory
     #(
       .DATA_DEPTH(DATA_DEPTH - 1), // 4-1=3 // 4'b=16 addr // 3'b=8 addr
       .DATA_WIDTH(DATA_WIDTH / 2)
       )
   instance0 (
	      .clk(clk),
	      .we0(we0 & ~addr0[ADDR_MSB]),
	      .we1(we1 & ~addr1[ADDR_MSB]),
	      .addr0(addr0[ADDR_BITS:0]), // [2:0] => 3'b
	      .addr1(addr1[ADDR_BITS:0]), // [2:0] => 3'b
	      .wdata0(wdata0[DATA_WIDTH-1:HALF_DATA_WIDTH]), // [15:8]  // 3524 -> 35
	      .wdata1(wdata1[DATA_WIDTH-1:HALF_DATA_WIDTH]), // [15:8]
	      .rdata0(rdata0Instances01[DATA_WIDTH-1:HALF_DATA_WIDTH]), // [15:8]
	      .rdata1(rdata1Instances01[DATA_WIDTH-1:HALF_DATA_WIDTH]) // [15:8]
	      );

   
   dual_port_memory
     #(
       .DATA_DEPTH(DATA_DEPTH - 1),
       .DATA_WIDTH(DATA_WIDTH / 2)
       )
   instance1 (
	      .clk(clk),
	      .we0(we0 & ~addr0[ADDR_MSB]),
	      .we1(we1 & ~addr1[ADDR_MSB]),
	      .addr0(addr0[ADDR_BITS:0]), // [2:0] => 3'b
	      .addr1(addr1[ADDR_BITS:0]), // [2:0] => 3'b
	      .wdata0(wdata0[HALF_DATA_WIDTH-1:0]), // [7:0]  // 3524 -> 24
	      .wdata1(wdata1[HALF_DATA_WIDTH-1:0]), // [7:0]
	      .rdata0(rdata0Instances01[HALF_DATA_WIDTH-1:0]), // [7:0]
	      .rdata1(rdata1Instances01[HALF_DATA_WIDTH-1:0]) // [7:0]
	      );


   dual_port_memory 
     #(
       .DATA_DEPTH(DATA_DEPTH - 1),
       .DATA_WIDTH(DATA_WIDTH / 2)
       )
   instance2 (
	      .clk(clk),
	      .we0(we0 & addr0[ADDR_MSB]),
	      .we1(we1 & addr1[ADDR_MSB]),
	      .addr0(addr0[ADDR_BITS:0]), // [2:0] => 3'b
	      .addr1(addr1[ADDR_BITS:0]), // [2:0] => 3'b
	      .wdata0(wdata0[DATA_WIDTH-1:HALF_DATA_WIDTH]), // [15:8]
	      .wdata1(wdata1[DATA_WIDTH-1:HALF_DATA_WIDTH]), // [15:8]
	      .rdata0(rdata0Instances23[DATA_WIDTH-1:HALF_DATA_WIDTH]), // [15:8]
	      .rdata1(rdata1Instances23[DATA_WIDTH-1:HALF_DATA_WIDTH]) // [15:8]  
	      );

   
   dual_port_memory
     #(
       .DATA_DEPTH(DATA_DEPTH - 1),
       .DATA_WIDTH(DATA_WIDTH / 2)
       )
   instance3 (
	      .clk(clk),
	      .we0(we0 & addr0[ADDR_MSB]),
	      .we1(we1 & addr1[ADDR_MSB]),
	      .addr0(addr0[ADDR_BITS:0]), // [2:0] => 3'b
	      .addr1(addr1[ADDR_BITS:0]), // [2:0] => 3'b
	      .wdata0(wdata0[HALF_DATA_WIDTH-1:0]), // [7:0]
	      .wdata1(wdata1[HALF_DATA_WIDTH-1:0]), // [7:0]
	      .rdata0(rdata0Instances23[HALF_DATA_WIDTH-1:0]), // [7:0]
	      .rdata1(rdata1Instances23[HALF_DATA_WIDTH-1:0]) // [7:0] 
	      );

endmodule