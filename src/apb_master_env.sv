class apb_master_env extends uvm_env;

  `uvm_component_utils(apb_master_env)

  apb_master_active_agent   a_agt;
  apb_master_passive_agent  p_agt;
  apb_master_scoreboard     scb;
  apb_master_subscriber      subscr;

  function new(string name="apb_master_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    a_agt = apb_master_active_agent ::type_id::create("a_agt", this);
    p_agt = apb_master_passive_agent::type_id::create("p_agt", this);
    scb   = apb_master_scoreboard    ::type_id::create("scb", this);
    subscr  = apb_master_subscriber  ::type_id::create("subscr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect analysis ports from monitors to scoreboard
    a_agt.mon.mon_act_ap.connect(scb.act_fifo.analysis_export);
    a_agt.mon.mon_act_ap.connect(subscr.analysis_export);
    
    p_agt.mon.mon_pas_ap.connect(scb.pas_fifo.analysis_export);
    p_agt.mon.mon_pas_ap.connect(subscr.pas_mon);
  endfunction

endclass

