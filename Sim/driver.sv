`define DRIV_IF vif.DRIVER.driver_cb
class driver;
  transaction       trans;
  int               no_transaction;
  virtual mem_intf  vif;
  mailbox           gen2driv;
  
  // Constructor
  function new(mailbox gen2driv , virtual mem_intf vif);
    this.gen2driv       = gen2driv;  
    this.vif            = vif; 
  endfunction

  // Reset method: Resets the interface signals to default/initial values
  task reset;
    wait(vif.HRESETn == 0); // Wait for reset signal to be asserted
    $display("╔═════════════════════════════════════╗");
    $display("║        [DRIVER] Reset Started        ║");
    $display("╚═════════════════════════════════════╝");
    `DRIV_IF.HSEL   <= 0;
    `DRIV_IF.HADDR  <= 0;
    `DRIV_IF.HWDATA <= 0;
    `DRIV_IF.HWRITE <= 0;
    `DRIV_IF.HSIZE  <= 0;
    `DRIV_IF.HBURST <= 0;
    `DRIV_IF.HPROT  <= 0;
    `DRIV_IF.HTRANS <= 0;
    `DRIV_IF.HREADY <= 0;
    wait(vif.HRESETn == 1); // Wait for reset signal to be de-asserted
    $display("╔═════════════════════════════════════╗");
    $display("║        [DRIVER] Reset Ended          ║");
    $display("╚═════════════════════════════════════╝");
  endtask
  
  // Drive task to drive the transaction items to the interface
  task drive();
  forever begin
    trans = new();
    gen2driv.get(trans);
    @(posedge vif.DRIVER.HCLK);
    // $display("--------- [DRIVER-TRANSFER: %0d] ---------",no_transaction);
    `DRIV_IF.HSEL    <= trans.HSEL;
    `DRIV_IF.HADDR   <= trans.HADDR;
    `DRIV_IF.HWDATA  <= trans.HWDATA;
    `DRIV_IF.HWRITE  <= trans.HWRITE;
    `DRIV_IF.HSIZE   <= trans.HSIZE;
    `DRIV_IF.HBURST  <= trans.HBURST;
    `DRIV_IF.HPROT   <= trans.HPROT;
    `DRIV_IF.HTRANS  <= trans.HTRANS;
    `DRIV_IF.HREADY  <= trans.HREADY;
    //  $display("-----------------------------------------");
     no_transaction++;
    // wait (~`DRIV_IF.HRESP & `DRIV_IF.HREADYOUT); //wait till the HRESP is low and HREADYOUT is high
    // print_drv();
  end
  endtask

task print_drv(); //for debugging purposes 
  $display("HSEL %h",   trans.HSEL);
  $display("HADDR %h",  trans.HADDR);
  $display("HWDATA %h", trans.HWDATA);
  $display("HWRITE %h", trans.HWRITE);
  $display("HSIZE %h",  trans.HSIZE);
  $display("HBURST %h", trans.HBURST);
  $display("HPROT %h",  trans.HPROT);
  $display("HTRANS %h", trans.HTRANS);
  $display("HREADY %h", trans.HREADY);
endtask

  // Main method: Waits until the reset comes and then calls the drive method
  task main;
    wait(vif.HRESETn);
    drive();
  endtask
  
endclass



