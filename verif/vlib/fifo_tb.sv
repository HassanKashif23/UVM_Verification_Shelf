//=======FIFO Top==============//

module fifo_tb;
    import uvm_pkg::*;
    import fifo_pkg::*;

    bit clk;

    // interface instance
    fifo_intf           intf (.clk(clk));

    // DUT instantiation
    fifo #(.DBIT(8), .DEPTH(8)) dut(
        .clk        (intf.clk),
        .rst        (intf.rst),
        .wr_en      (intf.wr_en),
        .rd_en      (intf.rd_en),
        .wr_data    (intf.wr_data),
        .rd_data    (intf.rd_data),
        .full       (intf.full),
        .empty      (intf.empty)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

    // UVM Testbench
    initial begin
        uvm_config_db #(virtual fifo_intf)::set(null,"*","vif",intf);
        run_test("simple_test");
    end

endmodule