module serial_line_fsm (
	input clock, reset,
  	input serial_line,
  	output match
);
  
  reg [2:0] current_state, next_state;
  
  localparam PARAM_IDLE = 3'h0;
  localparam PARAM_1 = 3'h1;
  localparam PARAM_10 = 3'h2;
  localparam PARAM_100 = 3'h3;
  localparam PARAM_1001 = 3'h4;
  localparam PARAM_10010 = 3'h5;
  localparam PARAM_100100 = 3'h6;
  localparam PARAM_1001001 = 3'h7;


  always @(posedge clock or negedge reset)
    if (~reset)
      current_state <= PARAM_IDLE;
  	else
      current_state <= next_state;
    
  always @(*)
    case (current_state)
      PARAM_IDLE: next_state = (serial_line) ? PARAM_1 : PARAM_IDLE;
      PARAM_1: next_state = (serial_line == 0) ? PARAM_10 : PARAM_1;
      PARAM_10: next_state = (serial_line == 0) ? PARAM_100 : PARAM_1;
      PARAM_100: next_state = (serial_line) ? PARAM_1001 : PARAM_IDLE;
      PARAM_1001: next_state = (serial_line == 0) ? PARAM_10010 : PARAM_1;
      PARAM_10010: next_state = (serial_line == 0) ? PARAM_100100 : PARAM_1;
      PARAM_100100: next_state = (serial_line) ? PARAM_1001001 : PARAM_IDLE;
      PARAM_1001001: next_state = (serial_line) ? PARAM_1 : PARAM_10010;
    endcase
  
  assign match = (current_state == PARAM_1001001) ? 1'b1 : 1'b0;
  
endmodule