`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2022 12:10:04 PM
// Design Name: 
// Module Name: forwarding_unit
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


module forwarding_unit(input [4:0] ID_EX_RegisterRs1, ID_EX_RegisterRs2, EX_MEM_RegisterRd, MEM_WB_RegisterRd, input EX_MEM_RegWrite, MEM_WB_RegWrite,
output reg [1:0]forwardA, forwardB);

always @(*)
begin

if ((EX_MEM_RegWrite == 1) && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs1)) 
	forwardA = 2'b01;
else if ((MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0))
&& (MEM_WB_RegisterRd == ID_EX_RegisterRs1))
	forwardA = 2'b10;
else
	forwardA = 2'b00;
	
if ((EX_MEM_RegWrite == 1) && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs2)) 
	forwardB = 2'b01;
else if ((MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0))
&& ( MEM_WB_RegisterRd == ID_EX_RegisterRs2))
	forwardB = 2'b10;
else
	forwardB = 2'b00;
	
end
    
endmodule
