//===========Input monitor=========//

class in_monitor extends uvm_monitor;
    `uvm_component_utils(in_monitor)

    //========constructor method========//
    function new (string name = "in_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Analysis port to send observed transactions
    uvm_analysis_port #(fifo_seq_item) mon_port;
    //virtual interface to connect to the dut
    virtual fifo_intf        vif;
    //sequence item to hold data
    fifo_seq_item           seq_item;

    //===============build phase method==========//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_intf)::get(this, "" , "vif", vif))
            `uvm_fatal("Input monitor", "Cannot get fifo_int from uvm config db");
            mon_port = new("monitor analysis port", this);
    endfunction

    //===========main phase method============//
    virtual task main_phase(uvm_phase phase);
        super.main_phase(phase);
        collect_data();
    endtask

    //===========data collection method========//
    virtual task collect_data();
        forever begin
            @(posedge vif.clk);
            seq_item = fifo_seq_item::type_id::create("input monitor");
            if(!vif.full && vif.wr_en) begin
                seq_item.wr_data = vif.wr_data;
                seq_item.rd_en   = vif.rd_en;
                seq_item.wr_en   = vif.wr_en;
                seq_item.full    = vif.full;
                seq_item.empty   = vif.empty;
                `uvm_info("MONITOR", $sformatf("Captured WRITE: data=0x%0h, full=%0d, empty=%0d", 
                      vif.wr_data, vif.full, vif.empty), UVM_MEDIUM)
                // send the collected data to the analysis port
                mon_port.write(seq_item);
            end else if (vif.rd_en && !vif.empty) begin
                seq_item.rd_data = vif.rd_data;
                seq_item.rd_en   = vif.rd_en;
                seq_item.wr_en   = vif.wr_en;
                seq_item.full    = vif.full;
                seq_item.empty   = vif.empty;
                `uvm_info("MONITOR", $sformatf("Captured READ: data=0x%0h, full=%0d, empty=%0d", 
                      vif.rd_data, vif.full, vif.empty), UVM_MEDIUM)
                // send the collected data to the analysis port
                mon_port.write(seq_item);
            end
        end
    endtask


endclass