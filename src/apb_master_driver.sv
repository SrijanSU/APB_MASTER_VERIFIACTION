class apb_master_driver extends uvm_driver #(apb_master_seq_item);
  `uvm_component_utils(apb_master_driver)
  virtual apb_if vif;
  bit prev_transfer;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("DRV_NO_VIF", "Virtual interface not set for driver")
  endfunction

  task run_phase(uvm_phase phase);
    repeat(2)@(vif.drv_cb);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
      @( vif.drv_cb);
    end
  endtask

  task drive();
      vif.PRESETn     <= req.PRESETn;
      vif.transfer    <= req.transfer;
      vif.write_read  <= req.write_read;
      vif.addr_in     <= req.addr_in;
      vif.wdata_in    <= req.wdata_in;
      vif.strb_in     <= req.strb_in;

      vif.PREADY      <= req.PREADY;
      vif.PRDATA      <= req.PRDATA;
      vif.PSLVERR     <= req.PSLVERR;
    `uvm_info(get_type_name(),
              $sformatf("driver1 time ",$time),
    UVM_LOW);
    req.print();

    while (req.transfer == 0)begin
         @(vif.drv_cb);
        prev_transfer = req.transfer;
        req.randomize();

        vif.PRESETn     <= req.PRESETn;
        vif.transfer    <= req.transfer;
        vif.write_read  <= req.write_read;
        vif.addr_in     <= req.addr_in;
        vif.wdata_in    <= req.wdata_in;
        vif.strb_in     <= req.strb_in;

        vif.PREADY      <= req.PREADY;
        vif.PRDATA      <= req.PRDATA;
        vif.PSLVERR     <= req.PSLVERR;
      
        `uvm_info(get_type_name(),
                  $sformatf("driver1.2 time",$time),
    UVM_LOW);
        $display("%d",vif.wdata_in);
        req.print();

      end



    if(prev_transfer != req.transfer)begin
        @(vif.drv_cb)
        vif.PRESETn     <= req.PRESETn;
        vif.transfer    <= req.transfer;
        vif.write_read  <= req.write_read;
        vif.addr_in     <= req.addr_in;
        vif.wdata_in    <= req.wdata_in;
        vif.strb_in     <= req.strb_in;

        vif.PREADY      <= req.PREADY;
        vif.PRDATA      <= req.PRDATA;
        vif.PSLVERR     <= req.PSLVERR;
      `uvm_info(get_type_name(),
                $sformatf("driver2 time",$time),
    UVM_LOW);
      req.print();
    end

//       do begin
//         req.randomize() with {
//           PREADY inside {0,1};
//           PSLVERR inside {0,1};

//         };

//         @(vif.drv_cb);
//         prev_transfer = req.transfer;
// //         vif.PRESETn     <= req.PRESETn;
// //        vif.transfer    <= req.transfer;
// //        vif.write_read  <= req.write_read;
// //        vif.addr_in     <= req.addr_in;
// //        vif.wdata_in    <= req.wdata_in;
// //        vif.strb_in     <= req.strb_in;

//         vif.PREADY      <= req.PREADY;  // non-blocking drive
// //        vif.PRDATA      <= req.PRDATA;
//         vif.PSLVERR     <= req.PSLVERR;
//         `uvm_info(get_type_name(),
//                   $sformatf("driver3 time",$time),
//     UVM_LOW);
//         $display("%d",vif.wdata_in);
//         req.print();

//       end
//       while (req.PREADY == 0);
      @(vif.drv_cb);
      vif.PRESETn     <= req.PRESETn;
      vif.transfer    <= req.transfer;
      vif.write_read  <= req.write_read;
      vif.addr_in     <= req.addr_in;
      vif.wdata_in    <= req.wdata_in;
      vif.strb_in     <= req.strb_in;

      vif.PREADY      <= req.PREADY;
      vif.PRDATA      <= req.PRDATA;
      vif.PSLVERR     <= req.PSLVERR;
    `uvm_info(get_type_name(),
              $sformatf("driver3 time ",$time),
    UVM_LOW);
    req.print();

    while (req.PREADY == 0)begin
         @(vif.drv_cb);
        req.randomize();

        vif.PREADY      <= req.PREADY;
        vif.PSLVERR     <= req.PSLVERR;
      
        `uvm_info(get_type_name(),
                  $sformatf("driver3.1 time",$time),
    UVM_LOW);
        $display("%d",vif.wdata_in);
        req.print();

      end


  endtask

endclass
