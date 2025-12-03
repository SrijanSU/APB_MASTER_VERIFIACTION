class apb_master_active_monitor extends uvm_monitor;

  `uvm_component_utils(apb_master_active_monitor)

  virtual apb_if vif;
  uvm_analysis_port #(apb_master_seq_item) mon_act_ap;

  function new(string name="apb_master_active_monitor", uvm_component parent=null);
    super.new(name,parent);
    mon_act_ap = new("mon_act_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))
      `uvm_fatal("APB_MON","VIF not set for monitor")
  endfunction


  task run_phase(uvm_phase phase);
    apb_master_seq_item seq;
    repeat(3)@(vif.act_mon_cb);
    
    forever begin
//    @(vif.act_mon_cb);
       //#0;
        seq = apb_master_seq_item::type_id::create("seq", this);
    
        seq.transfer   = vif.act_mon_cb.transfer;
    seq.PRESETn    = vif.act_mon_cb.PRESETn;
    seq.PRDATA     = vif.act_mon_cb.PRDATA;
    seq.PREADY     = vif.act_mon_cb.PREADY;
    seq.PSLVERR    = vif.act_mon_cb.PSLVERR;
    seq.write_read = vif.act_mon_cb.write_read;
    seq.addr_in    = vif.act_mon_cb.addr_in;
    seq.wdata_in   = vif.act_mon_cb.wdata_in;
    seq.strb_in    = vif.act_mon_cb.strb_in;
      `uvm_info(get_type_name(), 
                $sformatf("Active monitor time",$time),
    UVM_LOW);
      seq.print();
        mon_act_ap.write(seq);
        @(vif.act_mon_cb);
      end
  endtask

endclass

