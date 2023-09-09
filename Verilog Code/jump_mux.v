`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2022 01:14:30 AM
// Design Name: 
// Module Name: jump_mux
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


module jump_mux(input rst, input [31:0]A, B, C, input[1:0] sel, output reg [31:0] out);
always@(*)
if(rst)
out = 32'b0;
else begin
    case(sel)
    2'b00:out = A;
    2'b01:out = B;
    2'b10:out = C;
    endcase
end
endmodule
