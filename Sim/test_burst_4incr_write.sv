`include "amba_ahb_defines.sv"
`include "environment.sv"

program test(mem_intf vif);

  class my_trans extends transaction;
  
    bit [`HADDR_SIZE-1:0] prev_HADDR = 0; // variable to store the previous address
    function void pre_randomize();
    HTRANS  .rand_mode(0);
    HWRITE  .rand_mode(0);
    HSIZE   .rand_mode(0);
    HADDR   .rand_mode(0);
    HADDR   =  prev_HADDR;
    HTRANS  = `H_SEQ;
    HWRITE  = `H_WRITE;
    HSIZE   = `H_SIZE_32;

    prev_HADDR    = prev_HADDR + (2**HSIZE );

    endfunction  
  constraint haddr_within_256B {
   HADDR inside {[0:255]};
  };
  constraint address_alignment {
    HADDR % (2**HSIZE) == 0;
  };
  endclass

  environment env;
  my_trans my_tr;

  initial begin
    env                  = new(vif);
    my_tr                = new();
    env.gen.trans        = my_tr;
    env.gen.repeat_count = 25;
    env.scb.hport_data_access = 0;
    $readmemh("local_mem.txt", env.scb.local_memory,0,255); 
    env.run();
  end

endprogram
