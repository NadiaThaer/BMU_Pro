class bmu_or_random_std_seq extends bmu_or_base_sequence;
    `uvm_object_utils(bmu_or_random_std_seq)
    
    rand logic [31:0] rand_a;
    rand logic [31:0] rand_b;

    // Constraint: values must be between 1 and 10
    constraint c_range {
        rand_a inside {[1:10]};
        rand_b inside {[1:10]};
    }
    
    function new(string name = "bmu_or_random_std_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        bmu_sequence_item item;
        logic [31:0] expected_result;
        
        for (int i = 0; i < 11; i++) begin
            item = create_base_item();
            
            // Randomize inputs
            if (!this.randomize()) begin
                `uvm_error(get_type_name(), "Randomization failed")
            end
            
     

   
        item.rst_l = 1;
        item.scan_mode = 1'b0;
        item.valid_in = 1;
        item.a_in =rand_a;
        item.b_in = rand_b;
        item.csr_rddata_in = 32'h0;
        item.csr_ren_in = 1'b0;

        
        // Clear all control signals
        item.ap = '{default: 1'b0};
                // Initialize all fields
        item.ap.lor =1'b1;
        item.ap.zbb=1'b1;
            
            expected_result = rand_a | rand_b;  // Expected result = OR
            
            start_item(item);
            finish_item(item);
            
            `uvm_info(get_type_name(), $sformatf(
                "Random OR %0d: a_in=0x%08x (%0d), b_in=0x%08x (%0d), expected_result=0x%08x (%0d)", 
                i+1, item.a_in, item.a_in, item.b_in, item.b_in, expected_result, expected_result),
                UVM_MEDIUM)
                    end
        
        `uvm_info(get_type_name(), "Completed random standard OR operations", UVM_MEDIUM)
    endtask
endclass