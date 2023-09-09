`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2022 09:39:59 PM
// Design Name: 
// Module Name: reg_mux
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


module reg_mux(input [31:0]A, B, C, D, E, input[2:0] sel, output reg [31:0] out); //000->R-type, 001->LW&SW, 010->AUIPC, 011->JAL & JALR

always@(*)
begin
    case(sel)
    3'b000:out = A;
    3'b001:out = B;
    3'b010:out = C;
    3'b011:out = D;
    3'b111:out = E;
    endcase
end
endmodule
