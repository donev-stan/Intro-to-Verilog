module tb ();

   reg clk, rst;
   reg btn, floor0, floor1;
   wire [1:0] motor;

   elevator u_elevator (
			.clk(clk),
			.rst(rst),
			.btn(btn),
			.floor0(floor0),
			.floor1(floor1),
			.motor(motor)
			);



   initial begin
      clk = 0;
      btn = 0;
      rst = 0;
      floor0 = 0;
      floor1 = 0;
   end

   always #5 clk = ~clk;
   
   initial begin
      #10 rst = 1;
      
      // платформата е на floor0
      floor0 = 1;

      //repeat (2) @(posedge clk);

      // натискаме бутона
      repeat(2) begin  
	 @(posedge clk);
	 btn = 1;
      end
      btn = 0;

      // delay преди сензора спре да засича платформата floor0
      repeat(1) @(posedge clk);

      /*
      wait (motor != 0) begin
	 @(posedge clk);
	 floor0 = 0;
	 floor1 = 0;
      end
      */

      // не сме никъде
      repeat(2) begin 
	 @(posedge clk);
	 floor0 = 0;
	 floor1 = 0;
      end
      
      // стигаме до floor1
      @(posedge clk) floor1 = 1;

      // седим си на floor1 3 clk-a
      repeat(3) @(posedge clk);
      
      // ------ floor1 = 1 ----------

      // натискаме бутона
      repeat(2) begin
	 @(posedge clk);
	 btn = 1;
      end
      btn = 0;

      //repeat(1) @(posedge clk);

      // не сме никъде
      repeat(4) begin
	 @(posedge clk);
	 floor0 = 0;
	 floor1 = 0;
      end
      
      // стигаме дo floor0
      @(posedge clk) floor0 = 1;

      // седим си на floor0 3 clk-a
      repeat(3) @(posedge clk);
      
      // ------ floor0 = 1 -----------

      // натискаме бутона
      repeat(2) begin
	 @(posedge clk);
	 btn = 1;
      end
      btn = 0;
      
      //repeat(1) @(posedge clk);

      // не сме никъде
      repeat(5) begin 
	 @(posedge clk);
	 floor0 = 0;
	 floor1 = 0;
      end

      // влизаме в ресет
      rst = 0;
      // стоим 2 clk-а така
      repeat(2) @(posedge clk);
      // излизаме от ресет
      rst = 1;

      // 2 clk-a време докато се върнем на floor0
      repeat(2) @(posedge clk);

      // стигаме до floor0 (връщаме се по default заради rst)
      @(posedge clk) floor0 = 1;

      // седим си на floor0 3 clk-a
      repeat(3) @(posedge clk);

      // ------ floor0 = 1 -------

      // натискаме бутона
      repeat(2) begin
	 @(posedge clk);
	 btn = 1;
      end
      btn = 0;
      
      //repeat(1) @(posedge clk);
    
      // не сме никъде
      repeat(7) begin 
	 @(posedge clk);
	 floor0 = 0;
	 floor1 = 0;
      end

      // стигаме до floor1
      @(posedge clk) floor1 = 1;

      repeat(3) @(posedge clk);
      $finish();
   end
   
endmodule