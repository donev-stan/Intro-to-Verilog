module tb();

   parameter DATA_SIZE = 8;
   parameter MEM_DEPTH = 2;
   // Representing the number of bits needed in order to access a number of locations
   // Example: 2'b (00,01,10,11) = can access a total of 4 locations
   
   reg clk, rst;
   reg we, re;
   reg [DATA_SIZE-1:0] wrdata;
   wire [DATA_SIZE-1:0] rddata;
   wire full;
   wire empty;


   fifo 
     #(
       .DATA_SIZE(DATA_SIZE),
       .MEM_DEPTH(MEM_DEPTH)
       )
   u_fifo
     (
      .clk(clk),
      .rst(rst),
      .we(we),
      .re(re),
      .wrdata(wrdata),
      .rddata(rddata),
      .full(full),
      .empty(empty)
      );

   initial begin
      clk = 0;
      rst = 0;
      we = 0;
      re = 0;

      @(posedge clk) rst = 1;
   end

   initial begin

/*
      // Random everything!!!
      repeat(20) begin
	 @(posedge clk);
	 we = $random();
	 re = $random();
	 wrdata = $random();
      end
*/


      
/*      
      // Random WRITE & READ with seq wrdata
      for (int i=0; i < 20; i=i+1) begin
	 @(posedge clk);
	 we = $random();
	 re = $random();
	 wrdata = i;
      end
*/

      

/*
      // Seq WRITE & READ to all locations [0-3]
      //repeat(4) seq_write();
      //repeat(4) seq_read();
      //repeat(4) seq_write();
      //repeat(4) seq_read();
*/

      

      
       repeat(3) begin
	  repeat(2) seq_write();
	  repeat(2) seq_read();
	  repeat(4) seq_write();
	  repeat(4) seq_read();
	  repeat(6) seq_write();
	  repeat(6) seq_read();
       end



      
/*
      for (int i=0; i < (2^MEM_DEPTH); i=i+1) begin
	 @(posedge clk);
	 we <= 1;
	 re <= 1;
	 wrdata <= i;
      end
*/
      

      repeat(4) @(posedge clk);
      $finish();
   end

   task seq_write();
      @(posedge clk);
      we <= 1;
      re <= 0;
      wrdata <= $random();
   endtask 

   task seq_read();
      @(posedge clk);
      we <= 0;
      re <= 1;
   endtask

   always #5 clk = ~clk;

   initial begin
      $dumpfile("dump.vcd"); 
      $dumpvars;
   end
   
endmodule