//=============FIFO SEQUENCE==================//

class fifo_sequence extends uvm_sequence #(fifo_seq_item);
    
    `uvm_object_utils(fifo_sequence)

    fifo_seq_item       seq_item;
    common_config   com_cfg;
    fifo_config        cfg;
    int            num_items;
    int            i;

    // Constructor
    function new(string name = "fifo_sequence");
        super.new(name);
    endfunction

    virtual task pre_start();
    if (!uvm_config_db#(fifo_config)::get(null, "", "cfg", cfg))
        `uvm_fatal("SEQ", "No fifo_config found!")
    if (!uvm_config_db#(common_config)::get(null, "", "com_cfg", com_cfg))  
        `uvm_fatal("SEQ", "No common_config found!")
    // ✅ CRITICAL: Get the num_items value FROM the config
    num_items = com_cfg.num_items;
    `uvm_info("SEQ_PRE_START", $sformatf("Got num_items=%0d from com_cfg", num_items), UVM_MEDIUM)
  endtask

  // Body task
  virtual task body();
     seq_item = fifo_seq_item::type_id::create("seq_item");
     `uvm_info("fifo_sequence", $sformatf(" Generating fifo items %0d", num_items), UVM_MEDIUM);

     // Phase 1: Write Operations (fill FIFO with 8 writes)
     for (i = 0; i < num_items/2 ; i++) begin
        start_item(seq_item);

        if (cfg.random_data) begin
          // Generate random data for write operation
            seq_item.wr_data = $urandom_range(0, 255);    
        end else begin
            seq_item.wr_data = 8'hA0+i;
        end

        seq_item.cfg = cfg;
        seq_item.rd_en   = 1'b0;
        seq_item.wr_en   = 1'b1;

        `uvm_info("fifo_sequence", $sformatf(" Sending fifo item %0d", i), UVM_MEDIUM);
        finish_item(seq_item);
        // USE CONFIG DELAYS
        if (cfg.max_wr_delay > 0)
            #($urandom_range(1, cfg.max_wr_delay));
     end
     #30;
       // Phase 2: Read Operations (empty FIFO with 8 reads)
       for (i = 0; i < num_items/2; i++) begin
         start_item(seq_item);
         seq_item.cfg = cfg;
         seq_item.wr_data = 8'h00; // No data for read operation
         seq_item.rd_en   = 1'b1;
         seq_item.wr_en   = 1'b0;
         `uvm_info("fifo_sequence", $sformatf(" Read %0d", i), UVM_MEDIUM);
         finish_item(seq_item);
         if (cfg.max_rd_delay > 0)            // ✅ Add this for reads too!
        #($urandom_range(1, cfg.max_rd_delay));
       end

     `uvm_info("fifo_sequence", $sformatf("FIFO Sequence of %0d items Completed",i ),UVM_MEDIUM);
  endtask

endclass