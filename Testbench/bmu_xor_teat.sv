// XOR + OR Test Class
class BMU_XOR_Regression_Test extends uvm_test;
  `uvm_component_utils(BMU_XOR_Regression_Test)

  BMU_Environment bmu_environment;

  //////////////////////////////////////// Creation Object From Each Class /////////////////////////////////////////////////////////
  // XOR Sequences
  bmu_xor_std_all_zeros_seq      std_all_zeros_seq;
  bmu_xor_std_all_ones_seq       std_all_ones_seq;
  bmu_xor_std_alt_seq            std_alt_seq;
  bmu_xor_std_mixed_seq          std_mixed_seq;
  bmu_xor_std_single_bit_seq     std_single_bit_seq;
  bmu_xor_std_identity_seq       std_identity_seq;
  bmu_xor_std_self_inverse_seq   std_self_inverse_seq;
  bmu_xnor_all_zeros_seq         xnor_all_zeros_seq;
  bmu_xnor_all_ones_seq          xnor_all_ones_seq;
  bmu_xnor_mixed_seq             xnor_mixed_seq;
  bmu_xnor_specific_seq          xnor_specific_seq;
  bmu_xnor_identity_seq          xnor_identity_seq;
  bmu_xor_nibble_patterns_seq    nibble_patterns_seq;
  bmu_xor_boundary_values_seq    boundary_values_seq;
  bmu_xor_csr_read_conflict_seq  csr_read_conflict_seq;
  bmu_xor_csr_write_conflict_seq csr_write_conflict_seq;
  bmu_xor_or_conflict_seq        or_conflict_seq;
  bmu_xor_cross_coverage_seq     cross_coverage_seq;
  bmu_xor_random_std_seq         xor_rand;


  function new(string name = "BMU_XOR_Regression_Test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    bmu_environment = BMU_Environment::type_id::create("bmu_environment", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info(get_type_name(), "Starting BMU XOR + OR Regression Test", UVM_LOW)

    ////////////////////////////////////////////////////////////////////////////////
    // 1. Basic Functionality Tests - Standard XOR (ap.zbb = 0)
 /*   std_all_zeros_seq      = bmu_xor_std_all_zeros_seq::type_id::create("std_all_zeros_seq");
    `uvm_info(get_type_name(), "Running XOR_STD_ALL_ZEROS sequence", UVM_LOW)
    std_all_zeros_seq.start(bmu_environment.agent.sequencer); #10;

    std_all_ones_seq       = bmu_xor_std_all_ones_seq::type_id::create("std_all_ones_seq");
    `uvm_info(get_type_name(), "Running XOR_STD_ALL_ONES sequence", UVM_LOW)
    std_all_ones_seq.start(bmu_environment.agent.sequencer); #10;

    std_alt_seq            = bmu_xor_std_alt_seq::type_id::create("std_alt_seq");
    `uvm_info(get_type_name(), "Running XOR_STD_ALT sequence", UVM_LOW)
    std_alt_seq.start(bmu_environment.agent.sequencer); #10;

    std_mixed_seq          = bmu_xor_std_mixed_seq::type_id::create("std_mixed_seq");
    `uvm_info(get_type_name(), "Running XOR_STD_MIXED sequence", UVM_LOW)
    std_mixed_seq.start(bmu_environment.agent.sequencer); #10;

    std_single_bit_seq     = bmu_xor_std_single_bit_seq::type_id::create("std_single_bit_seq");
    `uvm_info(get_type_name(), "Running XOR_STD_SINGLE_BIT sequence", UVM_LOW)
    std_single_bit_seq.start(bmu_environment.agent.sequencer); #10;

    std_identity_seq       = bmu_xor_std_identity_seq::type_id::create("std_identity_seq");
    `uvm_info(get_type_name(), "Running XOR_STD_IDENTITY sequence", UVM_LOW)
    std_identity_seq.start(bmu_environment.agent.sequencer); #10;

    std_self_inverse_seq   = bmu_xor_std_self_inverse_seq::type_id::create("std_self_inverse_seq");
    `uvm_info(get_type_name(), "Running XOR_STD_SELF_INVERSE sequence", UVM_LOW)
    std_self_inverse_seq.start(bmu_environment.agent.sequencer); #10;

    ////////////////////////////////////////////////////////////////////////////////
    // 2. XNOR Tests (ap.zbb = 1)
    xnor_all_zeros_seq     = bmu_xnor_all_zeros_seq::type_id::create("xnor_all_zeros_seq");
    `uvm_info(get_type_name(), "Running XNOR_ALL_ZEROS sequence", UVM_LOW)
    xnor_all_zeros_seq.start(bmu_environment.agent.sequencer); #10;

    xnor_all_ones_seq      = bmu_xnor_all_ones_seq::type_id::create("xnor_all_ones_seq");
    `uvm_info(get_type_name(), "Running XNOR_ALL_ONES sequence", UVM_LOW)
    xnor_all_ones_seq.start(bmu_environment.agent.sequencer); #10;

    xnor_mixed_seq         = bmu_xnor_mixed_seq::type_id::create("xnor_mixed_seq");
    `uvm_info(get_type_name(), "Running XNOR_MIXED sequence", UVM_LOW)
    xnor_mixed_seq.start(bmu_environment.agent.sequencer); #10;

    xnor_specific_seq      = bmu_xnor_specific_seq::type_id::create("xnor_specific_seq");
    `uvm_info(get_type_name(), "Running XNOR_SPECIFIC sequence", UVM_LOW)
    xnor_specific_seq.start(bmu_environment.agent.sequencer); #10;

    xnor_identity_seq      = bmu_xnor_identity_seq::type_id::create("xnor_identity_seq");
    `uvm_info(get_type_name(), "Running XNOR_IDENTITY sequence", UVM_LOW)
    xnor_identity_seq.start(bmu_environment.agent.sequencer); #10;*/

    ////////////////////////////////////////////////////////////////////////////////
    // 3. Coverage-Targeted Tests
    nibble_patterns_seq    = bmu_xor_nibble_patterns_seq::type_id::create("nibble_patterns_seq");
    `uvm_info(get_type_name(), "Running XOR_NIBBLE_PATTERNS sequence", UVM_LOW)
    nibble_patterns_seq.start(bmu_environment.agent.sequencer); #10;

    boundary_values_seq    = bmu_xor_boundary_values_seq::type_id::create("boundary_values_seq");
    `uvm_info(get_type_name(), "Running XOR_BOUNDARY_VALUES sequence", UVM_LOW)
    boundary_values_seq.start(bmu_environment.agent.sequencer); #10;

    ////////////////////////////////////////////////////////////////////////////////
    // 4. Error Condition Tests
   /* csr_read_conflict_seq  = bmu_xor_csr_read_conflict_seq::type_id::create("csr_read_conflict_seq");
    `uvm_info(get_type_name(), "Running XOR_CSR_READ_CONFLICT sequence", UVM_LOW)
    csr_read_conflict_seq.start(bmu_environment.agent.sequencer); #10;

    csr_write_conflict_seq = bmu_xor_csr_write_conflict_seq::type_id::create("csr_write_conflict_seq");
    `uvm_info(get_type_name(), "Running XOR_CSR_WRITE_CONFLICT sequence", UVM_LOW)
    csr_write_conflict_seq.start(bmu_environment.agent.sequencer); #10;

    or_conflict_seq        = bmu_xor_or_conflict_seq::type_id::create("or_conflict_seq");
    `uvm_info(get_type_name(), "Running XOR_OR_CONFLICT sequence", UVM_LOW)
    or_conflict_seq.start(bmu_environment.agent.sequencer); #10;

    ////////////////////////////////////////////////////////////////////////////////
    // 5. Cross-Coverage Tests
    cross_coverage_seq     = bmu_xor_cross_coverage_seq::type_id::create("cross_coverage_seq");
    `uvm_info(get_type_name(), "Running XOR_CROSS_COVERAGE sequence", UVM_LOW)
    cross_coverage_seq.start(bmu_environment.agent.sequencer); #10;

  ///////////////////////
            
  xor_rand    = bmu_xor_random_std_seq::type_id::create("xor_rand");
    `uvm_info(get_type_name(), "Running bmu_xor_random_std_seq", UVM_LOW)
     xor_rand.start(bmu_environment.agent.sequencer); #10;*/



    ////////////////////////////////////////////////////////////////////////////////
    phase.drop_objection(this);
    `uvm_info(get_type_name(), "BMU XOR + OR Regression Test Complete", UVM_LOW)
  endtask

endclass
