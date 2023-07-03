`include "amba_ahb_defines.sv"
`include "environment.sv"

program test(mem_intf vif);
   bit [1:0] count; 
  class my_trans extends transaction;
    function void pre_randomize();
        HREADY .rand_mode(0);
      if(count%2 == 0) begin
        HREADY = `H_READ;
      end
      else begin
        HREADY = `H_WRITE;
      end
        count++;

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
