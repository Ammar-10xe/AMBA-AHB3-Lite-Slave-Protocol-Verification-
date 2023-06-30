class generator;
    transaction trans, tr;
    mailbox     gen2driv;
    int         repeat_count;
    event       gen_ended;

  function new( mailbox gen2driv, event gen_ended );
    this.gen2driv     = gen2driv;
    this.gen_ended    = gen_ended;
    trans             = new();
  endfunction

  task main();
    repeat (repeat_count) begin
      if ( !trans.randomize() )  $fatal("[Generator]: Trans randomization failed");
      tr = trans.do_copy();
      gen2driv.put(tr);
      $display("[Generator]: All packets sent to driver");
      end
    -> gen_ended;
  endtask

endclass


