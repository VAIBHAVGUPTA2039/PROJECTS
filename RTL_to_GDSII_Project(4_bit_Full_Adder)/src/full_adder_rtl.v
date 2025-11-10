module full_adder (A, B, C_in, Clock, C_out, sum); 
input [3:0] A, B;
input Clock, C_in;
output reg [3:0] sum;
output reg C_out;

reg [3:0] reg1, reg2, sum_i;
reg c_in, c_out;

always @ (posedge Clock)
        begin
                reg1 <= A;
                reg2 <= B;
		c_in <= C_in;
        end 

always @ (posedge Clock)
        begin
                sum <= sum_i;
                C_out <= c_out;
        end

always @ * 
        begin
                {c_out, sum_i} = reg1 + reg2 + c_in;   
        end 

endmodule
