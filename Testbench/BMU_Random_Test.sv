
class BMU_Random_Test extends uvm_test;

  // Declare environment and sequence handles
  BMU_Environment bmu_environment;

  // Register with UVM factory
  `uvm_component_utils(BMU_Random_Test)

  // Constructor
  function new(string name = "BMU_Random_Test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase: create environment instance
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    bmu_environment = BMU_Environment::type_id::create("bmu_environment", this);
  endfunction

  // Run phase: execute sequence 500 times
  task run_phase(uvm_phase phase);
    phase.raise_objection(this, "Starting BMU_Random_Test");
     phase.drop_objection(this, "Completed BMU_Random_Test");
    `uvm_info(get_type_name(), "End of testcase", UVM_LOW)
  endtask

endclass