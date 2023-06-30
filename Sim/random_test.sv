`include "environment.sv"
program test(mem_intf vif);
  
  //declaring environment instance
  environment env;
  
  initial begin

    //creating environment
    env = new(vif);
    
    //setting the repeat count of generator as 4, means to generate 4 packets
    env.gen.repeat_count = 2;

    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram