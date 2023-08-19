module MUX#(parameter WIDTH = 8)
(   input      [WIDTH-1:0]    I0,
    input      [WIDTH-1:0]    I1,
    input                     Sel,
    output reg [WIDTH-1:0]    Out
);
  always @(*)
        case(Sel)
            0:          Out = I0;
            1:          Out = I1;
            default:    Out = 0;
        endcase
endmodule