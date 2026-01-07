class bmu_xor_random_std_seq extends bmu_xor_base_sequence;
    `uvm_object_utils(bmu_xor_random_std_seq)
    
    rand logic signed [31:0] rand_a;
    rand logic [31:0] rand_b;
    
    
    function new(string name = "bmu_xor_random_std_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        bmu_sequence_item item;
        logic [31:0] expected_result;
        
        for (int i = 0; i < 1000; i++) begin
            item = create_base_item();
            
            // Randomize inputs
            if (!this.randomize()) begin
                `uvm_error(get_type_name(), "Randomization failed")
            end
            
            item.ap.lxor= 1'b1;         // Enable xor operation
            item.ap.zbb= 1'b1;         // Enable xor operation



            item.a_in = rand_a;         // Random operand A
            item.b_in = rand_b;         // Random operand B
            
            expected_result = rand_a ^ rand_b;  // Calculate expected result
            
            start_item(item);
            finish_item(item);
            
            `uvm_info(get_type_name(), $sformatf("Random xor %0d: a_in=0x%08x, b_in=0x%08x, expected_result=0x%08x", 
                      i+1, item.a_in, item.b_in, expected_result), UVM_HIGH)
        end
        
        `uvm_info(get_type_name(), $sformatf("Completed  random standard OR operations"), UVM_MEDIUM)
    endtask
endclass