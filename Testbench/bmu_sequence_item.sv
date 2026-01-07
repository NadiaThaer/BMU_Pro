// Fixed bmu_sequence_item.sv
// Note: UVM and ap_pkg imports are now handled in the top-level testbench
import ap_pkg::*;  // If ap_t is defined in ap_pkg


class bmu_sequence_item extends uvm_sequence_item;
    //---------------------------------------
    // Member variables
    //---------------------------------------
   rand   logic        rst_l;               // Active-low synchronous reset
    rand logic        scan_mode;           // Scan test mode control
    rand logic        valid_in;            // Instruction valid flag
    rand logic signed [31:0] a_in;         // Operand Asigned
    rand logic  unsigned [31:0] b_in;       // Operand B unsigned
    rand logic [31:0] csr_rddata_in;       // CSR read data
    rand logic        csr_ren_in;          // CSR read-enable
    rand ap_t ap;                          // Decoded instruction control signals (ap_pkg now imported)
    
    // Output signals (non-randomized)
    logic [31:0] result_ff;                // Final computed result
    logic        error;                    // Error indicator
    
    //---------------------------------------
    // Field automation macros
    //---------------------------------------
    `uvm_object_utils_begin(bmu_sequence_item)
        `uvm_field_int(rst_l, UVM_ALL_ON)
        `uvm_field_int(scan_mode, UVM_ALL_ON)
        `uvm_field_int(valid_in, UVM_ALL_ON)
        `uvm_field_int(a_in, UVM_ALL_ON)
        `uvm_field_int(b_in, UVM_ALL_ON)
        `uvm_field_int(csr_rddata_in, UVM_ALL_ON)
        `uvm_field_int(csr_ren_in, UVM_ALL_ON)
        `uvm_field_int(ap, UVM_ALL_ON)
        `uvm_field_int(result_ff, UVM_ALL_ON)
        `uvm_field_int(error, UVM_ALL_ON)
    `uvm_object_utils_end
     
    //----------------------------------------
    // Constructor
    //-----------------------------------------
    function new(string name = "bmu_sequence_item");
        super.new(name);
    endfunction

endclass
