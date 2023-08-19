module ALU
(   input       [7:0] A,
    input       [7:0] B,
    input       [3:0] Sel,
    output reg  [7:0] Out,
    output reg  [3:0] Flag
);
    localparam Add              = 4'h0; 
    localparam Sub              = 4'h1; 
    localparam Mul              = 4'h2; 
    localparam Div              = 4'h3; 
    localparam Shl              = 4'h4; 
    localparam Shr              = 4'h5; 
    localparam And              = 4'h6;
    localparam Or               = 4'h7;
    localparam Xor              = 4'h8;
    localparam Nxor             = 4'h9;
    localparam Nand             = 4'hA;
    localparam Nor              = 4'hB;
    localparam Noflag           = 4'b0000;
    localparam ZeroFlag         = 4'b1000;
    localparam CarryFlag        = 4'b0100;
    localparam OverflowFlag     = 4'b0010;
    localparam UnderflowFlag    = 4'b0001;
  
  	reg[31:0]		mulReg;

    always @(*)
    case(Sel)
        Add: begin
            Out <= A + B;
            Flag <= ((A + B < A || A + B < B) ? CarryFlag : Noflag) | ((!Out && (Sel >= 0 && Sel <= 4'hB)) ? ZeroFlag : Noflag);
        end
        Sub: begin
            Out <= A - B;
            Flag <= ((A - B > A) ? UnderflowFlag : Noflag) | ((!Out && (Sel >= 0 && Sel <= 4'hB)) ? ZeroFlag : Noflag);
        end
        Mul: begin
            Out <= A * B;
          	mulReg <= A * B;
          Flag <= ((mulReg > 32'hFF) ? OverflowFlag : Noflag) | ((!Out && (Sel >= 0 && Sel <= 4'hB)) ? ZeroFlag : Noflag);
        end
        Div: begin
            Out <= A / B;
            Flag <= ((A < B) ? UnderflowFlag : Noflag) | ((!Out && (Sel >= 0 && Sel <= 4'hB)) ? ZeroFlag : Noflag);
        end
        Shl: begin
            Out <= A << B;
            Flag <= CarryFlag | ((!Out && (Sel >= 0 && Sel <= 4'hB)) ? ZeroFlag : Noflag);
        end
        Shr: begin
            Out <= A >> B;
            Flag <= CarryFlag | ((!Out && (Sel >= 0 && Sel <= 4'hB)) ? ZeroFlag : Noflag);
        end
        And: begin
            Out <= A & B;
            Flag <= (!Out && (Sel >= 0 && Sel <= 4'hB)) ? ZeroFlag : Noflag;
        end
        Or: begin 
            Out <= A | B;
            Flag <= (!Out && (Sel >= 0 && Sel <= 4'hB)) ? ZeroFlag : Noflag;
        end
        Xor: begin
            Out <= A ^ B;
            Flag <= (!Out && (Sel >= 0 && Sel <= 4'hB)) ? ZeroFlag : Noflag;
        end
        Nxor: begin
          Out <= ~(A ^ B);
            Flag <= (!Out && (Sel >= 0 && Sel <= 4'hB)) ? ZeroFlag : Noflag;
        end
        Nand: begin
          Out <= ~(A & B);
            Flag <= (!Out && (Sel >= 0 && Sel <= 4'hB)) ? ZeroFlag : Noflag;
        end
        Nor: begin
          Out <= ~(A | B);
            Flag <= (!Out && (Sel >= 0 && Sel <= 4'hB)) ? ZeroFlag : Noflag;
        end
        default: begin
            Out <= 0;
            Flag <= Noflag;
        end
    endcase
endmodule