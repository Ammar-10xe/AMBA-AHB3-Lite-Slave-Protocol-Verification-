//For this test deafualt values will be read from the memory of the dut that was stored in a seperate file named as "mem_init.txt"
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
    constraint transfer_sizes {
    HSIZE ==`H_SIZE_32;
  };
  endclass

  environment env;
  my_trans my_tr;

  initial begin
    env = new(vif);
    my_tr = new();
    env.gen.trans = my_tr;
    env.gen.repeat_count = 25;
    $readmemh("local_mem.txt", env.scb.local_memory,0,255); 
    $display("local_mem read successfully");
    env.run();
  end

endprogram
