interface IBinaryCalculator #(parameter SIZE = 4);
    logic                       Clk;
    logic                       Reset;
    logic                       InputKey;
    logic                       ValidCmd;
    logic                       RW;
    logic   [7:0]               Addr;
    logic   [7:0]               InA;
    logic   [7:0]               InB;
    logic   [3:0]               Sel;
    logic                       ConfigDiv;
    logic   [31:0]              Din;

    logic                       DoutValid;
    logic   [SIZE-1:0]          DataOut;
    logic                       ClkTx;
    logic                       CalcBusy;
    logic                       CalcActive;
    logic                       CalcMode;

    modport DUT (
    input                   Clk,
    input                   Reset,
    input                   InputKey,
    input                   ValidCmd,
    input                   RW,
    input                   Addr,
    input                   InA,
    input                   InB,
    input                   Sel,
    input                   ConfigDiv,
    input                   Din,
    output                  DoutValid,
    output                  DataOut,
    output                  ClkTx,
    output                  CalcBusy,
    output                  CalcActive,
    output                  CalcMode);

endinterface