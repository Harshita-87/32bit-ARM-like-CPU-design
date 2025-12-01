`timescale 1ns / 1ps
module controller( input clk, reset,
    input [31:12] Instr,
    input [3:0] ALUflags,
    output reg [1:0] RegSrc, ImmSrc, ALUcontrol,
    output reg RegWrite, ALUsrc, MemWrite, MemtoReg, PCsrc);
    
    //internal wires
    wire [1:0] FlagW;
    wire PCs, RegW, MemW;
    
    //integrate decoder (PC logic + main decoder + ALU decoder)
    decoder dec(Instr[27:26], Instr[25:20], Instr[15:12],
    FlagW, PCs, RegW, MemW, MemtoReg, ALUsrc, ImmSrc, RegSrc, ALUcontrol);
    
    //integrate cond logic block
    condlogic cl(clk, reset, Instr[31:28], ALUflags, Flags, PCs,
    RegW, MemW, PCsrc, RegWrite, MemWrite);
endmodule
