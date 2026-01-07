class bmu_or_back_to_back_seq extends bmu_or_base_sequence;
    `uvm_object_utils(bmu_or_back_to_back_seq)
    
    function new(string name = "bmu_or_back_to_back_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        bmu_sequence_item item1, item2;
        
        // First OR operation
        item1 = create_base_item();
        item1.ap.lor = 1'b1;         // Enable OR operation
        item1.ap.zbb = 1'b0;         // Standard OR mode
        item1.a_in = 32'h12345678;   // Test pattern
        item1.b_in = 32'h11111111;   // Pattern to OR with
        item1.valid_in = 1'b1;       // Valid instruction
        
        start_item(item1);
        finish_item(item1);
        
        `uvm_info(get_type_name(), $sformatf("Back-to-Back OR 1: a_in=0x%08x, b_in=0x%08x, expected_result=0x%08x", 
                  item1.a_in, item1.b_in, 32'h13355779), UVM_MEDIUM)
        
        // Second OR operation (immediate next cycle)
        item2 = create_base_item();
        item2.ap.lor = 1'b1;         // Enable OR operation
        item2.ap.zbb = 1'b0;         // Standard OR mode
        item2.a_in = 32'h87654321;   // Different test pattern
        item2.b_in = 32'h22222222;   // Different pattern to OR with
        item2.valid_in = 1'b1;       // Valid instruction
        
        start_item(item2);
        finish_item(item2);
        
        `uvm_info(get_type_name(), $sformatf("Back-to-Back OR 2: a_in=0x%08x, b_in=0x%08x, expected_result=0x%08x", 
                  item2.a_in, item2.b_in, 32'hA7676723), UVM_MEDIUM)
    endtask
endclass