`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2022 12:36:55 PM
// Design Name: 
// Module Name: mux_4X1
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


module mux_4X1(input [31:0] A, B, C, input[1:0] sel, output reg[31:0] out);
//A: reg. B: ALU result, C-> data memory
always @(*)
begin 
    case(sel)
        2'b00:out = A;
        2'b10:out = B;
        2'b01:out = C;
    endcase
end
endmodule
