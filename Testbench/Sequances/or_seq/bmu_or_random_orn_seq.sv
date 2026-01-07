class bmu_or_random_orn_seq extends uvm_sequence #(bmu_sequence_item);
    `uvm_object_utils(bmu_or_random_orn_seq)
    
    // Constructor
    function new(string name = "bmu_or_random_orn_seq");
        super.new(name);
    endfunction: new
    
    // Task body
    task body();
        repeat(50) begin
            // Create NEW transaction instance for each iteration
            bmu_sequence_item transaction = bmu_sequence_item::type_id::create("transaction");
            
            start_item(transaction);
            
            void'(transaction.randomize() with { 
                valid_in == 1;
              // Example 1: Positive numbers
a_in == 32'h0000000A; // 10
b_in == 32'h00000014; // 20
csr_ren_in == 0;
ap.max==1;
ap.sub == 1;
ap.zbb ==0;
ap.zba ==0;








                
                // Ensure all other ap signals are 0
                ap.clz == 0;
                ap.ctz == 0;
                ap.cpop == 0;
                ap.lor == 0;
                ap.siext_h == 0;
                ap.min == 0;
                ap.siext_b == 0;
                ap.pack == 1;
                ap.packu == 0;
                ap.packh == 0;
                ap.rol == 0;
                ap.ror == 0;
                ap.grev == 0;
                ap.gorc == 0;
                ap.bset == 0;
                ap.bclr == 0;
                ap.binv == 0;
                ap.bext == 0;
                ap.sh1add == 0;
                ap.sh2add == 0;
                ap.sh3add == 0;
                ap.zba == 0;
                ap.land == 0;
                ap.lxor == 0;
                ap.sll == 0;
                ap.srl == 0;
                ap.sra == 0;
                ap.beq == 0;
                ap.bne == 0;
                ap.blt == 0;
                ap.bge == 0;
                ap.add == 0;
                ap.slt == 0;
                ap.unsign == 0;
                ap.jal == 0;
                ap.predict_t == 0;
                ap.predict_nt == 0;
                ap.csr_write == 0;
                ap.csr_imm == 0;
            });
            
            `uvm_info(get_type_name(), $sformatf("BMU OR Random Sequence:  \n %s", transaction.sprint()), UVM_NONE)
            finish_item(transaction);
        end 
    endtask: body
endclass