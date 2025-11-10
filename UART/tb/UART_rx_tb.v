module UART_rx_tb;
    reg clk, rst, rx;
    wire [7:0] data_out;
    wire rx_valid;
    wire [7:0] data_rx_test;
    wire [3:0] data_counter_test;
    wire internal_baud_test;
    wire [26:0] baud_counter_test;
    // Instantiate UART RX
    UART_rx #(.DATA_WIDTH(8)) URX (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .data_out(data_out),
        .rx_valid(rx_valid),
        .internal_baud_test(internal_baud_test),
        .baud_counter_test(baud_counter_test),
        .data_rx_test(data_rx_test),
        .data_counter_test(data_counter_test)
    );

    // Clock generation: 100 MHz
    initial clk = 0;
    always #5 clk = ~clk;  // 10 ns period

    // UART parameters
    parameter BAUD = 9600;
    parameter CLK_FREQ = 100_000_0000;
    parameter BIT_PERIOD = CLK_FREQ / BAUD; // clocks per bit

    // Test sequence
    initial begin
        // Initialize
        rst = 1;
        rx = 1;  // idle high
        #100;
        rst = 0;
        #100;

        // Send a test byte, e.g., 0xA5 (10100101)
        send_uart_byte(8'hA5);

        // Wait for RX to finish
        send_uart_byte(8'h00);
        send_uart_byte(8'hFF);
        $finish;
    end

    // Task to send a byte on rx line
    task send_uart_byte(input [7:0] byte);
        integer i;
        begin
            // Start bit
            rx = 0;
            #(BIT_PERIOD);

            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx = byte[i];
                #(BIT_PERIOD);
            end

            // Stop bit
            rx = 1;
            #(BIT_PERIOD);
        end
    endtask

endmodule
