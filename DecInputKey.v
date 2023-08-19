module DecInputKey
(   input           InputKey,
    input           ValidCmd,
    input           Reset,
    input           Clk,
    output reg      Active,
 	output reg      Mode
);
    localparam IDLE        = 3'b000;    //0
    localparam S1          = 3'b001;    //1
    localparam S2          = 3'b010;    //2
    localparam S3          = 3'b011;    //3
    localparam CORRECT     = 3'b100;    //4
    localparam MODE_CHANGE = 3'b101;    //5
    localparam WRONG       = 3'b110;    //6
  	localparam MODE_CHANGE_2 = 3'b111;  //7

    reg [2:0] CurrentState;
    reg [2:0] NextState;

  always @(InputKey, CurrentState, ValidCmd)begin
    case(CurrentState)
        IDLE:
        begin
            if(ValidCmd == 0)
            begin
                NextState = IDLE;
            end
            else
            begin
                if(InputKey == 1)
                begin
                    NextState = S1;
                end
                else
                begin
                    NextState = WRONG;
                end
            end
        end
        S1:
        begin
            if(ValidCmd == 1 && InputKey == 0)
            begin
                NextState = S2;
            end
            else
            begin
                NextState = WRONG;
            end
        end
        S2:
        begin
            if(ValidCmd == 1 && InputKey == 1)
            begin
                NextState = S3;
            end
            else
            begin
                NextState = WRONG;
            end
        end
        S3:
        begin
            if(ValidCmd == 1 && InputKey == 0)
            begin
                NextState = CORRECT;
            end
            else
            begin
                NextState = WRONG;
            end
        end
        CORRECT:
        begin
            if(ValidCmd == 1)
            begin
                NextState = MODE_CHANGE;
            end
            else
            begin
                NextState = WRONG;
            end
        end
        MODE_CHANGE:
        begin
          if(ValidCmd == 1)
            begin
                NextState = MODE_CHANGE_2;
            end
          else
             begin
            NextState = MODE_CHANGE;
             end
        end
        MODE_CHANGE_2:
        begin
          if(ValidCmd == 1)
            begin
                NextState = MODE_CHANGE;
            end
          else
             begin
            NextState = MODE_CHANGE_2;
             end
        end
        WRONG:
        begin
                NextState = WRONG;
        end
        default:
        begin
                NextState = IDLE;
        end
    endcase    
  end

  always @(posedge Clk, posedge Reset) begin 
    if(Reset) 
    begin
        CurrentState <= IDLE;
    end
    else 
    begin
        CurrentState <= NextState;
    end
  end
    always@(CurrentState)
    case(CurrentState)
        IDLE:           begin   Mode = 0; Active = 0; end
        S1:             begin   Mode = 0; Active = 0; end
        S2:             begin   Mode = 0; Active = 0; end
        S3:             begin   Mode = 0; Active = 0; end
        CORRECT:        begin   Mode = 0; Active = 0; end

        MODE_CHANGE:    begin   
                                Mode = InputKey; 
                                Active = 1; 
                        end
		MODE_CHANGE_2:  begin   
                                Mode = InputKey; 
                                Active = 1; 
                        end

        WRONG:          begin   Mode = 0; Active = 0; end
        default:        begin   Mode = 0; Active = 0; end
    endcase
endmodule