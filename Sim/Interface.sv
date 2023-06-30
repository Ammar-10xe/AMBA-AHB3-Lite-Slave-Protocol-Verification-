`include "amba_ahb_defines.sv"
interface mem_intf(input logic HCLK, HRESETn);
  logic                   HSEL;
  logic [`HADDR_SIZE-1:0] HADDR;
  logic [`HDATA_SIZE-1:0] HWDATA;
  logic [`HDATA_SIZE-1:0] HRDATA;
  logic                   HWRITE;
  logic [            2:0] HSIZE;
  logic [            2:0] HBURST;
  logic [            3:0] HPROT;
  logic [            1:0] HTRANS;
  logic                   HREADYOUT;
  logic                   HREADY;
  logic                   HRESP;
  
  // driver clocking block
  clocking driver_cb @(posedge HCLK);
    default input #1 output #1;
    input  HRDATA, HREADYOUT, HRESP;
    output HSEL, HADDR, HWDATA, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HREADY;
    
  endclocking
  
  // monitor clocking block
  clocking monitor_cb @(posedge HCLK);
    default input #1 output #1;
    input HRDATA, HREADYOUT, HRESP;
    input HSEL, HADDR, HWDATA, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HREADY;
  endclocking
  
  // modports
  modport DRIVER  (clocking driver_cb,  input HCLK, HRESETn);
  modport MONITOR (clocking monitor_cb, input HCLK, HRESETn);
  
endinterface

