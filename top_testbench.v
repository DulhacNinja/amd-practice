`include "IBinaryCalculator.sv"
`include "MonitorInputBinaryCalculator.sv"
`include "MonitorOutputBinaryCalculator.sv"
module testbench_interface;

  IBinaryCalculator#(.SIZE(4)) I();
    BinaryCalculator#(.SIZE(4)) dut (
        .Clk            (I.Clk),
        .Reset          (I.Reset),
        .InputKey       (I.InputKey),
        .ValidCmd       (I.ValidCmd),
        .RW             (I.RW),
        .Addr           (I.Addr),
        .InA            (I.InA),
        .InB            (I.InB),
        .Sel            (I.Sel),
        .ConfigDiv      (I.ConfigDiv),
        .Din            (I.Din),

        .DoutValid      (I.DoutValid),
        .ClkTx          (I.ClkTx),
        .DataOut        (I.DataOut),
        .CalcActive     (I.CalcActive),
        .CalcMode       (I.CalcMode),
        .CalcBusy       (I.CalcBusy)
    );
  MonitorInputBinaryCalculator monitorInput = new(I);
  MonitorOutputBinaryCalculator monitorOutput = new(I);
      initial begin
              I.Reset 			= 1;          //0
              I.InA	  			= 32'hFE;
              I.InB   			= 32'hE;
              I.Sel   			= 0;
              I.Addr				= 0;
              I.InputKey			= 0;
              I.ValidCmd			= 0;
              I.RW				= 0;
              I.ConfigDiv			= 0;
              I.Din				= 0;	
      
        #200 	I.Reset = 0;          //200
     			I.ValidCmd = 1;		
      			I.InputKey = 1;
      			I.ConfigDiv = 1;
      			I.Din = 2;
      			
      
      	#200	I.InputKey = 0;		//400
      			I.ConfigDiv = 0;
      	
      	#200	I.InputKey = 1;		//600
      	
      	#200	I.InputKey = 0;		//800
      	
      	#200	I.InputKey = 0;//mode //1000

      #13500	I.ValidCmd = 0; 
                I.InputKey = 1; 
                I.InA = 6; 
                I.InB = 7;
                I.Sel = 2;
                I.RW = 1;		//first change the mode and then the instruction ( cant change both mode and instruction on the same tick )
      
	    #600 	I.ValidCmd = 1;		

        #30000 $finish; 
    end
  
    initial begin
        $dumpfile("dump.vcd");
      $dumpvars(0, dut);
        I.Clk <= 0;
        forever #100 I.Clk =  ~I.Clk;
    end
  initial begin
      monitorInput.main;
    end
  initial begin
        monitorOutput.main;
    end
endmodule