module Concatenator
(   input   	[7:0]   	InA,
    input   	[7:0]   	InB,
    input   	[7:0]   	InC,
    input   	[3:0]   	InD,
    input   	[3:0]   	InE,
    output reg  [31:0]  	Out
);	
  always@(*)begin
    Out = {InE, InD, InC, InB, InA};
  end
endmodule