class bmu_or_nibble_patterns_seq extends bmu_or_base_sequence;
    `uvm_object_utils(bmu_or_nibble_patterns_seq)
    
    function new(string name = "bmu_or_nibble_patterns_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        bmu_sequence_item item = create_base_item();
        
        item.ap.lor = 1'b1;         // Enable OR operation
        item.ap.zbb = 1'b0;         // Standard OR mode
        item.a_in = 32'h0F0F0F0F;   // Nibble pattern (0000 1111 repeated)
        item.b_in = 32'h12121212;   // Different nibble pattern
        
        start_item(item);
        finish_item(item);
        
        `uvm_info(get_type_name(), $sformatf("OR Nibble Patterns: a_in=0x%08x, b_in=0x%08x, expected_result=0x%08x", 
                  item.a_in, item.b_in, 32'h1F1F1F1F), UVM_MEDIUM)
    endtask
endclass