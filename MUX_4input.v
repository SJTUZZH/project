module MUX_4input(A_in, B_in,C_in,D_in ,s0,s1, mux_out);
input [31:0] A_in, B_in,C_in,D_in;
input s0,s1;//s1 is Branch,s0 is Jump
            //10&11:Branch.  01:Jump   00:PC+4
output reg [31:0] mux_out;

always @ (*) begin
if (s0==1'b0&&s1==1'b0) begin
mux_out <= A_in;
end 
else if(s0==1'b1&&s1==1'b0)begin
mux_out <= B_in;
end
else if(s0==1'b0&&s1==1'b1)begin
mux_out<=C_in;
end
else begin
mux_out<=D_in;
end
end
endmodule