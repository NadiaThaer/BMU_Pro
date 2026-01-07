class bmu_xor_base_sequence extends uvm_sequence #(bmu_sequence_item);
    `uvm_object_utils(bmu_xor_base_sequence)
    
    function new(string name = "bmu_xor_base_sequence");
        super.new(name);
    endfunction
    
    // Helper function to create base item with common settings
    virtual function bmu_sequence_item create_base_item();
        bmu_sequence_item item = bmu_sequence_item::type_id::create("item");
        
        // Set default values for all control signals to 0
        item.ap.zbb = 1'b0;
        item.ap.zba = 1'b0;
        item.ap.lor = 1'b0;
        item.ap.lxor = 1'b0;
        item.ap.srl = 1'b0;
        item.ap.sra = 1'b0;
        item.ap.ror = 1'b0;
        item.ap.binv = 1'b0;
        item.ap.sh2add = 1'b0;
        item.ap.sub = 1'b0;
        item.ap.slt = 1'b0;
        item.ap.unsign = 1'b0;
        item.ap.ctz = 1'b0;
        item.ap.cpop = 1'b0;
        item.ap.siext_b = 1'b0;
        item.ap.max = 1'b0;
        item.ap.pack = 1'b0;
        item.ap.grev = 1'b0;
        item.ap.csr_write = 1'b0;
        item.ap.csr_imm = 1'b0;
        
        // Set default input control signals
        item.rst_l = 1'b1;          // Not in reset
        item.scan_mode = 1'b0;      // Normal mode
        item.valid_in = 1'b1;       // Valid instruction
        item.csr_ren_in = 1'b0;     // No CSR read
        item.csr_rddata_in = 32'h0; // Default CSR data
        
        return item;
    endfunction
endclass
