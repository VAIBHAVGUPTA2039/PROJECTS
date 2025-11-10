module UART_tx #(
    parameter DATA_WIDTH = 8,
    parameter baud_rate = 9600
)(
    input clk,
    input rst,
    input tx_start,
    input [DATA_WIDTH-1:0] data_in,
    output reg  tx,
    output reg  busy
    ,output [26:0] baud_counter_tx_test
    ,output internal_baud_tx_test
    ,output [DATA_WIDTH - 1:0] data_test
    ,output [$clog2(DATA_WIDTH) : 0] data_counter_test
);
    localparam counter = 100000000/baud_rate;
    reg [$clog2(DATA_WIDTH) : 0] data_counter;
    reg [DATA_WIDTH-1:0] data;
    reg [26:0] baud_counter_tx;
    reg internal_baud_tx;
    assign internal_baud_tx_test = internal_baud_tx;
    assign baud_counter_tx_test = baud_counter_tx;
    assign data_test = data;
    assign data_counter_test = data_counter;
    initial begin
        tx <= 1;
        busy <= 0;
        data_counter <= 0;
        data <= 0;
        baud_counter_tx <= 0;
        internal_baud_tx <= 0;
    end
    always @(posedge clk or posedge rst) begin
        if(baud_counter_tx == counter) begin
            internal_baud_tx <= 1;
            baud_counter_tx <= 0;
        end
        else if(tx_start == 1 || busy == 1) begin
            internal_baud_tx <= 0;
            baud_counter_tx <= baud_counter_tx + 1;
        end
    end
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            tx <= 1;
            busy <= 0;
            data_counter <= 0;
            baud_counter_tx <= 0;
            internal_baud_tx <= 0;
        end
        else if(tx_start) begin
            data_counter <= data_counter + 1;
            tx <= 0;
            data <= data_in;
            busy <= 1;
        end
        else if(internal_baud_tx && busy) begin
            if(data_counter == DATA_WIDTH + 1) begin
                tx <= 1;
                data_counter <= 0;
                busy <= 0;
                baud_counter_tx <= 0;
                internal_baud_tx <= 0;
            end
            else begin
                tx <= data[0];
                data <= {1'b0,data[DATA_WIDTH-1:1]};
                data_counter <= data_counter + 1;
           end
        end
    end
endmodule
