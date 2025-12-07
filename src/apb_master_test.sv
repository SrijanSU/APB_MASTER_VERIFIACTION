class apb_master_base_test extends uvm_test;
  `uvm_component_utils(apb_master_base_test)

  apb_master_env env;
  apb_master_base_sequence seq;

  function new(string name = "apb_master_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = apb_master_env::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.a_agt" , "is_active" ,UVM_ACTIVE);           
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.p_agt","is_active",UVM_PASSIVE);
    
  endfunction

  task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
    
    phase.raise_objection(this);
   seq = apb_master_base_sequence::type_id::create("seq");
    `uvm_info("APB_TEST", "Starting APB Master test", UVM_LOW)

    seq.start(env.a_agt.seqr);

    `uvm_info("APB_TEST", "APB Master test completed", UVM_LOW)

    phase.drop_objection(this);
    phase_done.set_drain_time(this,40); 
  endtask

endclass

class apb_master_write_test extends uvm_test;
  `uvm_component_utils(apb_master_write_test)

  apb_master_env env;
  write_sequence seq;
  

  function new(string name = "apb_master_write_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = apb_master_env::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.a_agt" , "is_active" ,UVM_ACTIVE);           
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.p_agt","is_active",UVM_PASSIVE);
    
  endfunction

  virtual task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
    
    phase.raise_objection(this);
   seq = write_sequence ::type_id::create("seq");
    `uvm_info("APB_TEST", "Starting APB Master Write test", UVM_LOW)

    seq.start(env.a_agt.seqr);

    `uvm_info("APB_TEST", "APB Master Write test completed", UVM_LOW)

    phase.drop_objection(this);
    phase_done.set_drain_time(this,40); 
  endtask

endclass


class apb_master_read_test extends uvm_test;
  `uvm_component_utils(apb_master_read_test)

  apb_master_env env;
  read_sequence seq;

  function new(string name = "apb_master_read_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = apb_master_env::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.a_agt" , "is_active" ,UVM_ACTIVE);           
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.p_agt","is_active",UVM_PASSIVE);
    
  endfunction

  virtual task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
    
    
    phase.raise_objection(this);
   seq = read_sequence::type_id::create("seq");
    `uvm_info("APB_TEST", "Starting APB Master Read test", UVM_LOW)

    seq.start(env.a_agt.seqr);

    `uvm_info("APB_TEST", "APB Master Read test completed", UVM_LOW)

    phase.drop_objection(this);
    phase_done.set_drain_time(this,40); 
  endtask

endclass


class apb_master_error_test extends uvm_test;
  `uvm_component_utils(apb_master_error_test)

  apb_master_env env;
  error_sequence seq;

  function new(string name = "apb_master_error_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = apb_master_env::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.a_agt" , "is_active" ,UVM_ACTIVE);           
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.p_agt","is_active",UVM_PASSIVE);
    
  endfunction

  virtual task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
    
    
    phase.raise_objection(this);
   seq = error_sequence::type_id::create("seq");
    `uvm_info("APB_TEST", "Starting APB Master Error test", UVM_LOW)

    seq.start(env.a_agt.seqr);

    `uvm_info("APB_TEST", "APB Master Read Error completed", UVM_LOW)

    phase.drop_objection(this);
    phase_done.set_drain_time(this,40); 
  endtask

endclass

