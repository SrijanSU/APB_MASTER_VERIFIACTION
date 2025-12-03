class apb_master_sequencer extends uvm_sequencer#(apb_master_seq_item);
  `uvm_component_utils(apb_master_sequencer)    // Register with the factory

  function new(string name = "apb_master_sequencer",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new
  
endclass:apb_master_sequencer
