interface bmu_interface(input logic clk);
   // import ap_pkg::*;//From the ap_def.sv that define the Strcut .

    logic        scan_mode;
    logic        valid_in;
    logic signed [31:0] a_in;    
    logic signed [31:0] b_in;  
    logic [31:0] csr_rddata_in;
    logic        csr_ren_in;
    logic [31:0] result_ff;
    logic        error;
    logic        rst_l;  // ADDED: rst_l as interface signal
    ap_t           ap;
    

    clocking DRIVER_CB @(posedge clk);
        default input #1step output #2;
        output valid_in;
        output a_in;
        output b_in;
        output csr_ren_in;
        output csr_rddata_in;
        output ap;
        output scan_mode;
    endclocking

    clocking monitor_cb @(posedge clk);
        default input #2step output #0;
        input rst_l;      // ADDED: Monitor reset
        input valid_in;
        input a_in;
        input b_in;
        input csr_ren_in;
        input csr_rddata_in;
        input ap;
        input scan_mode;
        input result_ff;
        input error;
    endclocking

    modport DRIVER (clocking DRIVER_CB, input clk);
    modport MONITOR (clocking monitor_cb, input clk);
endinterface