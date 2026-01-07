class bmu_orn_all_zeros_seq extends bmu_or_base_sequence;
    `uvm_object_utils(bmu_orn_all_zeros_seq)
    
    function new(string name = "bmu_orn_all_zeros_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        bmu_sequence_item item = create_base_item();
        
        item.ap.lor = 1'b1;         // Enable OR operation
        item.ap.zbb = 1'b1;         // ORN mode (OR with inverted B)
        item.a_in = 32'h00000000;   // All zeros
        item.b_in = 32'h00000000;   // All zeros
        
        start_item(item);
        finish_item(item);
        
        `uvm_info(get_type_name(), $sformatf("ORN All Zeros: a_in=0x%08x, b_in=0x%08x, expected_result=0x%08x", 
                  item.a_in, item.b_in, 32'hFFFFFFFF), UVM_MEDIUM)
    endtask
endclass