class bmu_xor_std_self_inverse_seq extends bmu_xor_base_sequence;
    `uvm_object_utils(bmu_xor_std_self_inverse_seq)
    
    function new(string name = "bmu_xor_std_self_inverse_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        bmu_sequence_item item = create_base_item();
        
        item.ap.lxor = 1'b1;        // Enable XOR operation
        item.ap.zbb = 1'b0;         // Standard XOR mode
        item.a_in = 32'h12345678;   // Test pattern
        item.b_in = 32'h12345678;   // Same value (should result in zero)
        
        start_item(item);
        finish_item(item);
        
        `uvm_info(get_type_name(), $sformatf("XOR Standard Self-Inverse: a_in=0x%08x, b_in=0x%08x, expected_result=0x%08x", 
                  item.a_in, item.b_in, 32'h00000000), UVM_MEDIUM)
    endtask
endclass