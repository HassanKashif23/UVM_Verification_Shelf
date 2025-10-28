//=============FIFO SEQUENCE==================//

class fifo_sequence extends uvm_sequence #(fifo_seq_item);
    
    `uvm_object_utils(fifo_sequence)

    fifo_seq_item       seq_item;
    fifo_config        cfg;
    int            num_items = 16;
    int            i;

    // Constructor
    function new(string name = "fifo_sequence");
        super.new(name);
    endfunction

  //   virtual task pre_start();
  //   if (!uvm_config_db#(fifo_config)::get(get_sequencer(), "", "fifo_cfg", cfg))
  //     `uvm_fatal("complex_sequence", "Did not get complex Config")
  // endtask

  // Body task
  virtual task body();
     seq_item = fifo_seq_item::type_id::create("seq_item");
     `uvm_info("fifo_sequence", $sformatf(" Generating fifo items 8 writes and 8 reads"), UVM_MEDIUM);
     // Phase 1: Write Operations (fill FIFO with 8 writes)
     for (i = 0; i < num_items/2 ; i++) begin
        start_item(seq_item);
        //  if(!comp.randomize()) `uvm_fatal("complex_sequence", "comp Randomization Failed");
        seq_item.cfg = cfg;
        seq_item.wr_data = 8'hA0+i;
        seq_item.rd_en   = 1'b0;
        seq_item.wr_en   = 1'b1;

        // if (cfg.randomize) begin
        //     seq_item.wr_data = $urandom_range(0, 255);
        //     seq_item.rd_en   = 1'b0;
        //     seq_item.wr_en   = 1'b1;
        // end else begin
        //     seq_item.wr_data = cfg.wr_data;
        //     seq_item.rd_en   = cfg.rd_en;
        //     seq_item.wr_en   = cfg.wr_en;
        // end

        `uvm_info("fifo_sequence", $sformatf(" Sending fifo item %0d", i), UVM_MEDIUM);
        finish_item(seq_item);
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
       end

     `uvm_info("fifo_sequence", $sformatf("FIFO Sequence of %0d items Completed",i ),UVM_MEDIUM);
  endtask

endclass