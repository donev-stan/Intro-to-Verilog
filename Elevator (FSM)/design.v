module elevator (clk, rst, btn, floor0, floor1, motor);

   input clk, rst;
   input btn; // when 1: the platform changes position
   input floor0; // when 1: the platform is at floor 0
   input floor1; // when 1: the platform is at floor 1
   output [1:0] motor;
   
   reg [1:0] cState, nState;
   reg [1:0] motor;
   
   localparam PARAM_IDLE = 2'b00;
   localparam PARAM_MOVING_UP = 2'b01;
   localparam PARAM_MOVING_DOWN = 2'b10;

   
   // СИНХРОНЕН БЛОК определящ текущото състояние на автомата
   always @(posedge clk or negedge rst) begin
      if (~rst)
	cState <= PARAM_IDLE;
      /*
      else if ((nState == PARAM_IDLE) & (~floor0 & ~floor1))
	cState <= PARAM_MOVING_DOWN;
      */
      else
	cState <= nState;
   end

   // КОМБИНАЦИОНЕН БЛОК (case) определящ следващото състояние на автомата
   always @(*) begin
      case (cState)
	PARAM_IDLE:
	  nState = (~btn & (floor0 | floor1)) ? PARAM_IDLE : (floor0) ? PARAM_MOVING_UP : PARAM_MOVING_DOWN;

	PARAM_MOVING_UP:
	  nState = (~floor1) ? PARAM_MOVING_UP : PARAM_IDLE;

	PARAM_MOVING_DOWN:
	  nState = (~floor0) ? PARAM_MOVING_DOWN : PARAM_IDLE;

	default: nState = PARAM_IDLE;
      endcase
   end

   always @(*) begin
      if ((floor0 | floor1) & (nState == PARAM_IDLE))
	motor = 2'b00; // IDLE
      else if (floor0 & ~btn)
	motor = 2'b01; // MOVING_UP
      else if (floor1 & ~btn)
	motor = 2'b10; // MOVING_DOWN
      else
	motor = cState;
   end
 
endmodule