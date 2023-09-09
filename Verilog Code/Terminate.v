`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2022 12:40:50 PM
// Design Name: 
// Module Name: Terminate
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


module Terminate(input clk, input [31:0]inst,output reg freeze,reset_PC);
//ebreak freezes PC and efence,ecall resets
parameter ecall = 32'b00001110011;
parameter ebreak=32'b00000000000100000000000001110011;
parameter fence=32'b00000000000000000001000000001111;
always@(clk)
begin
if(inst==ecall || inst==fence)
begin
freeze=1'b0;
reset_PC=1'b1;
end
else if(inst==ebreak)
begin
freeze=1'b1;
reset_PC=1'b0;
end
else 
begin
freeze=1'b0;  
reset_PC=1'b0;
end
end
endmodule
