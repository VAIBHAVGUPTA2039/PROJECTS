module UART_tx_tb;
    reg clk, rst, tx_start;
    reg [7:0] data_in;
    wire tx, busy;
    wire [7:0] data_test;
    wire [3:0] data_counter_test;
    wire [26:0] baud_counter_tx_test;
    wire internal_baud_tx_test;

    // Instantiate transmitter
    UART_tx #(.DATA_WIDTH(8)) TX (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .data_in(data_in),
        .tx(tx),
        .busy(busy),
        .internal_baud_tx_test(internal_baud_tx_test),
        .baud_counter_tx_test(baud_counter_tx_test),
        .data_test(data_test),
        .data_counter_test(data_counter_test) 
    );

    // Clock generation: 100 MHz
    initial clk = 0;
    always #5 clk = ~clk;  // 10 ns period

    // UART parameters
    parameter BAUD = 9600;
    parameter CLK_FREQ = 100_000_0000;
    parameter BIT_PERIOD = CLK_FREQ / BAUD; // clocks per bit

    initial begin
        // Initialize signals
        rst = 1;
        tx_start = 0;
        data_in = 8'h00;
        #100;
        rst = 0;
        #100;

        // Send first byte
        data_in = 8'hA5;  // 10100101
        tx_start = 1;
        #10;
        tx_start = 0;     // pulse tx_start for 1 clock

        // Wait for TX to finish
        #(BIT_PERIOD*10);  // start + 8 data bits + stop

        // Send second byte
        data_in = 8'h3C;  // 00111100
        tx_start = 1;
        #10;
        tx_start = 0;

        #(BIT_PERIOD*12);

        $finish;
    end
endmodule
