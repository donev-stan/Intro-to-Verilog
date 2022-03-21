module railway(clk, rst, car, s0, s1, barrier_ctrl);

   input clk, rst;
   input car, s0, s1;
   output reg barrier_ctrl; // 1: UP --- 0: DOWN

   parameter UP = 2'b00; // 0
   parameter DOWN = 2'b01; // 1
   parameter WAIT = 2'b10; // 2
      
   reg [1:0] cState, nState;

   reg s0_d1, s1_d1;
   
   always @(posedge clk or negedge rst) begin
      if (~rst)
	cState <= UP;
      else
	cState <= nState;
   end


   always @(*) begin
      case (cState)
	UP: 
	  nState = ((s0 | s1)) ? (car) ? WAIT : DOWN : UP;

	WAIT:
	  nState = ((~(s0 | s1) & ~car) | ~car) ? DOWN : WAIT;
	
	DOWN:
	  nState = (s0 | s1) ? UP : DOWN;

	default: nState = UP;
      endcase
   end 


/*   
   // Edge Detect s0
   always @(posedge clk or negedge rst) begin
     if (~rst)
       s0_d1 <= 0;
     else
       s0_d1 <= s0;
   end

   assign s0_rising_edge = s0 & ~s0_d1;

   // Edge Detect s1
   always @(posedge clk or negedge rst) begin
      if (~rst)
	s1_d1 <= 0;
      else
	s1_d1 <= s1;
   end

   assign s1_rising_edge = s1 & ~s1_d1;

  

   always @(*) begin
      case (cState)
	UP: 
	  nState = ((s0_rising_edge | s1_rising_edge)) ? (car) ? WAIT : DOWN : UP;

	WAIT:
	  nState = ((~(s0_rising_edge | s1_rising_edge) & ~car) | ~car) ? DOWN : WAIT;
	
	DOWN:
	  nState = (s0_rising_edge | s1_rising_edge) ? UP : DOWN;

	default: nState = UP;
      endcase
   end 
*/

   
   always @(*) begin
      if (cState == UP | cState == WAIT)
	barrier_ctrl = 1;
      else if (cState == DOWN | (cState == WAIT & ~car))
	barrier_ctrl = 0;
      else
	barrier_ctrl = 1;
   end
   
endmodule