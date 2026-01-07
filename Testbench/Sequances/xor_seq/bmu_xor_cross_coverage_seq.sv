class bmu_xor_cross_coverage_seq extends bmu_xor_base_sequence;
    `uvm_object_utils(bmu_xor_cross_coverage_seq)
    
    function new(string name = "bmu_xor_cross_coverage_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        bmu_sequence_item item;
        
        // Cross-coverage: XOR Standard Zero-Zero (xor_std_zero_zero bin)
        item = create_base_item();
        item.ap.lxor = 1'b1;        // XOR enabled
        item.ap.zbb = 1'b0;         // Standard mode
        item.a_in = 32'h00000000;   // All zeros
        item.b_in = 32'h00000000;   // All zeros
        start_item(item);
        finish_item(item);
        `uvm_info(get_type_name(), "Cross-Coverage: XOR STD Zero-Zero", UVM_MEDIUM)
        
        // Cross-coverage: XOR Standard Ones-Ones (xor_std_ones_ones bin)
        item = create_base_item();
        item.ap.lxor = 1'b1;        // XOR enabled
        item.ap.zbb = 1'b0;         // Standard mode
        item.a_in = 32'hFFFFFFFF;   // All ones
        item.b_in = 32'hFFFFFFFF;   // All ones
        start_item(item);
        finish_item(item);
        `uvm_info(get_type_name(), "Cross-Coverage: XOR STD Ones-Ones", UVM_MEDIUM)
        
        // Cross-coverage: XOR Inverted Zero-Zero (xor_inv_zero_zero bin)
        item = create_base_item();
        item.ap.lxor = 1'b1;        // XOR enabled
        item.ap.zbb = 1'b1;         // Inverted mode (XNOR)
        item.a_in = 32'h00000000;   // All zeros
        item.b_in = 32'h00000000;   // All zeros
        start_item(item);
        finish_item(item);
        `uvm_info(get_type_name(), "Cross-Coverage: XOR INV Zero-Zero", UVM_MEDIUM)
        
        // Cross-coverage: XOR Inverted Ones-Ones (xor_inv_ones_ones bin)
        item = create_base_item();
        item.ap.lxor = 1'b1;        // XOR enabled
        item.ap.zbb = 1'b1;         // Inverted mode (XNOR)
        item.a_in = 32'hFFFFFFFF;   // All ones
        item.b_in = 32'hFFFFFFFF;   // All ones
        start_item(item);
        finish_item(item);
        `uvm_info(get_type_name(), "Cross-Coverage: XOR INV Ones-Ones", UVM_MEDIUM)
    endtask
endclass