`include "amba_ahb_defines.sv"
`include "environment.sv"

program test(mem_intf vif);
   
  bit [4:0] ctrl_rw;
  class my_trans extends transaction;
    function void pre_randomize();
        HBURST  .rand_mode(0);
        HSIZE   .rand_mode(0);
        HADDR   .rand_mode(0);
        HTRANS  .rand_mode(0);
        HTRANS  = `H_NONSEQ;
        HADDR   = 32'd16;
        HBURST  =`H_SINGLE;
        HSIZE   = `H_SIZE_8;

        if (ctrl_rw % 2 != 0) begin
            HWRITE =`H_READ;
        end 
        else begin
            HWRITE =`H_WRITE;
        end
        ctrl_rw++;
    
    endfunction  
    constraint transfer_sizes {};
    constraint single_burst {};
  endclass

  environment env;
  my_trans my_tr;

  initial begin
    env = new(vif);
    my_tr = new();
    env.gen.trans = my_tr;
    env.gen.repeat_count = 10;
    env.scb.hport_data_access = 0;
    $readmemh("local_mem.txt", env.scb.local_memory,0,255); 
    env.run();
  end

endprogram
