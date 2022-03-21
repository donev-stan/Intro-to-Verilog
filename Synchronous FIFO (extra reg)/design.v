module fifo(clk, rst, we, re, wrdata, rddata, full, empty);

   parameter DATA_SIZE = 8;
   parameter MEM_DEPTH = 2; 
   // Representing the number of bits needed in order to access a number of locations
   // Example: 2'b (00,01,10,11) = can access a total of 4 locations
      
   input clk, rst;
   input we, re;
   input [DATA_SIZE-1:0] wrdata; 
   output [DATA_SIZE-1:0] rddata;
   output full;
   output empty;

   // за 4 локации са ми нужни 2'b pointers
   reg [MEM_DEPTH-1:0] wp; 
   reg [MEM_DEPTH-1:0] rp;

   // roll НЕ може да стане повече от веднъж, затова го слагаме еднобитов
   reg roll;

   dual_port_memory
     #(
       .DATA_WIDTH(DATA_SIZE),
       .MEM_DEPTH(MEM_DEPTH)
       )
   u_dual_port_memory
     (
      .clk(clk),
      .rst(rst),

      // write
      .we0(we & ~full),
      .addr0(wp),
      .wdata0(wrdata),
      .rdata0(),

      // read
      .we1(1'b0),
      .addr1(rp),
      .wdata1({DATA_SIZE{1'b0}}),
      .rdata1(rddata)
      );

   // Full & Empty изходи
   assign full = ((wp == rp) & (roll)) ? 1 : 0;
   assign empty = ((rp == wp) & (~roll)) ? 1 : 0;

   // Roll Register (1'b)
   always @(posedge clk or negedge rst) begin
      if (~rst) begin
	 roll <= 1'b0;
      end
      else begin
	 if (we & ~full)
	   if (wp == ((1<<MEM_DEPTH)-1))
	     roll <= 1'b1;

	 if (re & ~empty)
	   if (rp == ((1<<MEM_DEPTH)-1))
	     roll <= 1'b0;
      end
   end

   // Write Pointer Register
   always @(posedge clk or negedge rst) begin
      if (~rst) begin
	 wp <= 0;
      end
      else if (we & ~full) begin
	 wp <= wp + 1;
      end
      else begin
	 wp <= wp;
      end
   end

   // Read Pointer Register
   always @(posedge clk or negedge rst) begin
      if (~rst) begin
	 rp <= 0;
      end
      else if (re & ~empty) begin
	 rp <= rp + 1;
      end
      else begin
	 rp <= rp;
      end
   end
   
endmodule
