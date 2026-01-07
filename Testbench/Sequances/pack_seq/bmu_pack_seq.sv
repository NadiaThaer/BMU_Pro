class bmu_pack_seq extends uvm_sequence #(bmu_sequence_item);
    `uvm_object_utils(bmu_pack_seq)

    // Constructor
    function new(string name = "bmu_pack_seq");
        super.new(name);
    endfunction: new

    virtual task body();
        bmu_sequence_item req;

        // Example transaction for pack
        req = bmu_sequence_item::type_id::create("req");
        start_item(req);
        req.valid_in   = 1;
        req.a_in       = 32'h0000aaaa;   // lower half = 5678
        req.b_in       =32'h0000bbbb;  // lower half = EF12
        req.ap         = '{default:0};
        req.ap.pack    = 1;              // enable PACK operation
        req.csr_ren_in = 0;
        finish_item(req);

        // Add delay to separate transactions
        #35;
    endtask
endclass
