class bmu_xor_std_alt_seq extends bmu_xor_base_sequence;
    `uvm_object_utils(bmu_xor_std_alt_seq)
    
    function new(string name = "bmu_xor_std_alt_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        bmu_sequence_item item = create_base_item();
        
        item.ap.lxor = 1'b1;        // Enable XOR operation
        item.ap.zbb = 1'b0;         // Standard XOR mode
        item.a_in = 32'hAAAAAAAA;   // Alternating pattern
        item.b_in = 32'h55555555;   // Complementary alternating pattern
        
        start_item(item);
        finish_item(item);
        
        `uvm_info(get_type_name(), $sformatf("XOR Standard Alternating: a_in=0x%08x, b_in=0x%08x, expected_result=0x%08x", 
                  item.a_in, item.b_in, 32'hFFFFFFFF), UVM_MEDIUM)
    endtask
endclass