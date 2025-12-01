`timescale 1ns / 1ps
//instruction memory ONLY READING {loading data}

module imem(input [31:0] a,
  output [31:0] rd);
  reg[31:0] RAM [63:0];
  initial
    $readme ("memfile,data", RAM);
    assign rd = RAM[a[31:2]]; //word aligned
endmodule
