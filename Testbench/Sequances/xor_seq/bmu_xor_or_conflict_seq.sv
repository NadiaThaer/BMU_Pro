class bmu_xor_or_conflict_seq extends bmu_xor_base_sequence;
    `uvm_object_utils(bmu_xor_or_conflict_seq)
    
    function new(string name = "bmu_xor_or_conflict_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        bmu_sequence_item item = create_base_item();
        
        item.ap.lxor = 1'b1;        // Enable XOR operation
        item.ap.lor = 1'b1;         // ERROR: Enable OR operation simultaneously
        item.ap.zbb = 1'b0;         // Standard mode
        item.a_in = 32'h12345678;   // Test pattern
        item.b_in = 32'h87654321;   // Test pattern
        
        start_item(item);
        finish_item(item);
        
        `uvm_info(get_type_name(), $sformatf("XOR+OR Conflict: a_in=0x%08x, b_in=0x%08x, lxor=1, lor=1, expected_error=1", 
                  item.a_in, item.b_in), UVM_MEDIUM)
    endtask
endclass