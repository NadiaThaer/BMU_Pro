class BMU_basic_reset_sequence extends uvm_sequence #(bmu_sequence_item);
  `uvm_object_utils(BMU_basic_reset_sequence)
  
  function new(string name = "BMU_basic_reset_sequence");
    super.new(name);
  endfunction
  
  task body();
    bmu_sequence_item req;
    
    `uvm_info(get_type_name(), "=== BMU BASIC RESET TEST SEQUENCE ===", UVM_MEDIUM)
    
    // Apply Reset
    req = bmu_sequence_item::type_id::create("req");
    start_item(req);
    req.rst_l = 0;           // Assert reset
    req.scan_mode = 0;
    req.valid_in = 0;
    req.a_in = 32'hDEADBEEF;
    req.b_in = 32'hCAFEBABE;
    req.csr_rddata_in = 32'h12345678;
    req.csr_ren_in = 0;
    req.ap = '{default: 0};
    `uvm_info(get_type_name(), "Basic Reset: Asserting reset (rst_l=0)", UVM_MEDIUM)
    finish_item(req);
    #20;
    
    // Release Reset
    req = bmu_sequence_item::type_id::create("req");
    start_item(req);
    req.rst_l = 1;           // Release reset
    req.scan_mode = 0;
    req.valid_in = 0;
    req.a_in = 32'h0;
    req.b_in = 32'h0;
    req.csr_rddata_in = 32'h0;
    req.csr_ren_in = 0;
    req.ap = '{default: 0};
    `uvm_info(get_type_name(), "Basic Reset: Releasing reset (rst_l=1)", UVM_MEDIUM)
    finish_item(req);
    #10;
    
    `uvm_info(get_type_name(), "=== BASIC RESET TEST COMPLETED ===", UVM_MEDIUM)
  endtask

endclass