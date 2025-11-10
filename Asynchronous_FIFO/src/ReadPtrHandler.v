module ReadPtrHandler #(
    parameter ptr_width = 4
    )(
    input rd_clk,
    input rst,
    input rd_en,
    input [ptr_width :0] g_wr_ptr_sync,
    output reg [ptr_width :0] g_rd_ptr,
    output reg [ptr_width :0] b_rd_ptr,
    output reg empty
    ,output [ptr_width : 0] b_rd_ptr_test
    ,output [ptr_width : 0] g_rd_ptr_test
    ,output [ptr_width : 0] b_rd_ptr_next_test
    ,output [ptr_width : 0] g_rd_ptr_next_test
    ,output wempty_test
    );
    wire [ptr_width : 0] b_rd_ptr_next;
    wire [ptr_width : 0] g_rd_ptr_next;
    wire wempty;
    assign wempty_test = wempty;
    assign b_rd_ptr_test = b_rd_ptr;
    assign g_rd_ptr_test = g_rd_ptr;
    assign b_rd_ptr_next_test = b_rd_ptr_next;
    assign g_rd_ptr_next_test = g_rd_ptr_next;
    initial begin
        b_rd_ptr <= 0;
        g_rd_ptr <= 0;
        empty <= 0;
    end
    assign b_rd_ptr_next = b_rd_ptr + (rd_en && !empty); 
    assign g_rd_ptr_next = (b_rd_ptr_next >> 1) ^ b_rd_ptr_next;
    always @(posedge rd_clk or posedge rst) begin
        if(rst) begin
            b_rd_ptr <= 0;
            g_rd_ptr <= 0;
            empty <= 0;
        end
        else begin
            b_rd_ptr <= b_rd_ptr_next;
            g_rd_ptr <= g_rd_ptr_next;
        end
    end
    always @(posedge rd_clk or posedge rst) begin
        if(rst) begin
            empty <= 0;
        end
        else begin
            empty <= wempty;
        end
    end
    assign wempty = (g_rd_ptr_next == g_wr_ptr_sync);
endmodule