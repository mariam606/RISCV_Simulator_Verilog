
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/20/2021 05:25:10 PM
// Design Name:
// Module Name: decompression_unit
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


module decompression_unit(input rst, input[31:0] inst, output reg[31:0] out_inst, output reg compressed_flag);
reg[4:0] rs, rd;
always@(*) begin
    if(rst) begin
        compressed_flag = 0;
        out_inst = 32'b0000000_00000_00000_000_00000_0110011;//nop
     end
    else if(inst[1:0] == 2'b11) begin
        out_inst = inst;
        compressed_flag = 0;
    end
    else begin
        compressed_flag = 1;
        if(inst[1:0] == 2'b00) begin
            rd = inst[4:2] + 4'd8;
            rs = inst[9:7] + 4'd8;
            if(inst[15:13] == 3'b010) out_inst = {5'b00000, inst[5] ,inst[12:10], inst[6], 2'b00, rs, 3'b010, rd, 7'b0000011}; // LW
            else if(inst[15:13] == 3'b110) out_inst = {5'b00000, inst[5], inst[12], rd, rs, 3'b010, inst[11:10], inst[6], 2'b00, 7'b0100011}; // SW
        end
        else if(inst[1:0] == 2'b01) begin
            if(inst[11:7] == 5'b00000 && inst[15:13] == 3'b000) begin
                out_inst = 32'b0000000_00000_00000_000_00000_0110011; // NOP
            end
            else if(inst[15:13] == 3'b000) begin
                rd = inst[11:7];
                out_inst = {{7{inst[12]}}, inst[6:2], rd, 3'b000, rd, 7'b0010011}; // ADDI
            end
            else if(inst[15:13] == 3'b001) out_inst = {inst[12] ,inst[8], inst[10:9], inst[6], inst[7], inst[2], inst[11], inst[5:3], {9{inst[12]}}, 5'b00001 ,7'b1101111}; // JAL
            else if(inst[15:13] == 3'b010) begin
                rd = inst[11:7];
                out_inst = {{7{inst[12]}}, inst[6:2], 5'b00000, 3'b000, rd, 7'b0010011}; // LI
            end
            else if(inst[15:13] == 3'b011) begin
                rd = inst[11:7];
                out_inst = {{15{inst[12]}}, inst[6:2], rd, 7'b0110111}; // LUI
            end
            else if(inst[15:13] == 3'b100 && inst[11:10] == 2'b00) begin
                rd = inst[9:7] + 4'd8;
                out_inst = {7'b0000000, inst[6:2], rd, 3'b101, rd, 7'b0010011}; // SRLI
            end
            else if(inst[15:13] == 3'b100 && inst[11:10] == 2'b01) begin
                rd = inst[9:7] + 4'd8;
                out_inst = {7'b0100000, inst[6:2], rd, 3'b101, rd, 7'b0010011}; // SRAI
            end
            else if(inst[15:13] == 3'b100 && inst[11:10] == 2'b10) begin
                rd = inst[9:7] + 4'd8;
                out_inst = {{7{inst[12]}}, inst[6:2], rd, 3'b111, rd, 7'b0010011}; // ANDI
            end  
            else if(inst[15:13] == 3'b100 && inst[11:10] == 2'b11 && inst[6:5] == 2'b00) begin
                rd = inst[9:7] + 4'd8;
                rs = inst[4:2] + 4'd8;
                out_inst = {7'b0100000, rs, rd, 3'b000, rd, 7'b0110011}; // SUB
            end
            else if(inst[15:13] == 3'b100 && inst[11:10] == 2'b11 && inst[6:5] == 2'b01) begin
                rd = inst[9:7] + 4'd8;
                rs = inst[4:2] + 4'd8;
                out_inst = {7'b0000000, rs, rd, 3'b100, rd, 7'b0110011}; // XOR
            end    
            else if(inst[15:13] == 3'b100 && inst[11:10] == 2'b11 && inst[6:5] == 2'b10) begin
                rd = inst[9:7] + 4'd8;
                rs = inst[4:2] + 4'd8;
                out_inst = {7'b0000000, rs, rd, 3'b110, rd, 7'b0110011}; // OR
            end
            else if(inst[15:13] == 3'b100 && inst[11:10] == 2'b11 && inst[6:5] == 2'b11) begin
               rd = inst[9:7] + 4'd8;
               rs = inst[4:2] + 4'd8;
               out_inst = {7'b0000000, rs, rd, 3'b111, rd, 7'b0110011}; // AND
           end
           else if(inst[15:13] == 3'b101)  out_inst = {inst[12] ,inst[8], inst[10:9], inst[6], inst[7], inst[2], inst[11], inst[5:3], {9{inst[12]}}, 5'b00000 ,7'b1101111}; // J
           else if(inst[15:13] == 3'b110) begin
                rs = inst[9:7] + 8'd8;
                out_inst = {{4{inst[12]}}, inst[6:5], inst[2], 5'b00000, rs, 3'b000, inst[11:10], inst[4:3], inst[12], 7'b1100011}; // BEQZ                
           end  
           else if(inst[15:13] == 3'b111) begin
                rs = inst[9:7] + 8'd8;
                out_inst = {{4{inst[12]}}, inst[6:5], inst[2], 5'b00000, rs, 3'b001, inst[11:10], inst[4:3], inst[12], 7'b1100011}; // BNEZ                
           end                
        end
        else if(inst[1:0] == 2'b10) begin
            if(inst[15:13] == 3'b000) begin
                rd = inst[9:7] + 4'd8;
                out_inst = {7'b0000000, inst[6:2], rd, 3'b001, rd, 7'b0010011}; // SLLI          
            end
            else if(inst[15:13] == 3'b100 && inst[12] == 1'b0 && inst[6:2] == 5'b00000) begin
                rs = inst[11:7];
                out_inst = {12'd0, rs, 3'b000, 5'b00000, 7'b1100111}; // JR          
            end
            else if(inst[15:13] == 3'b100 && inst[12] == 1'b1 && inst[6:2] == 5'b00000) begin
                rs = inst[11:7];
                out_inst = {12'd0, rs, 3'b000, 5'b00001, 7'b1100111}; // JALR          
            end
            else if(inst[15:13] == 3'b100 && inst[12] == 1'b0) begin
                rd = inst[11:7];
                rs = inst[6:2];
                out_inst = {7'b0000000 ,5'b00000, rs, 3'b000, rd, 7'b0110011}; // MV          
            end
            else if(inst[15:13] == 3'b100 && inst[12] == 1'b1) begin
                rd = inst[11:7];
                rs = inst[6:2];
                out_inst = {7'b0000000 ,rd, rs, 3'b000, rd, 7'b0110011}; // MV          
            end
            else if(inst[15:13] == 3'b100 && inst[12] == 1'b1 && inst[6:2] == 5'b00000 && inst[11:7] == 5'b00000) begin
                out_inst = 32'b00000000000100000000000001110011;
            end
        end
    end
end
endmodule