// `uvm_analysis_imp_decl(_passive)   
// `uvm_analysis_imp_decl(_active)

class apb_master_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(apb_master_scoreboard)

  typedef enum {IDLE, SETUP, ACCESS} apb_state_t;
  apb_state_t state;

  uvm_tlm_analysis_fifo #(apb_master_seq_item) act_fifo;
  uvm_tlm_analysis_fifo #(apb_master_seq_item) pas_fifo;

  // expected and actual items
  apb_master_seq_item act_tr;
  apb_master_seq_item pas_tr;
  bit prev_transfer;
  
  // EXPECTED SIGNALS
  bit [`ADDR_WIDTH-1:0] exp_PADDR;
  bit exp_PSEL, exp_PENABLE, exp_PWRITE;
  bit [`DATA_WIDTH-1:0] exp_PWDATA;
  bit [`DATA_WIDTH/8-1:0] exp_PSTRB;
  bit [`DATA_WIDTH-1:0] exp_rdata;
  bit exp_done, exp_err;

  function new(string name = "apb_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    act_fifo = new("act_fifo", this);
    pas_fifo = new("pas_fifo", this);
  endfunction

 task run_phase(uvm_phase phase);
    apb_master_seq_item act_tr, pas_tr;

    forever begin
      act_fifo.get(act_tr);  // input side
      pas_fifo.get(pas_tr);  // DUT output sampling every posedge
//       if(state == IDLE)begin
//       if(prev_transfer == act_tr.transfer)
//         state = SETUP;
//       else
//         state= IDLE;
//       end
      reference_model(act_tr, pas_tr);
      check_outputs(pas_tr);
      prev_transfer = act_tr.transfer;
    end
  endtask


  //----------------------------------------------------------------------
  // REFERENCE MODEL — determines expected signal values based on APB rules
  //----------------------------------------------------------------------
  task reference_model(apb_master_seq_item act, apb_master_seq_item pas);
    

    case(state)

      // -------------------------------------- IDLE
      IDLE: begin
        exp_PSEL = 0;
        exp_PENABLE = 0;
        exp_done = 0;
        exp_err = 0;
//         exp_PWRITE = act.write_read;
//         exp_PADDR  = act.addr_in;
//         exp_PWDATA = act.wdata_in;
//         exp_PSTRB  = act.strb_in;
//         exp_rdata  = act.PRDATA;

        if (act.transfer == 1)
          state = SETUP;
        else
          state = IDLE;
      end

      // -------------------------------------- SETUP
      SETUP: begin
        exp_PSEL = 1;
        exp_PENABLE = 0;
        exp_done = 0;
        exp_err = 0;
        if (!act.write_read)begin
            exp_PWRITE = act.write_read;
          exp_PADDR  = act.addr_in;
          exp_PSTRB  = 0;
          //exp_rdata  = act.PRDATA;
            exp_PWDATA = 0;
          //exp_err = act.PSLVERR;
          end
        else begin
          exp_PWRITE = act.write_read;
          exp_PADDR  = act.addr_in;
          exp_PWDATA = act.wdata_in;
          exp_PSTRB  = act.strb_in;
          //exp_err = act.PSLVERR;
          exp_PWDATA = act.wdata_in;
        end

        state = ACCESS;
      end

      // -------------------------------------- ACCESS
      ACCESS: begin
        exp_PSEL = 1;
        exp_PENABLE = 1;
        

        if (act.PREADY) begin
          if (!act.write_read)begin
            exp_PWRITE = act.write_read;
          exp_PADDR  = act.addr_in;
          exp_PSTRB  = 0;
          exp_rdata  = act.PRDATA;
          exp_err = act.PSLVERR;
          end
        else begin
          exp_PWRITE = act.write_read;
          exp_PADDR  = act.addr_in;
          exp_PWDATA = act.wdata_in;
          exp_PSTRB  = act.strb_in;
          exp_err = act.PSLVERR;
          exp_PWDATA = act.wdata_in;
        end
          
          exp_done = 1;
          state=IDLE;
          
        end
        else begin
          exp_done = 0; // stay ACCESS if PREADY low
          state=ACCESS;
        end
      end

    endcase
  endtask


  //----------------------------------------------------------------------
  // COMPARE EXPECTED vs ACTUAL
  //----------------------------------------------------------------------
  task check_outputs(apb_master_seq_item tr);

  if (exp_PSEL === tr.PSEL)
    `uvm_info("APB_SCB", $sformatf("PSEL PASS  Exp=%0b  Act=%0b", exp_PSEL, tr.PSEL), UVM_LOW)
  else
    `uvm_error("APB_SCB", $sformatf("PSEL FAIL  Exp=%0b  Act=%0b", exp_PSEL, tr.PSEL))

  if (exp_PENABLE === tr.PENABLE)
    `uvm_info("APB_SCB", $sformatf("PENABLE PASS  Exp=%0b  Act=%0b", exp_PENABLE, tr.PENABLE), UVM_LOW)
  else
    `uvm_error("APB_SCB", $sformatf("PENABLE FAIL  Exp=%0b  Act=%0b", exp_PENABLE, tr.PENABLE))

  if (exp_PWRITE === tr.PWRITE)
    `uvm_info("APB_SCB", $sformatf("PWRITE PASS  Exp=%0b  Act=%0b", exp_PWRITE, tr.PWRITE), UVM_LOW)
  else
    `uvm_error("APB_SCB", $sformatf("PWRITE FAIL  Exp=%0b  Act=%0b", exp_PWRITE, tr.PWRITE))

  if (exp_PADDR === tr.PADDR)
    `uvm_info("APB_SCB", $sformatf("PADDR PASS  Exp=%0d  Act=%0d", exp_PADDR, tr.PADDR), UVM_LOW)
  else
    `uvm_error("APB_SCB", $sformatf("PADDR FAIL  Exp=%0d  Act=%0d", exp_PADDR, tr.PADDR))

  if (exp_PWDATA === tr.PWDATA)
    `uvm_info("APB_SCB", $sformatf("PWDATA PASS  Exp=%0d  Act=%0d", exp_PWDATA, tr.PWDATA), UVM_LOW)
  else
    `uvm_error("APB_SCB", $sformatf("PWDATA FAIL  Exp=%0d  Act=%0d", exp_PWDATA, tr.PWDATA))

  if (exp_PSTRB === tr.PSTRB)
    `uvm_info("APB_SCB", $sformatf("PSTRB PASS  Exp=%0d  Act=%0d", exp_PSTRB, tr.PSTRB), UVM_LOW)
  else
    `uvm_error("APB_SCB", $sformatf("PSTRB FAIL  Exp=%0d  Act=%0d", exp_PSTRB, tr.PSTRB))

  if (exp_rdata === tr.rdata_out)
    `uvm_info("APB_SCB", $sformatf("RDATA PASS  Exp=%0d  Act=%0d", exp_rdata, tr.rdata_out), UVM_LOW)
  else
    `uvm_error("APB_SCB", $sformatf("RDATA FAIL  Exp=%0d  Act=%0d", exp_rdata, tr.rdata_out))

  if (exp_done === tr.transfer_done)
    `uvm_info("APB_SCB", $sformatf("DONE PASS  Exp=%0b  Act=%0b", exp_done, tr.transfer_done), UVM_LOW)
  else
    `uvm_error("APB_SCB", $sformatf("DONE FAIL  Exp=%0b  Act=%0b", exp_done, tr.transfer_done))

  if (exp_err === tr.error)
    `uvm_info("APB_SCB", $sformatf("ERROR PASS  Exp=%0b  Act=%0b", exp_err, tr.error), UVM_LOW)
  else
    `uvm_error("APB_SCB", $sformatf("ERROR FAIL  Exp=%0b  Act=%0b", exp_err, tr.error))

endtask


endclass
