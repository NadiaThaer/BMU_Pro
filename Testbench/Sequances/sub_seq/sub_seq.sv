class bmu_sub_random_seq extends uvm_sequence #(bmu_sequence_item);
    `uvm_object_utils(bmu_sub_random_seq)
    
    function new(string name = "bmu_sub_random_seq");
        super.new(name);
    endfunction
    
    task body();
        repeat(50) begin
            bmu_sequence_item transaction = bmu_sequence_item::type_id::create("transaction");
            
            start_item(transaction);
            
            void'(transaction.randomize() with { 
                valid_in == 1;
                ap.sub == 1;           // Enable SUB operation
                ap.zba == 0;           // Must be 0 for subtraction (per spec)
                csr_ren_in == 0;
                
                // Test various subtraction scenarios
                a_in dist {
                    // Edge cases for subtraction
                    32'h00000000 :/ 5,  // Zero
                    32'h00000001 :/ 5,  // Smallest positive
                    32'h7FFFFFFF :/ 5,  // Largest positive
                    32'h80000000 :/ 5,  // Smallest negative
                    32'hFFFFFFFF :/ 5,  // Largest negative (negative one)
                    
                    // Positive numbers
                    [32'h00000002:32'h3FFFFFFF] :/ 20,
                    [32'h40000000:32'h7FFFFFFE] :/ 20,
                    
                    // Negative numbers
                    [32'h80000001:32'hBFFFFFFF] :/ 20,
                    [32'hC0000000:32'hFFFFFFFE] :/ 20
                };
                
                // Test various values to subtract from a_in
                b_in dist {
                    // Edge cases for subtraction
                    32'h00000000 :/ 5,  // Subtract zero
                    32'h00000001 :/ 5,  // Subtract one
                    32'h7FFFFFFF :/ 5,  // Subtract max positive
                    32'h80000000 :/ 5,  // Subtract min negative
                    32'hFFFFFFFF :/ 5,  // Subtract negative one
                    
                    // Positive numbers
                    [32'h00000002:32'h3FFFFFFF] :/ 20,
                    [32'h40000000:32'h7FFFFFFE] :/ 20,
                    
                    // Negative numbers
                    [32'h80000001:32'hBFFFFFFF] :/ 20,
                    [32'hC0000000:32'hFFFFFFFE] :/ 20
                };
                
                // For subtraction, unsign should be 0 (signed arithmetic)
                ap.unsign == 0;
                
                // Ensure all other ap signals are 0
                ap.slt == 0;
                ap.max == 0;
                ap.min == 0;
                ap.lor == 0;
                ap.lxor == 0;
                ap.land == 0;
                ap.sll == 0;
                ap.srl == 0;
                ap.sra == 0;
                ap.ror == 0;
                ap.rol == 0;
                ap.binv == 0;
                ap.bset == 0;
                ap.bclr == 0;
                ap.bext == 0;
                ap.sh1add == 0;
                ap.sh2add == 0;
                ap.sh3add == 0;
                ap.add == 0;
                ap.clz == 0;
                ap.ctz == 0;
                ap.cpop == 0;
                ap.siext_b == 0;
                ap.siext_h == 0;
                ap.pack == 0;
                ap.packu == 0;
                ap.packh == 0;
                ap.grev == 0;
                ap.gorc == 0;
                ap.zbb == 0;
                ap.beq == 0;
                ap.bne == 0;
                ap.blt == 0;
                ap.bge == 0;
                ap.jal == 0;
                ap.predict_t == 0;
                ap.predict_nt == 0;
                ap.csr_write == 0;
                ap.csr_imm == 0;
            });
            
                   
            finish_item(transaction);
        end
    endtask
endclass