`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2022 03:05:44 PM
// Design Name: 
// Module Name: RegFile
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

module RegFile#(parameter n=32)(input [4:0] readReg1, readReg2, writeReg, input regWrite, input [31:0] writeData, input clk,
 input rst, output [31:0] read1, read2);
wire [n-1:0] q[31:0];
reg [31:0]load;
always@(*)
begin
    load=32'b0;
    if(regWrite && writeReg!=4'b0000) load[writeReg] <= 1'b1;       
end
 genvar i;
    generate
    for(i=1;i<n;i=i+1)//always start from 0 s0 x0=0 alwaysssss
        nbit_reg UUT(clk, rst, load[i], writeData, q[i]);
    endgenerate  
assign read1 = q[readReg1];
assign read2 = q[readReg2];
assign q[0]=0; //x0=0

endmodule


