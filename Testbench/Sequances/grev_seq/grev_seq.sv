class bmu_grev_test_sequence extends uvm_sequence #(bmu_sequence_item);
    
    `uvm_object_utils(bmu_grev_test_sequence)
    
    // Constructor
    function new(string name = "bmu_grev_test_sequence");
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
                ap.cpop == 1;          // Enable CPOP operation
                csr_ren_in == 0;
                
                // Test various population count scenarios
                a_in dist {
                    // All zeros - should return 0
                    32'h00000000 :/ 5,
                    
                    // All ones - should return 32  --> 0x00000020
                    32'hFFFFFFFF :/ 5,
                    
                    // Single bit set scenarios
                    32'h00000001 :/ 3,  // Should return 1
                    32'h00000002 :/ 3,
                    32'h00000004 :/ 3,
                    32'h00000008 :/ 3,
                    32'h80000000 :/ 3,  // MSB set
                    
                    // Multiple bits set - specific patterns
                    32'h0000FFFF :/ 4,  // 16 ones
                    32'hFFFF0000 :/ 4,  // 16 ones
                    32'h55555555 :/ 4,  // Alternating bits (16 ones)
                    32'hAAAAAAAA :/ 4,  // Alternating bits (16 ones)
                    32'h33333333 :/ 4,  // 16 ones
                    32'hCCCCCCCC :/ 4,  // 16 ones
                    32'h0F0F0F0F :/ 4,  // 16 ones
                    32'hF0F0F0F0 :/ 4,  // 16 ones
                    
                    // Random patterns
                    [32'h00000003:32'h7FFFFFFE] :/ 20,
                    [32'h80000001:32'hFFFFFFFC] :/ 20
                };
                
                // b_in should be ignored for CPOP operation, but set to 0 for clarity
                b_in == 32'h0;
                
                // Ensure all other ap signals are 0
                ap.max == 0;
                ap.sub == 0;
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
                ap.slt == 0;
                ap.clz == 0;
                ap.ctz == 0;
                ap.siext_b == 0;
                ap.siext_h == 0;
                ap.min == 0;
                ap.pack == 0;
                ap.packu == 0;
                ap.packh == 0;
                ap.grev == 0;
                ap.gorc == 0;
                ap.zbb == 0;
                ap.zba == 0;
                ap.beq == 0;
                ap.bne == 0;
                ap.blt == 0;
                ap.bge == 0;
                ap.jal == 0;
                ap.predict_t == 0;
                ap.predict_nt == 0;
                ap.csr_write == 0;
                ap.csr_imm == 0;
                ap.unsign == 0;  // CPOP doesn't use unsigned flag
            });
            
            `uvm_info(get_type_name(), 
                $sformatf("CPOP Sequence: A=0x%08x (popcount=%0d expected)", 
                         transaction.a_in, $countones(transaction.a_in)), 
                UVM_MEDIUM)
            finish_item(transaction);
        end 
    endtask: body
endclasss