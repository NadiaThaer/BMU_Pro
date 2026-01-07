class bmu_or_base_sequence extends uvm_sequence #(bmu_sequence_item);
    `uvm_object_utils(bmu_or_base_sequence)
    
    function new(string name = "bmu_or_base_sequence");
        super.new(name);
    endfunction
    
    // Base function to create a properly initialized sequence item
    virtual function bmu_sequence_item create_base_item();
        bmu_sequence_item item;
        item = bmu_sequence_item::type_id::create("base_item");
        
        // Initialize all signals to safe defaults
        item.rst_l = 1'b1;              // Reset deasserted
        item.scan_mode = 1'b0;          // Normal mode
        item.valid_in = 1'b1;           // Valid instruction
        item.a_in = 32'h0;              // Initialize operands
        item.b_in = 32'h0;
        item.csr_rddata_in = 32'h0;     // Initialize CSR signals
        item.csr_ren_in = 1'b0;
        
        // Initialize all control signals to 0
        item.ap.csr_write = 1'b0;
        item.ap.lor = 1'b0;
        item.ap.lxor = 1'b0;
        item.ap.srl = 1'b0;
        item.ap.sra = 1'b0;
        item.ap.ror = 1'b0;
        item.ap.binv = 1'b0;
        item.ap.sh2add = 1'b0;
        item.ap.sub = 1'b0;
        item.ap.slt = 1'b0;
        item.ap.ctz = 1'b0;
        item.ap.cpop = 1'b0;
        item.ap.siext_b = 1'b0;
        item.ap.max = 1'b0;
        item.ap.pack = 1'b0;
        item.ap.grev = 1'b0;
        item.ap.zbb = 1'b0;
        item.ap.zba = 1'b0;
        item.ap.unsign = 1'b0;
        item.ap.csr_imm = 1'b0;
        
        return item;
    endfunction
    
       
endclass