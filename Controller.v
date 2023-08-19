module Controller
(   input           InputKey,
    input           Clk,
    input           ValidCmd,
    input           Reset,
    input           RW,
    input           TransferDone,
    output          Active,
    output          Busy,
    output          RWMem,
    output          AccessMem,
    output          Mode,
    output          SampleData,
    output          TransferData
);
    wire            DikActiveTmp;
    assign          Active = DikActiveTmp;
    wire            DikModeTmp;
    assign          Mode   = DikModeTmp;

    DecInputKey DIK(.InputKey(InputKey),
                    .ValidCmd(ValidCmd),
                    .Reset(Reset),
                    .Clk(Clk),
                    .Active(DikActiveTmp),
                    .Mode(DikModeTmp)
                    );

    ControlRWFlow CRWF(.ValidCmd(ValidCmd),
                       .RW(RW),
                       .Reset(Reset),
                       .Clk(Clk),
                       .TransferDone(TransferDone),
                       .Active(DikActiveTmp),
                       .Mode(DikModeTmp),
                       .AccessMem(AccessMem),
                       .RWMem(RWMem),
                       .SampleData(SampleData),
                       .TransferData(TransferData),
                       .Busy(Busy));
endmodule