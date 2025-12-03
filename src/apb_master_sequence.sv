class apb_master_base_sequence extends uvm_sequence#(apb_master_seq_item); //BASE sequence
  `uvm_object_utils(apb_master_base_sequence)    //Factory Registration
  apb_master_seq_item seq;
  bit read_prev;
  int unsigned qu[$];

  function new(string name = "apb_base_sequence");
    super.new(name);
  endfunction:new

  task body();
    repeat(10)begin
    `uvm_do_with(seq,
    {
      seq.transfer == 1;
      seq.PRESETn == 1;
      seq.PREADY == 1;
    })
    end
  endtask
endclass:apb_master_base_sequence
