class bmu_xor_boundary_values_seq extends bmu_xor_base_sequence;
    `uvm_object_utils(bmu_xor_boundary_values_seq)
    
    function new(string name = "bmu_xor_boundary_values_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        bmu_sequence_item item;
        logic [31:0] boundary_values[] = '{32'h7FFFFFFF, 32'h80000000, 32'h80000001, 32'hFFFFFFFE};
        
        foreach (boundary_values[i]) begin
            foreach (boundary_values[j]) begin
                item = create_base_item();
                item.ap.lxor = 1'b1;            // Enable XOR operation
                item.ap.zbb = 1'b0;             // Standard XOR mode
                item.a_in = boundary_values[i]; // Boundary value A
                item.b_in = boundary_values[j]; // Boundary value B
                
                start_item(item);
                finish_item(item);
                
                `uvm_info(get_type_name(), $sformatf("XOR Boundary Values: a_in=0x%08x, b_in=0x%08x", 
                          item.a_in, item.b_in), UVM_HIGH)
            end
        end
    endtask
endclass