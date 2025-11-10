module AsynchronousFIFO_tb;
    localparam DATA_WIDTH = 8;
    localparam FIFO_Depth = 16;
    localparam ptr_width = $clog2(FIFO_Depth);

    reg rd_clk;
    reg wr_clk;
    reg wr_en, rd_en, r_rst, w_rst;
    reg [DATA_WIDTH - 1:0] d_in;
    wire [DATA_WIDTH - 1:0] d_out;
    wire full, empty;
    wire [23:0] mem_test;
    wire wempty_test, wfull_test;
    wire [ptr_width : 0] b_rd_ptr_test;
    wire [ptr_width : 0] g_rd_ptr_test;
    wire [ptr_width : 0] b_rd_ptr_next_test;
    wire [ptr_width : 0] g_rd_ptr_next_test;
    wire [ptr_width : 0] b_wr_ptr_test;
    wire [ptr_width : 0] g_wr_ptr_test;
    wire [ptr_width : 0] b_wr_ptr_next_test;
    wire [ptr_width : 0] g_wr_ptr_next_test;
    wire [ptr_width : 0] g_rd_ptr_sync;
    wire [ptr_width : 0] g_wr_ptr_sync;

    // Clock generation
    always #20 rd_clk <= ~rd_clk; // 25 MHz
    always #5  wr_clk <= ~wr_clk; // 100 MHz

    // Instantiate FIFO
    AsynchronousFIFO #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_Depth(FIFO_Depth),
        .ptr_width(ptr_width)
    ) uut (
        d_in,
        rd_clk,
        wr_clk,
        rd_en,
        wr_en,
        w_rst,
        r_rst,
        d_out,
        full,
        empty,
        mem_test,
        b_rd_ptr_test, g_rd_ptr_test, b_rd_ptr_next_test, g_rd_ptr_next_test,
        b_wr_ptr_test, g_wr_ptr_test, b_wr_ptr_next_test, g_wr_ptr_next_test,
        wfull_test, wempty_test,
        g_rd_ptr_sync, g_wr_ptr_sync
    );

    integer i;

    initial begin
        // Init
        rd_clk = 0;
        wr_clk = 0;
        r_rst  = 1;
        w_rst  = 1;
        wr_en  = 0;
        rd_en  = 0;
        d_in   = 0;

        // Release reset
        #40;
        r_rst = 0;
        w_rst = 0;

        // --------- TEST SEQUENCE ---------

        // Burst write 5 values
        wr_en = 1;
        for (i = 0; i < 5; i = i + 1) begin
            d_in = i;
            #(10); // wait 2 wr_clk cycles
        end
        wr_en = 0;

        // Wait a bit, then read 3 values
        #80; // 2 rd_clk cycles
        rd_en = 1;
        #(40*3); // read 3 items
        rd_en = 0;

        // Burst write 8 more values
        #20;
        wr_en = 1;
        for (i = 5; i < 13; i = i + 1) begin
            d_in = i;
            #(10);
        end
        wr_en = 0;

        // Read everything until empty
        #80;
        rd_en = 1;
        while (!empty) begin
            #(40);
        end
        rd_en = 0;

        // Fill FIFO fully
        wr_en = 1;
        for (i = 100; i < 100 + FIFO_Depth; i = i + 1) begin
            d_in = i;
            #(10);
        end
        wr_en = 0;

        // Read half FIFO
        #60;
        rd_en = 1;
        #(40*(FIFO_Depth/2));
        rd_en = 0;

        // Write more while reading (overlap)
        #20;
        wr_en = 1;
        for (i = 200; i < 204; i = i + 1) begin
            d_in = i;
            #(10);
        end
        wr_en = 0;

        rd_en = 1;
        #(40*(FIFO_Depth/2 + 4)); // read remaining + new
        rd_en = 0;

        // Done
        #100;
        $finish;
    end

endmodule
