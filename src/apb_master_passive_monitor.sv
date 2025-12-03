class apb_master_passive_monitor extends uvm_monitor;

  `uvm_component_utils(apb_master_passive_monitor)

  virtual apb_if vif;
  uvm_analysis_port #(apb_master_seq_item) mon_pas_ap;

  function new(string name="apb_passive_monitor", uvm_component parent=null);
    super.new(name, parent);
    mon_pas_ap = new("mon_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))
      `uvm_fatal("PAS_MON","VIF not set for passive monitor");
  endfunction

  task run_phase(uvm_phase phase);
    apb_master_seq_item tr;
    repeat(3)@(vif.pas_mon_cb);

    forever begin
      @(vif.pas_mon_cb);
    #0;
      // create new sequence item
      tr = apb_master_seq_item::type_id::create("tr", this);

      // -----------------------
      // Capture DUT outputs
      // -----------------------
      tr.PADDR          = vif.pas_mon_cb.PADDR;
      tr.PSEL           = vif.pas_mon_cb.PSEL;
      tr.PENABLE        = vif.pas_mon_cb.PENABLE;
      tr.PWRITE         = vif.pas_mon_cb.PWRITE;
      tr.PWDATA         = vif.pas_mon_cb.PWDATA;
      tr.PSTRB          = vif.pas_mon_cb.PSTRB;
      tr.rdata_out      = vif.pas_mon_cb.rdata_out;
      tr.transfer_done  = vif.pas_mon_cb.transfer_done;
      tr.error          = vif.pas_mon_cb.error;
      `uvm_info(get_type_name(), 
                $sformatf("Passive monitor time",$time),
    UVM_LOW);
      tr.print();
      // send to scoreboard / analysis port
      mon_pas_ap.write(tr);
     // @(vif.pas_mon_cb);
    end
  endtask

endclass

