`include "uvm_pkg.sv"
`include "uvm_macros.svh"
`include "apb_master_pkg.sv"
`include "apb_master_interface.sv"
`include "defines.sv"
`include "design.v"
 import uvm_pkg::*;  
 import apb_master_pkg::*;


module top;
  
   
  // Clock & reset
  bit PCLK;
  bit PRESETn;

  // Instantiate APB interface
  apb_if apb_vif (PCLK);

  // DUT instantiation (matches ALL signals you shared)
  apb_master #(
    .ADDR_WIDTH(8),
    .DATA_WIDTH(32)
  ) DUT (
    // Global
    .PCLK          (PCLK),
    .PRESETn       (PRESETn),

    // APB Master Interface (to slave)
    .PADDR         (apb_vif.PADDR),
    .PSEL          (apb_vif.PSEL),
    .PENABLE       (apb_vif.PENABLE),
    .PWRITE        (apb_vif.PWRITE),
    .PWDATA        (apb_vif.PWDATA),
    .PSTRB         (apb_vif.PSTRB),
    .PRDATA        (apb_vif.PRDATA),
    .PREADY        (apb_vif.PREADY),
    .PSLVERR       (apb_vif.PSLVERR),

    // User Interface Inputs
    .transfer      (apb_vif.transfer),
    .write_read    (apb_vif.write_read),
    .addr_in       (apb_vif.addr_in),
    .wdata_in      (apb_vif.wdata_in),
    .strb_in       (apb_vif.strb_in),

    // User Interface Outputs
    .rdata_out     (apb_vif.rdata_out),
    .transfer_done (apb_vif.transfer_done),
    .error         (apb_vif.error)
  );

  // Clock generator
  initial begin
    PCLK = 0;
    forever #5 PCLK = ~PCLK;
  end

  // Reset generator
  initial begin
    PRESETn = 0;
    repeat(2)@(posedge PCLK);
    PRESETn = 1;
  end

  // Start UVM test
  initial begin
    // Provide virtual interface to agent inside env
    uvm_config_db#(virtual apb_if)::set(null, "*", "vif", apb_vif);

    run_test("apb_master_test");
    #100 $finish;
  end

endmodule

