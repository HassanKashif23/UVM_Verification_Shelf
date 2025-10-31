//=======FIFO configuration class==========//

class fifo_config extends uvm_component;

    uvm_cmdline_processor clp = uvm_cmdline_processor::get_inst();
    
    function new(string name = "fifo_config", uvm_component parent = null);
        super.new(name,parent);
    endfunction 

    // ACTUAL FIFO PARAMETERS YOU NEED:
    int depth = 8;           // Depth of your FIFO
    int width = 8;           // Width of data bus  
    int max_wr_delay = 5;         // Max delay between writes
    int max_rd_delay = 5;         // Max delay between reads
    bit random_data = 0;      // 1=random data, 0=sequential

    function void build_phase(uvm_phase phase);
        post_randomize();
    endfunction

    `uvm_component_utils_begin(fifo_config)
    `uvm_field_int(depth  ,  UVM_DEC)
    `uvm_field_int(width  ,  UVM_DEC)
    `uvm_field_int(max_wr_delay    , UVM_DEC)
    `uvm_field_int(max_rd_delay    , UVM_DEC)
    `uvm_field_int(random_data , UVM_DEC)
    `uvm_component_utils_end  

    function void post_randomize();
        string arg_value;

        // GET ACTUAL FIFO PARAMETERS FROM COMMAND LINE:
        if(clp.get_arg_value("+depth=", arg_value))
            depth = arg_value.atoi();
        if(clp.get_arg_value("+width=", arg_value))
            width = arg_value.atoi();
        if(clp.get_arg_value("+max_wr_delay=", arg_value))
            max_wr_delay = arg_value.atoi();
        if(clp.get_arg_value("+max_rd_delay=", arg_value))
            max_rd_delay = arg_value.atoi();
        if(clp.get_arg_value("+random_data=", arg_value))
            random_data = arg_value.atoi();

            `uvm_info("FIFO_CONFIG", $sformatf(
            "Config: depth=%0d, width=%0d, random=%0d",
            depth, width, random_data), UVM_MEDIUM)

    endfunction


endclass 