`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_master_seq_item extends uvm_sequence_item;
  rand logic PRESETn;
  rand logic [`ADDR_WIDTH-1:0] PRDATA;
  rand logic PREADY;
  rand logic PSLVERR;
  rand logic transfer;
  rand logic write_read;
  rand logic [`ADDR_WIDTH-1:0] addr_in;
  rand logic [`DATA_WIDTH-1:0] wdata_in;
  rand logic [`DATA_WIDTH/8-1:0] strb_in;
  logic [`ADDR_WIDTH-1:0] PADDR;
  logic PSEL;
  logic PENABLE;
  logic PWRITE;
  logic [`DATA_WIDTH-1:0] PWDATA;
  logic [`DATA_WIDTH/8-1:0] PSTRB;
  logic [`DATA_WIDTH-1:0] rdata_out;
  logic transfer_done;
  logic error;

  function new(string name="apb_master_seq_item");
    super.new(name);
  endfunction
  
    // -------------------------------
  // Basic Legal Constraints
  // -------------------------------
  constraint c_basic {
    PRESETn inside {0,1};
    PRESETn dist {1 := 90, 0 := 10};

    transfer inside {0,1};
    transfer dist {1 := 70, 0 := 30};

    write_read inside {0,1};  

    addr_in inside {[0 : (2**`ADDR_WIDTH - 1)]};

    wdata_in inside {[0 : (2**`DATA_WIDTH - 1)]};

    (write_read == 1) -> strb_in != 0;
    (write_read == 0) -> strb_in == 0;

    PREADY inside {0,1};
    PSLVERR inside {0,1};

   PRDATA inside {[0 : (2**`DATA_WIDTH - 1)]};
  }


  `uvm_object_utils_begin(apb_master_seq_item)
  `uvm_field_int(PRESETn, UVM_ALL_ON | UVM_BIN)
  `uvm_field_int(PSEL, UVM_ALL_ON | UVM_BIN)
  `uvm_field_int(PENABLE, UVM_ALL_ON | UVM_BIN)
  `uvm_field_int(PWRITE, UVM_ALL_ON | UVM_BIN)
  `uvm_field_int(PADDR, UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(PWDATA, UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(PSTRB, UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(PRDATA , UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(PSLVERR , UVM_ALL_ON | UVM_BIN)
  `uvm_field_int(PREADY , UVM_ALL_ON | UVM_BIN)
  `uvm_field_int(transfer, UVM_ALL_ON | UVM_BIN)
  `uvm_field_int(write_read, UVM_ALL_ON | UVM_BIN)
  `uvm_field_int(addr_in, UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(wdata_in, UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(strb_in, UVM_ALL_ON | UVM_BIN)
  `uvm_field_int(rdata_out, UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(transfer_done, UVM_ALL_ON | UVM_BIN)
  `uvm_field_int(error, UVM_ALL_ON | UVM_BIN)
  `uvm_object_utils_end

endclass


