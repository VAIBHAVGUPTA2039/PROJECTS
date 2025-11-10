module FIFOmem #(
    parameter DEPTH = 16,
    parameter DATA_WIDTH = 8,
    parameter ptr_width = 4
    )(
    input rd_clk,
    input wr_clk,
    input [DATA_WIDTH-1:0] d_in,
    input full,
    input empty,
    input wr_en,
    input rd_en,
    input [ptr_width-1 : 0] rd_ptr,
    input [ptr_width-1 : 0] wr_ptr,
    output reg [DATA_WIDTH-1:0] d_out
    ,output [23:0] mem_test
    );
    reg [DATA_WIDTH - 1:0] mem [DEPTH - 1 : 0];
    assign mem_test = {mem[0],mem[1],mem[2]};
    always @(posedge wr_clk) begin
        if(wr_en && !full) begin
            mem[wr_ptr] <= d_in;
        end
    end
    always @(posedge rd_clk) begin
        if(rd_en && !empty) begin
            d_out <= mem[rd_ptr];
        end
    end
endmodule