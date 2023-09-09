`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2022 07:10:48 PM
// Design Name: 
// Module Name: control_exp3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control_unit(input [31:0] inst, output reg[1:0] jump_sel, output reg branch, output reg memRead,output reg[2:0]  memtoReg, output reg memWrite, ALUsrc, regWrite, output reg[1:0] ALUop);
always@(*)
begin
if(inst[6:2] == 5'b01100)//R-type
    begin
        jump_sel =2'b0; //0 -> not jumping, 01-> JAL, 10->JALR
        branch =1'b0;
        memRead = 1'b0; 
        memtoReg= 3'b000;
        ALUop= 2'b10; 
        memWrite=1'b0; 
        ALUsrc=1'b0; 
        regWrite=1'b1;
     end
   else if(inst[6:2] == 5'b00000)//load
    begin
        jump_sel =2'b0;
        branch =1'b0;
        memRead = 1'b1; 
        memtoReg= 3'b001;
        ALUop= 2'b00; 
        memWrite=1'b0; 
        ALUsrc=1'b1; 
        regWrite=1'b1;
     end
   else if(inst[6:2] == 5'b01000)//store
    begin
        jump_sel =2'b0;
        branch =1'b0;
        memRead = 1'b0; 
        memtoReg= 3'b1;
        ALUop= 2'b00; 
        memWrite=1'b1; 
        ALUsrc=1'b1; 
        regWrite=1'b0;
     end      
   else if(inst[6:2] == 5'b11000)//B-type
    begin
        jump_sel =2'b0;
        branch =1'b1;
        memRead = 1'b0; 
        memtoReg= 3'b1; //getting the value of the ALU
        ALUop= 2'b11; 
        memWrite=1'b0; 
        ALUsrc=1'b0; 
        regWrite=1'b0;
     end
   else if(inst[6:2] == 5'b00100)//I-type
    begin
        jump_sel =2'b0;
        branch =1'b0;
        memRead = 1'b0; 
        memtoReg= 3'b0; //getting the value of the immediate
        ALUop= 2'b01; 
        memWrite=1'b0; 
        ALUsrc=1'b1; //coming  from the immediate 
        regWrite=1'b1;
     end
   else if(inst[6:2] == 5'b00101)//AUIPC
    begin
        jump_sel =2'b0;
        branch =1'b0;
        memRead = 1'b0; 
        memtoReg= 3'b010;
        ALUop= 2'b00; 
        memWrite=1'b0; 
        ALUsrc=1'b1; 
        regWrite=1'b1;
     end
   else if(inst[6:2] == 5'b01101)//LUI
    begin
        jump_sel =2'b0;
        branch =1'b0;
        memRead = 1'b0; 
        memtoReg= 3'b111;
        ALUop= 2'b00; 
        memWrite=1'b0; 
        ALUsrc=1'b1; //immediate
        regWrite=1'b1;
     end
   else if(inst[6:2] == 5'b11011)//JAL 
    begin
        jump_sel =2'b01; //0 -> not jumping, 01-> JAL, 10->JALR
        branch =1'b0;
        memRead = 1'b0; 
        memtoReg= 3'b011;
        ALUop= 2'b00; 
        memWrite=1'b0; 
        ALUsrc=1'b1; //immediate
        regWrite=1'b1;
     end   
   else if(inst[6:2] == 5'b11001)//JALR
    begin
        jump_sel =2'b10; //0 -> not jumping, 01-> JAL, 10->JALR
        branch =1'b0;
        memRead = 1'b0; 
        memtoReg= 3'b011;
        ALUop= 2'b00; 
        memWrite=1'b0; 
        ALUsrc=1'b1; //immediate
        regWrite=1'b1;
     end 
   else 
    begin
        jump_sel =2'b00; 
        branch =1'b0;
        memRead = 1'b0; 
        memtoReg= 3'b000;
        ALUop= 2'b00; 
        memWrite=0'b0; 
        ALUsrc=0'b0; //immediate
        regWrite=1'b0;
     end        
end
endmodule
