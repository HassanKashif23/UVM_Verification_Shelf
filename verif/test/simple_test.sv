class simple_test extends fifo_base_test;
    `uvm_component_utils(simple_test)
    
    function new(string name = "simple_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
endclass