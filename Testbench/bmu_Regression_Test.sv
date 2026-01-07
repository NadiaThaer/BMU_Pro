//0.2 Ver
class BMU_Regression_Test extends uvm_test;
`uvm_component_utils(BMU_Regression_Test)
 BMU_Environment bmu_environment;
 //////////////////////////////////////// Creation Object From Each Class /////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////Remark Very Important //////////////////////////////////////
/*
 rst My be 1 Since it is a signal so Can Be Flush to rst 1 when it is 1 then no work no operation Done Result=0 Error = 0.
*/

  function new(string name = "BMU_Regression_Test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    bmu_environment= BMU_Environment::type_id::create("bmu_environment", this);
  endfunction

  task run_phase(uvm_phase phase);
    //1.Raises number of objections for corresponding object with default count = 1
   
    phase.drop_objection(this);
    `uvm_info(get_type_name(), "BMU_Regression Test Complete", UVM_LOW)
  endtask

endclass