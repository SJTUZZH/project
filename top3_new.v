`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/16 16:38:42
// Design Name: 
// Module Name: top3_new
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


module top3_new(clk,PCout_IF,IM_IF,comparator_result,comparator_zero,ALUresult,ALUzero,
Branch1_ID,Branch2_ID,Branch_ID, write_register_WB,write_data_WB,
comparatorinput1,comparatorinput2);
input clk;

output [31:0]PCout_IF,IM_IF,comparator_result,ALUresult,comparatorinput1,comparatorinput2;
output comparator_zero,ALUzero,Branch1_ID,Branch2_ID,Branch_ID;
output[4:0] write_register_WB;
output [31:0]write_data_WB;





wire[31:0]PCadd4_IF,PCadd4_ID,j_address_after_ID,branchaddr_ID;
wire[31:0]PCin_IF,PCout_IF;
wire[31:0]IM_IF,IM_ID;

wire[5:0]op_ID;
wire[4:0]rs_ID,rt_ID,rd_ID;
wire[16:0]const_address_ID;
wire[26:0]j_address_before_ID;
assign op_ID=IM_ID[31:26];
assign rs_ID=IM_ID[25:21];
assign rt_ID=IM_ID[20:16];
assign rd_ID=IM_ID[15:11];
assign const_address_ID=IM_ID[15:0];
assign j_address_before_ID=IM_ID[25:0];

wire [1:0] ForwardA,ForwardB;
wire Forward_BranchA,Forward_BranchB;
wire[1:0]ALUop_ID;
wire[3:0]ALUcontrol;
wire ALUSrc_ID,RegDst_ID,Branch1_ID,Branch2_ID,MemWrite_ID,MemRead_ID,MemToReg_ID,RegWrite_ID,Jump_ID,Branch_ID;


wire[31:0]out32_ID,branchshift_out,RFout1,RFout2,PCadd4_EX,data1_EX,data2_EX,out32_EX,ALUresult,ALU_b;
wire[31:0]ALUinput1,ALUinput2,comparatorinput1,comparatorinput2;
wire[4:0]write_register_EX,write_register_MEM,write_register_WB;

wire[31:0]comparator_result; wire comparator_zero,ALUzero;

wire[1:0]ALUop_EX;
wire ALUSrc_EX,RegDst_EX;
wire MemWrite_EX,MemWrite_MEM,MemRead_EX,MemRead_MEM;
wire MemToReg_EX,MemToReg_MEM,MemToReg_WB,RegWrite_EX,RegWrite_MEM,RegWrite_WB;
wire[4:0]rs_EX,rt_EX,rd_EX,rs_MEM,rt_MEM,rd_MEM,rs_WB,rt_WB,rd_WB;

wire[31:0]DMreaddata,DMwritedata,Read_Data_WB,ALUresult_MEM,ALUresult_WB,write_data_WB;
wire nop,IDEX_flush,IFID_flush;

assign Branch_ID=(Branch1_ID&&comparator_zero)||(Branch2_ID&&(~comparator_zero));

MUX_4input MUX_IF1(
    .A_in(PCadd4_IF),//from add_IF1
    .B_in(j_address_after_ID),//from Jump1
    .C_in(branchaddr_ID),//from add_ID1
    .D_in(branchaddr_ID),//from add_ID1
    .s0(Jump_ID),
    .s1(Branch_ID),
    .mux_out(PCin_IF)
);

PC PC1(
    .clk(clk),
    .nop(nop),//////////////////////
    .in(PCin_IF),//from MUX_IF1
    .out(PCout_IF)
);


add add_IF1(
    .a(PCout_IF),//from PC1
    .b(32'b00000000000000000000000000000100),
    .c_in(32'b0),
    .sum(PCadd4_IF)
 );

IMem IMem1(
    .pcaddress(PCout_IF),//from PC1
    .out(IM_IF)
);


IF_ID IF_ID1(
    .clk(clk),
    .nop(nop),////////////////////////////////
    //.flush(1'b0),
    //.flush(Branch_ID),/////////////////////////////
    .flush(IFID_flush),//////////////////////////////
    .PCadd4_IF(PCadd4_IF),//from add_IF1
    .IM_IF(IM_IF),//from IM1
    .PCadd4_ID(PCadd4_ID),
    .IM_ID(IM_ID)
 );
 
 
 
 Hazard_Detection Hazard_Detection1(
    .MemRead_EX(MemRead_EX),
    .MemRead_MEM(MemRead_MEM),
    .RegWrite_EX(RegWrite_EX),
    .Branch(Branch_ID),
    .rs_ID(rs_ID),
    .rt_ID(rt_ID),
    .rt_EX(rt_EX),
    .rd_EX(rd_EX),
    .rd_MEM(rd_MEM),
    .IFID_flush(IFID_flush),
    .IDEX_flush(IDEX_flush),
    .nop(nop)
 );
 
 
 Forwarding Forwarding1(
     .rs_ID(rs_ID),
     .rt_ID(rt_ID),
     .rs_EX(rs_EX),
     .rt_EX(rt_EX),
     .rd_MEM(rd_MEM),
     .rd_WB(rd_WB),
     .ForwardA(ForwardA),
     .ForwardB(ForwardB),
     .Forward_BranchA(Forward_BranchA),
     .Forward_BranchB(Forward_BranchB)
 );



Control_ID Control1(
    .op(op_ID),
    .AluSrc(ALUSrc_ID),
    .AluOp(ALUop_ID),
    .RegDst(RegDst_ID),
    .Branch1(Branch1_ID),
    .Branch2(Branch2_ID),
    .MemWrite(MemWrite_ID),
    .MemRead(MemRead_ID),
    .MemtoReg(MemToReg_ID),
    .RegWrite(RegWrite_ID),
    .Jump(Jump_ID)
 );
 
 
Jump Jump1(
     .pc_4(PCadd4_ID),//////////////////////////////////////////////////////////////////////////////
     .j_address_before(j_address_before_ID),
     .j_address_after(j_address_after_ID)
);
 
 
Signed_Extended Signed_Extended1(
     .in16(const_address_ID),
     .out32(out32_ID)
);
 
shift_left_2 shift1(
     .before(out32_ID),//from Signed_Extended1
     .after(branchshift_out)
);
 
add add_ID1(
     .a(branchshift_out),//from shift1
     .b(PCadd4_ID),//from IF_ID1
     .c_in(1'b0),
     .sum(branchaddr_ID)
);
  
 
 
 
RF RF1(
    .clk(clk),
    .rs(rs_ID),
    .rt(rt_ID),
    .write_register(write_register_WB),//5bit
    .write_data(write_data_WB),//32bits
    .RegWrite(RegWrite_WB),//1bit
    .RFout1(RFout1),//32bit
    .RFout2(RFout2)//32bit
);


MUX MUX_comparatorselect1(
   .A_in(RFout1),
   .B_in(ALUresult_MEM),
   .s(Forward_BranchA),
   .mux_out(comparatorinput1)
);
MUX MUX_comparatorselect2(
   .A_in(RFout2),
   .B_in(ALUresult_MEM),
   .s(Forward_BranchB),
   .mux_out(comparatorinput2)
);

  
ALU comparator(
   .a(comparatorinput1),
   .b(comparatorinput2),
   .ALUcontrol(4'b0110),
   .ALUresult(comparator_result),
   .zero(comparator_zero)
); 



ID_EX ID_EX1(
    .clk(clk),
    .IDEX_flush(IDEX_flush),///////////////////////////////////
    .ALUop_ID(ALUop_ID),
    .ALUSrc_ID(ALUSrc_ID),
    .RegDst_ID(RegDst_ID),
    .MemWrite_ID(MemWrite_ID),
    .MemRead_ID(MemRead_ID),
    .MemToReg_ID(MemToReg_ID),
    .RegWrite_ID(RegWrite_ID),
    .PCadd4_ID(PCadd4_ID),
    .ReadData1_ID(RFout1),
    .ReadData2_ID(RFout2),
    .out32_ID(out32_ID),
    .rs_ID(rs_ID),
    .rt_ID(rt_ID),
    .rd_ID(rd_ID),
    
    .ALUop_EX(ALUop_EX),
    .ALUSrc_EX(ALUSrc_EX),
    .RegDst_EX(RegDst_EX),
    .MemWrite_EX(MemWrite_EX),
    .MemRead_EX(MemRead_EX),
    .MemToReg_EX(MemToReg_EX),
    .RegWrite_EX(RegWrite_EX),
    .PCadd4_EX(PCadd4_EX),
    .ReadData1_EX(data1_EX),
    .ReadData2_EX(data2_EX),
    .out32_EX(out32_EX),
    .rs_EX(rs_EX),
    .rt_EX(rt_EX),
    .rd_EX(rd_EX)
);


MUX MUX_EX1(
   .A_in(data2_EX),
   .B_in(out32_EX),
   .s(ALUSrc_EX),
   .mux_out(ALU_b)
);

MUX_5bit MUX_EX2(
   .A_in(rt_EX),
   .B_in(rd_EX),
   .s(RegDst_EX),
   .mux_out(write_register_EX)
);

ALU_controller ALU_controller1(
    .ALUop(ALUop_EX),
    .funct(out32_EX[5:0]),
    .ALUcontrol(ALUcontrol)
);



MUX_4input ALUselect1(
    .A_in(data1_EX),//from current stage
    .B_in(Read_Data_WB),//from MEM/WB
    .C_in(ALUresult_MEM),//from EX/MEM
    .D_in(ALUresult_MEM),//from EX/MEM
    .s0(ForwardA[0]),
    .s1(ForwardA[1]),
    .mux_out(ALUinput1)
);
MUX_4input ALUselect2(
    .A_in(ALU_b),//from current stage
    .B_in(Read_Data_WB),//from MEM/WB
    .C_in(ALUresult_MEM),//from EX/MEM
    .D_in(ALUresult_MEM),//from EX/MEM
    .s0(ForwardB[0]),
    .s1(ForwardB[1]),
    .mux_out(ALUinput2)
);



ALU ALU1(
    .a(ALUinput1),
    .b(ALUinput2),
    .ALUcontrol(ALUcontrol),
    .ALUresult(ALUresult),
    .zero(ALUzero)
);


EXMEM EXMEM1(
    .clk(clk),
    .MemWrite_EX(MemWrite_EX),
    .MemRead_EX(MemRead_EX),
    .MemToReg_EX(MemToReg_EX),
    .RegWrite_EX(RegWrite_EX),
    .ALUresult(ALUresult),
    .data2_EX(data2_EX),
    .write_register_EX(write_register_EX),
    .rs_EX(rs_EX),
    .rt_EX(rt_EX),
    .rd_EX(rd_EX),
    
    .MemWrite_MEM(MemWrite_MEM),
    .MemRead_MEM(MemRead_MEM),
    .MemToReg_MEM(MemToReg_MEM),
    .RegWrite_MEM(RegWrite_MEM),
    .ALUresult_MEM(ALUresult_MEM),
    .DMwritedata(DMwritedata),
    .write_register_MEM(write_register_MEM),
    .rs_MEM(rs_MEM),
    .rt_MEM(rt_MEM),
    .rd_MEM(rd_MEM)
);


DataMem DataMem1(
    .MemWrite(MemWrite_MEM),
    .MemRead(MemRead_MEM),
    .address(ALUresult_MEM),
    .w_data(DMwritedata),
    .r_data(DMreaddata)
);


MEMWB MEMWB1(
/*

output reg [4:0]write_register_WB,
output reg [4:0] rs_WB,rt_WB,rd_WB*/
    .clk(clk),
    .MemToReg_MEM(MemToReg_MEM),
    .RegWrite_MEM(RegWrite_MEM),
    .Read_Data_MEM(DMreaddata),
    .ALUresult_MEM(ALUresult_MEM),
    .write_register_MEM(write_register_MEM),
    .rs_MEM(rs_MEM),
    .rt_MEM(rt_MEM),
    .rd_MEM(rd_MEM),
    
    .MemToReg_WB(MemToReg_WB),
    .RegWrite_WB(RegWrite_WB),
    .Read_Data_WB(Read_Data_WB),
    .ALUresult_WB(ALUresult_WB),
    .write_register_WB(write_register_WB),
    .rs_WB(rs_WB),
    .rt_WB(rt_WB),
    .rd_WB(rd_WB)
);

MUX MUX_WB1(
    .A_in(ALUresult_WB),
    .B_in(Read_Data_WB),
    .s(MemToReg_WB),
    .mux_out(write_data_WB)
);
 

endmodule
