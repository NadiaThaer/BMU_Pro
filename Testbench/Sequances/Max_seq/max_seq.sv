class bmu_max_random_seq extends uvm_sequence #(bmu_sequence_item);
    `uvm_object_utils(bmu_max_random_seq)
    
    // Constructor
    function new(string name = "bmu_max_random_seq");
        super.new(name);
    endfunction: new
   
    
    virtual task body();
        bmu_sequence_item req;
        
   

        req = bmu_sequence_item::type_id::create("req");
        start_item(req);
        req.valid_in = 1;
        req.a_in = 32'h0000000A;       // 10
        req.b_in = 32'h00000014;       // 20
        req.ap = '{default: 0};
        req.ap.max = 1;
        req.ap.sub = 1;
        req.ap.unsign = 0;             // Signed
        req.csr_ren_in = 0;
        finish_item(req);
       #35;

        
    endtask
endclass