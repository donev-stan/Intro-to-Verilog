module coproc (clk, rst, icode, valid);
   
   parameter WIDTH = 8;
   parameter COUNTER_WIDTH = 7;
   
   input clk, rst;
   input [WIDTH-1:0] icode;
   input valid;
  
   reg [COUNTER_WIDTH-1:0] s3_mem_out;
   reg [COUNTER_WIDTH-1:0] s4_adder_out;
   reg [COUNTER_WIDTH-1:0] s5_adder_out;
   wire [COUNTER_WIDTH-1:0] s4_mux;
   
   reg s1_vld, s2_vld, s3_vld, s4_vld;
   reg [WIDTH-1:0] s1_icode, s2_icode, s3_icode, s4_icode;
   
   reg s4_s1_match;
   
   wire [COUNTER_WIDTH-1:0] RdData_0;

   // Регистър къде записваме входният сигнал icode
   always @(posedge clk or negedge rst) begin
     if (~rst)
       s1_icode <= {WIDTH{1'b0}};
     else
       s1_icode <= icode;
   end

   // Регистър къде записваме изхода от паметта - s3_mem_out
   always @(posedge clk or negedge rst) begin
     if (~rst)
       s3_mem_out <= {COUNTER_WIDTH{1'b0}};
     else if ((s4_icode == s2_icode) & s4_vld) // mux
       s3_mem_out <= s4_adder_out; // вземаме резултата от събирането
     else if (s4_s1_match) // mux
       s3_mem_out <= s5_adder_out;
     else
       s3_mem_out <= RdData_0;
   end

   // Регистър за сравнение на s4_icode с s1_icode
   always @(posedge clk or negedge rst) begin
      if (~rst)
	s4_s1_match <= 1'b0;
      else
	s4_s1_match <= ((s4_icode == s1_icode) & s4_vld) ? 1'b1 : 1'b0;
   end
   
   always @(posedge clk or negedge rst) begin
      if (~rst)
	s5_adder_out <= 1'b0;
      else
	s5_adder_out <= s4_adder_out;
   end

   // Резултат от събирането - s4_adder_out
   always @(posedge clk or negedge rst) begin
     if (~rst)
       s4_adder_out <= {COUNTER_WIDTH{1'b0}};
     else
       s4_adder_out <= s4_mux + 1'b1;
   end

   // Решаване на конфликт: два последователни цикъла с еднакви инструкции
   assign s4_mux = ((s4_icode == s3_icode) & s4_vld) ? s4_adder_out : s3_mem_out;

   dual_port_memory
     #(
       .DATA_WIDTH(COUNTER_WIDTH),
       .DATA_DEPTH(WIDTH)
       )
   u_dual_port_memory (
		       .clk(clk),

		       // Read
		       .addr0(s1_icode),
		       .we0(1'b0),
		       .wdata0({COUNTER_WIDTH{1'b0}}),
		       .rdata0(RdData_0),

		       // Write
		       .addr1(s4_icode),
		       .we1(s4_vld),
		       .wdata1(s4_adder_out),
		       .rdata1()
		       );
   
   always @(posedge clk or negedge rst) begin
     if (~rst) begin
	s1_vld <= 1'b0;
	s2_vld <= 1'b0;
	s3_vld <= 1'b0;
	s4_vld <= 1'b0;
     end
     else begin
	s1_vld <= valid;
	s2_vld <= s1_vld;
	s3_vld <= s2_vld;
	s4_vld <= s3_vld;
     end
   end
  
   always @(posedge clk or negedge rst) begin
     if (~rst) begin
	s1_icode <= {WIDTH{1'b0}};
	s2_icode <= {WIDTH{1'b0}};
	s3_icode <= {WIDTH{1'b0}};
	s4_icode <= {WIDTH{1'b0}};
     end
     else begin
	s1_icode <= icode;
	s2_icode <= s1_icode;
	s3_icode <= s2_icode;
	s4_icode <= s3_icode;
     end
   end
  
endmodule