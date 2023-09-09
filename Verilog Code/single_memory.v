`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2022 08:48:52 PM
// Design Name: 
// Module Name: single_memory
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


module single_memory(input clk, input MemRead, input MemWrite, input[8:0]addr,input [2:0]func3, input[31:0] data_in, output reg [31:0]out);
parameter InstOffset = 256;
reg [7:0] mem [0:511];//7:0, 0:module adder 
reg [31:0]data_out;

    always@(*)
        if(clk)
            out = {mem[InstOffset + 3 + addr], mem[InstOffset + 2 + addr], mem[InstOffset + 1 + addr], mem[InstOffset + addr]};
        else 
            out = data_out;
    
    always@(*)
    begin
    if(MemRead)
        begin
           case(func3)
           3'b000:data_out= {{24{mem[addr][7]}}, {mem[addr]}};//lb
           3'b001:data_out= {{16{mem[addr+1][7]}}, {mem[addr+1], mem[addr]}};//lh
           3'b010:data_out= {mem[addr+3][7], mem[addr+2],  mem[addr+1], mem[addr]};//lw
           3'b100:data_out= {{24{1'b0}}, mem[addr]};//lbu
           3'b101:data_out= {{16{1'b0}}, mem[addr+1], mem[addr]};//lhu
           default data_out= 32'b0;
           endcase   
        end 
    else data_out =32'b0;
    end 
    
    always@(clk)
    begin 
        if(MemWrite)
        begin
           case(func3)
           3'b000:mem[addr] = data_in[7:0];//SB
           3'b001:{mem[addr+1], mem[addr]} = {data_in[15:8],data_in[7:0]};//SH
           3'b010:{mem[addr+3],mem[addr+2], mem[addr+1], mem[addr]} = {data_in[31:24],data_in[23:16],data_in[15:8],data_in[7:0]};//SW
           default mem[addr]= 32'b0;
           endcase
        end
    end

initial begin 
mem[0] = 8'd17; 
mem[1] = 8'd0; 
mem[2] = 8'd0;
mem[3] = 8'd0;
mem[4]= 8'd112;
mem[5] = 8'd0;
mem[6] = 8'd0;
mem[7] = 8'd0;
mem[8]=8'd9;
mem[9] = 8'd0;
mem[10] = 8'd0;
mem[11] = 8'd0;
mem[20]=8'd8;
mem[21] = 8'd0;
mem[22] = 8'd0;
mem[23] = 8'd0;

//{mem[InstOffset + 3], mem[InstOffset + 2], mem[InstOffset + 1], mem[InstOffset + 0]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//{mem[InstOffset + 7], mem[InstOffset + 6], mem[InstOffset + 5], mem[InstOffset + 4]}=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0) //x1 =17    
//{mem[InstOffset + 11], mem[InstOffset + 10], mem[InstOffset + 9], mem[InstOffset + 8]}=32'b01000000000100000000000010110011; //sub x1, x0, x1 //x1 =-17  
//{mem[InstOffset + 15], mem[InstOffset + 14], mem[InstOffset + 13], mem[InstOffset + 12]}=  32'b0100100000000000100010011; //addi x2, x0, 9 //x2 = 9
//{mem[InstOffset + 19], mem[InstOffset + 18], mem[InstOffset + 17], mem[InstOffset + 16]}=32'b0010001000001011000110110011; //mulhu x3, x1, x2 //x3=8

//{mem[InstOffset + 3], mem[InstOffset + 2], mem[InstOffset + 1], mem[InstOffset + 0]}=32'h00000033; //add x0, x0, x0   
//{mem[InstOffset + 7], mem[InstOffset + 6], mem[InstOffset + 5], mem[InstOffset + 4]}=32'h00002083; //lw x1, 0(x0) //x1 =17  
//{mem[InstOffset + 11], mem[InstOffset + 10], mem[InstOffset + 9], mem[InstOffset + 8]}=32'h00900113 ; //lw x2, 4(x0) //x2 = 9
//{mem[InstOffset + 15], mem[InstOffset + 14], mem[InstOffset + 13], mem[InstOffset + 12]}=32'h00802183; //lw x3, 8(x0) 
//{mem[InstOffset + 19], mem[InstOffset + 18], mem[InstOffset + 17], mem[InstOffset + 16]}=32'h023181b3; //or x4, x1, x2
//{mem[InstOffset + 23], mem[InstOffset + 22], mem[InstOffset + 21], mem[InstOffset + 20]}=32'h0020e233; //beq x4, x3, 4     
//{mem[InstOffset + 27], mem[InstOffset + 26], mem[InstOffset + 25], mem[InstOffset + 24]}=32'h00320463; //add x3, x1, x2  
//{mem[InstOffset + 31], mem[InstOffset + 30], mem[InstOffset + 29], mem[InstOffset + 28]}=32'h002086b3; //add x5, x3, x2   
//{mem[InstOffset + 35], mem[InstOffset + 34], mem[InstOffset + 33], mem[InstOffset + 32]}=32'h002182b3;  //sw x5, 12(x0)  
//{mem[InstOffset + 39], mem[InstOffset + 38], mem[InstOffset + 37], mem[InstOffset + 36]}=32'h00502623;  //lw x6, 12(x0)      
//{mem[InstOffset + 43], mem[InstOffset + 42], mem[InstOffset + 41], mem[InstOffset + 40]}=32'h00c02303; //and x7, x6, x1
//{mem[InstOffset + 47], mem[InstOffset + 46], mem[InstOffset + 45], mem[InstOffset + 44]}=32'h001373b3;  
//{mem[InstOffset + 51], mem[InstOffset + 50], mem[InstOffset + 49], mem[InstOffset + 48]}=32'h00801883; //add x0, x1, x2
//{mem[InstOffset + 55], mem[InstOffset + 54], mem[InstOffset + 53], mem[InstOffset + 52]}=32'h0100c993; //add x9, x0, x1
//{mem[InstOffset + 59], mem[InstOffset + 58], mem[InstOffset + 57], mem[InstOffset + 56]}=32'h03334433; //add x0, x0, x0  
//{mem[InstOffset + 63], mem[InstOffset + 62], mem[InstOffset + 61], mem[InstOffset + 60]}=32'h001124b3; //add x0, x0, x0  
//{mem[InstOffset + 67], mem[InstOffset + 66], mem[InstOffset + 65], mem[InstOffset + 64]}=32'h00419513; //add x0, x0, x0  
//{mem[InstOffset + 71], mem[InstOffset + 70], mem[InstOffset + 69], mem[InstOffset + 68]}=32'h002bc5b7; //beq x4, x3, 16
//{mem[InstOffset + 75], mem[InstOffset + 74], mem[InstOffset + 73], mem[InstOffset + 72]}=32'h00c0066f; //add x0, x0, x0 
//{mem[InstOffset + 79], mem[InstOffset + 78], mem[InstOffset + 77], mem[InstOffset + 76]}=32'h00e00713; //add x0, x0, x0 
//{mem[InstOffset + 83], mem[InstOffset + 82], mem[InstOffset + 81], mem[InstOffset + 80]}=32'h01408067; //add x0, x0, x0  
//{mem[InstOffset + 87], mem[InstOffset + 86], mem[InstOffset + 85], mem[InstOffset + 84]}=32'hfe20cee3; //add x3, x1, x2 
//{mem[InstOffset + 91], mem[InstOffset + 90], mem[InstOffset + 89], mem[InstOffset + 88]}=32'h00000073; //add x0, x0, x0 
//{mem[InstOffset + 95], mem[InstOffset + 94], mem[InstOffset + 93], mem[InstOffset + 92]}=32'h0012ca17; //add x0, x0, x0 
//{mem[InstOffset + 99], mem[InstOffset + 98], mem[InstOffset + 97], mem[InstOffset + 96]}=32'h00100023; //add x0, x0, x0 

{mem[InstOffset+3],mem[InstOffset+2],mem[InstOffset+1],mem[InstOffset+0]}=32'b0000000_00000_00000_000_00000_0110011;
{mem[InstOffset+5],mem[InstOffset+4]}= 16'b010_0_01000_00100_01; // li x8, 4 --> x8 = 4
{mem[InstOffset+7],mem[InstOffset+6]}= 16'b010_000_000_00_001_00; // lw x9, 0(x8) --> x9 = 112
{mem[InstOffset+9],mem[InstOffset+8]}= 16'b000_0_01001_01010_01; // ADDI x9, 10 --> x9 = 122
{mem[InstOffset+11],mem[InstOffset+10]}=16'b110_000_000_10_001_00; // SW x9, 4(x8) --> mem[8] = 122
{mem[InstOffset+13],mem[InstOffset+12]}=16'b101_00000000100_01; // j 4
{mem[InstOffset+15],mem[InstOffset+14]}=16'b000_0_01001_01010_01; // ADDI x9, 10 --> skipped
{mem[InstOffset+17],mem[InstOffset+16]}=16'b100_0_00010_01001_10; // mv x2, x9 --> x2 = 122
{mem[InstOffset+21],mem[InstOffset+20],mem[InstOffset+19],mem[InstOffset+18]}=32'h03717193; // (not comp) andi x3, x2, 55 --> x3= 50
//{mem[InstOffset+23],mem[InstOffset+22]}=16'b100_1_01000_00010_10; // add x8, x8, x2 --> x8 = 126
//{mem[InstOffset+7+200],mem[InstOffset+6+200],mem[InstOffset+5+200],mem[InstOffset+4+200]}=32'd112;
//{mem[InstOffset + 103], mem[InstOffset + 102], mem[InstOffset + 101], mem[InstOffset + 100]}=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2 
//{mem[InstOffset + 107], mem[InstOffset + 106], mem[InstOffset + 105], mem[InstOffset + 104]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0 
//{mem[InstOffset + 111], mem[InstOffset + 110], mem[InstOffset + 109], mem[InstOffset + 108]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0 
//{mem[InstOffset + 115], mem[InstOffset + 114], mem[InstOffset + 113], mem[InstOffset + 112]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0 
//{mem[InstOffset + 119], mem[InstOffset + 118], mem[InstOffset + 117], mem[InstOffset + 116]}=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)   
//{mem[InstOffset + 123], mem[InstOffset + 122], mem[InstOffset + 121], mem[InstOffset + 120]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0 
//{mem[InstOffset + 127], mem[InstOffset + 126], mem[InstOffset + 125], mem[InstOffset + 124]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0 
//{mem[InstOffset + 131], mem[InstOffset + 130], mem[InstOffset + 129], mem[InstOffset + 128]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0 
//{mem[InstOffset + 135], mem[InstOffset + 134], mem[InstOffset + 133], mem[InstOffset + 132]}=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)   
//{mem[InstOffset + 139], mem[InstOffset + 138], mem[InstOffset + 137], mem[InstOffset + 136]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0 
//{mem[InstOffset + 143], mem[InstOffset + 142], mem[InstOffset + 141], mem[InstOffset + 140]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0 
//{mem[InstOffset + 147], mem[InstOffset + 146], mem[InstOffset + 145], mem[InstOffset + 144]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0 
//{mem[InstOffset + 151], mem[InstOffset + 150], mem[InstOffset + 149], mem[InstOffset + 148]}=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1 
//{mem[InstOffset + 155], mem[InstOffset + 154], mem[InstOffset + 153], mem[InstOffset + 152]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0  
//{mem[InstOffset + 159], mem[InstOffset + 158], mem[InstOffset + 157], mem[InstOffset + 156]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0 
//{mem[InstOffset + 163], mem[InstOffset + 162], mem[InstOffset + 161], mem[InstOffset + 160]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0 
//{mem[InstOffset + 167], mem[InstOffset + 166], mem[InstOffset + 165], mem[InstOffset + 164]}=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2 
//{mem[InstOffset + 171], mem[InstOffset + 170], mem[InstOffset + 169], mem[InstOffset + 168]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0  
//{mem[InstOffset + 175], mem[InstOffset + 174], mem[InstOffset + 173], mem[InstOffset + 172]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0 
//{mem[InstOffset + 179], mem[InstOffset + 178], mem[InstOffset + 177], mem[InstOffset + 176]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0 
//{mem[InstOffset + 183], mem[InstOffset + 182], mem[InstOffset + 181], mem[InstOffset + 180]}=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2 
//{mem[InstOffset + 187], mem[InstOffset + 186], mem[InstOffset + 185], mem[InstOffset + 184]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0  
//{mem[InstOffset + 191], mem[InstOffset + 190], mem[InstOffset + 189], mem[InstOffset + 188]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0 
//{mem[InstOffset + 195], mem[InstOffset + 194], mem[InstOffset + 193], mem[InstOffset + 192]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0 
//{mem[InstOffset + 199], mem[InstOffset + 198], mem[InstOffset + 197], mem[InstOffset + 196]}=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1
end
endmodule
