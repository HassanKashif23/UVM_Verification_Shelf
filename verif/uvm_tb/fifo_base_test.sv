//============ FIFO base test ============

class fifo_base_test extends uvm_test;
    `uvm_component_utils(fifo_base_test)

    //Constructor
    function new(string name = "fifo_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    //component handles
    fifo_env                env;
    common_config           com_cfg;
    fifo_config             cfg;
    // virtual interface
    virtual fifo_intf        fifo_vif;

    // Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        com_cfg = common_config::type_id::create("common_config",this);
        cfg = fifo_config::type_id::create("fifo_config", this);

        uvm_config_db#(common_config)::set(null, "*", "com_cfg", com_cfg);
        uvm_config_db#(fifo_config)::set(null, "*", "cfg", cfg);
        //creating environment object
        env = fifo_env::type_id::create("env",this);
        //get virtual interface
        if(!uvm_config_db #(virtual fifo_intf)::get(this, "", "vif", fifo_vif))
            `uvm_fatal("TEST", "Virtual interface not found")
        
    endfunction

    // Main phase
    virtual task main_phase(uvm_phase phase);
        fifo_sequence seq;
        phase.raise_objection(this);
        `uvm_info("TEST", $sformatf("Starting main phase"), UVM_MEDIUM)
        super.main_phase(phase);
        fifo_vif.rst <= 1'b0;
        //Start the sequence
        seq = fifo_sequence::type_id::create("seq");
        seq.start(env.fifo_in_agent.sequencer);
        // Wait for sequence to complete
        //#5000;

        `uvm_info("TEST", $sformatf("Main phase completed"), UVM_MEDIUM)
        phase.drop_objection(this);
    endtask

    // reset phase
    virtual task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("TEST", $sformatf("Starting reset phase"), UVM_MEDIUM)
        super.reset_phase(phase);
        vif_init_zero();
        `uvm_info("TEST", $sformatf("Reset phase completed"), UVM_MEDIUM)
        repeat(100) @(posedge fifo_vif.clk);
        phase.drop_objection(this);
    endtask

    task vif_init_zero();
        fifo_vif.rst   <= 1'b1;
        fifo_vif.wr_en <= 1'b0;
        fifo_vif.rd_en <= 1'b0;
        fifo_vif.wr_data <= '0;
    endtask

endclass

