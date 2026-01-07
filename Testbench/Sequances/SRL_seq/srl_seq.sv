class bmu_srl_sequence extends uvm_sequence #(bmu_sequence_item);
    
    `uvm_object_utils(bmu_srl_sequence)
    
    function new(string name = "bmu_srl_sequence");
        super.new(name);
    endfunction
    
    task body();
        repeat(20) begin
            bmu_sequence_item transaction = bmu_sequence_item::type_id::create("transaction");
            
            start_item(transaction);
            
            void'(transaction.randomize() with { 
                valid_in == 1;
                ap.lor== 1;           // Enable SRL operation
                ap.zbb== 1;           // Enable SRL operation

                csr_ren_in == 0;
                
                // Test various shift scenarios
                a_in dist {
                    // Edge cases
                    32'h00000000 :/ 5,  // All zeros
                    32'hFFFFFFFF :/ 5,  // All ones
                    32'h80000000 :/ 5,  // MSB set only
                    32'h00000001 :/ 5,  // LSB set only
                    32'hAAAAAAAA :/ 5,  // Alternating pattern 1
                    32'h55555555 :/ 5,  // Alternating pattern 2
                    
                    // Various bit patterns
                    32'hF0F0F0F0 :/ 4,
                    32'h0F0F0F0F :/ 4,
                    32'hFF00FF00 :/ 4,
                    32'h00FF00FF :/ 4,
                    32'hFFFF0000 :/ 4,
                    32'h0000FFFF :/ 4,
                    
                    // Random patterns
                    [32'h00000002:32'h7FFFFFFE] :/ 20,
                    [32'h80000001:32'hFFFFFFFC] :/ 20
                };
                
                // Shift amount (lower 5 bits of b_in)
                b_in[4:0] dist {
                    5'd0  :/ 5,   // No shift
                    5'd1  :/ 5,   // Shift by 1
                    5'd2  :/ 5,   // Shift by 2
                    5'd4  :/ 5,   // Shift by 4
                    5'd8  :/ 5,   // Shift by 8
                    5'd16 :/ 5,   // Shift by 16
                    5'd31 :/ 5,   // Maximum shift
                    [5'd3:5'd7]   :/ 10,
                    [5'd9:5'd15]  :/ 10,
                    [5'd17:5'd30] :/ 10
                };
                
                // Upper bits of b_in should be ignored for SRL
                b_in[31:5] == 0;
                
                // Ensure all other ap signals are 0
                ap.max == 0;
                ap.sub == 0;
                ap.srl == 0;
                ap.lxor == 0;
                ap.land == 0;
                ap.sll == 0;
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
                ap.unsign == 0;
            });
            
                    
            finish_item(transaction);
        end 
    endtask: body    
endclass