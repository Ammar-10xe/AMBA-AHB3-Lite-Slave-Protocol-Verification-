`include "amba_ahb_defines.sv"
`include "environment.sv"

program test(mem_intf vif);

  class my_trans extends transaction;
    function void pre_randomize();
    HTRANS  .rand_mode(0);
    HWRITE  .rand_mode(0);
    HTRANS  = `H_NONSEQ;
    HWRITE  = `H_READ;
    endfunction  
  endclass

  environment env;
  my_trans my_tr;

  initial begin
    env = new(vif);
    my_tr = new();
    env.gen.trans = my_tr;
    env.gen.repeat_count = 25;
    env.scb.big_endian = 0;
    $readmemh("local_mem.txt", env.scb.local_memory,0,255); 
    env.run();
  end

endprogram
