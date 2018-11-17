module ALU_controller(ALUop,funct,ALUcontrol);
input [1:0]ALUop;
input [5:0]funct;
output reg [3:0]ALUcontrol;

parameter add_funct=6'b100000;
parameter sub_funct=6'b100010;
parameter AND_funct=6'b100100;
parameter OR_funct=6'b100101;
parameter slt_funct=6'b101010;

always @(*)  begin
    case(ALUop)
        2'b00:ALUcontrol<=4'b0010;//lw,sw,addi
        2'b01:ALUcontrol<=4'b0110;//beq,bne,j
        2'b10:
            case(funct)
                add_funct:ALUcontrol<=4'b0010;//add
                sub_funct:ALUcontrol<=4'b0110;//sub
                AND_funct:ALUcontrol<=4'b0000;//AMD
                OR_funct:ALUcontrol<=4'b0001;//OR
                slt_funct:ALUcontrol<=4'b0111;//slt
                default:ALUcontrol<=4'b1111;
            endcase
        2'b11:ALUcontrol<=4'b0000;//ANDi
        default:ALUcontrol<=4'b1111;
    endcase
end
  


endmodule