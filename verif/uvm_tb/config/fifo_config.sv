//=======FIFO configuration class==========//

class fifo_config extends uvm_component;

    uvm_cmdline_processor clp = uvm_cmdline_processor::get_inst();
    
    function new(string name = "fifo_config", uvm_component parent = null);
        super.new(name,parent);
    endfunction 

    int config_1;
    int config_2;
    int wr_data;
    int wr_en;
    int rd_en;
    bit random;

    function void build_phase(uvm_phase phase);
        post_randomize();
    endfunction

    `uvm_component_utils_begin(fifo_config)
    `uvm_field_int(config_1  ,  UVM_DEC)
    `uvm_field_int(config_2  ,  UVM_DEC)
    `uvm_component_utils_end  

    function void post_randomize();
        string arg_value;

        if(clp.get_arg_value("+config_1=", arg_value))
            config_1 = arg_value.atoi();
        if(clp.get_arg_value("+config_2=",arg_value))
            config_2 = arg_value.atoi();
        if(clp.get_arg_value("+data = ", arg_value))
            wr_data = arg_value.atoi();
        if(clp.get_arg_value("+wr_en = ", arg_value))
            wr_en = arg_value.atoi();
        if(clp.get_arg_value("+rd_en = ", arg_value))
            rd_en = arg_value.atoi();
        // Random values for length, width and height
        if (clp.get_arg_value("+random", arg_value)) 
            random = 'b1;
    endfunction


endclass 