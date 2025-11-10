module WritePtrHandler #(
    parameter ptr_width = 4
    )(
    input wr_clk,
    input rst,
    input wr_en,
    input [ptr_width :0] g_rd_ptr_sync,
    output reg [ptr_width :0] g_wr_ptr,
    output reg [ptr_width :0] b_wr_ptr,
    output reg full
    ,output [ptr_width : 0] b_wr_ptr_test
    ,output [ptr_width : 0] g_wr_ptr_test
    ,output [ptr_width : 0] b_wr_ptr_next_test
    ,output [ptr_width : 0] g_wr_ptr_next_test
    ,output wfull_test
    );
    wire [ptr_width : 0] b_wr_ptr_next;
    wire [ptr_width : 0] g_wr_ptr_next;
    wire wfull;
    assign wfull_test = wfull;
    assign b_wr_ptr_test = b_wr_ptr;
    assign g_wr_ptr_test = g_wr_ptr;
    assign b_wr_ptr_next_test = b_wr_ptr_next;
    assign g_wr_ptr_next_test = g_wr_ptr_next;
    initial begin
        b_wr_ptr <= 0;
        g_wr_ptr <= 0;
        full = 0;
    end

    assign b_wr_ptr_next = b_wr_ptr + (wr_en && !full); 
    assign g_wr_ptr_next = (b_wr_ptr_next >> 1) ^ b_wr_ptr_next;
    always @(posedge wr_clk or posedge rst) begin
        if(rst) begin
            b_wr_ptr <= 0;
            g_wr_ptr <= 0;
            full <= 0;
        end
        else begin
            b_wr_ptr <= b_wr_ptr_next;
            g_wr_ptr <= g_wr_ptr_next;
        end
    end
    always @(posedge wr_clk or posedge rst) begin
        if(rst) begin
            full <= 0;
        end
        else begin
            full <= wfull;
        end
    end
    assign wfull = (g_wr_ptr_next == {~g_rd_ptr_sync[ptr_width : ptr_width - 1],g_rd_ptr_sync[ptr_width-2:0]});
endmodule