
class BMU_sequencer extends uvm_sequencer #(bmu_sequence_item);

	//------------------------------
	//Register the object 
	//-----------------------------
  `uvm_component_utils(BMU_sequencer)

       //------------------------------
       //Build Constructor 
       //-----------------------------
	function new(string name = "BMU_sequencer", uvm_component parent);
         super.new(name, parent);
        endfunction : new
        /*
	*Remark :in sequencer :No real stimulus should run during build_phase or connect_phase
	since sequencer work AS Channel Between Sequence iteam And Driver.
	*/
 
endclass :BMU_sequencer



