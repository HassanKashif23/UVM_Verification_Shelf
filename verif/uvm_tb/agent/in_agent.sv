class in_agent extends uvm_agent;
    `uvm_component_utils(in_agent)

    //=========constructor========//
    function new(string name = "in_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    in_driver       driver;     // driver handle
    in_monitor      monitor;    // monitor handle
    fifo_sequencer  sequencer;   // sequencer handle

    //=========build_phase========//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // create sequencer
        sequencer = fifo_sequencer::type_id::create("sequencer", this);
        // create driver
        driver = in_driver::type_id::create("driver", this);
        // create monitor
        monitor = in_monitor::type_id::create("monitor", this);
    endfunction

    //=========connect_phase========//
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction

endclass