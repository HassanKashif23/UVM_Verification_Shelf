//===========Environment class=============

class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)


    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Internal signals and handles
    in_agent            fifo_in_agent;
    scoreboard          fifo_scoreboard;
    common_config       com_cfg;
    int                 wd_timer;
    uvm_event           scb_event;

    // Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Creating components
        fifo_in_agent = in_agent::type_id::create("fifo_in_agent", this);
        fifo_scoreboard = scoreboard::type_id::create("fifo_scoreboard", this);
        scb_event = uvm_event_pool::get_global("scb_event");
        uvm_config_db#(common_config)::get(this, "*", "com_cfg", com_cfg);
    endfunction

    // Connect phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // connecting analysis port to scoreboard
        fifo_in_agent.monitor.mon_port.connect(fifo_scoreboard.mon_port);
    endfunction

    // Main phase
    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("ENV", "Environment main phase started", UVM_MEDIUM)
        super.main_phase(phase);
        wd_timer = com_cfg.watchdog_timer;

        // fork
        //     begin
        //         #wd_timer;
        //         `uvm_error("fifo_env", $sformatf("Watchdog timer timed out after %0d time units", wd_timer))
        //     end
        //     begin
        //         scb_event.wait_trigger();
        //         `uvm_info("ENV", "Scoreboard verification completed.", UVM_MEDIUM)
        //     end
        // join_any
        `uvm_info("ENV", "Environment main phase ended", UVM_MEDIUM);
        phase.drop_objection(this);
    endtask

endclass 