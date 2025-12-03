class apb_master_test extends uvm_test;
  `uvm_component_utils(apb_master_test)

  apb_master_env env;
  

  function new(string name = "apb_master_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = apb_master_env::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.a_agt" , "is_active" ,UVM_ACTIVE);           
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.p_agt","is_active",UVM_PASSIVE);
    
  endfunction

  task run_phase(uvm_phase phase);
    apb_master_base_sequence seq;
    phase.raise_objection(this);
   seq = apb_master_base_sequence::type_id::create("seq");
    `uvm_info("APB_TEST", "Starting APB Master test", UVM_LOW)

    seq.start(env.a_agt.seqr);

    `uvm_info("APB_TEST", "APB Master test completed", UVM_LOW)

    phase.drop_objection(this);
  endtask

endclass


