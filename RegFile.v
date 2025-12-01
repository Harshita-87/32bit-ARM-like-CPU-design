`timescale 1ns / 1ps
module RegFile(
    input clk,
    input we3, //1 bit control sg
    input [3:0] ra1, ra2, wa3, //address ports--ra1 & ra2 for read
    input [31:0] wd3,r15,
    output reg [31:0] rd1, rd2
    );
    reg [31:0] rf[14:0]; //15 locations, each having 32 bits locations

//we need 15 locations only, bcz r15 is special one
//r15 is an i/p of 32 bit

    always @(posedge clk)begin
       if(we3) rf[wa3]<=wd3; //wa3 is A3 in the diag.
/*any memory location given at wa3, will get written with 
the content of wd3*/
       assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1];
       assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2];
    end
endmodule
