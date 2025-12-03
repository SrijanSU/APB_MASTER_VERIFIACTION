class apb_master_active_agent extends uvm_agent;

  `uvm_component_utils(apb_master_active_agent)

  apb_master_driver              drv;
  apb_master_active_monitor      mon;
  apb_master_sequencer       seqr;
  
  virtual apb_if vif;

  function new(string name="apb_master_active_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))
      `uvm_fatal("APB_ACT_AGT","VIF not set for active agent");

    if(get_is_active() == UVM_ACTIVE) begin
      seqr = apb_master_sequencer::type_id::create("seqr", this);
      drv  = apb_master_driver::type_id::create("drv", this);
    end
    mon = apb_master_active_monitor::type_id::create("mon", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    if(get_is_active() == UVM_ACTIVE) begin
      drv.seq_item_port.connect(seqr.seq_item_export);
    end
    
  endfunction

endclass

