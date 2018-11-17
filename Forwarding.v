
module Forwarding(rs_ID, rt_ID,rs_EX,rt_EX,rd_MEM,rd_WB,RegWrite_MEM,RegWrite_WB,ForwardA,ForwardB,Forward_BranchA,Forward_BranchB);
input[4:0]   rs_ID, rt_ID,rs_EX,rt_EX,rd_MEM,rd_WB;
input RegWrite_MEM,RegWrite_WB;
output reg  [1:0] ForwardA,ForwardB;
output reg Forward_BranchA,Forward_BranchB;

initial begin
ForwardA = 2'b00;
ForwardB = 2'b00;
Forward_BranchA = 1'b0;
Forward_BranchB = 1'b0;
end

//ForwardA,ForwardB in EX stage
always@(*) begin
    if( (RegWrite_MEM)&&(rd_MEM)&&(rd_MEM==rs_EX) ) begin
        ForwardA=2'b10;
    end
    else if( (RegWrite_WB)&&(rd_WB)&&(rd_WB==rs_EX)&&
    (~(RegWrite_MEM)&&(rd_MEM)&&(rd_MEM==rs_EX)) ) begin
        ForwardA=2'b01;
    end
    else begin
        ForwardA=2'b00;
    end
end

always@(*) begin
    if( (RegWrite_MEM)&&(rd_MEM)&&(rd_MEM==rt_EX) ) begin
        ForwardB=2'b10;
    end
    else if( (RegWrite_WB)&&(rd_WB)&&(rd_WB==rt_EX)&&
    (~(RegWrite_MEM)&&(rd_MEM)&&(rd_MEM==rt_EX)) ) begin
        ForwardB=2'b01;
    end
    else begin
        ForwardB=2'b00;
    end
end


//Forward_BranchA, Forward_BranchB in ID stage
always@(*) begin
    if( (RegWrite_MEM)&&(rd_MEM)&&(rd_MEM==rs_ID) )begin
        Forward_BranchA=1'b1;
    end
    else begin
        Forward_BranchA=1'b0;
    end
end

always@(*) begin
    if( (RegWrite_MEM)&&(rd_MEM)&&(rd_MEM==rt_ID) )begin
        Forward_BranchB=1'b1;
    end
    else begin
        Forward_BranchB=1'b0;
    end
end

endmodule