`timescale 1ns/1ps

module prbs #(
	parameter SIZE = 8,
  	parameter TAP1 = 7,
  	parameter TAP2 = 6)
	(
  	input clock, reset, set_seed, 
  	input [SIZE-1:0] seed,
  	output prbs
);
  
  reg [SIZE-1:0] prbs_core;
  
  assign prbs = prbs_core[SIZE-1];
  
  always @(posedge clock or negedge reset)
    if (reset == 1'b0)
      prbs_core <= 0;
  	else if (set_seed == 1'b1)
      prbs_core <= seed;
  	else
      prbs_core <= {prbs_core[SIZE-2:0], prbs_core[TAP1] ^ prbs_core[TAP2] ^ 1'b1}; 
  
  
    /* 8 bit prbs
  reg [7:0] prbs_core;
  
  assign prbs = prbs_core[7];
  
  always @(posedge clock or negedge reset)
    if (reset == 1'b0)
      prbs_core <= 0;
  	else
      prbs_core <= {prbs_core[6:0], prbs_core[7] ^ prbs_core[6] ^ 1'b1}; 
  		// X^7+X^6+1
   */
endmodule