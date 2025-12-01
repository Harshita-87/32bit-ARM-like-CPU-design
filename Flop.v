`timescale 1ns / 1ps
//d flipflop
module flop(
    input clk, reset,
    input [31:0] d,
    output reg [31:0] q);
    always @ (posedge clk, posedge reset) begin
        if(reset) q<=0;
        else q<=d;
    end
endmodule
