class BMU_reset_test extends uvm_test;
  `uvm_component_utils(BMU_reset_test)
  
  // Environment handle
  BMU_Environment env;
  BMU_basic_reset_sequence reset_seq;
  BMU_reset_back2back_sequence b2b_seq;

  
  // Constructor
  function new(string name = "BMU_reset_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  // Build phase - create environment
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Create environment
    env = BMU_Environment::type_id::create("env", this);
   
    
    `uvm_info(get_type_name(), "BMU Reset Test build phase completed", UVM_MEDIUM)
  endfunction
  
  // Connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), "BMU Reset Test connect phase completed", UVM_MEDIUM)
  endfunction
  
  // Run phase - execute the test
  virtual task run_phase(uvm_phase phase);
    
    phase.raise_objection(this);
    
    `uvm_info(get_type_name(), "Starting BMU Reset Test", UVM_MEDIUM)

    `uvm_info(get_type_name(), "Starting BMU Reset Test Standared", UVM_MEDIUM)

    // Create and start the reset sequence
    reset_seq = BMU_basic_reset_sequence::type_id::create("reset_seq");
    // Start sequence on the sequencer
    reset_seq.start(env.agent.sequencer);
    // Add some delay to observe final results
    #100;

////////////////////////////////////////////////////////////// BMU_reset_back2back_sequence////////////////////////
    `uvm_info(get_type_name(), "Starting BMU_reset_back2back_sequence", UVM_MEDIUM)

     // Create and start the reset sequence
    b2b_seq=BMU_reset_back2back_sequence::type_id::create("b2b_seq");
    // Start sequence on the sequencer
    b2b_seq.start(env.agent.sequencer);
    // Add some delay to observe final results
    #100;

    
    `uvm_info(get_type_name(), "BMU Reset Test completed", UVM_MEDIUM)
    
    phase.drop_objection(this);
  endtask
  
  
  // Final phase - print test results
  virtual function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    
    `uvm_info(get_type_name(), "========================================", UVM_MEDIUM)
    `uvm_info(get_type_name(), "BMU RESET TEST SUMMARY", UVM_MEDIUM) 
    `uvm_info(get_type_name(), "Expected Results:", UVM_MEDIUM)
    `uvm_info(get_type_name(), "- result_ff should be 32'h00000000 after reset", UVM_MEDIUM)
    `uvm_info(get_type_name(), "- error should be 1'b0 after reset", UVM_MEDIUM)
    `uvm_info(get_type_name(), "Check scoreboard/monitor for actual results", UVM_MEDIUM)
    `uvm_info(get_type_name(), "========================================", UVM_MEDIUM)
  endfunction
  
endclass