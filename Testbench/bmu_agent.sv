class BMU_agent extends uvm_agent;
    //1. Registration Component
    `uvm_component_utils(BMU_agent)
    
    //2. Initializations of agent components
    BMU_driver    driver;
    bmu_monitor   monitor;  // Note: should be BMU_monitor (capital M) to match your driver
    BMU_sequencer sequencer;
    
    //3. Constructor
    function new(string name = "BMU_agent", uvm_component parent);
        super.new(name, parent);
    endfunction : new
    
    //4. Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        /*
        Need to check if the Agent is Active or Not by using get_is_active()
        If it is Active then we need to create the DRIVER + Sequencer + Monitor 
        If it is Passive then it will just observe signals from DUT.
        */
        if(get_is_active() == UVM_ACTIVE) begin
            sequencer = BMU_sequencer::type_id::create("BMU_sequencer", this);
            driver = BMU_driver::type_id::create("BMU_driver", this);
            `uvm_info(get_name(), "This is Active BMU agent", UVM_LOW);
        end
        monitor = bmu_monitor::type_id::create("bmu_monitor", this);
    endfunction : build_phase
    
    //5. Connect Phase
    /*
    Since the Agent is Container then we will connect them 
    Sequencer ----------------> Driver 
    seq_item_pull_export ------------->seq_item_pull_port
                     Notice we use :
          seq_item_export extends seq_item_pull_export
          seq_item_port extends seq_item_pull_port
    */
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(get_is_active() == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction : connect_phase
    
endclass : BMU_agent