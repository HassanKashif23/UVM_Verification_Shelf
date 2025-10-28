//===========Driver==========//

class in_driver extends uvm_driver #(fifo_seq_item);
    `uvm_component_utils(in_driver)

    //======Constructor======//
    function new(string name = "in_driver" , uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual fifo_intf       vif;
    fifo_seq_item           seq_item;

    //========Build phase method=======//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seq_item = fifo_seq_item::type_id::create("seq_item",this);
        if(!uvm_config_db#(virtual fifo_intf)::get(this, " ", "vif",vif))
            `uvm_fatal("Input driver","Could not get vif")
    endfunction

    //=============Main phase method===========//
    virtual task main_phase(uvm_phase phase);
        super.main_phase(phase);
        forever begin
            seq_item_port.get_next_item(seq_item);
            drive_item(seq_item);
            seq_item_port.item_done();        
        end
    endtask

    //=========Drive item==============//
    virtual task drive_item(fifo_seq_item seq_item);
        vif.wr_data <= seq_item.wr_data;
        vif.wr_en <= seq_item.wr_en;
        vif.rd_en <= seq_item.rd_en;
        @(posedge vif.clk);
        `uvm_info("DRIVER", $sformatf("Driven: wr_en=%0d, rd_en=%0d, data=0x%0h", 
              seq_item.wr_en, seq_item.rd_en, seq_item.wr_data), UVM_MEDIUM)
    endtask


endclass