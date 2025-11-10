`include "full_adder_rtl.v"

module testbench;
	reg [3:0] A,B;
	reg Clock,C_in;
	wire [3:0] sum;
	wire C_out;
	full_adder dut (
		.A(A),
		.B(B),
		.Clock(Clock),
		.C_in(C_in),
		.sum(sum),
		.C_out(C_out)
		);
	always #5 Clock <= ~Clock;
	initial begin
		$fsdbDumpvars();
		A<=0 ; B<= 0; C_in<= 0; Clock <= 0;
		// Apply test cases
		#20 A <= 4'b0001; B <= 4'b0001; C_in <= 0; // 1 + 1 = 2 (binary: 10)
		$display("A = %b, B = %b, C_in = %b, SUM = %b, C_out = %b", A, B, C_in, sum, C_out);

		#20 A <= 4'b0110; B <= 4'b1010; C_in <= 1; // 6 + 10 + 1 = 17 (binary: 10001)
		$display("A = %b, B = %b, C_in = %b, SUM = %b, C_out = %b", A, B, C_in, sum, C_out);

		#20 A <= 4'b1000; B <= 4'b1111; C_in <= 1; // 8 + 15 + 1 = 24 (binary: 11000)
		$display("A = %b, B = %b, C_in = %b, SUM = %b, C_out = %b", A, B, C_in, sum, C_out);

		#100 $finish;
	end
endmodule
