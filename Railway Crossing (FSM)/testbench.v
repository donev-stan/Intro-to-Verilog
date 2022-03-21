module tb ();

   reg clk, rst;
   reg car, s0, s1;
   wire barrier_ctrl;

   railway u_railway (
		      .clk(clk),
		      .rst(rst),
		      .car(car),
		      .s0(s0),
		      .s1(s1),
		      .barrier_ctrl(barrier_ctrl)
		      );

   initial begin
      clk = 0;
      rst = 0;
      car = 0;
      s0 = 0;
      s1 = 0;
      
      $dumpfile("dump.vcd"); 
      $dumpvars;
   end

   always #5 clk = ~clk;
         
   initial begin
      #5 rst = 1;
      repeat(2) @(posedge clk);

      // train_passing_left_to_right_car_oneCycle();

      //train_passing_left_to_right_no_car_oneCycle();

      // train_passing_left_to_right_car_over_s0_oneCycle();

      //train_passing_left_to_right_car_with_s0_oneCycle();
            
      //train_passing_left_to_right_car();      
      //train_passing_right_to_left_car();
      train_passing_left_to_right_no_car();
      //train_passing_right_to_left_no_car();
      
      repeat(2) @(posedge clk);
      $finish();
   end // initial begin

   task train_passing_left_to_right_car_with_s0_oneCycle();
      
      repeat (2) begin
	 @(posedge clk);
	 car = 1;
	 s0 = 1;
      end
      
      @(posedge clk) s0 = 0; car = 0;

      repeat(2) @(posedge clk);
      
      repeat (1) begin
	 @(posedge clk);
	 s1 = 1;
      end
      @(posedge clk) s1 = 0;
   endtask

   task train_passing_left_to_right_car_oneCycle();

      repeat (2) begin
	 @(posedge clk);
	 car = 1;
      end
      
      repeat (1) begin
	 @(posedge clk);
	 s0 = 1;
      end
      @(posedge clk) s0 = 0; car = 0;

      repeat(2) @(posedge clk);
      
      repeat (1) begin
	 @(posedge clk);
	 s1 = 1;
      end
      @(posedge clk) s1 = 0;

   endtask // train_passing_left_to_right_car_oneCycle

    task train_passing_left_to_right_no_car_oneCycle();
      
      repeat (1) begin
	 @(posedge clk);
	 s0 = 1;
      end
       @(posedge clk) s0 = 0;

      repeat(2) @(posedge clk);
      
      repeat (1) begin
	 @(posedge clk);
	 s1 = 1;
      end
      @(posedge clk) s1 = 0;

    endtask // 

   task train_passing_left_to_right_car_over_s0_oneCycle();

      @(posedge clk)  car = 1;

      repeat (1) begin
	 @(posedge clk);
	 s0 = 1;
      end
      @(posedge clk) s0 = 0;
      
      repeat(2) begin
	 @(posedge clk);
	 car = 0;
      end
      
      repeat(2) @(posedge clk);
      
      repeat (1) begin
	 @(posedge clk);
	 s1 = 1;
      end
      @(posedge clk) s1 = 0;
   endtask

   task train_passing_left_to_right_car();
      repeat (2) begin
	 @(posedge clk);
	 car = 1;
      end

      repeat (2) begin
	 @(posedge clk);
	 s0 = 1;

	 repeat (2) @(posedge clk);
	 car = 0;
      end
      @(posedge clk) s0 = 0;

      repeat(2) @(posedge clk);
      
      repeat (2) begin
	 @(posedge clk);
	 s1 = 1;
      end
      @(posedge clk) s1 = 0;
   endtask

   task train_passing_right_to_left_car();
      repeat (2) begin
	 @(posedge clk);
	 car = 1;
      end

      repeat (2) begin
	 @(posedge clk);
	 s1 = 1;

	 @(posedge clk);
	 car = 0;
      end
      @(posedge clk) s1 = 0;

      repeat(2) @(posedge clk);
      
      repeat (2) begin
	 @(posedge clk);
	 s0 = 1;
      end
      @(posedge clk) s0 = 0;
   endtask 

   task train_passing_right_to_left_no_car();
      repeat (2) begin
	 @(posedge clk);
	 s1 = 1;
      end
      @(posedge clk) s1 = 0;

      repeat(2) @(posedge clk);
      
      repeat (2) begin
	 @(posedge clk);
	 s0 = 1;
      end
      @(posedge clk) s0 = 0;
   endtask

   task train_passing_left_to_right_no_car();
      repeat (2) begin
	 @(posedge clk);
	 s0 = 1;
      end
      @(posedge clk) s0 = 0;

      repeat(2) @(posedge clk);
      
      repeat (2) begin
	 @(posedge clk);
	 s1 = 1;
      end
      @(posedge clk) s0 = 0;
   endtask 
   
endmodule