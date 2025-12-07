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


// Setup to Access
  property setup_to_access;
    @(posedge PCLK) disable iff (!PRESETn)
    (PSEL && !PENABLE) |=> PENABLE;
  endproperty
  assert property(setup_to_access)
    else $error("Protocol Error: PENABLE didn't assert after PSEL at time %0t", $time);

  property penable_needs_psel;
    @(posedge PCLK) disable iff (!PRESETn)
    PENABLE |-> PSEL;
  endproperty
  assert property(penable_needs_psel)
    else $error("Protocol Error: PENABLE is high but PSEL is low at time %0t", $time);


  property penable_deassert;
    @(posedge PCLK) disable iff (!PRESETn)
    (PSEL && PENABLE && PREADY) |=> !PENABLE;
  endproperty
  assert property(penable_deassert)
    else $error("Protocol Error: PENABLE stuck high after PREADY at time %0t", $time);


  // Address stable during wait states
  property addr_stable;
    @(posedge PCLK) disable iff (!PRESETn)
    (PSEL && PENABLE && !PREADY) |=> $stable(PADDR);
  endproperty
  assert property(addr_stable)
    else $error("Stability Error: PADDR changed during wait state at time %0t", $time);

  // PWRITE stable during wait states
  property write_stable;
    @(posedge PCLK) disable iff (!PRESETn)
    (PSEL && PENABLE && !PREADY) |=> $stable(PWRITE);
  endproperty
  assert property(write_stable)
    else $error("Stability Error: PWRITE changed during wait state at time %0t", $time);

  // PWDATA stable during write wait states
  property wdata_stable;
    @(posedge PCLK) disable iff (!PRESETn)
    (PSEL && PENABLE && PWRITE && !PREADY) |=> $stable(PWDATA);
  endproperty
  assert property(wdata_stable)
    else $error("Stability Error: PWDATA changed during write wait at time %0t", $time);

  // PSTRB during write wait states
  property strb_stable;
    @(posedge PCLK) disable iff (!PRESETn)
    (PSEL && PENABLE && PWRITE && !PREADY) |=> $stable(PSTRB);
  endproperty
  assert property(strb_stable)
    else $error("Stability Error: PSTRB changed during write wait at time %0t", $time);


//X/Z test
  property addr_valid;
    @(posedge PCLK) disable iff (!PRESETn)
    (PSEL) |-> !$isunknown(PADDR);
  endproperty
  assert property(addr_valid)
    else $error("Invalid Signal: PADDR has X/Z values at time %0t", $time);


  property write_valid;
    @(posedge PCLK) disable iff (!PRESETn)
    (PSEL) |-> !$isunknown(PWRITE);
  endproperty
  assert property(write_valid)
    else $error("Invalid Signal: PWRITE has X/Z values at time %0t", $time);

  property wdata_valid;
    @(posedge PCLK) disable iff (!PRESETn)
    (PSEL && PWRITE) |-> !$isunknown(PWDATA);
  endproperty
  assert property(wdata_valid)
    else $error("Invalid Signal: PWDATA has X/Z values during write at time %0t", $time);

  property psel_valid;
    @(posedge PCLK) disable iff (!PRESETn)
    !$isunknown(PSEL);
  endproperty
  assert property(psel_valid)
    else $error("Invalid Signal: PSEL has X/Z values at time %0t", $time);


  property penable_valid;
    @(posedge PCLK) disable iff (!PRESETn)
    !$isunknown(PENABLE);
  endproperty
  assert property(penable_valid)
    else $error("Invalid Signal: PENABLE has X/Z values at time %0t", $time);

  // PSTRB must be 0 during read operations
  property strb_zero_read;
    @(posedge PCLK) disable iff (!PRESETn)
    (PSEL && !PWRITE) |-> (PSTRB == '0);
  endproperty
  assert property(strb_zero_read)
    else $error("Strobe Error: PSTRB should be 0 during read at time %0t", $time);

  property strb_valid_write;
    @(posedge PCLK) disable iff (!PRESETn)
    (PSEL && PWRITE) |-> !$isunknown(PSTRB);
  endproperty
  assert property(strb_valid_write)
    else $error("Invalid Signal: PSTRB has X/Z values during write at time %0t", $time);

  // Control signals must be cleared during reset
  property reset_check;
    @(posedge PCLK)
    (!PRESETn) |-> (!PSEL && !PENABLE);
  endproperty
  assert property(reset_check)
    else $error("Reset Error: Control signals not cleared during reset at time %0t", $time);

  // In IDLE state (PSEL=0), PENABLE must be low
  property idle_penable_low;
    @(posedge PCLK) disable iff (!PRESETn)
    (!PSEL) |-> (!PENABLE);
  endproperty
  assert property(idle_penable_low)
    else $error("Idle Error: PENABLE high while PSEL is low at time %0t", $time);

  property return_to_idle_or_access;
    @(posedge PCLK) disable iff (!PRESETn)
    (PSEL && PENABLE && PREADY) |=> (!PSEL || (PSEL && !PENABLE));
  endproperty
  assert property(return_to_idle_or_access)
    else $error("State Error: Invalid state after transaction completion at time %0t", $time);


  // PSEL cannot toggle during access phase
  property psel_stable_access;
    @(posedge PCLK) disable iff (!PRESETn)
    (PSEL && PENABLE && !PREADY) |=> PSEL;
  endproperty
  assert property(psel_stable_access)
    else $error("Protocol Error: PSEL deasserted during access phase at time %0t", $time);

  // PREADY must not have X/Z when PSEL and PENABLE are high
  property pready_valid;
    @(posedge PCLK) disable iff (!PRESETn)
    (PSEL && PENABLE) |-> !$isunknown(PREADY);
  endproperty
  assert property(pready_valid)
    else $error("Invalid Signal: PREADY has X/Z values during access phase at time %0t", $time);

  // PRDATA must not have X/Z during read operations when PREADY is high
  property rdata_valid;
    @(posedge PCLK) disable iff (!PRESETn)
    (PSEL && PENABLE && !PWRITE && PREADY) |-> !$isunknown(PRDATA);
  endproperty
  assert property(rdata_valid)
    else $error("Invalid Signal: PRDATA has X/Z values during read completion at time %0t", $time);

endinterface
