module testbench;
	reg [3:0] a;
	reg [3:0] b;
	reg c_in;
	wire [3:0] sum;
	wire c_out;
	4_bit_full_adder FA1(a,b,c_in,sum,c_out);
	initial begin
		$fsdbDumpfile("sim/4_bit_full_adder.fsdb");
		$fsdbDumpvars();
		a = 4'h0; b = 4'h0; c_in = 1'b0;
		#5 a = 4'h0; b = 4'h1; c_in = 1'b1;
		#5 a = 4'hA; b = 4'h8; c_in= 1'b0;
		#5 a = 4'h5; b = 4'hE; c_in= 1'b0;
		#5 $finish;
	end
endmodule
