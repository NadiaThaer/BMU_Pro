class bmu_ctz_sequence extends uvm_sequence #(bmu_sequence_item);
    
    `uvm_object_utils(bmu_ctz_sequence)
    
    function new(string name = "bmu_ctz_sequence");
        super.new(name);
    endfunction
    
    // Task body
    task body();
        repeat(50) begin
            // Create NEW transaction instance for each iteration
            bmu_sequence_item transaction = bmu_sequence_item::type_id::create("transaction");
            
            start_item(transaction);
            
            void'(transaction.randomize() with { 
                valid_in == 1;
                ap.ctz == 1;           // Enable CTZ operation
                csr_ren_in == 0;
                
                // Test various trailing zero scenarios
                a_in dist {
                    // All zeros - should return 32
                    32'h00000000 :/ 5,
                    
                    // Single bit set at various positions
                    32'h00000001 :/ 3,  // CTZ = 0
                    32'h00000002 :/ 3,  // CTZ = 1
                    32'h00000004 :/ 3,  // CTZ = 2
                    32'h00000008 :/ 3,  // CTZ = 3
                    32'h00000010 :/ 3,  // CTZ = 4
                    32'h00000020 :/ 3,  // CTZ = 5
                    32'h00000040 :/ 3,  // CTZ = 6
                    32'h00000080 :/ 3,  // CTZ = 7
                    32'h00000100 :/ 3,  // CTZ = 8
                    32'h00000200 :/ 3,  // CTZ = 9
                    32'h00000400 :/ 3,  // CTZ = 10
                    32'h00000800 :/ 3,  // CTZ = 11
                    32'h00001000 :/ 3,  // CTZ = 12
                    32'h00002000 :/ 3,  // CTZ = 13
                    32'h00004000 :/ 3,  // CTZ = 14
                    32'h00008000 :/ 3,  // CTZ = 15
                    32'h00010000 :/ 3,  // CTZ = 16
                    32'h00020000 :/ 3,  // CTZ = 17
                    32'h00040000 :/ 3,  // CTZ = 18
                    32'h00080000 :/ 3,  // CTZ = 19
                    32'h00100000 :/ 3,  // CTZ = 20
                    32'h00200000 :/ 3,  // CTZ = 21
                    32'h00400000 :/ 3,  // CTZ = 22
                    32'h00800000 :/ 3,  // CTZ = 23
                    32'h01000000 :/ 3,  // CTZ = 24
                    32'h02000000 :/ 3,  // CTZ = 25
                    32'h04000000 :/ 3,  // CTZ = 26
                    32'h08000000 :/ 3,  // CTZ = 27
                    32'h10000000 :/ 3,  // CTZ = 28
                    32'h20000000 :/ 3,  // CTZ = 29
                    32'h40000000 :/ 3,  // CTZ = 30
                    32'h80000000 :/ 3,  // CTZ = 31
                    
                    // Multiple bits set - trailing zeros should still be counted
                    32'h00000003 :/ 3,  // CTZ = 0 (binary: 11)
                    32'h0000000C :/ 3,  // CTZ = 2 (binary: 1100)
                    32'h000000F0 :/ 3,  // CTZ = 4 (binary: 11110000)
                    32'h00000F00 :/ 3,  // CTZ = 8
                    32'h0000F000 :/ 3,  // CTZ = 12
                    32'h000F0000 :/ 3,  // CTZ = 16
                    32'h00F00000 :/ 3,  // CTZ = 20
                    32'h0F000000 :/ 3,  // CTZ = 24
                    32'hF0000000 :/ 3,  // CTZ = 28
                    
                    // Patterns with varying trailing zeros
                    32'hFFFFFFFE :/ 3,  // CTZ = 1 (LSB is 0)
                    32'hFFFFFFFC :/ 3,  // CTZ = 2
                    32'hFFFFFFF8 :/ 3,  // CTZ = 3
                    32'hFFFFFFF0 :/ 3,  // CTZ = 4
                    32'hFFFFFFE0 :/ 3,  // CTZ = 5
                    
                    // Random patterns
                    [32'h00000003:32'h7FFFFFFE] :/ 10,
                    [32'h80000001:32'hFFFFFFFC] :/ 10
                };
                
                // b_in should be ignored for CTZ operation, but set to 0 for clarity
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
                ap.cpop == 0;
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
                ap.unsign == 0;  // CTZ doesn't use unsigned flag
            });
            
            finish_item(transaction);
        end 
    endtask: body    
endclass