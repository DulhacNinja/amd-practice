class MonitorOutputBinaryCalculator;
  
  virtual IBinaryCalculator IV;

  function new(virtual IBinaryCalculator IV);
    this.IV = IV;
  endfunction
  
  task main;
    forever begin
      begin
      @(IV.DoutValid, IV.ClkTx, IV.DataOut, IV.CalcActive, IV.CalcMode, IV.CalcBusy);
        $display("Time = %0t, DoutValid = %0h, ClkTx = %0h, DataOut = %0h, CalcActive = %0h, CalcMode = %0h, CalcBusy = %0h",
                        $time, IV.DoutValid, IV.ClkTx, IV.DataOut, IV.CalcActive, IV.CalcMode, IV.CalcBusy);
      end
    end
  endtask
  
endclass