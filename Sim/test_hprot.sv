`include "amba_ahb_defines.sv"
`include "environment.sv"

program test(mem_intf vif);

  class my_trans extends transaction;
    function void pre_randomize();
        HPROT  .rand_mode(0);
        HPROT = 4'd1;
    endfunction  
    constraint data_protection{}; 
  endclass

  environment env;
  my_trans my_tr;

  initial begin
    env = new(vif);
    my_tr = new();
    env.gen.trans = my_tr;
    env.gen.repeat_count = 25;
    env.run();
  end

endprogram
