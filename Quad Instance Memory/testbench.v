module tb();

   parameter DATA_DEPTH = 4;
   parameter DATA_WIDTH = 16;

   reg clock;
   reg we0, we1;
   reg [DATA_DEPTH-1:0] addr0, addr1;
   reg [DATA_WIDTH-1:0] wdata0, wdata1;
   wire [DATA_WIDTH-1:0] rdata0, rdata1;

   memory_wrapper #(
		      .DATA_WIDTH(DATA_WIDTH),
		      .DATA_DEPTH(DATA_DEPTH)
)
   u_memory_wrapper (
		       .clk(clock),
		       .we0(we0),
		       .we1(we1),
		       .addr0(addr0),
		       .addr1(addr1),
		       .wdata0(wdata0),
		       .wdata1(wdata1),
		       .rdata0(rdata0),
		       .rdata1(rdata1)
);


   initial begin
      we0 = 0;
      we1 = 0;
      addr0 = 0;
      addr1 = 0;
      wdata0 = 0;
      wdata1 = 0;
   end

   initial begin

      // CHECK - Read & Write from different ports to/from same location!
/*
      // Write - address 0 / port 0
      #10;
      we0 = 1;
      addr0 = 0;
      wdata0 = $random();

      // Read from we1 when we write from we0 to the same location
      we1 = 0;
      addr1 = 0;

      // Write - address 1 / port 1
      #20;
      we1 = 1;
      addr1 = 1;
      wdata1 = $random();

      // Read from we0 when we write from we1 to the same location
      we0 = 0;
      addr0 = 1;
*/


      // CHECK - Write to same location from both interfaces
/*
      #10;
      we0 = 1;
      addr0 = 0;
      wdata0 = $random();

      we1 = 1;
      addr1 = 0;
      wdata1 = $random();
*/

      
      // Read & Write to all locations without edge cases
/*
      // Write - address 0
      #50;
      we0 = 1;
      addr0 = 0;
      wdata0 = $random();
      // Read - address 0
      #50;
      we0 = 0;
      addr0 = 0;
      
      // Write - address 1
      #50;
      we0 = 1;
      addr0 = 1;
      wdata0 = $random();
      // Read - address 1
      #50;
      we0 = 0;
      addr0 = 1;

      // Write  - address 2
      #50;
      we0 = 1;
      addr0 = 2;
      wdata0 = $random();
      // Read - address 2
      #50;
      we0 = 0;
      addr0 = 2;

      // Write  - address 3
      #50;
      we0 = 1;
      addr0 = 3;
      wdata0 = $random();
      // Read - address 3
      #50;
      we0 = 0;
      addr0 = 3;

      
      // Write - address 4
      #50;
      we0 = 1;
      addr0 = 4;
      wdata0 = $random();
      // Read - address 4
      #50;
      we0 = 0;
      addr0 = 4;

      // Write - address 5
      #50;
      we0 = 1;
      addr0 = 5;
      wdata0 = $random();
      // Read - address 5
      #50;
      we0 = 0;
      addr0 = 5;

      // Write - address 6
      #50;
      we0 = 1;
      addr0 = 6;
      wdata0 = $random();
      // Read - address 6
      #50;
      we0 = 0;
      addr0 = 6;

      // Write - address 7
      #50;
      we0 = 1;
      addr0 = 7;
      wdata0 = $random();
      // Read - address 7
      #50;
      we0 = 0;
      addr0 = 7;
*/

      
/*
      #10;
      for (int i=0; i<(1<<DATA_DEPTH); i=i+1) begin
	 write_data(i);
      end

      for (int j=0; j<(1<<DATA_DEPTH); j=j+1) begin
	 read_data(j);
      end
*/
      
/*
      test_write(0);
      test_write(7);
      test_write(8);
      test_write(15);

      test_read(0);
      test_read(7);
      test_read(8);
      test_read(15);
*/  

      repeat(50) rnd_data();
      
      #100;
      $finish();
    end

   task test_write(int i);
      @(posedge clock);
      
      we0 <= 1;
      addr0 <= i;
      wdata0 <= $random();
   endtask

   task test_read(int i);
      @(posedge clock);

      we0 <= 0;
      addr0 <= i;
   endtask

   task rnd_data();
      @(posedge clock);

      we0 <= $random();
      addr0 <= 0 + {$random} % (15 - 0);
      wdata0 <= $random();

      we1 <= $random();
      addr1 <=  0 + {$random} % (15 - 0);
      wdata1 <= $random();
   endtask

   task write_data(int i);
      @(posedge clock);

      /*
      we0 <= 1;
      addr0 <= i;
      wdata0 <= $random();
       */

      we1 <= 1;
      wdata1 <= $random();
   endtask

   task read_data (int j);
      @(posedge clock);

      /*
      we0 <= 0;
      addr0 <= j;
       */

      we1 <= 0;
      addr1 <= j;
   endtask

   
   initial clock = 0;
   always #5 clock = ~clock;
   
   initial begin
      $dumpfile("dump.vcd"); 
      $dumpvars;
   end
	
endmodule