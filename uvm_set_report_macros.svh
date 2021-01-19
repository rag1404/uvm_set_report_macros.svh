// Let's take the same example from Messaging verbosity

import uvm_pkg::*;
`include "uvm_macros.svh"
program tb;

class transaction extends uvm_object;
  rand bit[3:0] data;
  rand bit[5:0] addr;
  rand bit wr_en;
  
  `uvm_object_utils_begin(transaction);
  `uvm_field_int(data,UVM_ALL_ON)
  `uvm_field_int(addr,UVM_ALL_ON)
  `uvm_field_int(wr_en,UVM_ALL_ON)
  `uvm_object_utils_end;
  
  
  function new (string name  = "transaction");
    super.new(name);
  endfunction  
    
  function void print_call ();
    `uvm_info(get_full_name(),"I belong here",UVM_HIGH);
  endfunction
  
endclass

// comp_a has 1 UVM_LOW and 1 UVM_MEDIUM message
  

class comp_a extends uvm_component;
  `uvm_component_utils (comp_a)
  
  uvm_analysis_port #(transaction) broadcast_port;
  
  function new (string name = "comp_a", uvm_component parent);
    super.new(name,parent);
  endfunction
  
   function void build_phase(uvm_phase phase);
     broadcast_port = new("broadcast_port",this);
  endfunction
  
  task run_phase (uvm_phase phase);
    transaction tx;
    
    tx = transaction::type_id::create("tx", this);
    
    void'(tx.randomize());
    `uvm_info(get_type_name(),$sformatf(" tranaction randomized"),UVM_LOW)
    tx.print();
    tx.print_call();
    `uvm_info(get_type_name(),$sformatf(" tranaction sending to comp_c"),UVM_MEDIUM)
    broadcast_port.write(tx);

  endtask  
  
endclass

// comp_b has 1 UVM_HIGH and 1 UVM_LOW messages

class comp_b extends uvm_component;
  `uvm_component_utils (comp_b)
  
  uvm_analysis_port #(transaction) aport_send;
  
  function new (string name = "comp_b", uvm_component parent);
    super.new(name,parent);
  endfunction
  
   function void build_phase(uvm_phase phase);
     aport_send = new("aport_send",this);
  endfunction
  
  task run_phase (uvm_phase phase);
    transaction trans;
    
    trans = transaction::type_id::create("trans", this);
    
    trans.data = 4'h3;
    trans.addr = 6'h10;
    trans.wr_en = 1;
    
    `uvm_info("hello",$sformatf(" tranaction not randomized"),UVM_HIGH)
    trans.print();
    `uvm_info(get_type_name(),$sformatf(" tranaction sending to comp_c"),UVM_LOW)
    aport_send.write(trans);

  endtask  
 
endclass

// comp_c has 2 UVM_LOW messages

  `uvm_analysis_imp_decl(_comp_a)
  `uvm_analysis_imp_decl(_comp_b)
  
  class comp_c extends uvm_component;
    `uvm_component_utils (comp_c)
  
    uvm_analysis_imp_comp_a #(transaction,comp_c) comp_a_export;
    uvm_analysis_imp_comp_b #(transaction,comp_c) comp_b_export;
    
    
    function new (string name = "comp_c", uvm_component parent);
    super.new(name,parent);
  endfunction
  
   function void build_phase(uvm_phase phase);
     comp_a_export = new ("comp_a_export",this);
     comp_b_export = new ("comp_b_export",this);
  endfunction
  
    function void write_comp_a (transaction t);
      `uvm_info(get_type_name(),$sformatf(" transaction Received in scoreboard comp_a"),UVM_LOW)
    t.print();
      
    endfunction

    function void write_comp_b (transaction tr);
      `uvm_info("comp_c",$sformatf(" transaction Received in scoreboard comp_b"),UVM_LOW)
    tr.print();
      
    endfunction
    
 
endclass

  // Env has 1 UVM_DEBUG message 

class my_env extends uvm_env;
  `uvm_component_utils(my_env)
  
  comp_a test_a;
  comp_b test_b;
  comp_c test_c;
  
  function new (string name = "my_env", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
   function void build_phase(uvm_phase phase);
     test_a = comp_a::type_id::create("test_a",this);
     test_b = comp_b::type_id::create("test_b",this);
     test_c = comp_c::type_id::create("test_c",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    test_a.broadcast_port.connect(test_c.comp_a_export);
    test_b.aport_send.connect(test_c.comp_b_export);
    `uvm_info ("my_env", "Demonstrating UVM_DEBUG message from my_env",UVM_DEBUG);
  endfunction
  
  
 
  
endclass

  // Test has 1 uvm_high and 1 uvm_low messages 
  
class base_test extends uvm_test;

  `uvm_component_utils(base_test)
  
 
  my_env env;

  
  function new(string name = "base_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = my_env::type_id::create("env", this);
  endfunction : build_phase
  
  
   function void end_of_elaboration();
   
    print();
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info ("Inside_test","Example to demonstrate UVM_HIGH",UVM_HIGH);
    #500;
    `uvm_info ("Inside_test","Example to demonstrate UVM_LOW from base_test",UVM_LOW);
    phase.drop_objection(this);
  endtask
  
endclass : base_test



  initial begin
    run_test("base_test");  
    
  end  
  
endprogram
