interface apb_if(input bit PCLK);
  logic PRESETn;
  logic [`DATA_WIDTH-1:0] PRDATA;
  logic PREADY;
  logic PSLVERR;
  logic transfer;
  logic write_read;
  logic [`ADDR_WIDTH-1:0] addr_in;
  logic [`DATA_WIDTH-1:0] wdata_in;
  logic [`DATA_WIDTH/8-1:0] strb_in;
  logic [`ADDR_WIDTH-1:0] PADDR;
  logic PSEL;
  logic PENABLE;
  logic PWRITE;
  logic [`DATA_WIDTH-1:0] PWDATA;
  logic [`DATA_WIDTH/8-1:0] PSTRB;
  logic [`DATA_WIDTH-1:0] rdata_out;
  logic transfer_done;
  logic error;

  

  clocking drv_cb @(posedge PCLK);
    default input #1 output #1;
    
    input   PSEL;
    input PENABLE;
    
    output  PRESETn;
    output  PRDATA;
    output  PREADY;
    output  PSLVERR;
    output  transfer;
    output  write_read;
    output  addr_in;
    output  wdata_in;
    output  strb_in;
    
  endclocking 
  
  clocking act_mon_cb @(posedge PCLK);
    default input #1 output #1;
    
    input  PRESETn;
    input  PRDATA;
    input  PREADY;
    input  PSLVERR;
    input  transfer;
    input  write_read;
    input  addr_in;
    input  wdata_in;
    input  strb_in;
  endclocking

  clocking pas_mon_cb @(posedge PCLK);
    default input #1 output #1;
    
    input PADDR;
    input PSEL;
    input PENABLE;
    input PWRITE;
    input PWDATA;
    input PSTRB;
    input rdata_out;
    input transfer_done;
    input error;
  endclocking



  modport DRV(clocking drv_cb);
  modport ACT_MON(clocking act_mon_cb);
  modport PAS_MON(clocking pas_mon_cb);

endinterface

