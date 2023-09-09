`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2022 03:04:48 PM
// Design Name: 
// Module Name: nbit_reg
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



module nbit_reg#(parameter N=32)(input clk,input rst,input load,input [N-1:0]d,output [N-1:0]Q);
    genvar i;
    wire [N-1:0]result;
    generate
    for(i=0;i<N;i=i+1)
    begin
        n_bit_mux #(1) mx(Q[i],d[i],load, result[i]);
        DFlipFlop ff(clk, rst,result[i],Q[i]);
    end
    endgenerate
endmodule
