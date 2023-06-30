`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
  
   //Instances
  generator  gen;
  driver     driv;
  monitor    mon;
  scoreboard scb;
  
  //mailbox handle's
  mailbox gen2driv;
  mailbox mon2scb;

  //event for synchronization between generator and test
  event gen_ended;
  
  //virtual interface
  virtual mem_intf vif;
  
  //constructor
  function new(virtual mem_intf vif);
    //get the interface from test
    this.vif = vif;

    //creating the mailbox (Same handle will be shared across generator and driver
    gen2driv = new();
    mon2scb  = new();
    
    //creating generator and driver
    gen  = new (gen2driv,gen_ended);
    driv = new (gen2driv,vif);
    mon  = new (mon2scb, vif);
    scb  = new (mon2scb);
  endfunction
  
  
  task pre_test();
    driv.reset();
  endtask
  
  task test();
    fork 
    gen.main();
    driv.main();
    mon.main();
    scb.main();      
    join_any
  endtask
  
  task post_test();
    wait(gen_ended.triggered);
    wait(gen.repeat_count == driv.no_transaction);
    wait(gen.repeat_count == scb.no_transaction);
  endtask  
  
  //run task
  task run;
    pre_test();
    test();
    post_test();
    $finish;
  endtask
  
endclass

