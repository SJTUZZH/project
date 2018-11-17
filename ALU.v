`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/14 23:11:56
// Design Name: 
// Module Name: ALU
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


module ALU (a,b,ALUcontrol,ALUresult,zero);
    input signed [31:0]a;
    input signed [31:0]b;
    input [3:0]ALUcontrol;//this is the 4-bit output of ALU control
    output signed  [31:0]ALUresult;
    output zero;
    //output set;
    //output overflow;
    //reg [31:0]ALUresult;
    reg [32:0]result;//[31:0] represents ALUresult, [32] represents overflow
    
    initial begin 
    //ALUresult=32'b0;
    result=33'b0;
    end
    
    parameter add=4'b0010;//add,addi,sw,lw
    //parameter addi=4'b0010;
    parameter sub=4'b0110;//sub,beq,bne
    parameter AND=4'b0000;//AND,ANDi
    //parameter ANDi=4'b0000;
    parameter OR=4'b0001;//OR
    parameter slt=4'b0111;//slt
    //parameter lw=4'b0010;
    //parameter sw=4'b0010;
    //parameter beq=4'b0110;
    //parameter bne=4'b0110;
    parameter j=4'b1111;//j
    
  
    
    always@(a,b,ALUcontrol)begin
        case(ALUcontrol)
            add:begin result<=a+b; end
            //addi:begin result=a+b; end
            sub:begin result<=a-b; end
            AND:begin result<=a&b; end
            //ANDi:begin result=a&b; end
            OR:begin result<=a|b; end
            slt:begin result<=(a<b)?1:0; end
            //lw:begin result=a+b; end
            //sw:begin result=a+b; end
            //beq:begin result=a-b; end    
            //bne:begin result=a-b; end
            j:begin end      
            default: ;
        endcase   
    end    
    
    assign ALUresult=result[31:0];
    //assign overflow=result[32];
    //assign set=result[31];
    assign zero=(ALUresult==32'b0)?1:0;
    //carry=result[32]??
    
 endmodule
    
