class bmu_or_mode_switch_seq extends bmu_or_base_sequence;
    `uvm_object_utils(bmu_or_mode_switch_seq)
    
    function new(string name = "bmu_or_mode_switch_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        bmu_sequence_item item1, item2;
        
        // First transaction: Standard OR
        item1 = create_base_item();
        item1.ap.lor = 1'b1;         // Enable OR operation
        item1.ap.zbb = 1'b0;         // Standard OR mode
        item1.a_in = 32'h0F0F0F0F;   // Test pattern
        item1.b_in = 32'hF0F0F0F0;   // Complementary pattern
        
        start_item(item1);
        finish_item(item1);
        
        `uvm_info(get_type_name(), $sformatf("Mode Switch - Standard OR: a_in=0x%08x, b_in=0x%08x, expected_result=0x%08x", 
                  item1.a_in, item1.b_in, 32'hFFFFFFFF), UVM_MEDIUM)
        
        // Second transaction: ORN (same inputs)
        item2 = create_base_item();
        item2.ap.lor = 1'b1;         // Enable OR operation
        item2.ap.zbb = 1'b1;         // ORN mode
        item2.a_in = 32'h0F0F0F0F;   // Same test pattern
        item2.b_in = 32'hF0F0F0F0;   // Same complementary pattern
        
        start_item(item2);
        finish_item(item2);
        
        `uvm_info(get_type_name(), $sformatf("Mode Switch - ORN: a_in=0x%08x, b_in=0x%08x, expected_result=0x%08x", 
                  item2.a_in, item2.b_in, 32'h0F0F0F0F), UVM_MEDIUM)
    endtask
endclass