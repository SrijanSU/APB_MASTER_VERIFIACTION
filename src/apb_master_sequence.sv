class apb_master_base_sequence extends uvm_sequence#(apb_master_seq_item); //BASE sequence
  `uvm_object_utils(apb_master_base_sequence)    //Factory Registration
  apb_master_seq_item seq;

  function new(string name = "apb_base_sequence");
    super.new(name);
  endfunction:new

  task body();
    repeat(10)begin
    `uvm_do_with(seq,
    {
     // seq.transfer == 1;
      seq.PRESETn == 1;
      seq.PREADY == 1;
      seq.write_read ==1;
    })
    end
  endtask
endclass:apb_master_base_sequence

class normal extends apb_master_base_sequence; //BASE sequence
  `uvm_object_utils(normal)    //Factory Registration
  apb_master_seq_item seq;


  function new(string name = "normal");
    super.new(name);
  endfunction:new

  task body();
    repeat(10)begin
      `uvm_do(seq);
    end
  endtask
endclass


class write_sequence extends apb_master_base_sequence; //BASE sequence
  `uvm_object_utils(write_sequence)    //Factory Registration
  apb_master_seq_item seq;


  function new(string name = "write_sequence");
    super.new(name);
  endfunction:new

  task body();
    repeat(10)begin
    `uvm_do_with(seq,
    {
      seq.write_read == 1;
    })
    end
  endtask
endclass

class read_sequence extends apb_master_base_sequence; //BASE sequence
  `uvm_object_utils(read_sequence)    //Factory Registration
  apb_master_seq_item seq;


  function new(string name = "read_sequence");
    super.new(name);
  endfunction:new

  task body();
    repeat(10)begin
    `uvm_do_with(seq,
    {
      seq.write_read == 0;
    })
    end
  endtask
endclass

class error_sequence extends apb_master_base_sequence; //BASE sequence
  `uvm_object_utils(error_sequence)    //Factory Registration
  apb_master_seq_item seq;


  function new(string name = "error_sequence");
    super.new(name);
  endfunction:new

  task body();
    repeat(10)begin
    `uvm_do_with(seq,
    {
      seq.PSLVERR == 1;
    })
    end
  endtask
endclass

class no_transfer_sequence extends apb_master_base_sequence; //BASE sequence
  `uvm_object_utils(no_transfer_sequence)    //Factory Registration
  apb_master_seq_item seq;


  function new(string name = "no_transfer_sequence");
    super.new(name);
  endfunction:new

  task body();
    repeat(10)begin
    `uvm_do_with(seq,
    {
      seq.transfer == 0;
    })
    end
  endtask
endclass

class no_pready_sequence extends apb_master_base_sequence; //BASE sequence
  `uvm_object_utils(no_pready_sequence)    //Factory Registration
  apb_master_seq_item seq;


  function new(string name = "no_pready_sequence");
    super.new(name);
  endfunction:new

  task body();
    repeat(10)begin
    `uvm_do_with(seq,
    {
      seq.PREADY == 0;
    })
    end
  endtask
endclass

class pstrb_sequence extends apb_master_base_sequence; //BASE sequence
  `uvm_object_utils(pstrb_sequence)    //Factory Registration
  apb_master_seq_item seq;


  function new(string name = "pstrb_sequence");
    super.new(name);
  endfunction:new

  task body();
    repeat(10)begin
    `uvm_do_with(seq,
    {
      seq.strb_in == 1;
    })
    end
  endtask
endclass

class no_pstrb_sequence extends apb_master_base_sequence; //BASE sequence
  `uvm_object_utils(no_pstrb_sequence)    //Factory Registration
  apb_master_seq_item seq;


  function new(string name = "no_pstrb_sequence");
    super.new(name);
  endfunction:new

  task body();
    repeat(10)begin
    `uvm_do_with(seq,
    {
      seq.strb_in == 0;
    })
    end
  endtask
endclass



class regression_sequence extends apb_master_base_sequence; //BASE sequence
  
  write_sequence seq1;
  read_sequence seq2;
  error_sequence seq3;
  no_transfer_sequence seq4;
  no_pready_sequence seq5;
  normal      seq6;
  pstrb_sequence  seq7;
  no_pstrb_sequence seq8;
  
  
  `uvm_object_utils(regression_sequence)    //Factory Registration
  apb_master_seq_item seq;


  function new(string name = "regression_sequence");
    super.new(name);
  endfunction:new

  task body();
    `uvm_do(seq4)
    `uvm_do(seq1)
    `uvm_do(seq2)
    `uvm_do(seq3)
    `uvm_do(seq5)
    `uvm_do(seq6)
    `uvm_do(seq7)
    `uvm_do(seq8)
  endtask

endclass
