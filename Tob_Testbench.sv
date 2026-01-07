import uvm_pkg::*;
`include "uvm_macros.svh"
`include "/home/Trainee11/nadia/BMU_Proj/Packages/ap_def.sv"
import ap_pkg::*;
`include "Design/DUT/Bit_Manipulation_Unit_RTL/library/rtl_pdef.sv"
`include "Design/DUT/Bit_Manipulation_Unit_RTL/library/rtl_defines.sv"
`include "Design/DUT/Bit_Manipulation_Unit_RTL/library/rtl_lib.sv"
`include "Design/DUT/Bit_Manipulation_Unit_RTL/library/rtl_def.sv"
`include"Design/bmu_design.sv"
`include "Testbench/bmu_interface.sv"
`include "Testbench/bmu_sequence_item.sv"
`include "Testbench/Sequances/or_seq/Or_Base_seq.sv"
`include "Testbench/Sequances/or_seq/alternating_pattern_seq.sv"
`include "Testbench/Sequances/or_seq/bmu_Min_Neg_seq.sv"
`include "Testbench/Sequances/or_seq/bmu_or_back_to_back_seq.sv"
`include "Testbench/Sequances/or_seq/bmu_or_csr_read_conflict_seq.sv"
`include "Testbench/Sequances/or_seq/bmu_or_csr_write_conflict_seq.sv"
`include "Testbench/Sequances/or_seq/bmu_or_invalid_seq.sv"
`include "Testbench/Sequances/or_seq/bmu_or_max_postive_seq.sv"
`include "Testbench/Sequances/or_seq/bmu_or_mode_switch_seq.sv"
`include "Testbench/Sequances/or_seq/bmu_or_nibble_patterns_seq.sv"
`include "Testbench/Sequances/or_seq/bmu_or_random_orn_seq.sv"
`include "Testbench/Sequances/or_seq/bmu_or_random_std_seq.sv"
`include "Testbench/Sequances/or_seq/bmu_or_sub_conflict_seq.sv"
`include "Testbench/Sequances/or_seq/Mixed_Pattern_seq.sv"
`include "Testbench/Sequances/or_seq/orn_all_ones_seq.sv"
`include "Testbench/Sequances/or_seq/orn_all_zero_seq.sv"
`include "Testbench/Sequances/or_seq/orn_with_ones.sv"
`include "Testbench/Sequances/or_seq/or_with_zero.sv"
`include "Testbench/Sequances/or_seq/single_bit_operation_seq.sv"
`include "Testbench/Sequances/or_seq/standerd_or_all_ones_seq.sv"
`include "Testbench/Sequances/or_seq/standerd_or_all_zero_seq.sv"
`include "/home/Trainee11/BMU_Proj/Testbench/Sequances/Max_seq/max_seq.sv"
`include "/home/Trainee11/BMU_Proj/Testbench/Sequances/cpop_seq/cpop_Seq.sv"
`include "/home/Trainee11/BMU_Proj/Testbench/Sequances/pack_seq/bmu_pack_seq.sv"
//`include "/home/Trainee11/BMU_Proj/Testbench/Sequances/grev_seq/grev_seq.sv"
`include "/home/Trainee11/BMU_Proj/Testbench/Sequances/signxb_seq/signxb_seq.sv"
`include "/home/Trainee11/BMU_Proj/Testbench/Sequances/CTZ_seq/CTZ_seq.sv"
`include "/home/Trainee11/BMU_Proj/Testbench/Sequances/SLT_seq/slt_seq.sv"
`include "/home/Trainee11/BMU_Proj/Testbench/Sequances/sub_seq/sub_seq.sv"
`include "/home/Trainee11/BMU_Proj/Testbench/Sequances/SRL_seq/srl_seq.sv"
`include "Testbench/Sequances/xor_seq/bmu_xor_base_seq.sv"
`include "Testbench/Sequances/xor_seq/bmu_xnor_all_ones_seq.sv"
`include "Testbench/Sequances/xor_seq/bmu_xnor_all_zeros_seq.sv"
`include "Testbench/Sequances/xor_seq/bmu_xnor_identity_seq.sv"
`include "Testbench/Sequances/xor_seq/bmu_xnor_mixed_seq.sv"
`include "Testbench/Sequances/xor_seq/bmu_xnor_specific_seq.sv"
`include "Testbench/Sequances/xor_seq/bmu_xor_boundary_values_seq.sv"
`include "Testbench/Sequances/xor_seq/bmu_xor_cross_coverage_seq.sv"
`include "Testbench/Sequances/xor_seq/bmu_xor_csr_read_conflict_seq.sv"
`include "Testbench/Sequances/xor_seq/bmu_xor_csr_write_conflict_seq.sv"
`include "Testbench/Sequances/xor_seq/bmu_xor_nibble_patterns_seq.sv"
`include "Testbench/Sequances/xor_seq/bmu_xor_or_conflict_seq.sv"
`include "Testbench/Sequances/xor_seq/bmu_xor_std_all_ones_seq.sv"
`include "Testbench/Sequances/xor_seq/bmu_xor_std_all_zeros_seq.sv"
`include "Testbench/Sequances/xor_seq/bmu_xor_std_alternating_seq.sv"
`include "Testbench/Sequances/xor_seq/bmu_xor_std_identity_seq.sv"
`include "Testbench/Sequances/xor_seq/bmu_xor_std_mixed_seq.sv"
`include "Testbench/Sequances/xor_seq/bmu_xor_std_self_inverse_seq.sv"
`include "Testbench/Sequances/xor_seq/bmu_xor_std_single_bit_seq.sv"
`include "/home/Trainee11/BMU_Proj/Testbench/Sequances/xor_seq/xor_random.sv"

`include "Testbench/bmu_sequencer.sv"
`include "Testbench/bmu_driver.sv"
`include "Testbench/bmu_monitor.sv"
`include "Testbench/bmu_agent.sv"
`include "Testbench/bmu_scoreboard.sv"
`include "Testbench/bmu_subscriber.sv"
`include "Testbench/bmu_env.sv"
`include "Testbench/BMU_Random_Test.sv"
`include "Testbench/bmu_or_test.sv"
`include "/home/Trainee11/BMU_Proj/Testbench/bmu_xor_teat.sv"

module BMU_TestBench;
    
    logic clk;
    logic rst_l;  // Keep as separate signal
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
initial begin
  // Step 1: Assert reset at time 0
  rst_l = 1'b0;

  // Step 2: Hold reset for a few clock cycles (e.g., 20ns)
  #20;

  // Step 3: De-assert reset to release the DUT
  rst_l = 1'b1;
end
    assign vif.rst_l = rst_l;

    // Interface instantiation - REMOVED: rst_l from interface input
    bmu_interface vif(clk);  // Only clock input
    
    // DUT instantiation - Connect to interface rst_l
    Bit_Manibulation_Unit_top dut (
        .clk(vif.clk),
        .rst_l(vif.rst_l),  // Connect to interface signal
        .scan_mode(vif.scan_mode),
        .valid_in(vif.valid_in),
        .ap(vif.ap),
        .csr_ren_in(vif.csr_ren_in),
        .csr_rddata_in(vif.csr_rddata_in),
        .a_in(vif.a_in),
        .b_in(vif.b_in),
        .result_ff(vif.result_ff),
        .error(vif.error)
    );
    
    initial begin
        // Set interface in config_db
        uvm_config_db#(virtual bmu_interface)::set(uvm_root::get(), "*", "vif", vif);
        
        // Run the specified test
        run_test("BMU_OR_Regression_Test");
    end
    
       
endmodule: BMU_TestBench