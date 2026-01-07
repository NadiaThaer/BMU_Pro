class BMU_subscriber extends uvm_subscriber #(bmu_sequence_item);
  `uvm_component_utils(BMU_subscriber)
  
  // Sequence item for coverage sampling
  bmu_sequence_item item;

////////////////////////////////////////////////////////////////////// CoverGroup Logical Operation///////////////////////////////////

  covergroup cg_logic_operations;
    option.per_instance = 1;
    option.name = "Logic_Operations_Coverage";
    
    
    
    cp_or_operation: coverpoint item.ap.lor {
        bins or_enabled = {1'b1};
        bins or_disabled = {1'b0};
    }
    
    cp_xor_operation: coverpoint item.ap.lxor {
        bins xor_enabled = {1'b1};
        bins xor_disabled = {1'b0};
    }
    
    cp_zbb_mode: coverpoint item.ap.zbb iff (item.ap.lor || item.ap.lxor) {
        bins zbb_standard = {1'b0};  // Standard OR/XOR
        bins zbb_inverted = {1'b1};  // ORN/XNOR
    }
    
       
    cp_operand_a: coverpoint item.a_in iff (item.ap.lor || item.ap.lxor) {
        bins all_zeros = {32'h00000000};
        bins all_ones = {32'hFFFFFFFF};
        bins alt_01 = {32'h55555555};
        bins alt_10 = {32'hAAAAAAAA};
        bins single_bit[32] = {[0:31]} with (32'h1 << item);
        bins nibble_patterns[] = {32'h0F0F0F0F, 32'hF0F0F0F0, 32'h00FF00FF, 32'hFF00FF00};
        bins boundary[] = {32'h7FFFFFFF, 32'h80000000, 32'h80000001, 32'hFFFFFFFE};
        bins random = default;
    }
    
    cp_operand_b: coverpoint item.b_in iff (item.ap.lor || item.ap.lxor) {
        bins all_zeros = {32'h00000000};
        bins all_ones = {32'hFFFFFFFF};
        bins alt_01 = {32'h55555555};
        bins alt_10 = {32'hAAAAAAAA};
        bins single_bit[32] = {[0:31]} with (32'h1 << item);
        bins nibble_patterns[] = {32'h0F0F0F0F, 32'hF0F0F0F0, 32'h00FF00FF, 32'hFF00FF00};
        bins boundary[] = {32'h7FFFFFFF, 32'h80000000, 32'h80000001, 32'hFFFFFFFE};
        bins random = default;
    }
    
       cp_csr_conflict: coverpoint item.csr_ren_in iff (item.ap.lor || item.ap.lxor) {
        bins no_conflict = {1'b0};
        bins conflict = {1'b1};
    }
    
    cp_operation_conflict: coverpoint {item.ap.lor, item.ap.lxor} {
        bins only_or = {2'b10};
        bins only_xor = {2'b01};
        bins no_op = {2'b00};
        bins both_ops = {2'b11};
    }
    
    cp_other_ap_active: coverpoint {item.ap.sub, item.ap.slt, item.ap.srl, item.ap.sra, 
                                   item.ap.ror, item.ap.binv, item.ap.sh2add, item.ap.ctz, 
                                   item.ap.cpop, item.ap.siext_b, item.ap.max, item.ap.pack, 
                                   item.ap.grev, item.ap.zba, item.ap.csr_write, item.ap.csr_imm} 
                                   iff (item.ap.lor || item.ap.lxor) {
        bins all_zero = {17'b0};
        bins any_active = {[1:$]};
    }
    
    cp_error: coverpoint item.error iff (item.ap.lor || item.ap.lxor) {
        bins no_error = {1'b0};
        bins error = {1'b1};
    }
    
 
    
    cp_or_result: coverpoint item.result_ff iff (item.ap.lor && !item.error) {
        bins zero = {32'h00000000};
        bins ones = {32'hFFFFFFFF};
        bins patterns[] = {32'h55555555, 32'hAAAAAAAA, 32'h0F0F0F0F, 32'hF0F0F0F0};
        bins random = default;
    }
    
    cp_xor_result: coverpoint item.result_ff iff (item.ap.lxor && !item.error) {
        bins zero = {32'h00000000};
        bins ones = {32'hFFFFFFFF};
        bins patterns[] = {32'h55555555, 32'hAAAAAAAA, 32'h0F0F0F0F, 32'hF0F0F0F0};
        bins random = default;
    }
    
      
    // OR operation with all combinations
    cross_or_combinations: cross cp_or_operation, cp_zbb_mode, cp_operand_a, cp_operand_b
    iff (item.ap.lor) {
        bins or_std_zero_zero = binsof(cp_or_operation.or_enabled) &&
                              binsof(cp_zbb_mode.zbb_standard) &&
                              binsof(cp_operand_a.all_zeros) &&
                              binsof(cp_operand_b.all_zeros);
        
        bins or_std_ones_ones = binsof(cp_or_operation.or_enabled) &&
                              binsof(cp_zbb_mode.zbb_standard) &&
                              binsof(cp_operand_a.all_ones) &&
                              binsof(cp_operand_b.all_ones);
        
        bins or_inv_zero_zero = binsof(cp_or_operation.or_enabled) &&
                              binsof(cp_zbb_mode.zbb_inverted) &&
                              binsof(cp_operand_a.all_zeros) &&
                              binsof(cp_operand_b.all_zeros);
        
        bins or_inv_ones_ones = binsof(cp_or_operation.or_enabled) &&
                              binsof(cp_zbb_mode.zbb_inverted) &&
                              binsof(cp_operand_a.all_ones) &&
                              binsof(cp_operand_b.all_ones);
    }
    
    // XOR operation with all combinations
    cross_xor_combinations: cross cp_xor_operation, cp_zbb_mode, cp_operand_a, cp_operand_b
    iff (item.ap.lxor) {
        bins xor_std_zero_zero = binsof(cp_xor_operation.xor_enabled) &&
                               binsof(cp_zbb_mode.zbb_standard) &&
                               binsof(cp_operand_a.all_zeros) &&
                               binsof(cp_operand_b.all_zeros);
        
        bins xor_std_ones_ones = binsof(cp_xor_operation.xor_enabled) &&
                               binsof(cp_zbb_mode.zbb_standard) &&
                               binsof(cp_operand_a.all_ones) &&
                               binsof(cp_operand_b.all_ones);
        
        bins xor_inv_zero_zero = binsof(cp_xor_operation.xor_enabled) &&
                               binsof(cp_zbb_mode.zbb_inverted) &&
                               binsof(cp_operand_a.all_zeros) &&
                               binsof(cp_operand_b.all_zeros);
        
        bins xor_inv_ones_ones = binsof(cp_xor_operation.xor_enabled) &&
                               binsof(cp_zbb_mode.zbb_inverted) &&
                               binsof(cp_operand_a.all_ones) &&
                               binsof(cp_operand_b.all_ones);
    }
    
    // Error condition cross-coverage
    cross_error_conditions: cross cp_operation_conflict, cp_csr_conflict, cp_other_ap_active, cp_error {
        bins valid_or = binsof(cp_operation_conflict.only_or) &&
                       binsof(cp_csr_conflict.no_conflict) &&
                       binsof(cp_other_ap_active.all_zero) &&
                       binsof(cp_error.no_error);
        
        bins valid_xor = binsof(cp_operation_conflict.only_xor) &&
                        binsof(cp_csr_conflict.no_conflict) &&
                        binsof(cp_other_ap_active.all_zero) &&
                        binsof(cp_error.no_error);
        
        bins csr_error = binsof(cp_csr_conflict.conflict) &&
                        binsof(cp_error.error);
        
        bins dual_op_error = binsof(cp_operation_conflict.both_ops) &&
                           binsof(cp_error.error);
        
        bins other_field_error = binsof(cp_other_ap_active.any_active) &&
                               binsof(cp_error.error);
    }

endgroup
  
   covergroup cg_shift_operations;
    option.per_instance = 1;
    option.name = "Shift_Operations_Coverage";
    
    // Shift Right Logical Coverage
    cp_srl_operation: coverpoint item.ap.srl {
      bins srl_enabled = {1'b1};
      bins srl_disabled = {1'b0};
      option.weight = 0;
    }
    
    // Shift Right Arithmetic Coverage
    cp_sra_operation: coverpoint item.ap.sra {
      bins sra_enabled = {1'b1};
      bins sra_disabled = {1'b0};
      option.weight = 0;
    }
    
    // Rotate Right Coverage
    cp_ror_operation: coverpoint item.ap.ror {
      bins ror_enabled = {1'b1};
      bins ror_disabled = {1'b0};
      option.weight = 0;
    }
    
    // Bit Inverse Coverage
    cp_binv_operation: coverpoint item.ap.binv {
      bins binv_enabled = {1'b1};
      bins binv_disabled = {1'b0};
      option.weight = 0;
    }
    
    // Shift Amount Coverage (lower 5 bits of b_in)
    cp_shift_amount: coverpoint item.b_in[4:0] iff (item.ap.srl || item.ap.sra || item.ap.ror) {
      bins shift_amount_zero = {5'd0};
      bins shift_amount_one = {5'd1};
      bins shift_amount_small[] = {5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7};
      bins shift_amount_medium[] = {5'd8, 5'd15, 5'd16, 5'd23};
      bins shift_amount_large[] = {5'd24, 5'd30};
      bins shift_amount_max = {5'd31};
      option.weight = 0;
    }
    
    // Bit Position for BINV (lower 5 bits of b_in)
    cp_binv_bit_position: coverpoint item.b_in[4:0] iff (item.ap.binv) {
      bins bit_pos_lsb = {5'd0};                    // LSB
      bins bit_pos_low[] = {5'd1, 5'd2, 5'd3, 5'd7}; // Low bits
      bins bit_pos_mid[] = {5'd8, 5'd15, 5'd16, 5'd23}; // Middle bits
      bins bit_pos_high[] = {5'd24, 5'd28, 5'd29, 5'd30}; // High bits
      bins bit_pos_msb = {5'd31};                   // MSB
      option.weight = 0;
    }
    
    // Shift Operand A Pattern for Sign Extension (SRA)
    cp_sra_operand_a: coverpoint item.a_in iff (item.ap.sra) {
      bins sra_positive_max = {32'h7FFFFFFF};       // Max positive
      bins sra_positive_values[] = {32'h00000001, 32'h12345678, 32'h40000000};
      bins sra_negative_min = {32'h80000000};       // Most negative
      bins sra_negative_values[] = {32'hFFFFFFFF, 32'hFEDCBA98, 32'hC0000000};
      bins sra_zero = {32'h00000000};
      option.weight = 0;
    }
  endgroup
  
  //=============================================================================
  // COVERAGE GROUP 3: ARITHMETIC OPERATIONS (SUB, SLT)
  //=============================================================================
  covergroup cg_arithmetic_operations;
    option.per_instance = 1;
    option.name = "Arithmetic_Operations_Coverage";
    
    // Subtract Operation Coverage
    cp_sub_operation: coverpoint item.ap.sub {
      bins sub_enabled = {1'b1};
      bins sub_disabled = {1'b0};
      option.weight = 0;
    }
    
    // Set Less Than Operation Coverage
    cp_slt_operation: coverpoint item.ap.slt {
      bins slt_enabled = {1'b1};
      bins slt_disabled = {1'b0};
      option.weight = 0;
    }
    
    // SLT Signed/Unsigned Mode
    cp_slt_sign_mode: coverpoint item.ap.unsign iff (item.ap.slt) {
      bins slt_signed = {1'b0};     // Signed comparison
      bins slt_unsigned = {1'b1};   // Unsigned comparison
      option.weight = 0;
    }
    
    // SUB/SLT Operand A Coverage
    cp_arith_operand_a: coverpoint item.a_in iff (item.ap.sub || item.ap.slt) {
      bins arith_a_zero = {32'h00000000};
      bins arith_a_positive_max = {32'h7FFFFFFF};
      bins arith_a_negative_min = {32'h80000000};
      bins arith_a_all_ones = {32'hFFFFFFFF};
      bins arith_a_small_positive[] = {32'h00000001, 32'h00000002, 32'h0000007F};
      bins arith_a_small_negative[] = {32'hFFFFFFFF, 32'hFFFFFFFE, 32'hFFFFFF80};
      bins arith_a_boundary[] = {32'h80000001, 32'h7FFFFFFE};
      option.weight = 0;
    }
    
    // SUB/SLT Operand B Coverage
    cp_arith_operand_b: coverpoint item.b_in iff (item.ap.sub || item.ap.slt) {
      bins arith_b_zero = {32'h00000000};
      bins arith_b_positive_max = {32'h7FFFFFFF};
      bins arith_b_negative_min = {32'h80000000};
      bins arith_b_all_ones = {32'hFFFFFFFF};
      bins arith_b_small_positive[] = {32'h00000001, 32'h00000002, 32'h0000007F};
      bins arith_b_small_negative[] = {32'hFFFFFFFF, 32'hFFFFFFFE, 32'hFFFFFF80};
      bins arith_b_boundary[] = {32'h80000001, 32'h7FFFFFFE};
      option.weight = 0;
    }
  endgroup
  
  //=============================================================================
  // COVERAGE GROUP 4: BIT MANIPULATION (CTZ, CPOP, SEXT.B, MAX, PACK, GREV)
  //=============================================================================
  covergroup cg_bit_manipulation;
    option.per_instance = 1;
    option.name = "Bit_Manipulation_Coverage";
    
    // Count Trailing Zeros Coverage
    cp_ctz_operation: coverpoint item.ap.ctz {
      bins ctz_enabled = {1'b1};
      bins ctz_disabled = {1'b0};
      option.weight = 0;
    }
    
    // Count Population Coverage
    cp_cpop_operation: coverpoint item.ap.cpop {
      bins cpop_enabled = {1'b1};
      bins cpop_disabled = {1'b0};
      option.weight = 0;
    }
    
    // Sign Extend Byte Coverage
    cp_siext_b_operation: coverpoint item.ap.siext_b {
      bins siext_b_enabled = {1'b1};
      bins siext_b_disabled = {1'b0};
      option.weight = 0;
    }
    
    // Maximum Operation Coverage
    cp_max_operation: coverpoint item.ap.max {
      bins max_enabled = {1'b1};
      bins max_disabled = {1'b0};
      option.weight = 0;
    }
    
    // Pack Operation Coverage
    cp_pack_operation: coverpoint item.ap.pack {
      bins pack_enabled = {1'b1};
      bins pack_disabled = {1'b0};
      option.weight = 0;
    }
    
    // GREV Operation Coverage
    cp_grev_operation: coverpoint item.ap.grev {
      bins grev_enabled = {1'b1};
      bins grev_disabled = {1'b0};
      option.weight = 0;
    }
    
    // CTZ Input Patterns
    cp_ctz_input_patterns: coverpoint item.a_in iff (item.ap.ctz) {
      bins ctz_all_zeros = {32'h00000000};          // CTZ = 32
      bins ctz_no_trailing_zeros = {32'hFFFFFFFF};  // CTZ = 0
      bins ctz_one_trailing_zero = {32'hFFFFFFFE};  // CTZ = 1
      bins ctz_power_of_two[] = {32'h00000001, 32'h00000002, 32'h00000004, 
                                 32'h00000008, 32'h00000010, 32'h80000000};
      bins ctz_alternating = {32'hAAAAAAAA};        // CTZ = 1
      bins ctz_many_trailing[] = {32'h12300000, 32'hABC00000, 32'hFFF00000};
      option.weight = 0;
    }
    
    // CPOP Input Patterns
    cp_cpop_input_patterns: coverpoint item.a_in iff (item.ap.cpop) {
      bins cpop_all_zeros = {32'h00000000};         // CPOP = 0
      bins cpop_all_ones = {32'hFFFFFFFF};          // CPOP = 32
      bins cpop_single_bit[] = {32'h00000001, 32'h80000000, 32'h40000000};
      bins cpop_alternating_01 = {32'h55555555};    // CPOP = 16
      bins cpop_alternating_10 = {32'hAAAAAAAA};    // CPOP = 16
      bins cpop_sparse_bits[] = {32'h80000001, 32'h40008000, 32'h12481248};
      bins cpop_dense_bits[] = {32'h0FFFFFFF, 32'hFFFFFFF0, 32'h7FFFFFFE};
      option.weight = 0;
    }
    
    // SEXT.B Input Byte Patterns
    cp_siext_b_byte_patterns: coverpoint item.a_in[7:0] iff (item.ap.siext_b) {
      bins siext_b_positive_zero = {8'h00};
      bins siext_b_positive_max = {8'h7F};
      bins siext_b_positive_values[] = {8'h01, 8'h02, 8'h40, 8'h55};
      bins siext_b_negative_min = {8'h80};
      bins siext_b_negative_max = {8'hFF};
      bins siext_b_negative_values[] = {8'h81, 8'h90, 8'hAA, 8'hFE};
      option.weight = 0;
    }
    
    // GREV Control Value (should be 24 for byte reversal)
    cp_grev_control: coverpoint item.b_in[4:0] iff (item.ap.grev) {
      bins grev_byte_reverse = {5'd24};             // Valid: 5'b11000
      bins grev_invalid_values[] = {5'd0, 5'd1, 5'd2, 5'd3, 5'd23, 5'd25, 5'd31};
      option.weight = 0;
    }
  endgroup
  
  //=============================================================================
  // COVERAGE GROUP 5: ADDRESS GENERATION (SH2ADD)
  //=============================================================================
  covergroup cg_address_generation;
    option.per_instance = 1;
    option.name = "Address_Generation_Coverage";
    
    // SH2ADD Operation Coverage
    cp_sh2add_operation: coverpoint item.ap.sh2add {
      bins sh2add_enabled = {1'b1};
      bins sh2add_disabled = {1'b0};
      option.weight = 0;
    }
    
    // SH2ADD Operand A Coverage (will be shifted left by 2)
    cp_sh2add_operand_a: coverpoint item.a_in iff (item.ap.sh2add) {
      bins sh2add_a_zero = {32'h00000000};
      bins sh2add_a_small_positive[] = {32'h00000001, 32'h00000002, 32'h0000000F};
      bins sh2add_a_overflow_risk = {32'h40000000}; // Will overflow when shifted by 2
      bins sh2add_a_max_safe = {32'h3FFFFFFF};      // Max without overflow
      bins sh2add_a_negative[] = {32'hFFFFFFFF, 32'hFFFFFFFE, 32'h80000000};
      bins sh2add_a_boundary[] = {32'h20000000, 32'h1FFFFFFF, 32'h80000001};
      option.weight = 0;
    }
    
    // SH2ADD Operand B Coverage (will be added to shifted A)
    cp_sh2add_operand_b: coverpoint item.b_in iff (item.ap.sh2add) {
      bins sh2add_b_zero = {32'h00000000};
      bins sh2add_b_small[] = {32'h00000001, 32'h00000004, 32'h0000000F};
      bins sh2add_b_large[] = {32'h7FFFFFFF, 32'hFFFFFFFF, 32'h80000000};
      bins sh2add_b_boundary[] = {32'h7FFFFFFE, 32'h80000001};
      option.weight = 0;
    }
  endgroup
  
  //=============================================================================
  // COVERAGE GROUP 6: CSR OPERATIONS
  //=============================================================================
  covergroup cg_csr_operations;
    option.per_instance = 1;
    option.name = "CSR_Operations_Coverage";
    
    // CSR Read Enable
    cp_csr_read_enable: coverpoint item.csr_ren_in {
      bins csr_read_active = {1'b1};
      bins csr_read_inactive = {1'b0};
      option.weight = 0;
    }
    
    // CSR Write Enable
    cp_csr_write_enable: coverpoint item.ap.csr_write {
      bins csr_write_active = {1'b1};
      bins csr_write_inactive = {1'b0};
      option.weight = 0;
    }
    
    // CSR Immediate Mode
    cp_csr_immediate: coverpoint item.ap.csr_imm iff (item.ap.csr_write) {
      bins csr_imm_mode = {1'b1};     // Use b_in as write data
      bins csr_reg_mode = {1'b0};     // Use a_in as write data
      option.weight = 0;
    }
    
    // CSR Read Data Patterns
    cp_csr_read_data: coverpoint item.csr_rddata_in iff (item.csr_ren_in) {
      bins csr_data_zero = {32'h00000000};
      bins csr_data_all_ones = {32'hFFFFFFFF};
      bins csr_data_alternating[] = {32'h55555555, 32'hAAAAAAAA};
      bins csr_data_boundary[] = {32'h7FFFFFFF, 32'h80000000, 32'h80000001};
      bins csr_data_random = default;
      option.weight = 0;
    }
  endgroup
  
  //=============================================================================
  // COVERAGE GROUP 7: ERROR CONDITIONS
  //=============================================================================
  covergroup cg_error_conditions;
    option.per_instance = 1;
    option.name = "Error_Conditions_Coverage";
    
    // Multiple Operations Active (Error Condition)
    cp_multiple_ops_active: coverpoint {item.ap.lor, item.ap.lxor, item.ap.srl, item.ap.sra} {
      bins single_op_lor = {4'b1000};
      bins single_op_lxor = {4'b0100};
      bins single_op_srl = {4'b0010};
      bins single_op_sra = {4'b0001};
      bins no_ops = {4'b0000};
      bins multiple_ops_error[] = {4'b1100, 4'b1010, 4'b1001, 4'b0110, 4'b0101, 4'b0011, 4'b1110, 4'b1101, 4'b1011, 4'b0111, 4'b1111};
      option.weight = 0;
    }
    
    // CSR Conflict with Operations
    cp_csr_operation_conflict: coverpoint {item.csr_ren_in, (item.ap.lor || item.ap.lxor || item.ap.srl)} {
      bins no_conflict_csr_only = {2'b10};
      bins no_conflict_op_only = {2'b01};
      bins no_conflict_neither = {2'b00};
      bins conflict_both_active = {2'b11};  // Error condition
      option.weight = 0;
    }
    
    // ZBA Dependency Violations
    cp_zba_dependency: coverpoint {item.ap.sh2add, item.ap.zba} {
      bins sh2add_valid = {2'b11};      // SH2ADD with ZBA enabled
      bins sh2add_invalid = {2'b10};    // SH2ADD without ZBA (error)
      bins no_sh2add = {2'b00, 2'b01};
      option.weight = 0;
    }
    
    // SUB with ZBA constraint
    cp_sub_zba_constraint: coverpoint {item.ap.sub, item.ap.zba} {
      bins sub_valid = {2'b10};         // SUB with ZBA=0
      bins sub_invalid = {2'b11};       // SUB with ZBA=1 (error)
      bins no_sub = {2'b00, 2'b01};
      option.weight = 0;
    }
    
    // Valid Input Signal
    cp_valid_input: coverpoint item.valid_in {
      bins valid_active = {1'b1};
      bins valid_inactive = {1'b0};
      option.weight = 0;
    }
  endgroup
  
  //=============================================================================
  // COVERAGE GROUP 8: OPERAND PATTERNS
  //=============================================================================
  covergroup cg_operand_patterns;
    option.per_instance = 1;
    option.name = "Operand_Patterns_Coverage";
    
    // General A Operand Patterns
    cp_operand_a_patterns: coverpoint item.a_in {
      bins a_zero = {32'h00000000};
      bins a_all_ones = {32'hFFFFFFFF};
      bins a_alternating_01 = {32'h55555555};
      bins a_alternating_10 = {32'hAAAAAAAA};
      bins a_walking_ones[] = {32'h00000001, 32'h00000002, 32'h00000004, 32'h00000008,
                               32'h00000010, 32'h00000020, 32'h00000040, 32'h00000080,
                               32'h00000100, 32'h80000000};
      bins a_walking_zeros[] = {32'hFFFFFFFE, 32'hFFFFFFFD, 32'hFFFFFFFB, 32'hFFFFFFF7,
                                32'hFFFFFFEF, 32'hFFFFFFDF, 32'hFFFFFFBF, 32'hFFFFFF7F,
                                32'h7FFFFFFF};
      bins a_random = default;
      option.weight = 0;
    }
    
    // General B Operand Patterns  
    cp_operand_b_patterns: coverpoint item.b_in {
      bins b_zero = {32'h00000000};
      bins b_all_ones = {32'hFFFFFFFF};
      bins b_alternating_01 = {32'h55555555};
      bins b_alternating_10 = {32'hAAAAAAAA};
      bins b_walking_ones[] = {32'h00000001, 32'h00000002, 32'h00000004, 32'h00000008,
                               32'h00000010, 32'h00000020, 32'h00000040, 32'h00000080,
                               32'h00000100, 32'h80000000};
      bins b_walking_zeros[] = {32'hFFFFFFFE, 32'hFFFFFFFD, 32'hFFFFFFFB, 32'hFFFFFFF7,
                                32'hFFFFFFEF, 32'hFFFFFFDF, 32'hFFFFFFBF, 32'hFFFFFF7F,
                                32'h7FFFFFFF};
      bins b_random = default;
      option.weight = 0;
    }
  endgroup
  
  //=============================================================================
  // COVERAGE GROUP 9: EXTENSION MODES
  //=============================================================================
  covergroup cg_extension_modes;
    option.per_instance = 1;
    option.name = "Extension_Modes_Coverage";
    
    // ZBB Extension Usage
    cp_zbb_extension: coverpoint item.ap.zbb {
      bins zbb_enabled = {1'b1};
      bins zbb_disabled = {1'b0};
      option.weight = 0;
    }
    
    // ZBA Extension Usage
    cp_zba_extension: coverpoint item.ap.zba {
      bins zba_enabled = {1'b1};
      bins zba_disabled = {1'b0};
      option.weight = 0;
    }
    
    // Extension Combinations
    cp_extension_combinations: coverpoint {item.ap.zbb, item.ap.zba} {
      bins no_extensions = {2'b00};
      bins zbb_only = {2'b10};
      bins zba_only = {2'b01};
      bins both_extensions = {2'b11};
      option.weight = 0;
    }
  endgroup

// Constructor
  function new(string name = "BMU_subscriber", uvm_component parent);
    super.new(name, parent);
    
    // Initialize coverage groups
    cg_logic_operations = new();
    cg_shift_operations = new();
    cg_arithmetic_operations = new();
    cg_bit_manipulation = new();
    cg_address_generation = new();
    cg_csr_operations = new();
    cg_error_conditions = new();
    cg_operand_patterns = new();
    cg_extension_modes = new();
  endfunction
  
  // Write method - called when transaction is received
  function void write(bmu_sequence_item t);
    item = t;
    
    // Sample all coverage groups
    cg_logic_operations.sample();
    cg_shift_operations.sample();
    cg_arithmetic_operations.sample();
    cg_bit_manipulation.sample();
    cg_address_generation.sample();
    cg_csr_operations.sample();
    cg_error_conditions.sample();
    cg_operand_patterns.sample();
    cg_extension_modes.sample();
  endfunction
   //=============================================================================
  // COVERAGE REPORTING FUNCTIONS
  //=============================================================================
  
  // Function to get overall coverage percentage
  function real get_coverage();
    real total_coverage = 0;
    int coverage_groups = 9;
    
    total_coverage += cg_logic_operations.get_coverage();
    total_coverage += cg_shift_operations.get_coverage();
    total_coverage += cg_arithmetic_operations.get_coverage();
    total_coverage += cg_bit_manipulation.get_coverage();
    total_coverage += cg_address_generation.get_coverage();
    total_coverage += cg_csr_operations.get_coverage();
    total_coverage += cg_error_conditions.get_coverage();
    total_coverage += cg_operand_patterns.get_coverage();
    total_coverage += cg_extension_modes.get_coverage();
    
    return (total_coverage / coverage_groups);
  endfunction
  
  // Function to print simple coverage report
  function void print_coverage_report();
      
    // Print to simulation log
    `uvm_info(get_type_name(), "=== SIMPLE BMU COVERAGE REPORT ===", UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("1. Logic Operations: %0.2f%%", cg_logic_operations.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("2. Shift Operations: %0.2f%%", cg_shift_operations.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("3. Arithmetic Operations: %0.2f%%", cg_arithmetic_operations.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("4. Bit Manipulation: %0.2f%%", cg_bit_manipulation.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("5. Address Generation: %0.2f%%", cg_address_generation.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("6. CSR Operations: %0.2f%%", cg_csr_operations.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("7. Error Conditions: %0.2f%%", cg_error_conditions.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("8. Operand Patterns: %0.2f%%", cg_operand_patterns.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("9. Extension Modes: %0.2f%%", cg_extension_modes.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("OVERALL COVERAGE: %0.2f%%", get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), "=================================", UVM_LOW)
  endfunction
  
  // Extract phase - call print_coverage_report
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    print_coverage_report(); // Call the coverage report here
  endfunction
  
endclass : BMU_subscriber
