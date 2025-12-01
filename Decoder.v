`timescale 1ns / 1ps
module decoder(input [1:0]op,
   input [5:0]funct,
   input [3:0]Rd,
   output reg [1:0]FlagW,
   output reg PCs, RegW, MemW, MemtoReg, ALUsrc, 
   output reg [1:0]ImmSrc, RegSrc, ALUcontrol);

//internal wires
   reg Branch, ALUop;
   reg [9:0] controls;

//main decoder
    always @(*) begin
        case(op)
            //data-processing immediate
            2'b00: if (funct[5]) controls = 10'b0011001x01;
            //data-processing register
            else controls = 10'b0000xx1001;
            //ldr
            2'b01: if (funct[0]) controls = 10'b0101011x00;
            //str
            else controls = 10'b0x11010100; 
            //b
            2'b10: controls = 10'b1001100x10;
            //unimplemented
            default: controls = 10'bx;
        endcase
        assign {Branch, MemtoReg, MemW, ALUsrc, 
        ImmSrc, RegW, RegSrc, ALUop} = controls;
        assign PCs = ((Rd==4'b1111 & RegW) | Branch);
    end //end of main decoder
    
//ALU decoder
    always @(*)begin
        case(ALUop)
            1:  begin 
                case (funct[4:1])
                    //ADD
                    4'b100: begin
                        if (funct[0]) 
                            FlagW = 2'b11;
                        else FlagW = 2'b00; 
                    end
                    default: ALUcontrol = 2'b00;
                    //SUB
                    4'b0010: begin
                        if (funct[0]) begin
                            FlagW = 2'b11; 
                            ALUcontrol = 2'b01;
                        end
                        else begin 
                            FlagW = 2'b00; 
                            ALUcontrol = 2'b01; 
                        end
                    end
                    //AND
                    4'b0000: begin
                        if (funct[0]) begin
                            FlagW = 2'b10; 
                            ALUcontrol = 2'b10;
                        end
                        else begin 
                            FlagW = 2'b00; 
                            ALUcontrol = 2'b10; 
                        end
                    end
                    //ORR
                    4'b1100: begin
                        if (funct[0]) begin
                            FlagW = 2'b10; 
                            ALUcontrol = 2'b11;
                        end
                        else begin 
                            FlagW = 2'b00; 
                            ALUcontrol = 2'b11; 
                        end
                    end
                endcase
            end    
        endcase
    end //end of ALU decoder
    
endmodule