class apb_master_no_transfer_test extends uvm_test;
  `uvm_component_utils(apb_master_no_transfer_test)

  apb_master_env env;
  no_transfer_sequence seq;

  function new(string name = "apb_master_no_transfer_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = apb_master_env::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.a_agt" , "is_active" ,UVM_ACTIVE);           
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.p_agt","is_active",UVM_PASSIVE);
    
  endfunction

  virtual task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
    
    phase.raise_objection(this);
   seq = no_transfer_sequence::type_id::create("seq");
    `uvm_info("APB_TEST", "Starting APB Master No Transfer test", UVM_LOW)

    seq.start(env.a_agt.seqr);

    `uvm_info("APB_TEST", "APB Master Read No Transfer completed", UVM_LOW)

    phase.drop_objection(this);
    phase_done.set_drain_time(this,40); 
  endtask

endclass



class apb_master_no_pready_test extends uvm_test;
  `uvm_component_utils(apb_master_no_pready_test)

  apb_master_env env;
  no_pready_sequence seq;

  function new(string name = "apb_master_no_pready_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = apb_master_env::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.a_agt" , "is_active" ,UVM_ACTIVE);           
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.p_agt","is_active",UVM_PASSIVE);
    
  endfunction

  virtual task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
    
    phase.raise_objection(this);
   seq = no_pready_sequence::type_id::create("seq");
    `uvm_info("APB_TEST", "Starting APB Master No PREADY test", UVM_LOW)

    seq.start(env.a_agt.seqr);

    `uvm_info("APB_TEST", "APB Master Read No PREADY completed", UVM_LOW)

    phase.drop_objection(this);
    phase_done.set_drain_time(this,40); 
  endtask

endclass

class normal_test extends uvm_test;
  `uvm_component_utils(normal_test)

  apb_master_env env;
  normal seq;

  function new(string name = "normal_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = apb_master_env::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.a_agt" , "is_active" ,UVM_ACTIVE);           
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.p_agt","is_active",UVM_PASSIVE);
    
  endfunction

  virtual task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
    
    phase.raise_objection(this);
   seq = normal::type_id::create("seq");
    `uvm_info("APB_TEST", "Starting APB Master Normal test", UVM_LOW)

    seq.start(env.a_agt.seqr);

    `uvm_info("APB_TEST", "APB Master Read Normal completed", UVM_LOW)

    phase.drop_objection(this);
    phase_done.set_drain_time(this,40); 
  endtask

endclass

class strobe_test extends uvm_test;
  `uvm_component_utils(strobe_test)

  apb_master_env env;
  pstrb_sequence seq;

  function new(string name = "strobe_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = apb_master_env::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.a_agt" , "is_active" ,UVM_ACTIVE);           
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.p_agt","is_active",UVM_PASSIVE);
    
  endfunction

  virtual task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
    
    phase.raise_objection(this);
   seq = pstrb_sequence::type_id::create("seq");
    `uvm_info("APB_TEST", "Starting APB Master Strobe test", UVM_LOW)

    seq.start(env.a_agt.seqr);

    `uvm_info("APB_TEST", "APB Master Read Strobe completed", UVM_LOW)

    phase.drop_objection(this);
    phase_done.set_drain_time(this,40); 
  endtask

endclass

class no_pstrobe_test extends uvm_test;
  `uvm_component_utils(no_pstrobe_test)

  apb_master_env env;
  no_pstrb_sequence seq;

  function new(string name = "no_pstrobe_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = apb_master_env::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.a_agt" , "is_active" ,UVM_ACTIVE);           
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.p_agt","is_active",UVM_PASSIVE);
    
  endfunction

  virtual task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
    
    phase.raise_objection(this);
   seq = no_pstrb_sequence::type_id::create("seq");
    `uvm_info("APB_TEST", "Starting APB Master NO Strobe test", UVM_LOW)

    seq.start(env.a_agt.seqr);

    `uvm_info("APB_TEST", "APB Master Read NO Strobe completed", UVM_LOW)

    phase.drop_objection(this);
    phase_done.set_drain_time(this,40); 
  endtask

endclass


class regression_test extends uvm_test;
  `uvm_component_utils(regression_test)

  apb_master_env env;
  regression_sequence seq;

  function new(string name = "regression_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = apb_master_env::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.a_agt" , "is_active" ,UVM_ACTIVE);           
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.p_agt","is_active",UVM_PASSIVE);
    
  endfunction

  virtual task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
    
    phase.raise_objection(this);
   seq = regression_sequence::type_id::create("seq");
    `uvm_info("APB_TEST", "Starting APB Master Regressiontest", UVM_LOW)

    seq.start(env.a_agt.seqr);

    `uvm_info("APB_TEST", "APB Master Read Regression completed", UVM_LOW)

    phase.drop_objection(this);
    phase_done.set_drain_time(this,40); 
  endtask

endclass
