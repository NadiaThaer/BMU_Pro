class bmu_or_sub_conflict_seq extends bmu_or_base_sequence;
    `uvm_object_utils(bmu_or_sub_conflict_seq)
    
    function new(string name = "bmu_or_sub_conflict_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        bmu_sequence_item item = create_base_item();
        
        item.ap.lor = 1'b1;         // Enable OR operation
        item.ap.sub = 1'b1;         // ERROR: Multiple operation conflict
        item.ap.zbb = 1'b0;         // Standard OR mode
        item.a_in = 32'h12345678;   // Test pattern
        item.b_in = 32'h87654321;   // Test pattern
        
        start_item(item);
        finish_item(item);
        
        `uvm_info(get_type_name(), $sformatf("OR+SUB Conflict: a_in=0x%08x, b_in=0x%08x, lor=1, sub=1, expected_error=1", 
                  item.a_in, item.b_in), UVM_MEDIUM)
    endtask
endclass