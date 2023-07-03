`include "amba_ahb_defines.sv"
`include "environment.sv"

program test(mem_intf vif);

  class my_trans extends transaction;
    function void pre_randomize();
    HWRITE  .rand_mode(0);
    HBURST  .rand_mode(0);
    HBURST  = `H_SINGLE;        
    HWRITE  = `H_WRITE;
    endfunction  
  endclass

  environment env;
  my_trans my_tr;

  initial begin
    env                       = new(vif);
    my_tr                     = new();
    env.gen.trans             = my_tr;
    env.gen.repeat_count      = 25;
    env.scb.hport_data_access = 1'b0;
    
    $readmemh("local_mem.txt", env.scb.local_memory,0,255); 
    env.run();
  end

endprogram
