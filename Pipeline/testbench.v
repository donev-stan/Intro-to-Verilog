module tb ();
   `define MEMORY_PATH u_coproc.u_dual_port_memory.memory
   
   parameter WIDTH = 8;
   parameter COUNTER_WIDTH = 7; 
   parameter ICodeNumber = 8;

   int seed = 1801561073;
   int icode_id;
   int dep1, dep2, dep3;
   
   reg clk, rst;
   reg [WIDTH-1:0] icode, icode_d1, icode_d2, icode_d3;
   reg [COUNTER_WIDTH-1:0] icode_cnt [ICodeNumber]; // [COUNTER_WIDTH-1]
   reg [WIDTH-1:0] pool [ICodeNumber]; // [WIDTH-1]
   reg valid;
      
   coproc #(
	    .WIDTH(WIDTH),
	    .COUNTER_WIDTH(COUNTER_WIDTH))
   u_coproc (
 	     .clk(clk),
	     .rst(rst),
	     .icode(icode),
	     .valid(valid)
	     );

   initial begin
      for (int i=0; i < (1<<WIDTH); i++) begin
	 `MEMORY_PATH[i] = 0;
      end
   end
   
   initial begin

      for (int i=0; i<ICodeNumber; i++)
	pool[i] = $random(seed);	

      for (int i=0; i<ICodeNumber; i++)
	icode_cnt[i] = 0;

      valid <= 0;
      icode <= 0;

      wait (rst == 1);
      
      repeat (1000) begin
	 
	 valid <= |($urandom(seed)%8);
	 icode_id = $urandom(seed)%ICodeNumber;
	 icode <= pool[icode_id];
	 
	 icode_d3 <= icode_d2;
	 icode_d2 <= icode_d1;
	 icode_d1 <= icode;
	 
	 @(posedge clk);
	 if (valid) icode_cnt[icode_id]++;
	 if (icode_d3 == icode_d2) dep1++;
	 if (icode_d3 == icode_d1) dep2++;
	 if (icode_d3 == icode) dep3++;
      end 

      valid <= 0;

      repeat (5) begin
	 @(posedge clk);
	 report();
      end
      
      $finish();
   end
  
   task report();
      for (int i=0; i < ICodeNumber; i++) begin
	 $display("icode_cnt[%d] = %d", i, icode_cnt[i]);
      end

      for (int i=0; i < ICodeNumber; i++) begin
	 $display("mem[%d] = %d", pool[i], `MEMORY_PATH[(pool[i])]);
      end

      for (int i=0; i < ICodeNumber; i++) begin
	 if (icode_cnt[i] != `MEMORY_PATH[(pool[i])])
       $display("ERROR for ICODE %d --- icode_cnt[%d]=%d --- mem[%d]=%d", pool[i], i, icode_cnt[i], pool[i], `MEMORY_PATH[(pool[i])]);
      end

      $display("Data dependency two consequitive cycles %d", dep1);
      $display("Data dependency over one cycle %d", dep2);
      $display("Data dependency over two cycles %d", dep3);
      
   endtask
  

   initial clk = 0;
   always #1 clk = ~clk;

   initial begin 
      rst = 1'b0; 
      #10;
      rst = 1'b1;
   end
   
   initial begin
      $dumpfile("dump.vcd"); 
      $dumpvars;
   end
   
endmodule