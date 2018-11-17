`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/15 17:45:13
// Design Name: 
// Module Name: Hazard_Detection
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


module Hazard_Detection(MemRead_EX,MemRead_MEM,RegWrite_EX,Branch,rs_ID,rt_ID,rt_EX,rd_EX, rd_MEM,IFID_flush,IDEX_flush,nop);
input MemRead_EX,MemRead_MEM,RegWrite_EX;
input Branch;
input [4:0]rs_ID,rt_ID,rt_EX,rd_EX, rd_MEM;          
output reg IFID_flush,IDEX_flush,nop;

initial begin 
nop=1'b0;
IFID_flush=1'b0;
IDEX_flush=1'b0;
end



 //load-use hazard detection
always@(*) begin
if(Branch==1'b1) begin 
    IFID_flush=1'b1;
    if (((RegWrite_EX==1'b1)&&(rd_EX)&&((rd_EX==rs_ID)||(rd_EX==rt_ID)))||
    (((MemRead_MEM==1'b1)||(MemRead_EX==1'b1))&&(rd_MEM)&&((rd_MEM==rs_ID)||(rd_MEM==rt_ID))))begin//1st preceding ALU or 2nd preceding load or 1str precding load
        nop=1'b1;IDEX_flush=1'b1;
    end
    else begin nop=1'b0;IDEX_flush=1'b0;end
 end
 
 else begin
    IFID_flush=1'b0;
    if((MemRead_EX==1'b1)&&( (rt_EX==rs_ID)||(rt_EX==rt_ID) )) begin
        nop=1'b1;IDEX_flush=1'b1;
    end
    else begin nop=1'b0;IDEX_flush=1'b0;end
 end
 end


endmodule

        





