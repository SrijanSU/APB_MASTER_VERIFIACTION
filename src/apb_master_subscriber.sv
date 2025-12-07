`uvm_analysis_imp_decl(_passive_mon)

class apb_master_subscriber extends uvm_subscriber #(apb_master_seq_item);

  `uvm_component_utils(apb_master_subscriber)

  apb_master_seq_item act_tr;
  apb_master_seq_item pas_tr;
  
  uvm_analysis_imp_passive_mon#(apb_master_seq_item,apb_master_subscriber) pas_mon; 

  covergroup apb_ip_cg ;


    PRESETn_cp     : coverpoint act_tr.PRESETn { bins pr[] = {0,1}; }
    addr_in_cp     : coverpoint act_tr.addr_in {bins addr[]= {[0:(2**`ADDR_WIDTH)-1]};}
    write_read_cp  : coverpoint act_tr.write_read { bins wr_rd[] = {0,1}; }
    wdata_in_cp    : coverpoint act_tr.wdata_in {bins wdata[]= {[0:(2**`DATA_WIDTH)-1]};}
    PRDATA_cp      : coverpoint act_tr.PRDATA {bins prdata[]= {[0:(2**`DATA_WIDTH)-1]};}
    transfer_cp    : coverpoint act_tr.transfer { bins trans[] = {0,1}; }
    strb_in_cp     : coverpoint act_tr.strb_in { bins strb[] = {[0:(`DATA_WIDTH/8)-1]}; }
    PSLVERR_cp     : coverpoint act_tr.PSLVERR { bins pslverr[] = {0,1}; }
    PREADY_cp      : coverpoint act_tr.PREADY { bins ready[] = {0,1}; }


    write_readxaddr_in : cross write_read_cp, addr_in_cp;
    write_readxwdata_in: cross write_read_cp, wdata_in_cp;
    addr_inxwdata_in   : cross addr_in_cp, wdata_in_cp;
  endgroup
  
  covergroup apb_op_cg ;


    rdata_out_cp     : coverpoint pas_tr.rdata_out {bins rdata[]= {[0:(2**`DATA_WIDTH)-1]};}
    PSEL_cp          : coverpoint pas_tr.PSEL { bins psel[] = {0,1}; }
    PENABLE_cp       : coverpoint pas_tr.PENABLE { bins pen[] = {0,1}; }
    PADDR_cp         : coverpoint pas_tr.PADDR {bins paddr[]= {[0:(2**`ADDR_WIDTH)-1]};}
    PWRITE_cp        : coverpoint pas_tr.PWRITE { bins pw[] = {0,1}; }
    PWDATA_cp        : coverpoint pas_tr.PWDATA { bins pwdata[] = {0,1}; }
    PSTRB_cp         : coverpoint pas_tr.PSTRB { bins pstrb[] = {[0:(`DATA_WIDTH/8)-1]}; }
    transfer_done_cp : coverpoint pas_tr.transfer_done { bins tr_do[] = {0,1}; }
    error_cp         : coverpoint pas_tr.error { bins err[] = {0,1}; }


    PADDRxrdata_out : cross PADDR_cp, rdata_out_cp;

  endgroup



  function new(string name="apb_master_subscriber", uvm_component parent=null);
    super.new(name, parent);
    apb_ip_cg = new();
    apb_op_cg = new();
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    pas_mon = new("pas_mon",this);
  endfunction:build_phase


 function void write(apb_master_seq_item t);
   act_tr = t;
   apb_ip_cg.sample();
   `uvm_info(get_name,"[SUBSCIBER]:INPUT RECIEVED",UVM_HIGH);
  endfunction
  
  function void write_passive_mon(apb_master_seq_item t);
    pas_tr = t;
    apb_op_cg.sample();   
    `uvm_info(get_name,"[SUBSCIBER]:INPUT RECIEVED",UVM_HIGH);
  endfunction

endclass

