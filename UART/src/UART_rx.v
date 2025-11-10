module UART_rx #(
    parameter DATA_WIDTH = 8,
    parameter baud_rate = 9600
    )(
    input clk,
    input rst,
    input rx,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg rx_valid
    ,output internal_baud_test
    ,output [26:0] baud_counter_test
    ,output [DATA_WIDTH-1:0] data_rx_test
    ,output [$clog2(DATA_WIDTH) : 0]data_counter_test
);
    localparam counter = 100000000/baud_rate;
    reg internal_baud;
    reg recieving;
    reg [26:0] baud_counter;
    reg [DATA_WIDTH-1:0] data_rx;
    reg [$clog2(DATA_WIDTH) : 0]data_counter;
    assign data_rx_test = data_rx;
    assign internal_baud_test = internal_baud;
    assign data_counter_test = data_counter;
    assign baud_counter_test = baud_counter;
    initial begin
        data_counter <= 0;
        data_rx <= 0;
        data_out <= 0;
        baud_counter <= 0;
        internal_baud <= 0;
    end
    always @(posedge clk or posedge rst) begin
        if(baud_counter == counter/2) begin
            internal_baud <= 1;
            baud_counter <= baud_counter + 1;
        end
        else if(baud_counter == counter) begin
            baud_counter <= 0;
        end
        else if(rx == 0 || recieving == 1) begin
            if(data_counter == 0) recieving <= 1;
            internal_baud <= 0;
            baud_counter <= baud_counter + 1;
        end
        
    end
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            data_counter <= 0;
            data_out <= 0;
            rx_valid <= 0;
            data_rx <= 0;
            baud_counter <= 0;
            internal_baud <= 0;
        end
        else begin
            if(internal_baud) begin
                if(data_counter == 0 && rx == 0) begin
                    data_counter <= data_counter + 1; 
                end
                if(data_counter != 0) begin
                    if(data_counter == DATA_WIDTH + 1) begin
                        rx_valid <= 1;
                        recieving <= 0;
                        data_counter <= 0;
                        data_out <= data_rx;
                        baud_counter <= 0;
                    end
                    else begin
                        data_rx <= {rx,data_rx[DATA_WIDTH-1:1]};
                        data_counter <= data_counter + 1;
                    end
                end
            end
        end
    end
endmodule
