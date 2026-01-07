//BMU Random Sequence
class BMU_Random_Sequence extends uvm_sequence #(bmu_sequence_item);
    //1. an Object
    `uvm_object_utils(BMU_Random_Sequence)
    
    //3. Constructor
    function new(string name = "BMU_Random_Sequence");
        super.new(name);
    endfunction: new
    
    //4. Task body
    task body();
        repeat(5) begin
            bmu_sequence_item transaction = bmu_sequence_item::type_id::create("transaction");
            transaction.randomize() with {
                rst_l == 1; 
                valid_in == 1;
                ap.lor == 1;
            };
        
            start_item(transaction);
                `uvm_info(get_type_name(), $sformatf("BMU_Random_Sequence:  \n %s", transaction.sprint()), UVM_NONE)
            finish_item(transaction);
        
        end 
     
    endtask: body
    
endclass: BMU_Random_Sequence