class apb_master_passive_agent extends uvm_agent;

  `uvm_component_utils(apb_master_passive_agent)

  apb_master_passive_monitor mon;
  virtual apb_if vif;

  function new(string name="apb_master_passive_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))
      `uvm_fatal("APB_PAS_AGT","VIF not set for passive agent");

    mon = apb_master_passive_monitor::type_id::create("mon", this);
  endfunction

endclass

