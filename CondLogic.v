`timescale 1ns / 1ps
module condlogic(input clk, reset, PCs, RegW, MemW,
    input [3:0] cond, ALUflags,
    input [1:0] FlagW,
    output PCsrc, RegWrite, MemWrite);
    
    //n z c of
    wire [1:0] FlagWrite;
    wire [3:0] Flags;
    wire CondEx;
    
    flopenr #(.WIDTH(2))flagreg1(clk, reset, FlagWrite[1], ALUflags[3:2],
    Flags[3:2] );
    flopenr #(.WIDTH(2))flagreg0(clk, reset, FlagWrite[0], ALUflags[1:0],
    Flags[1:0] );
    
    //write controls are conditional
    condcheck cc(cond, Flags, CondEx);
    assign FlagWrite = FlagW & {2{CondEx}};
    assign RegWrite = RegW & CondEx;
    assign MemWrite = MemW & CondEx;
    assign PCsrc = PCs & CondEx;  
endmodule

//cond check
module condcheck(input [3:0] cond,
output reg CondEx);
    wire neg, zero, carry, overflow, ge; //ge--> greater than or eq to
    assign ge = (neg == overflow);
    always @ (*)begin
        case(cond)
            4'b0000: CondEx = zero; //EQ
            4'b0001: CondEx = ~zero; //NE
            4'b0010: CondEx = carry; //CS
            4'b0011: CondEx = ~carry; //CC
            4'b0100: CondEx = neg; //MI
            4'b0101: CondEx = ~neg; //PL
            4'b0110: CondEx = overflow; //VS
            4'b0111: CondEx = ~overflow; //VC
            4'b1000: CondEx = carry & ~zero; //HI
            4'b1001: CondEx = ~(carry & ~zero); //LS
            4'b1010: CondEx = ge; //GE
            4'b1011: CondEx = ~ge; //LT
            4'b1100: CondEx = ~zero & ge; //GT
            4'b1101: CondEx = ~(~zero & ge); //LE
            4'b1110: CondEx = 1'b1; //Always
            default: CondEx = 1'bx; //undefined
        endcase 
    end
endmodule
