`define MON_IF vif.MONITOR.monitor_cb
class monitor;

   mailbox          mon2scb;
   virtual mem_intf vif;
   int              no_transaction;
   transaction      trans;
  //constructor
  function new(mailbox mon2scb , virtual mem_intf vif);
    this.mon2scb = mon2scb;
    this.vif     = vif;
  endfunction
  
task print_mon(); //for debuggin purposes 
  $display("HSEL %h",     `MON_IF.HSEL);
  $display("HADDR %h",    `MON_IF.HADDR);
  $display("HWDATA %h",   `MON_IF.HWDATA);
  $display("HWRITE %h",   `MON_IF.HWRITE);
  $display("HSIZE %h",    `MON_IF.HSIZE);
  $display("HBURST %h",   `MON_IF.HBURST);
  $display("HPROT %h",    `MON_IF.HPROT);
  $display("HTRANS %h",   `MON_IF.HTRANS);
  $display("HREADY %h",   `MON_IF.HREADY);
  $display("output obtained is...");
  $display("HRDATA %h",   `MON_IF.HRDATA);
  $display("HREADYOUT %h",`MON_IF.HREADYOUT);
  $display("HRESP %h",    `MON_IF.HRESP);
endtask

  //Samples the interface signal and send the sample packet to scoreboard
  task main();
  forever begin
      trans = new();
      @(posedge vif.MONITOR.HCLK);
        $display("--------- [MONITOR-TRANSFER: %0d] ---------",no_transaction);
        trans.HSEL      = `MON_IF.HSEL;
        trans.HADDR     = `MON_IF.HADDR;
        trans.HWRITE    = `MON_IF.HWRITE;
        trans.HSIZE     = `MON_IF.HSIZE;
        trans.HBURST    = `MON_IF.HBURST;
        trans.HPROT     = `MON_IF.HPROT;
        trans.HTRANS    = `MON_IF.HTRANS;
        trans.HREADY    = `MON_IF.HREADY;
        if (`MON_IF.HWRITE) begin
          @(posedge vif.MONITOR.HCLK);
          trans.HWDATA    = `MON_IF.HWDATA;
        end 
        else begin
           @(posedge vif.MONITOR.HCLK);
           trans.HRDATA    = `MON_IF.HRDATA;
        end
        trans.HREADYOUT = `MON_IF.HREADYOUT;
        trans.HRESP     = `MON_IF.HRESP;
        mon2scb.put(trans);
        // print_mon();
        $display("-----------------------------------------");
        no_transaction++;
  end
  endtask
endclass


