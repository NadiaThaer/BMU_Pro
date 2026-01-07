class bmu_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(bmu_scoreboard)

  // Analysis imp to receive packets
  uvm_analysis_imp#(bmu_sequence_item, bmu_scoreboard) exp;

  // Pipeline handling
  int unsigned latency = 1;
  bmu_sequence_item cmd_pipe[$];

    // Queue to store transactions for processing
    bmu_sequence_item transaction_queue[$];
    bmu_sequence_item current_trans;

  // Statistics counters
  int pass_count = 0;
  int fail_count = 0;
  int total_transactions = 0;

  // ANSI Color Codes for Terminal Output
  parameter string GREEN = "\033[1;32m";
  parameter string RED = "\033[1;31m";
  parameter string RESET = "\033[0m";

  // Sequence tracking
  string sequence_results[string];
  int sequence_pass_count = 0;
  int sequence_fail_count = 0;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    int unsigned tmp_latency;
    
    super.build_phase(phase);
    exp = new("exp", this);
    
    // Optional: allow overriding latency from test/env
    if (uvm_config_db#(int unsigned)::get(this, "", "latency", tmp_latency)) 
      latency = tmp_latency;
  endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    
    fork
        // Thread 1: Continuous monitoring and periodic reporting
        begin
            forever begin
                #10000; // Report every 10,000 time units
                if (total_transactions > 0) begin
                    `uvm_info("SCOREBOARD_MONITOR", 
                        $sformatf("Progress Report: Total=%0d, Pass=%0d, Fail=%0d, Success Rate=%.1f%%", 
                                  total_transactions, pass_count, fail_count, 
                                  (pass_count * 100.0) / total_transactions), UVM_LOW)
                end
            end
        end
        
        // Thread 2: Transaction queue monitoring (if using queue-based approach)
        begin
            forever begin
                // Wait for transactions to be available in queue
                wait(transaction_queue.size() != 0);
                
                // Process transaction from queue
                current_trans = transaction_queue.pop_front();
                
                
                
                // Small delay to prevent infinite loop stress
                #1;
            end
        end
        
        // Thread 3: Error condition monitoring
        begin
            forever begin
                #1000; // Check every 1000 time units
                
                // Monitor for potential issues
                if (cmd_pipe.size() > 100) begin
                    `uvm_warning("SCOREBOARD_MONITOR", 
                        $sformatf("Pipeline depth is getting large: %0d transactions pending", 
                                  cmd_pipe.size()))
                end
                
                // Check if we're getting too many consecutive failures
                if (fail_count > 0 && total_transactions > 10) begin
                    real fail_rate = (fail_count * 100.0) / total_transactions;
                    if (fail_rate > 50.0) begin
                        `uvm_warning("SCOREBOARD_MONITOR", 
                            $sformatf("High failure rate detected: %.1f%% (%0d/%0d)", 
                                      fail_rate, fail_count, total_transactions))
                    end
                end
            end
        end
        
        // Thread 4: Graceful shutdown monitoring
        begin
            phase.wait_for_state(UVM_PHASE_READY_TO_END, UVM_GTE);
            
            // Wait for pipeline to drain before ending
            `uvm_info("SCOREBOARD_MONITOR", "Waiting for pipeline to drain...", UVM_LOW)
            wait(cmd_pipe.size() == 0);
            
            // Final report
            `uvm_info("SCOREBOARD_MONITOR", 
                $sformatf("Final Status: Pipeline drained, %0d transactions processed", 
                          total_transactions), UVM_LOW)
        end
        
    join_any
    
    // Clean up when phase ends
    `uvm_info("SCOREBOARD_MONITOR", "run_phase ending", UVM_LOW)
    
endtask : run_phase

    function void write(bmu_sequence_item req);
    // Declare all variables at the beginning
    bmu_sequence_item in_tr;
    bmu_sequence_item prod;
    string sequence_name;
    logic [31:0] exp_res;
    bit exp_err;
    string operation_str;
    string color_code;

    // Flush on reset
    if (!req.rst_l) begin
      cmd_pipe.delete();
      `uvm_info("SCOREBOARD", "Reset observed -> clearing pipeline", UVM_LOW)
      return;
    end

    // Push current-cycle inputs into the pipe
    in_tr = new();
    in_tr.copy(req);
    cmd_pipe.push_back(in_tr);

    // When we have enough history, pop the producer of today's result
    if (cmd_pipe.size() > latency) begin
      prod = cmd_pipe.pop_front();
      total_transactions++;

      // Extract sequence name
      sequence_name = $sformatf("SEQ_%0d", total_transactions);

      // Compute expected result
      compute_expected(prod, exp_res, exp_err);

      // Get operation string
      operation_str = get_operation_name(prod.ap, prod.csr_ren_in);

      // Compare results
      if ((req.result_ff === exp_res) && (req.error === exp_err)) begin
        pass_count++;
        sequence_results[sequence_name] = "PASS";
        sequence_pass_count++;
        `uvm_info("SCOREBOARD:", $sformatf("PASS"), UVM_NONE)
      end else begin
        fail_count++;
        sequence_results[sequence_name] = "FAIL";
        sequence_fail_count++;
        `uvm_error("SCOREBOARD:", $sformatf("FAIL"))
        `uvm_error("SCOREBOARD", $sformatf("Mismatch: A=0x%08x B=%0x exp=0x%08x/%0b got=0x%08x/%0b", 
                  prod.a_in, prod.b_in, exp_res, exp_err, req.result_ff, req.error))
      end

      // Display detailed results
      color_code = ((req.result_ff === exp_res) && (req.error === exp_err)) ? GREEN : RED;
      display_transaction_results(prod, req, exp_res, exp_err, sequence_name, operation_str, color_code, RESET);
    end
  endfunction
   // Helper function to count active control signals
    function int count_active_controls(input ap_t ap_in);
        int count = 0;
        if (ap_in.lor) count++;
        if (ap_in.lxor) count++;
        if (ap_in.srl) count++;
        if (ap_in.sra) count++;
        if (ap_in.ror) count++;
        if (ap_in.binv) count++;
        if (ap_in.sh2add) count++;
        if (ap_in.sub) count++;
        if (ap_in.ctz) count++;
        if (ap_in.cpop) count++;
        if (ap_in.siext_b) count++;
        if (ap_in.max) count++;
        if (ap_in.pack) count++;
        if (ap_in.grev) count++;
        if (ap_in.csr_write) count++;
        return count;
    endfunction

task compute_expected(bmu_sequence_item tr, output logic [31:0] expected, output bit exp_err);
    // Initialize outputs
    expected = 32'h0;
    exp_err = 1'b0;
    
    // Reset handling - if reset is active, return zeros
    if (!tr.rst_l) return;
    
    // If not valid, return zero result
    if (!tr.valid_in) begin
        expected = 32'h0;
        return;
    end
    
    // CSR Operations - Highest Priority
    if (tr.csr_ren_in) begin
        // Error: CSR read with any bit manipulation operation
        if (tr.ap.lor || tr.ap.lxor || tr.ap.land || tr.ap.srl || tr.ap.sra || tr.ap.sll ||
            tr.ap.ror || tr.ap.rol || tr.ap.binv || tr.ap.bset || tr.ap.bclr || tr.ap.bext ||
            tr.ap.sh1add || tr.ap.sh2add || tr.ap.sh3add || tr.ap.add || tr.ap.sub ||
            tr.ap.slt || tr.ap.ctz || tr.ap.clz || tr.ap.cpop || tr.ap.siext_b ||
            tr.ap.siext_h || tr.ap.max || tr.ap.min || tr.ap.pack || tr.ap.packu ||
            tr.ap.packh || tr.ap.grev || tr.ap.gorc) begin
            exp_err = 1'b1;
            expected = 32'h0;
            return;
        end
        // Valid CSR read
        expected = tr.csr_rddata_in;
        return;
    end
    
    // CSR Write Operations
    if (tr.ap.csr_write) begin
        // Error: CSR write with any other operation
        if (count_active_controls(tr.ap) > 1) begin
            exp_err = 1'b1;
            expected = 32'h0;
            return;
        end
        // Valid CSR write
        expected = tr.ap.csr_imm ? tr.b_in : tr.a_in;
        return;
    end
    
    // Logic Operations
    if (tr.ap.lor) begin
        // Error: Multiple operations active
        if (count_active_controls(tr.ap) > 1) begin
            exp_err = 1'b1;
            expected = 32'h0;
            return;
        end
        // Valid OR operation
        if (tr.ap.zbb)
            expected = tr.a_in | (~tr.b_in);  // ORN - OR with inverted B
        else
            expected = tr.a_in | tr.b_in;     // Standard OR
        return;
    end
    
    if (tr.ap.lxor) begin
        // Error: Multiple operations active
        if (count_active_controls(tr.ap) > 1) begin
            exp_err = 1'b1;
            expected = 32'h0;
            return;
        end
        // Valid XOR operation
        if (tr.ap.zbb)
            expected = tr.a_in ^ (~tr.b_in);  // XNOR - XOR with inverted B
        else
            expected = tr.a_in ^ tr.b_in;     // Standard XOR
        return;
    end
    
    
    // Shift Operations
    if (tr.ap.srl) begin
        // Error: Multiple operations active
        if (count_active_controls(tr.ap) > 1) begin
            exp_err = 1'b1;
            expected = 32'h0;
            return;
        end
        // Valid SRL operation
        expected = tr.a_in >> tr.b_in[4:0];
        return;
    end
    
    if (tr.ap.sra) begin
        // Error: Multiple operations active
        if (count_active_controls(tr.ap) > 1) begin
            exp_err = 1'b1;
            expected = 32'h0;
            return;
        end
        // Valid SRA operation
        expected = $signed(tr.a_in) >>> tr.b_in[4:0];
        return;
    end
    
    
    if (tr.ap.ror) begin
        // Error: Multiple operations active
        if (count_active_controls(tr.ap) > 1) begin
            exp_err = 1'b1;
            expected = 32'h0;
            return;
        end
        // Valid ROR operation
        expected = (tr.a_in >> tr.b_in[4:0]) | (tr.a_in << (32 - tr.b_in[4:0]));
        return;
    end
    
       
    // Bit Manipulation Operations
    if (tr.ap.binv) begin
        // Error: Multiple operations active
        if (count_active_controls(tr.ap) > 1) begin
            exp_err = 1'b1;
            expected = 32'h0;
            return;
        end
        // Valid BINV operation
        expected = tr.a_in ^ (32'h1 << tr.b_in[4:0]);
        return;
    end
    
    if (tr.ap.bset) begin
        // Error: Multiple operations active
        if (count_active_controls(tr.ap) > 1) begin
            exp_err = 1'b1;
            expected = 32'h0;
            return;
        end
        // Valid BSET operation
        expected = tr.a_in | (32'h1 << tr.b_in[4:0]);
        return;
    end
    
    if (tr.ap.bclr) begin
        // Error: Multiple operations active
        if (count_active_controls(tr.ap) > 1) begin
            exp_err = 1'b1;
            expected = 32'h0;
            return;
        end
        // Valid BCLR operation
        expected = tr.a_in & (~(32'h1 << tr.b_in[4:0]));
        return;
    end
    
    if (tr.ap.bext) begin
        // Error: Multiple operations active
        if (count_active_controls(tr.ap) > 1) begin
            exp_err = 1'b1;
            expected = 32'h0;
            return;
        end
        // Valid BEXT operation
        expected = (tr.a_in >> tr.b_in[4:0]) & 32'h1;
        return;
    end
    
      
    if (tr.ap.sh2add) begin
        // Error: Multiple operations active or Zba not enabled
        if (count_active_controls(tr.ap) > 1 || !tr.ap.zba) begin
            exp_err = 1'b1;
            expected = 32'h0;
            return;
        end
        // Valid SH2ADD operation
        expected = (tr.a_in << 2) + tr.b_in;
        return;
    end
       
    // MOVED: Check composite ops (that require sub) before add/sub
    if (tr.ap.slt) begin
        // Error: Multiple operations active (but sub can be active for SLT)
        if ((count_active_controls(tr.ap) > 2) || 
            (count_active_controls(tr.ap) > 1 && !tr.ap.sub)) begin
            exp_err = 1'b1;
            expected = 32'h0;
            return;
        end
        // Valid SLT operation
        if (tr.ap.unsign)
            expected = (tr.a_in < tr.b_in) ? 32'h1 : 32'h0;  // SLTU
        else
            expected = ($signed(tr.a_in) < $signed(tr.b_in)) ? 32'h1 : 32'h0;  // SLT
        return;
    end
    
    if (tr.ap.max) begin
        // Error: Multiple operations active (but sub can be active for MAX)
        if ((count_active_controls(tr.ap) > 2) || 
            (count_active_controls(tr.ap) > 1 && !tr.ap.sub)) begin
            exp_err = 1'b1;
            expected = 32'h0;
            return;
        end
        // Valid MAX operation
        expected = ($signed(tr.a_in) > $signed(tr.b_in)) ? tr.a_in : tr.b_in;
        return;
    end
    
    if (tr.ap.sub) begin
        // Error: Multiple operations active or SUB used with Zba
        if (count_active_controls(tr.ap) > 1 || tr.ap.zba) begin
            exp_err = 1'b1;
            expected = 32'h0;
            return;
        end
        // Valid standalone SUB operation
        expected = tr.a_in - tr.b_in;
        return;
    end
    
  if (tr.ap.ctz) begin
    // Error: Multiple operations active
    if (count_active_controls(tr.ap) > 1) begin
        exp_err = 1'b1;
        expected = 32'h0;
        return;
    end
    
    // Valid CTZ operation - count trailing zeros
    expected = 32;  // Default to 32 for all-zeros case
    for (int i = 0; i < 32; i++) begin
        if (tr.a_in[i]) begin
            expected = i;
            break;
        end
    end
    // No need for the if (i == 31) check - it's unreachable
    return;
end
        
    if (tr.ap.cpop) begin
        // Error: Multiple operations active
        if (count_active_controls(tr.ap) > 1) begin
            exp_err = 1'b1;
            expected = 32'h0;
            return;
        end
        // Valid CPOP operation - population count
        expected = 32'h0;
        for (int i = 0; i < 32; i++) begin
            if (tr.a_in[i]) expected++;
        end
        return;
    end
    
    // Sign Extension Operations
    if (tr.ap.siext_b) begin
        // Error: Multiple operations active
        if (count_active_controls(tr.ap) > 1) begin
            exp_err = 1'b1;
            expected = 32'h0;
            return;
        end
        // Valid SEXT.B operation - sign extend byte
        expected = {{24{tr.a_in[7]}}, tr.a_in[7:0]};
        return;
    end
        
    // Pack Operations
    if (tr.ap.pack) begin
        // Error: Multiple operations active
        if (count_active_controls(tr.ap) > 1) begin
            exp_err = 1'b1;
            expected = 32'h0;
            return;
        end
        // Valid PACK operation - pack lower halves
        expected = {tr.b_in[15:0], tr.a_in[15:0]};
        return;
    end
    
      
    // Generalized Reverse Operations
    if (tr.ap.grev) begin
        // Error: Multiple operations active or invalid b_in value
        if (count_active_controls(tr.ap) > 1 || tr.b_in[4:0] != 5'b11000) begin
            exp_err = 1'b1;
            expected = 32'h0;
            return;
        end
        // Valid GREV operation - byte reverse (REV8)
        expected = {tr.a_in[7:0], tr.a_in[15:8], tr.a_in[23:16], tr.a_in[31:24]};
        return;
    end
    
    
    // If no operation is active but valid_in is high, this might be an error
    if (count_active_controls(tr.ap) == 0) begin
        expected = 32'h0;
        // This might not be an error condition - just no operation selected
    end
    
    `uvm_info("REF_MODEL", 
        $sformatf("Reference Model: A=0x%08x, B=0x%08x, Operation=%s, Result=0x%08x, Error=%b", 
                  tr.a_in, tr.b_in, get_operation_name(tr.ap, tr.csr_ren_in), 
                  expected, exp_err), UVM_LOW)
                  
endtask
// Helper function to get operation name for logging
function string get_operation_name(input ap_t ap_in, input bit csr_ren);
    if (csr_ren) return "CSR_READ";
    if (ap_in.csr_write) return "CSR_WRITE";
    if (ap_in.lor) return ap_in.zbb ? "ORN" : "OR";
    if (ap_in.lxor) return ap_in.zbb ? "XNOR" : "XOR";
    if (ap_in.land) return ap_in.zbb ? "ANDN" : "AND";
    if (ap_in.srl) return "SRL";
    if (ap_in.sra) return "SRA";
    if (ap_in.sll) return "SLL";
    if (ap_in.ror) return "ROR";
    if (ap_in.rol) return "ROL";
    if (ap_in.binv) return "BINV";
    if (ap_in.bset) return "BSET";
    if (ap_in.bclr) return "BCLR";
    if (ap_in.bext) return "BEXT";
    if (ap_in.sh1add) return "SH1ADD";
    if (ap_in.sh2add) return "SH2ADD";
    if (ap_in.sh3add) return "SH3ADD";
    if (ap_in.add) return "ADD";
    if (ap_in.sub && !ap_in.slt && !ap_in.max && !ap_in.min) return "SUB";
    if (ap_in.slt) return ap_in.unsign ? "SLTU" : "SLT";
    if (ap_in.ctz) return "CTZ";
    if (ap_in.clz) return "CLZ";
    if (ap_in.cpop) return "CPOP";
    if (ap_in.siext_b) return "SEXT.B";
    if (ap_in.siext_h) return "SEXT.H";
    if (ap_in.max) return "MAX";
    if (ap_in.min) return "MIN";
    if (ap_in.pack) return "PACK";
    if (ap_in.packu) return "PACKU";
    if (ap_in.packh) return "PACKH";
    if (ap_in.grev) return "GREV(REV8)";
    if (ap_in.gorc) return "GORC(ORC.B)";
    return "NO_OP";
endfunction
 
  // Display function for transaction results
  function void display_transaction_results(
    bmu_sequence_item prod, 
    bmu_sequence_item actual,
    logic [31:0] expected_result,
    bit expected_error,
    string sequence_name,
    string operation_str,
    string color_code,
    string reset_code
  );
    // DECLARATIONS FIRST (none needed beyond parameters)

    // Display results
    $display("%s+-----------------------------------------------+%s", color_code, reset_code);
    $display("%s| Transaction: %-32s |%s", color_code, sequence_name, reset_code);
    $display("%s+-----------------------------------------------+%s", color_code, reset_code);
    $display("%s| Operation:   %-32s |%s", color_code, operation_str, reset_code);
    $display("%s| Input A:     0x%08x                            |%s", color_code, prod.a_in, reset_code);
    $display("%s| Input B:     0x%08x                            |%s", color_code, prod.b_in, reset_code);
    $display("%s| Reset:       %-1d                                    |%s", color_code, prod.rst_l, reset_code);
    $display("%s| Control:     %-32s |%s", color_code, $sformatf("csr_write=%b, lor=%b, lxor=%b", 
              prod.ap.csr_write, prod.ap.lor, prod.ap.lxor), reset_code);
    $display("%s|              %-32s |%s", color_code, $sformatf("srl=%b, sra=%b, ror=%b", 
              prod.ap.srl, prod.ap.sra, prod.ap.ror), reset_code);
    $display("%s|              %-32s |%s", color_code, $sformatf("binv=%b, sh2add=%b, sub=%b", 
              prod.ap.binv, prod.ap.sh2add, prod.ap.sub), reset_code);
    $display("%s|              %-32s |%s", color_code, $sformatf("slt=%b, ctz=%b, cpop=%b", 
              prod.ap.slt, prod.ap.ctz, prod.ap.cpop), reset_code);
    $display("%s|              %-32s |%s", color_code, $sformatf("siext_b=%b, max=%b, pack=%b", 
              prod.ap.siext_b, prod.ap.max, prod.ap.pack), reset_code);
    $display("%s|              %-32s |%s", color_code, $sformatf("grev=%b, zba=%b, zbb=%b", 
              prod.ap.grev, prod.ap.zba, prod.ap.zbb), reset_code);
    $display("%s| Expected:    0x%08x                            |%s", color_code, expected_result, reset_code);
    $display("%s| Actual:      0x%08x                            |%s", color_code, actual.result_ff, reset_code);
    $display("%s| Error Exp:   %-1d                                |%s", color_code, expected_error, reset_code);
    $display("%s| Error Act:   %-1d                                |%s", color_code, actual.error, reset_code);
    $display("%s| Status:      %-32s |%s", color_code, 
             ((actual.result_ff === expected_result) && (actual.error === expected_error)) ? "PASS" : "FAIL", reset_code);
    $display("%s+-----------------------------------------------+%s", color_code, reset_code);
    $display("");
  endfunction


  // Final phase - print final statistics
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    
    `uvm_info("SCOREBOARD:", $sformatf("FINAL REPORT: Total=%0d, Pass=%0d, Fail=%0d", 
              total_transactions, pass_count, fail_count), UVM_NONE)
  endfunction

endclass