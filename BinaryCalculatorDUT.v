`include "ALU.v"
`include "Concatenator.v"
`include "ControlRWFlow.v"
`include "DecInputKey.v"
`include "Controller.v"
`include "Memory.v"
`include "MUX.v"
`include "FrequencyDivider.v"
`include "SerialTransceiver.v"

module BinaryCalculator#(parameter SIZE = 4)
  (	input 	[7:0]		InA,
   	input 	[7:0]		InB,
   	input 	[3:0]		Sel,
	input 	[7:0]		Addr,
   	input 				InputKey,
   	input 				Clk,
   	input 				ValidCmd,
   	input 				Reset,
   	input 				RW,
   	input 				ConfigDiv,	
   	input 	[31:0]		Din,
	output 				CalcBusy,
	output				CalcActive,
	output				CalcMode,
	output 				DoutValid,
   	output 	[SIZE-1:0]	DataOut,
	output 				ClkTx
  );
	wire			[7:0]	MuxInATmp, MuxInBTmp;
	wire			[3:0]	MuxSelTmp;
	wire			[7:0]	AluOutTmp;
	wire			[3:0]	AluFlagTmp;
	wire			[31:0]	ConcatOutTmp;
	wire					ResetTmp;
	wire			[31:0]	MemDout;
	wire					CtrlActiveTmp;
	wire					CtrlRWMemTmp;
	wire					CtrlAccessMemTmp;
	wire					CtrlModeTmp;
	wire					CtrlSampleDataTmp;
	wire					CtrlTransferData;
	wire					RWTmp;
	wire			[31:0]	TxDinTmp;
	wire					SerialTxDone;

	assign ResetTmp 	= Reset && !CtrlActiveTmp;
	assign RWTmp		= RW	&& CtrlActiveTmp;
	assign CalcActive	= CtrlActiveTmp;
	assign CalcMode		= CtrlModeTmp;
	
	MUX#(8)			M1		(.I0(InA), .I1(8'h00), .Out(MuxInATmp), .Sel(ResetTmp));
	MUX#(8)			M2		(.I0(InB), .I1(8'h00), .Out(MuxInBTmp), .Sel(ResetTmp));
	MUX#(4)			M3		(.I0(Sel), .I1(4'h0),  .Out(MuxSelTmp), .Sel(ResetTmp));
	MUX#(32)		M4		(.I0(ConcatOutTmp), .I1(MemDout), .Out(TxDinTmp), .Sel(CtrlModeTmp));

	ALU				M_ALU	(.A(MuxInATmp), .B(MuxInBTmp), .Sel(MuxSelTmp), .Out(AluOutTmp), .Flag(AluFlagTmp));
	Concatenator	Concat  (.InA(MuxInATmp), .InB(MuxInBTmp), .InC(AluOutTmp), .InD(MuxSelTmp), .InE(AluFlagTmp), .Out(ConcatOutTmp));
	
	Controller		Ctrl    (.InputKey(InputKey),
							 .Clk(Clk),
							 .ValidCmd(ValidCmd), 
							 .Reset(Reset), 
							 .RW(RWTmp), 
							 .TransferDone(SerialTxDone), 
							 .Active(CtrlActiveTmp), 
							 .Busy(CalcBusy), 
							 .RWMem(CtrlRWMemTmp), 
							 .AccessMem(CtrlAccessMemTmp), 
							 .Mode(CtrlModeTmp), 
							 .SampleData(CtrlSampleDataTmp), 
							 .TransferData(CtrlTransferData));

		Memory				Mem 	(.Din(ConcatOutTmp), 
									 .Addr(Addr), 
									 .R_W(CtrlRWMemTmp), 
									 .Valid(CtrlAccessMemTmp), 
									 .Reset(ResetTmp), 
									 .Clk(Clk), 
									 .Dout(MemDout));

  SerialTransceiver#(.SIZE(SIZE))	Serial 	(.DataIn(TxDinTmp),
									 .SampleData(CtrlSampleDataTmp),
									 .StartTx(CtrlTransferData),
									 .Reset(ResetTmp),
									 .TxDone(SerialTxDone),
									 .Clk(Clk),
									 .ClkTx(ClkTx),
									 .DataOut(DataOut),
									 .TxBusy(DoutValid));
	
	FrequencyDivider	FreqDiv   	(.Din(Din),
									 .ConfigDiv(ConfigDiv),
									 .Reset(ResetTmp),
									 .Clk(Clk),
									 .Enable(CtrlActiveTmp),
									 .ClkOut(ClkTx));

endmodule