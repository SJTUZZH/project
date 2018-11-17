module Control_ID(
    input [5:0] op,
    output reg AluSrc,
    output reg [1:0] AluOp,
    output reg RegDst,
    output reg Branch1,
    output reg Branch2,
    output reg MemWrite,
    output reg MemRead,
    output reg MemtoReg,
    output reg RegWrite,
    //output reg PcSrc,
    output reg Jump
    );
    initial begin
    AluSrc=1'b0;
    AluOp=2'b00;
    RegDst=1'b0;
    Branch1=1'b0;
    Branch2=1'b0;
    MemWrite=1'b0;
    MemRead=1'b0;
    MemtoReg=1'b0;
    RegWrite=1'b0;
    //PcSrc<=1'b0;
    Jump=1'b0;
    end
    
    always@(op) begin
    case(op)
    6'b000000: begin //R_tyoe
    AluSrc<=1'b0;
    AluOp<=2'b10;
    RegDst<=1'b1;
    Branch1<=1'b0;
    Branch2<=1'b0;
    MemWrite<=1'b0;
    MemRead<=1'b0;
    MemtoReg<=1'b0;
    RegWrite<=1'b1;
    //PcSrc<=1'b0;
    Jump<=1'b0;
    end
    
    6'b100011: begin //lw
    AluSrc<=1'b1;
    AluOp<=2'b00;
    RegDst<=1'b0;
    Branch1<=1'b0;
    Branch2<=1'b0;
    MemWrite<=1'b0;
    MemRead<=1'b1;
    MemtoReg<=1'b1;
    RegWrite<=1'b1;
    //PcSrc<=1'b0;
    Jump<=1'b0;
    end
    
    6'b001000: begin //addi
    AluSrc=1'b1;
    AluOp=2'b00;
    RegDst=1'b0;
    Branch1=1'b0;
    Branch2=1'b0;
    MemWrite=1'b0;
    MemRead=1'b0;
    MemtoReg=1'b0;
    RegWrite=1'b1;
    //PcSrc<=1'b0;
    Jump=1'b0;
    end
    
    6'b001100: begin //andi
    AluSrc<=1'b1;
    AluOp<=2'b11;
    RegDst<=1'b0;
    Branch1<=1'b0;
    Branch2<=1'b0;
    MemWrite<=1'b0;
    MemRead<=1'b0;
    MemtoReg<=1'b0;
    RegWrite<=1'b1;
    //PcSrc<=1'b0;
    Jump<=1'b0;
    end      
    
    6'b101011: begin //sw
    AluSrc<=1'b1;
    AluOp<=2'b00;
    RegDst<=1'b0; //x
    Branch1<=1'b0;
    Branch2<=1'b0;
    MemWrite<=1'b1;
    MemRead<=1'b0;
    MemtoReg<=1'b0;//x
    RegWrite<=1'b0;
    //PcSrc<=1'b0;
    Jump<=1'b0;
    end
    
    6'b000100: begin //beq
    AluSrc<=1'b0;
    AluOp<=2'b01;
    RegDst<=1'b0;//x
    Branch1<=1'b1;
    Branch2<=1'b0;
    MemWrite<=1'b0;
    MemRead<=1'b0;
    MemtoReg<=1'b0;//x
    RegWrite<=1'b0;
    //PcSrc<=1'b0;
    Jump<=1'b0;
    end
    
    6'b000101: begin //bne 具体要看mem的结构
    AluSrc<=1'b0;
    AluOp<=2'b01;
    RegDst<=1'b0;//x
    Branch1<=1'b0;
    Branch2<=1'b1;
    MemWrite<=1'b0;
    MemRead<=1'b0;
    MemtoReg<=1'b0;//x
    RegWrite<=1'b0;
    //PcSrc<=1'b0;
    Jump<=1'b0;
    end
    
    6'b000010: begin //j
    AluSrc<=1'b0;//x
    AluOp<=2'b00;//x
    RegDst<=1'b0;//x
    Branch1<=1'b0;//x
    Branch2<=1'b0;//x
    MemWrite<=1'b0;
    MemRead<=1'b0;//x
    MemtoReg<=1'b0;//x
    RegWrite<=1'b0;
    //PcSrc<=1'b1;
    Jump<=1'b1;
    end
    
    default: ;
    endcase
 end
 
endmodule