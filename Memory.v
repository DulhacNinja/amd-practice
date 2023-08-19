module Memory
#(  parameter WIDTH     = 8,
    parameter DinLENGTH = 32
)
(   input      [DinLENGTH-1:0]   Din,
    input      [WIDTH-1:0]       Addr,
    input                        R_W,
    input                        Valid,
    input                        Reset,
    input                        Clk,
    output reg  [DinLENGTH-1:0]  Dout
);
    localparam Read = 0;
    localparam Write = 1;
    integer iterator;

    reg      [DinLENGTH-1:0] 	RegBank [WIDTH-1:0];

    always @(posedge Clk, posedge Reset)
    if(Reset)begin
      for(iterator = 0; iterator < WIDTH; iterator = iterator + 1)begin
            RegBank[iterator] = 0;
            Dout              = 0;
        end
    end
    else if(Valid && R_W == Read)begin
            Dout <= RegBank[Addr];
    end
    else if(Valid && R_W == Write)begin
            RegBank[Addr] <= Din;
    end
endmodule