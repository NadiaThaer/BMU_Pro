class bmu_or_min_negative_seq extends bmu_or_base_sequence;
    `uvm_object_utils(bmu_or_min_negative_seq)
    
    function new(string name = "bmu_or_min_negative_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        bmu_sequence_item item = create_base_item();
        
        item.ap.lor = 1'b1;         // Enable OR operation
        item.ap.zbb = 1'b0;         // Standard OR mode
        item.a_in = 32'h80000000;   // Minimum negative 32-bit signed value
        item.b_in = 32'h00000000;   // Zero
        
        start_item(item);
        finish_item(item);
        
        `uvm_info(get_type_name(), $sformatf("OR Min Negative: a_in=0x%08x, b_in=0x%08x, expected_result=0x%08x", 
                  item.a_in, item.b_in, 32'h80000000), UVM_MEDIUM)
    endtask
endclass