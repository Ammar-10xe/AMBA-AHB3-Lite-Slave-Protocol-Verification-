`include "amba_ahb_defines.sv"
`include "environment.sv"

program test(mem_intf vif);

  class my_trans extends transaction;
    function void pre_randomize();
        HREADY .rand_mode(0);
        HSEL   .rand_mode(0);
        HPROT  .rand_mode(0);
        HSEL   =`H_NO_SLAVE_SELECT;
        HPROT  = 4'b0010; // Privileged access
        HREADY =`H_READY; 
    endfunction
    constraint hsel   {};
    constraint hready {};  
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
