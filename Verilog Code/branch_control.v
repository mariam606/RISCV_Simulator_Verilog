`timescale 1ns / 1ps
`include"defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2022 01:35:33 AM
// Design Name: 
// Module Name: branch_control
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


module branch_control(input [2:0] funct3, input zf, cf, vf, sf, output reg sig);
always@(*)begin
  if(funct3 == `BR_BEQ) sig = zf;
  else if(funct3 == `BR_BNE) sig = (!zf);
  else if(funct3 == `BR_BLT) sig = (sf != vf);
  else if(funct3 == `BR_BGE) sig = (sf == vf);
  else if(funct3 == `BR_BLTU) sig = (!cf);
  else if(funct3 == `BR_BGEU) sig = (cf);
  else sig = 0; // ECALL - EBREAK - FENCE
end

endmodule
