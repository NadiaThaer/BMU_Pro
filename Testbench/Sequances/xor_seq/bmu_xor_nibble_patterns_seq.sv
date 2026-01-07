class bmu_xor_nibble_patterns_seq extends bmu_xor_base_sequence;
    `uvm_object_utils(bmu_xor_nibble_patterns_seq)
    
    function new(string name = "bmu_xor_nibble_patterns_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        bmu_sequence_item item;
        logic [31:0] nibble_patterns[] = '{32'h0F0F0F0F, 32'hF0F0F0F0, 32'h00FF00FF, 32'hFF00FF00};
        
        foreach (nibble_patterns[i]) begin
            foreach (nibble_patterns[j]) begin
                item = create_base_item();
                item.ap.lxor = 1'b1;           // Enable XOR operation
                item.ap.zbb = 1'b0;            // Standard XOR mode
                item.a_in = nibble_patterns[i]; // Nibble pattern A
                item.b_in = nibble_patterns[j]; // Nibble pattern B
                
                start_item(item);
                finish_item(item);
                
                `uvm_info(get_type_name(), $sformatf("XOR Nibble Patterns: a_in=0x%08x, b_in=0x%08x", 
                          item.a_in, item.b_in), UVM_HIGH)
            end
        end
    endtask
endclass
