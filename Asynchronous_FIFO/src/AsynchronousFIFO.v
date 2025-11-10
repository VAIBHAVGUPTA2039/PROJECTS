module AsynchronousFIFO #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_Depth = 16,
    parameter ptr_width = $clog2(FIFO_Depth)
    )(
    input [DATA_WIDTH - 1: 0] d_in,
    input rd_clk,wr_clk,
    input rd_en,wr_en,
    input w_rst,r_rst,
    output [DATA_WIDTH - 1 : 0] d_out,
    output full,empty
    ,output [23:0] mem_test
    ,output [ptr_width : 0] b_rd_ptr_test
    ,output [ptr_width : 0] g_rd_ptr_test
    ,output [ptr_width : 0] b_rd_ptr_next_test
    ,output [ptr_width : 0] g_rd_ptr_next_test
    ,output [ptr_width : 0] b_wr_ptr_test
    ,output [ptr_width : 0] g_wr_ptr_test
    ,output [ptr_width : 0] b_wr_ptr_next_test
    ,output [ptr_width : 0] g_wr_ptr_next_test
    ,output wfull_test
    ,output wempty_test
    ,output wire [ptr_width : 0] g_rd_ptr_sync_test
    ,output wire [ptr_width : 0] g_wr_ptr_sync_test
    );
//    localparam ptr_width = $clog2(FIFO_Depth);
    wire [ptr_width : 0] g_rd_ptr_sync;
    wire [ptr_width : 0] g_wr_ptr_sync;
    
    assign g_rd_ptr_sync_test = g_rd_ptr_sync;
    assign g_wr_ptr_sync_test = g_wr_ptr_sync;
    wire [ptr_width : 0] g_wr_ptr;
    wire [ptr_width : 0] b_wr_ptr;
    wire [ptr_width : 0] g_rd_ptr;
    wire [ptr_width : 0] b_rd_ptr;
    TwoFFSynchronizer #(
        .DATA_WIDTH(ptr_width)
        ) sync1(
        .clk(rd_clk),
        .rst(r_rst),
        .d_in(g_wr_ptr),
        .d_out(g_wr_ptr_sync)
        );
    TwoFFSynchronizer #(
        .DATA_WIDTH(ptr_width)
        ) sync2(
        .clk(wr_clk),
        .rst(w_rst),
        .d_in(g_rd_ptr),
        .d_out(g_rd_ptr_sync)
        );
    WritePtrHandler #(
        .ptr_width(ptr_width)
        ) WPH (
        .wr_clk(wr_clk),
        .rst(w_rst),
        .wr_en(wr_en),
        .g_rd_ptr_sync(g_rd_ptr_sync),
        .g_wr_ptr(g_wr_ptr),
        .b_wr_ptr(b_wr_ptr),
        .full(full)
        ,
        .b_wr_ptr_test(b_wr_ptr_test),
        .g_wr_ptr_test(g_wr_ptr_test),
        .b_wr_ptr_next_test(b_wr_ptr_next_test),
        .g_wr_ptr_next_test(g_wr_ptr_next_test),
        .wfull_test(wfull_test)
        );
     ReadPtrHandler #(
        .ptr_width(ptr_width)
        ) RPH (
        .rd_clk(rd_clk),
        .rst(r_rst),
        .rd_en(rd_en),
        .g_wr_ptr_sync(g_wr_ptr_sync),
        .g_rd_ptr(g_rd_ptr),
        .b_rd_ptr(b_rd_ptr),
        .empty(empty)
        ,
        .b_rd_ptr_test(b_rd_ptr_test),
        .g_rd_ptr_test(g_rd_ptr_test),
        .b_rd_ptr_next_test(b_rd_ptr_next_test),
        .g_rd_ptr_next_test(g_rd_ptr_next_test),
        .wempty_test(wempty_test)
        );
    FIFOmem #(
        .DEPTH(FIFO_Depth),
        .DATA_WIDTH(DATA_WIDTH),
        .ptr_width(ptr_width)
        ) FIFO (
            .rd_clk(rd_clk),
            .wr_clk(wr_clk),
            .d_in(d_in),
            .full(full),
            .empty(empty),
            .wr_en(wr_en),
            .rd_en(rd_en),
            .rd_ptr(b_rd_ptr[ptr_width-1:0]),
            .wr_ptr(b_wr_ptr[ptr_width-1:0]),
            .d_out(d_out)
            ,.mem_test(mem_test)
        );
     
endmodule