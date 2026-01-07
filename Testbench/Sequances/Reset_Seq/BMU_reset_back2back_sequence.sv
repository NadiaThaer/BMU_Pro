class BMU_reset_back2back_sequence extends uvm_sequence #(bmu_sequence_item);
  `uvm_object_utils(BMU_reset_back2back_sequence)
  
  function new(string name = "BMU_reset_back2back_sequence");
    super.new(name);
  endfunction
  
  task body();
    bmu_sequence_item req;
    
    `uvm_info(get_type_name(), "=== BMU BACK-TO-BACK OPERATIONS WITH RESET TEST SEQUENCE ===", UVM_MEDIUM)
    
    // Operation 1: SUB operation
    req = bmu_sequence_item::type_id::create("req");
    start_item(req);
    req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.a_in = 32'h00000030; // 48 decimal
    req.b_in = 32'h00000010; // 16 decimal
    req.csr_rddata_in = 32'h0;
    req.csr_ren_in = 0;
    req.ap = '{default: 0};
    req.ap.sub = 1;          // SUB operation
    `uvm_info(get_type_name(), "Back2Back: Operation 1 - SUB (48 - 16)", UVM_MEDIUM)
    `uvm_info(get_type_name(), $sformatf("Expected SUB result: %0d - %0d = %0d (0x%08x)", 
              req.a_in, req.b_in, req.a_in - req.b_in, req.a_in - req.b_in), UVM_MEDIUM)
    finish_item(req);
    #10;
    
    // RESET between operations
    req = bmu_sequence_item::type_id::create("req");
    start_item(req);
    req.rst_l = 0;           // Assert reset
    req.scan_mode = 0;
    req.valid_in = 0;
    req.a_in = 32'hFFFFFFFF; // Garbage data
    req.b_in = 32'hFFFFFFFF; // Garbage data
    req.csr_rddata_in = 32'h0;
    req.csr_ren_in = 0;
    req.ap = '{default: 0};
    `uvm_info(get_type_name(), "Back2Back: RESET between operations", UVM_HIGH)
    `uvm_info(get_type_name(), "Expected: Previous SUB result cleared, garbage data ignored", UVM_HIGH)
    finish_item(req);
    #15;
    
    // Release reset
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
    `uvm_info(get_type_name(), "Back2Back: Reset released", UVM_MEDIUM)
    `uvm_info(get_type_name(), "Expected: Clean state, no residual from Operation 1", UVM_MEDIUM)
    finish_item(req);
    #5;
    
    // Operation 2: SH2ADD (after reset recovery)
    req = bmu_sequence_item::type_id::create("req");
    start_item(req);
    req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.a_in = 32'h00000008; // 8 decimal
    req.b_in = 32'h00000064; // 100 decimal
    req.csr_rddata_in = 32'h0;
    req.csr_ren_in = 0;
    req.ap = '{default: 0};
    req.ap.sh2add = 1;       // SH2ADD operation
    req.ap.zba = 1;          // Enable Zba extension
    `uvm_info(get_type_name(), "Back2Back: Operation 2 - SH2ADD after reset (8<<2 + 100)", UVM_MEDIUM)
    `uvm_info(get_type_name(), $sformatf("Expected SH2ADD result: (%0d << 2) + %0d = %0d + %0d = %0d (0x%08x)", 
              req.a_in, req.b_in, req.a_in << 2, req.b_in, 
              (req.a_in << 2) + req.b_in, (req.a_in << 2) + req.b_in), UVM_MEDIUM)
    finish_item(req);
    #10;
    
    `uvm_info(get_type_name(), "=== BACK-TO-BACK OPERATIONS WITH RESET TEST COMPLETED ===", UVM_MEDIUM)
    `uvm_info(get_type_name(), "Key Validation: Operation 2 result should be independent of Operation 1", UVM_MEDIUM)
  endtask

endclass