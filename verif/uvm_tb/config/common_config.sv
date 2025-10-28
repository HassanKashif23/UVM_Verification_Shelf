//======Common configuration class===========//

class common_config extends uvm_component;
    uvm_cmdline_processor clp = uvm_cmdline_processor::get_inst();

    // constructor
    function new(string name = "common_config", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    int         num_items = 20;
    int         watchdog_timer = 20000;

    // Build phase
    function void build_phase(uvm_phase phase);
        string arg_value;
        if(clp.get_arg_value("+num_items", arg_value))
            num_items = arg_value.atoi();
        if(clp.get_arg_value("+watchdog_timer", arg_value))
            watchdog_timer = arg_value.atoi()*1000000;
    endfunction

    `uvm_component_utils_begin(common_config)
    `uvm_field_int(num_items  ,  UVM_DEC)
    `uvm_field_int(watchdog_timer  ,  UVM_DEC)
    `uvm_component_utils_end  

endclass

  // function void post_randomize();
  //   string arg_value;
  //   super.post_randomize();
  //   if(clp.get_arg_value("+inp_num_cboids=" , arg_value)) inp_num_cboids = arg_value.atoi();
  //   if(clp.get_arg_value("+watchdog_timer=" , arg_value)) watchdog_timer = arg_value.atoi()*1000000; 

  // endfunction // post_randomize