class bmu_xnor_all_ones_seq extends bmu_xor_base_sequence;
    `uvm_object_utils(bmu_xnor_all_ones_seq)
    
    function new(string name = "bmu_xnor_all_ones_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        bmu_sequence_item item = create_base_item();
        
        item.ap.lxor = 1'b1;        // Enable XOR operation
        item.ap.zbb = 1'b1;         // XNOR mode (XOR with inverted B)
        item.a_in = 32'hFFFFFFFF;   // All ones
        item.b_in = 32'hFFFFFFFF;   // All ones
        
        start_item(item);
        finish_item(item);
        
        `uvm_info(get_type_name(), $sformatf("XNOR All Ones: a_in=0x%08x, b_in=0x%08x, expected_result=0x%08x", 
                  item.a_in, item.b_in, 32'hFFFFFFFF), UVM_MEDIUM)
    endtask
endclass