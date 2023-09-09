`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2022 06:42:52 PM
// Design Name: 
// Module Name: ALU_exp4
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



module ALU_control(input [1:0] ALUOp, input [2:0] func3,  input inst25, input inst30, output reg [4:0] ALUSelection);


always@(*) begin
  //R-type
  if(ALUOp == 2'b00) ALUSelection = `ALU_ADD;
  else if(!inst25 && ALUOp == 2'b10 && func3 == 3'b111 && inst30 == 1'b0) ALUSelection = `ALU_AND; //AND checked
  else if(!inst25 &&ALUOp == 2'b10 && func3 == 3'b110 && inst30 == 1'b0) ALUSelection = `ALU_OR; //OR  checked
  else if(!inst25 &&ALUOp == 2'b10 && func3 == 3'b000 && inst30 == 1'b0) ALUSelection = `ALU_ADD;//Add  checked
  else if(!inst25 &&ALUOp == 2'b10 && func3 == 3'b001 && inst30 == 1'b0) ALUSelection = `ALU_SLL;//SLL  checked 
  else if(!inst25 &&ALUOp == 2'b10 && func3 == 3'b010 && inst30 == 1'b0) ALUSelection = `ALU_SLT;//SLT  checked 
  else if(!inst25 &&ALUOp == 2'b10 && func3 == 3'b011 && inst30 == 1'b0) ALUSelection = `ALU_SLTU;//SLTU checked
  else if(!inst25 &&ALUOp == 2'b10 && func3 == 3'b000 && inst30 == 1'b1) ALUSelection = `ALU_SUB; //SUB checked
  else if(!inst25 &&ALUOp == 2'b10 && func3 == 3'b100 && inst30 == 1'b0) ALUSelection = `ALU_XOR; //XOR checked
  else if(!inst25 &&ALUOp == 2'b10 && func3 == 3'b101 && inst30 == 1'b0) ALUSelection = `ALU_SRL; //SRL 
  else if(!inst25 &&ALUOp == 2'b10 && func3 == 3'b101 && inst30 == 1'b1) ALUSelection = `ALU_SRA; //SRA
  //M exte!inst25&& nsion
  else if(inst25 && ALUOp == 2'b10&& func3 == 3'b000) ALUSelection = `ALU_MUL;
  else if(inst25 && ALUOp == 2'b10&& func3 == 3'b001) ALUSelection = `ALU_MULH;
  else if(inst25 && ALUOp == 2'b10&& func3 == 3'b010) ALUSelection = `ALU_MULHSU;
  else if(inst25 && ALUOp == 2'b10&& func3 == 3'b011) ALUSelection = `ALU_MULHU;
  else if(inst25 && ALUOp == 2'b10&& func3 == 3'b100) ALUSelection = `ALU_DIV;
  else if(inst25 && ALUOp == 2'b10&& func3 == 3'b101) ALUSelection = `ALU_DIVU;
  else if(inst25 && ALUOp == 2'b10&& func3 == 3'b110) ALUSelection = `ALU_REM;
  else if(inst25 && ALUOp == 2'b10&& func3 == 3'b111) ALUSelection = `ALU_REMU;
  //I-type 
  else if(ALUOp == 2'b01 && func3 == 3'b000 && inst30 == 0) ALUSelection = `ALU_ADD; 
  else if(ALUOp == 2'b01 && func3 == 3'b000 && inst30 == 1) ALUSelection = `ALU_SUB;
  else if(ALUOp == 2'b01 && func3 == 3'b001) ALUSelection = `ALU_SLL;
  else if(ALUOp == 2'b01 && func3 == 3'b010) ALUSelection = `ALU_SLT; 
  else if(ALUOp == 2'b01 && func3 == 3'b011) ALUSelection = `ALU_SLTU;
  else if(ALUOp == 2'b01 && func3 == 3'b100) ALUSelection = `ALU_XOR;
  else if(ALUOp == 2'b01 && func3 == 3'b101 && inst30 == 1'b0) ALUSelection = `ALU_SRL;
  else if(ALUOp == 2'b01 && func3 == 3'b101 && inst30 == 1'b1) ALUSelection = `ALU_SRA;
  else if(ALUOp == 2'b01 && func3 == 3'b110) ALUSelection = `ALU_OR;
  else if(ALUOp == 2'b01 && func3 == 3'b111) ALUSelection = `ALU_AND; 
  else ALUSelection = `ALU_SUB; //branch
end

//4'b0000 -> AND
//4'b0001 -> OR
//4'b0010 -> add
//4'b0011-> SLL  //001, 0
//4'b0100-> SLT  //010, 0
//4'b0101-> SLTU //011, 0
//4'b0110 -> sub
//4'b0111-> XOR //100, 0 
//4'b1000-> SRL //101, 0
//4'b1001-> SRA //101, 1

endmodule