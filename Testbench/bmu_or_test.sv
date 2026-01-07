class BMU_OR_Regression_Test extends uvm_test;
    `uvm_component_utils(BMU_OR_Regression_Test)
    
    BMU_Environment bmu_environment;
  bmu_max_random_seq max_seq;
   bmu_cpop_random_seq cpop_seq;          // Add CPOP sequence
// bmu_cpop_edge_cases_seq cpop_edge_seq; // Add CPOP edge cases sequence

bmu_pack_seq  pack_seq;
//bmu_grev_test_sequence  grev_seq;
bmu_siext_b_sequence    siex_b_seq;
bmu_ctz_sequence        CTZ_seq;
bmu_slt_random_seq      slt_seq;
bmu_sub_random_seq      sub_seq;
bmu_srl_sequence        srl_seq;
    function new(string name = "BMU_OR_Regression_Test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        bmu_environment = BMU_Environment::type_id::create("bmu_environment", this);

srl_seq=bmu_srl_sequence::type_id::create("srl_seq");


sub_seq=bmu_sub_random_seq::type_id::create("sub_seq");

slt_seq=bmu_slt_random_seq::type_id::create("slt_seq");

CTZ_seq=bmu_ctz_sequence::type_id::create("CTZ_seq");

siex_b_seq=bmu_siext_b_sequence::type_id::create("siex_b_seq");

//grev_seq =bmu_grev_test_sequence::type_id::create("grev_seq");

        pack_seq =bmu_pack_seq::type_id::create("pack_seq");
       max_seq = bmu_max_random_seq::type_id::create("max_seq");
      cpop_seq = bmu_cpop_random_seq::type_id::create("cpop_seq");          // Create CPOP sequence
     //   cpop_edge_seq = bmu_cpop_edge_cases_seq::type_id::create("cpop_edge_seq"); // Create CPOP edge cases
      

    endfunction
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

`uvm_info(get_type_name(), "Running srl_seq", UVM_LOW)
  srl_seq.start(bmu_environment.agent.sequencer);
`uvm_info(get_type_name(), "Running sub_seq", UVM_LOW)
   sub_seq.start(bmu_environment.agent.sequencer);

`uvm_info(get_type_name(), "Running slt_seq", UVM_LOW)
   slt_seq.start(bmu_environment.agent.sequencer);

`uvm_info(get_type_name(), "Running CTZ_seq", UVM_LOW)
     CTZ_seq.start(bmu_environment.agent.sequencer);

 `uvm_info(get_type_name(), "Running siex_b_seq", UVM_LOW)
     siex_b_seq.start(bmu_environment.agent.sequencer);

 `uvm_info(get_type_name(), "Running grev_seq", UVM_LOW)
    //  grev_seq.start(bmu_environment.agent.sequencer);

           `uvm_info(get_type_name(), "Running pack_seq", UVM_LOW)
      pack_seq.start(bmu_environment.agent.sequencer);

        `uvm_info(get_type_name(), "Running bmu_max_random_seq", UVM_LOW)
       max_seq.start(bmu_environment.agent.sequencer);
        
       `uvm_info(get_type_name(), "Running CPOP random sequence", UVM_LOW)
      cpop_seq.start(bmu_environment.agent.sequencer);
        
      //  `uvm_info(get_type_name(), "Running CPOP edge cases sequence", UVM_LOW)
       // cpop_edge_seq.start(bmu_environment.agent.sequencer);
        
        phase.drop_objection(this);
    endtask
endclass