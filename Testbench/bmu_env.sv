//BMU Environment
class BMU_Environment extends uvm_env;
    `uvm_component_utils(BMU_Environment)
    
    // Environment Components
    BMU_agent      agent;
    bmu_scoreboard scoreboard;
    BMU_subscriber  subscriber;
   
    
    function new(string name = "BMU_Environment", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
                        
        // Create agent
        agent = BMU_agent::type_id::create("agent", this);
        
       
        
        // Create scoreboard
        scoreboard = bmu_scoreboard::type_id::create("scoreboard", this);
        
        // Create subscriber for coverage collection
        subscriber =  BMU_subscriber::type_id::create("subscriber", this);
        
        `uvm_info(get_name(), "BMU Environment build phase completed", UVM_MEDIUM)
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // Connect monitor to scoreboard for result checking
        agent.monitor.port.connect(scoreboard.exp);
        
        // Connect monitor to subscriber for coverage collection
        agent.monitor.port.connect(subscriber.analysis_export);
        
        `uvm_info(get_name(), "BMU Environment connect phase completed", UVM_MEDIUM)
    endfunction
    
    /*
    Does not have a run phase since it is just a structural component:
    Container that contains the active components like agent, scoreboard, etc.
    */
        
endclass : BMU_Environment
