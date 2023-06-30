`include "amba_ahb_defines.sv"
class transaction;
  rand bit                   HSEL;
  rand bit [`HADDR_SIZE-1:0] HADDR;
  rand bit [`HDATA_SIZE-1:0] HWDATA;
  bit      [`HDATA_SIZE-1:0] HRDATA;
  rand bit                   HWRITE;
  rand bit [            2:0] HSIZE;
  rand bit [            2:0] HBURST;
  rand bit [            3:0] HPROT;
  rand bit [            1:0] HTRANS;
  bit                        HREADYOUT;
  rand bit                   HREADY;
  bit                        HRESP;

 //for debugging purposes ( to allign the address with the local memory ) 
  constraint haddr_within_256B {
   HADDR inside {[0:255]};
  };
//Setting the Slave select to 1
  constraint hsel   { HSEL   == `H_SLAVE_SELECT;
  };
//Assuming that each instruction takes one cycle only
  constraint hready { HREADY == `H_READY;
  };

 //Single burst, 4-beat wrapping burst and 4-beat increment burst
  constraint single_burst {
    HBURST inside {`H_SINGLE, `H_WRAP4, `H_INCR4};
  };
  // Address aligned w.r.t. Size
  constraint address_alignment {
    solve HSIZE before HADDR;
    HADDR % (2**HSIZE) == 0;
  };
// Protection control for Data Access only
  constraint data_protection {
    HPROT == `HPROT_DATA_ACCESS;
  };
// Transfer sizes of byte, half word and word only
  constraint transfer_sizes {
    HSIZE inside {`H_SIZE_8, `H_SIZE_16, `H_SIZE_32};
  };

  // deep copy method
  function transaction do_copy();
    transaction trans;
    trans = new();
    trans.HSEL      = this.HSEL;
    trans.HADDR     = this.HADDR;
    trans.HWDATA    = this.HWDATA;
    trans.HRDATA    = this.HRDATA;
    trans.HWRITE    = this.HWRITE;
    trans.HSIZE     = this.HSIZE;
    trans.HBURST    = this.HBURST;
    trans.HPROT     = this.HPROT;
    trans.HTRANS    = this.HTRANS;
    trans.HREADYOUT = this.HREADYOUT;
    trans.HREADY    = this.HREADY;
    trans.HRESP     = this.HRESP;
    return trans;
  endfunction

  // print_trans method to print transaction item values for debug purposes
  function void print_trans();
    $display("--------- [Trans] Transaction Item Values ------");
    $display("\t HSEL      = %b", HSEL);
    $display("\t HADDR     = %h", HADDR);
    $display("\t HWDATA    = %h", HWDATA);
    $display("\t HRDATA    = %h", HRDATA);
    $display("\t HWRITE    = %b", HWRITE);
    $display("\t HSIZE     = %b", HSIZE);
    $display("\t HBURST    = %b", HBURST);
    $display("\t HPROT     = %b", HPROT);
    $display("\t HTRANS    = %b", HTRANS);
    $display("\t HREADYOUT = %b", HREADYOUT);
    $display("\t HREADY    = %b", HREADY);
    $display("\t HRESP     = %b", HRESP);
    $display("---------------------------------------------");
  endfunction

endclass
