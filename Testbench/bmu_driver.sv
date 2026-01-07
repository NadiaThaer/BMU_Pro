class BMU_driver extends uvm_driver #(bmu_sequence_item);
  `uvm_component_utils(BMU_driver)

  virtual bmu_interface vif;
  bmu_sequence_item req;
  
  // ADD THIS ANALYSIS PORT
  uvm_analysis_port #(bmu_sequence_item) driver_port;

  function new(string name = "BMU_driver", uvm_component parent);
    super.new(name, parent);
    driver_port = new("driver_port", this); // CREATE THE PORT
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!(uvm_config_db#(virtual bmu_interface)::get(this, "", "vif", vif))) 
      `uvm_fatal(get_type_name(), "Not set at top level");
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      
      // SEND TRANSACTION TO SCOREBOARD
      driver_port.write(req);
      
      `uvm_info(get_type_name(), $sformatf("Driver: signals driven"), UVM_HIGH);
      seq_item_port.item_done();
    end
  endtask

  task drive();
    @(vif.DRIVER_CB);
    vif.DRIVER_CB.a_in <= req.a_in;
    vif.DRIVER_CB.b_in <= req.b_in;
    vif.DRIVER_CB.valid_in <= req.valid_in;
    vif.DRIVER_CB.csr_ren_in <= req.csr_ren_in;
    vif.DRIVER_CB.csr_rddata_in <= req.csr_rddata_in;
    vif.DRIVER_CB.scan_mode <= req.scan_mode;
    vif.DRIVER_CB.ap <= req.ap;
  endtask

endclass : BMU_driver