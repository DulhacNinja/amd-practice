module SerialTransceiver#(parameter DinLENGTH = 32, SIZE = 4)
(   input   [DinLENGTH-1:0]     DataIn,
    input                       SampleData,
    input                       StartTx,
    input                       Reset,
    input                       Clk,
    input                       ClkTx,
    output reg                  TxBusy,
    output reg                  TxDone,
 	output reg	[SIZE-1:0]      DataOut
);
    reg    [DinLENGTH-1:0]      RegBank;
    reg    [DinLENGTH-1:0]      RegCounter = 0;
    reg                         TxFlag = 0;

    always @(posedge Clk, posedge Reset)
    if(Reset)begin
        TxBusy = 0;
        RegBank = 0;
        TxDone = 0;
        RegCounter = 0;
      	DataOut = 0;
        TxFlag = 0;
    end
    else begin
        if(SampleData && !StartTx)begin
            RegBank = DataIn;
            RegCounter = DinLENGTH - 1; 
        end
      else if(StartTx && !SampleData && !TxFlag && !TxBusy)begin
            TxBusy = 1;
            TxDone = 0;
        	TxFlag = 0;
        end
      else if(TxFlag && TxBusy) begin
            TxDone = 1;
            TxBusy = 0;
        	TxFlag = 1;
        end
      else if(TxFlag && !TxBusy) begin
            TxDone = 0;
        	TxFlag = 0;
        end


    end
    always @(posedge ClkTx) begin
      if(TxBusy && !TxFlag && !TxDone) begin
        if(RegCounter - SIZE < RegCounter) begin
          DataOut <= RegBank[DinLENGTH - 1: DinLENGTH-SIZE];
            RegBank <= RegBank << SIZE;
            RegCounter <= RegCounter - SIZE;
        end
        else 
            begin 
                DataOut <= RegBank[DinLENGTH - 1: DinLENGTH-SIZE];
                TxFlag <= 1;
                RegBank <= RegBank << SIZE;
            end
        end
    end
endmodule