class bmu_monitor extends uvm_monitor;
    `uvm_component_utils(bmu_monitor)
    
    // Initializations
    virtual bmu_interface vif;
    bmu_sequence_item packet;
    
    // Analysis port for sending transactions to scoreboard
    uvm_analysis_port #(bmu_sequence_item) port;
    
    // Constructor 
    function new(string name = "bmu_monitor", uvm_component parent);
        super.new(name, parent);
        port = new("port", this);
    endfunction
    
    // Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual bmu_interface)::get(this, "", "vif", vif))
            `uvm_fatal(get_type_name(), "Virtual interface not set at top level");
    endfunction
    
    // Run Phase - SIMPLIFIED like ALU example
    task run_phase(uvm_phase phase);
        forever begin
            @(vif.monitor_cb);
            
            // Create new packet for each transaction
            packet = bmu_sequence_item::type_id::create("packet");
            
            // Capture input signals
            packet.rst_l = vif.monitor_cb.rst_l;
            packet.scan_mode = vif.monitor_cb.scan_mode;
            packet.valid_in = vif.monitor_cb.valid_in;
            packet.a_in = vif.monitor_cb.a_in;
            packet.b_in = vif.monitor_cb.b_in;
            packet.csr_rddata_in = vif.monitor_cb.csr_rddata_in;
            packet.csr_ren_in = vif.monitor_cb.csr_ren_in;
            packet.ap = vif.monitor_cb.ap;
            
            `uvm_info(get_type_name(), 
                $sformatf("Monitor Input: rst_l=%0b, valid_in=%0b, a_in=0x%08x, b_in=0x%08x, lor=%0b", 
                packet.rst_l, packet.valid_in, packet.a_in, packet.b_in, packet.ap.lor), UVM_HIGH);
            
            // Capture output signals
            packet.result_ff = vif.monitor_cb.result_ff;
            packet.error = vif.monitor_cb.error;
            
            `uvm_info(get_type_name(), 
                $sformatf("Monitor Output: result_ff=0x%08x, error=%0b",
                packet.result_ff, packet.error), UVM_HIGH);
            
            // Send complete packet to analysis port
            port.write(packet);
        end
    endtask
    
endclass: bmu_monitor