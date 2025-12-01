`timescale 1ns / 1ps
module Datapath(input clk, reset, RegWrite, ALUsrc, MemtoReg, PCsrc, 
    input[1:0] RegSrc, ImmSrc, ALUcontrol,
    input[31:0] Instr, ReadData, PC,
    output reg [3:0] ALUflags, 
    output reg [31:0] ALUresult, WireData);

    wire [31:0] PCnext, PCplus4, PCplus8, ExtImm, SrcA, SrcB, Result;
    wire [3:0] RA1, RA2; 

    //PC logic
    mux2x1 #32 pcmux(.y(PCnext), .s(PCsrc), .d0(PCplus4), .d1(Result));
    flop #32 (.clk(clk), .reset(reset), .d(PCnext), .q(PC));
    adder #32 (PC, 32'b100, PCplus4);
    adder #32 (.a(32'b100), .b(PCplus4), .y(PCplus8));

    //Register File
    mux2x1 #4 ra1mux(.y(RA1), .s(RegSrc[0]), .d0(Instr[19:16]), .d1(4'b1111));
    mux2x1 #4 ra2mux(.y(RA2), .s(RegSrc[1]), .d0(Instr[3:0]), .d1(Instr[15:12]));
    RegFile rf(.clk(clk), .we3(Result), .ra1(RA1), .ra2(RA2), .wa3(Instr[15:12]), .wd3(Result), .r15(PCplus8), 
    .rd1(SrcA), .rd2(WriteData));
    mux2x1 #32 resultmux(.y(Result), .s(MemtoReg), .d0(ALUresult), .d1(ReadData));
    extend ext(Instr[23:0], ImmSrc, ExtImm);

    //ALU logic
    mux2x1 #32 SrcBmux(.y(SrcB), .s(ALUsrc), .d0(WriteData), .d1(ExtImm));
    ALU alu(.SrcA(SrcA), .SrcB(SrcB), .ALUcontrol(ALUcontrol), .ALUresult(ALUresult), .zero(ALUflags[0]), .negative(ALUflags[1]), .overflow(ALUflags[2]), .carry(ALUflags[3]));
endmodule
