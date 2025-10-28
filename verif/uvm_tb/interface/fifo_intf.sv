interface fifo_intf #(parameter DBIT = 8, parameter DEPTH = 8)(input logic clk);

    logic              wr_en;
    logic              rd_en;
    logic [DBIT-1:0]   wr_data;
    logic [DBIT-1:0]   rd_data;
    logic              full;
    logic              empty;
    logic              rst;
    
endinterface 