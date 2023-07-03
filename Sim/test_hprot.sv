`include "amba_ahb_defines.sv"
`include "environment.sv"

program test(mem_intf vif);

  class my_trans extends transaction;
    function void pre_randomize();
        HPROT  .rand_mode(0);
        HTRANS .rand_mode(0);
        HBURST .rand_mode(0);
        HBURST = `H_WRAP8;
        HPROT  = 4'd1;
        HTRANS = 2'bx;
    endfunction  
    constraint data_protection{};
    constraint single_burst{};  
  endclass

  environment env;
  my_trans my_tr;

  initial begin
    env = new(vif);
    my_tr = new();
    env.gen.trans = my_tr;
    env.gen.repeat_count = 25;
    env.scb.hport_data_access = 0; 
    env.run();
  end

endprogram
