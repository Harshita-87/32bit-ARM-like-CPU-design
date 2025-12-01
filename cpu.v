`timescale 1ns / 1ps
module cpu(input clk, reset,
input [31:0] Instr, ReadData,
output [31:0] PC, MemWrite, ALUresult, WriteData);

//internal wires
wire [3:0] ALUflags;
wire RegWrite, ALUsrc, MemtoReg, PCsrc;
wire [1:0] RegSrc, ImmSrc, ALUcontrol;

//integrate controller
controller c(clk, reset, Instr[31:12], ALUflags,
MemWrite, ImmSrc, ALUsrc, ALUcontrol, RegWrite,
MemtoReg, PCsrc, RegSrc);

//integrate datapath
datapath dp(clk, reset, RegSrc, RegWrite, ImmSrc, ALUsrc, ALUcontrol,
MemtoReg, PCsrc, ALUflags, PC, Instr, ALUresult, WriteData, ReadData);
endmodule
