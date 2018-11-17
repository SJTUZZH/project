`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/14 23:10:41
// Design Name: 
// Module Name: testbench3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench3;
    reg clock;
    
    wire [31:0] PCout_IF,IM_IF,comparator_result,ALUresult,write_data_WB,comparatorinput1,comparatorinput2;
    wire comparator_zero,ALUzero,Branch1_ID,Branch2_ID,Branch_ID;
    wire [4:0]write_register_WB;
    
    
    top3_new UUT (clock,PCout_IF,IM_IF,comparator_result,comparator_zero,ALUresult,ALUzero,
    Branch1_ID,Branch2_ID,Branch_ID, write_register_WB,write_data_WB,comparatorinput1,comparatorinput2);

    initial begin
        #0 clock=0;
    end
    always #10 clock=~clock;
    initial #100000 $stop;
endmodule


