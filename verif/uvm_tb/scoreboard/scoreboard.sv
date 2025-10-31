//=========== Scoreboard ===========//

class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    //============Implmentation ports===========//
    uvm_analysis_imp #(fifo_seq_item, scoreboard) mon_port;

    //=========== Constructor ===========//
    function new(string name = "scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    fifo_seq_item       fifo_item[$];    // dynamic array to store fifo items
    uvm_event           data_event;     // event to indicate data arrival
    common_config       cfg;
    fifo_seq_item       expected_item;
    int                 match,mismatch;

    //=========== Build Phase ===========//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_port = new("monitor", this);
        data_event = uvm_event_pool::get_global("scoreboard in event");
        // getting common configuration
        if(!uvm_config_db #(common_config)::get(this, "*", "com_cfg", cfg))
            `uvm_error("SCOREBOARD", "Failed to get common_config")
    endfunction

    //============ write function to push expected data ============//
    virtual function void write(fifo_seq_item item);
        fifo_seq_item     fifo_seq = new();
        if(item.wr_en && !item.full) begin
            // store data for comparison
            fifo_item.push_back(item);
            `uvm_info("SCOREBOARD", $sformatf("Stored: data=0x%0h",item.wr_data), UVM_MEDIUM)
        end else if (item.rd_en && !item.empty) begin
            // Check read data against expected
            if (fifo_item.size()>0) begin
                expected_item = fifo_item.pop_front();
                if (item.rd_data == expected_item.wr_data) begin
                    `uvm_info("SCOREBOARD", $sformatf("Pass: Read 0x%0h, Expected 0x%0h", item.rd_data, expected_item.wr_data), UVM_MEDIUM)
                    match++;
                end else begin
                    `uvm_info("SCOREBOARD", $sformatf("FAIL: Read 0x%0h, Expected 0x%0h", item.rd_data, expected_item.wr_data), UVM_MEDIUM)
                    mismatch++;
            end
            end else begin
                `uvm_error("SCOREBOARD ERROR", "No expected data available for comparison");
            end
        end
    endfunction

    //=========== Main Phase ===========//
    // virtual task main_phase(uvm_phase phase);
    //     super.main_phase(phase);
    //     wait(cfg.num_items == (match + mismatch));
    //     data_event.trigger();
    // endtask

    virtual function void report_phase(uvm_phase phase);
        `uvm_info("SCOREBOARD INFO", $sformatf("Total Matches: %0d, Mismatches: %0d", match,mismatch), UVM_MEDIUM);
    endfunction

    virtual function void display_mismatches(fifo_seq_item expected_item, fifo_seq_item item);
        string msg;
        msg = $sformatf("\nMismatch item: Expected data = %0d, Actual data = %0d\n",expected_item.rd_data, item.rd_data);
        msg = {msg, $sformatf("====================================================\n")};
        `uvm_error("SCOREBOARD MISMATCH", msg);
    endfunction

endclass