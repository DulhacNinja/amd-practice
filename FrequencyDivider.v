module FrequencyDivider
(   input   [31:0]  Din,
    input           ConfigDiv,
    input           Reset,
    input           Clk,
    input           Enable,
    output reg      ClkOut
);
    reg     [31:0]  T           = 0;
    reg     [31:0]  PosCounter  = 0;
    reg     [31:0]  NegCounter  = 0;

    always @(Clk, posedge Reset) begin
        if(Reset) begin
            T      = 0;
            ClkOut = 0;
            PosCounter = 0;
            NegCounter = 0;
        end
        else if(Clk) begin
            if(!Enable)begin
                if(ConfigDiv)begin
                    T = Din;
                end
                else begin
                    if(T > 1) begin
                        PosCounter = T / 2;
                        NegCounter = T - (T / 2);
                    end
                end
            end
            else begin
                if(PosCounter) begin
                    ClkOut = 1;
                    PosCounter = PosCounter - 1;
                end
                else if (NegCounter) begin
                    ClkOut = 0;
                    NegCounter = NegCounter - 1;
                end
                else begin
                    if(T > 1) begin
                        ClkOut = 1;
                        PosCounter = T / 2 - 1;
                        NegCounter = T - ( T / 2 - 1 ) - 1;
                    end
                    else begin
                        ClkOut = 1;
                    end
                end
            end
        end
        else if (!Clk && T < 2) begin
            ClkOut = 0;
        end
    end
endmodule