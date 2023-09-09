`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2022 12:53:28 AM
// Design Name: 
// Module Name: shifter
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

`include"defines.v"
module shifter(input [31:0]a, input [31:0] shamt, input [1:0]type, output reg[31:0] r);

always @(*)
begin
r = a;
case(type)
   2'b01:  r = a << shamt; //sll
   2'b00: r = $unsigned(a) >> shamt;//srl
   2'b10:  r = $signed(a) >>> shamt;//sra 
   endcase
end

endmodule
