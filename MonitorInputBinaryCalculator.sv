class MonitorInputBinaryCalculator;
  
  virtual IBinaryCalculator IV;

  function new(virtual IBinaryCalculator IV);
    this.IV = IV;
  endfunction
  
  task main;
    forever begin
      begin
      @(IV.InputKey, IV.ValidCmd, IV.RW, IV.Addr, IV.InA, IV.InB, IV.Sel, IV.ConfigDiv, IV.Din, IV.Reset);
        $display("Time = %0t, InputKey = %0h, ValidCmd = %0h, RW = %0h, Addr = %0h, InA = %0h, InB = %0h, Sel = %0h, ConfigDiv = %0h, Din = %0h, Reset = %0h",
                        $time, IV.InputKey, IV.ValidCmd, IV.RW, IV.Addr, IV.InA, IV.InB, IV.Sel, IV.ConfigDiv, IV.Din, IV.Reset);
      end
    end
  endtask
  
endclass