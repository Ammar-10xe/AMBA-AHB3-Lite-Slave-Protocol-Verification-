`include "amba_ahb_defines.sv"
`include "environment.sv"

program test(mem_intf vif);

  class my_trans extends transaction;
    
    bit [5:0] temp_variable;
    bit [`HADDR_SIZE-1:0] prev_HADDR = 0; // variable to store the previous address
    function void pre_randomize();
    HWRITE  .rand_mode(0);
    HSIZE   .rand_mode(0);
    HADDR   .rand_mode(0);
    if (temp_variable == 4**HSIZE) begin
        prev_HADDR = 32'd0;
        temp_variable = 5'd0;
    end
    HADDR   =  prev_HADDR;
    HWRITE  = `H_WRITE;
    HSIZE   = `H_SIZE_32;

    prev_HADDR    = prev_HADDR + (2**HSIZE );
    temp_variable = temp_variable + (2**HSIZE);
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
