module ControlRWFlow
(   input           ValidCmd,
    input           RW,
    input           Reset,
    input           Clk,
    input           TransferDone,
    input           Active,
    input           Mode,
    output reg      AccessMem,
    output reg      RWMem,
    output reg      SampleData,
    output reg      TransferData,
 	output reg      Busy
);
    localparam      Read    = 0;
    localparam      Write   = 1;

    localparam Idle                             = 3'b000;
    localparam ReadMemory                       = 3'b001;
    localparam SampleSerialTransceiver          = 3'b010;
    localparam StartTransferSerialTransceiver   = 3'b011;
    localparam WaitTransferDone                 = 3'b100;
    localparam WriteMemory                      = 3'b101;

    reg [2:0] CurrentState;
    reg [2:0] NextState;

  always @(CurrentState, Active, Mode, RW, TransferDone, ValidCmd)    
    case (CurrentState)
        Idle: begin
          if(ValidCmd == 1 && Active == 1 && Mode == 1 && RW == Read)
            begin
                NextState = ReadMemory;
            end
          else if(ValidCmd == 1 && Active == 1 && Mode == 1 && RW == Write)
            begin
                NextState = WriteMemory;
            end
          else if(ValidCmd == 1 && Active == 1 && Mode == 0)
            begin
                NextState = SampleSerialTransceiver;
            end
            else 
            begin
                NextState = Idle;
            end
        end
        ReadMemory: begin
          if(Active == 1 && Mode == 1 && TransferDone == 0)
            begin       
                NextState = SampleSerialTransceiver;
            end
            else
            begin
                NextState = ReadMemory;
            end
        end
        SampleSerialTransceiver: begin
          if(Active == 1 && TransferDone == 0)
            begin                
                NextState = StartTransferSerialTransceiver;
            end
            else
            begin
                NextState = SampleSerialTransceiver;
            end
        end
        StartTransferSerialTransceiver: begin
          if(Active == 1 && TransferDone == 0)
            begin
                NextState = WaitTransferDone;
            end
            else
            begin
                NextState = StartTransferSerialTransceiver;
            end
        end
        WaitTransferDone: begin
          if(TransferDone == 1)
            begin
                NextState = Idle;
            end
            else
            begin
                NextState = WaitTransferDone;
            end
        end
        WriteMemory: begin
            if(ValidCmd == 1 && Active == 1 && Mode == 1 && RW == Write)
            begin
                NextState = WriteMemory;
            end
            else
            begin
                NextState = Idle;
            end
        end
        default: begin                       
            NextState = Idle;
        end
    endcase

    always@(posedge Clk, posedge Reset)
    if(Reset)begin
        AccessMem             = 0;
        RWMem                 = 0;
        SampleData            = 0;
        TransferData          = 0;
        Busy                  = 0;
      	CurrentState 	      = Idle;
      	NextState		      = Idle;
    end
    else begin
     CurrentState <= NextState;
    end

    always@(CurrentState)
    case(CurrentState)
        Idle: begin
            AccessMem       = 0;
            RWMem           = 0;
            SampleData      = 0;
            TransferData    = 0;
            Busy            = 0;
        end
        ReadMemory: begin 
            AccessMem       = 1;
            RWMem           = 0; 
            SampleData      = 0;
            TransferData    = 0;
            Busy            = 1;
        end
        SampleSerialTransceiver: begin
          	AccessMem       = 0;
            RWMem           = 0;
            SampleData      = 1;
            TransferData    = 0;
            Busy            = 1;
        end
        StartTransferSerialTransceiver: begin
            AccessMem       = 0;
            RWMem           = 0;
          	SampleData      = 0;
            TransferData    = 1;
            Busy            = 1;
        end
        WaitTransferDone: begin
            AccessMem       = 0;
            RWMem           = 0;
            SampleData      = 0;
            TransferData    = 0;
            Busy            = 1;
        end
        WriteMemory: begin
            AccessMem       = 1;
            RWMem           = 1;
            SampleData      = 0;
            TransferData    = 0;
            Busy            = 1;
        end
        default: begin      // something went wrong if I ever reach this state
            AccessMem       = 1;
            RWMem           = 1;
            SampleData      = 1;
            TransferData    = 1;
            Busy            = 1;
         end
    endcase
endmodule