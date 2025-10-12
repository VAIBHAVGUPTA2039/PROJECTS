module Counter_usingVIO(
	input clk,
	input rst,
	output reg [7:0] count
);
	always @(posedge clk) begin
		if(rst) begin
			count <= 0;
		end
		else
			count <= count + 1;
	end
endmodule
