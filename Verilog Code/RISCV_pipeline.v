`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2022 06:12:46 PM
// Design Name: 
// Module Name: RISCV_pipeline
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

//ollalalas
module RISCV_pipeline (input clk,input rst,input[1:0]ledSel, input[3:0]ssdSel,input SSD_clk,output [6:0]leds, output [3:0]Anode, output  [15:0] out_LED);
// PC wires
//reg [31:0] PC;
wire compressed;
reg [15:0] temp;
reg [31:0]initial_IR;
wire [31:0] PC, IF_ID_Inst_in, branch_pc, IR;
reg[6:0]ssdOut;
wire[31:0] next_pc, pc_plus4;
wire flush = (EX_MEM_out_sig&EX_MEM_branch) | (EX_MEM_jump_sel == 2'b01) | (EX_MEM_jump_sel == 2'b10);
reg load;
wire reset_PC, freeze;
//IF_ID wire
wire [31:0] write_data, read_data1, read_data2;
wire [31:0] Immediate;
wire branch, memRead, memWrite, ALUSrc, regWrite;
wire[2:0] memToReg;
wire [1:0]  ALUOp, jump_sel;
wire [31:0] IF_ID_PC, IF_ID_Inst, IF_ID_pc_plus4;
wire [11:0] temp_ctrl_out;

//ID_EX wire
wire [31:0] ALU_input2, ALU_input1, ALUOutput, ALU_input2_tmp;
wire [4:0] ALUSelection;
wire zf, cf, vf, sf, output_signal;
wire[31:0] PC_target, ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, ID_EX_pc_plus4; 
wire ID_EX_regWrite, ID_EX_branch, ID_EX_memRead, ID_EX_memWrite, ID_EX_ALUsrc;
wire[1:0] ID_EX_ALUOp, ID_EX_jump_sel;
wire[2:0] ID_EX_memToReg;
wire [3:0] ID_EX_Func;
wire [4:0] ID_EX_Rd;
wire[8:0] ID_EX_controls;
//Forwarding unit 
wire [4:0] ID_EX_RS1, ID_EX_RS2;
wire [1:0] forwardA, forwardB;

//EX_MEM wires
wire [31:0] mem_data_out, MEM_WB_BranchAddOut;
wire [8:0] mem_adddres;
wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Imm, EX_MEM_pc_plus4;
wire [4:0] EX_MEM_Rd;
wire EX_MEM_out_sig;
wire EX_MEM_regWrite, EX_MEM_branch, EX_MEM_memRead, EX_MEM_memWrite;
wire[2:0] EX_MEM_memToReg;
wire[1:0] EX_MEM_jump_sel;
wire[3:0] EX_MEM_Func;

//MEM_WB wires
wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Imm, MEM_WB_pc_plus4;
wire [4:0] MEM_WB_Rd;
wire MEM_WB_regWrite;
wire[2:0] MEM_WB_memToReg;

//Termination 
always@(*)begin
    if(slow_clk)begin
        initial_IR = mem_data_out;
    end
    else begin
        initial_IR =initial_IR;
    end
end
//assign compressed = (rst?0:compressed);
//assign initial_IR = (rst?32'b11:slow_clk?mem_data_out:initial_IR);
Terminate TR(slow_clk, mem_data_out,freeze,reset_PC);
decompression_unit dec(rst, initial_IR, IR, compressed);
//assign pc_plus4 = compressed? PC + 2: PC + 4;

always@(*)
begin
    if(freeze)
        load=1'b0;
    else 
        load=1'b1;  
end
//assign next_pc=(reset_PC ? 32'b0:next_pc);
//PC Update stage
//clockDivider clkDiv(clk,rst,slow_clk);
assign slow_clk =clk;
adder PC_adder(PC, (compressed?32'd2:32'd4), pc_plus4); 
n_bit_mux #(32) PC_mux(pc_plus4, EX_MEM_BranchAddOut, EX_MEM_out_sig&EX_MEM_branch, branch_pc);
jump_mux JM(reset_PC, branch_pc, EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_jump_sel, next_pc); //0 -> not jumping, 01-> JAL, 10->JALR
nbit_reg regPC(slow_clk, rst, load, next_pc, PC);
//IF_ID reg
nbit_reg #(96) IF_ID(!slow_clk,rst,1'b1,
 {PC, IR, pc_plus4},
 {IF_ID_PC,IF_ID_Inst, IF_ID_pc_plus4});

//Decoding stage
control_unit cu(IF_ID_Inst, jump_sel, branch, memRead, memToReg, memWrite,  ALUSrc, regWrite, ALUOp);
RegFile RF(IF_ID_Inst[19:15], IF_ID_Inst[24:20],MEM_WB_Rd, MEM_WB_regWrite, write_data, !slow_clk, rst,read_data1, read_data2);
rv32_ImmGen IG(IF_ID_Inst, Immediate);
n_bit_mux #(12) control_mux({regWrite, memToReg, branch, memRead, memWrite, ALUSrc, ALUOp, jump_sel},12'b0, flush, temp_ctrl_out);
//ID_EX reg
nbit_reg #(191) ID_EX (slow_clk,rst,1'b1,
{temp_ctrl_out, IF_ID_PC, read_data1, read_data2, Immediate, IF_ID_Inst[14:12], IF_ID_Inst[30], IF_ID_Inst[11:7], IF_ID_pc_plus4, IF_ID_Inst[19:15], IF_ID_Inst[24:20]}, 
{ID_EX_regWrite, ID_EX_memToReg, ID_EX_branch, ID_EX_memRead, ID_EX_memWrite, ID_EX_ALUsrc, ID_EX_ALUOp, ID_EX_jump_sel, ID_EX_PC ,ID_EX_RegR1,ID_EX_RegR2, ID_EX_Imm, ID_EX_Func,ID_EX_Rd, ID_EX_pc_plus4, ID_EX_RS1, ID_EX_RS2} );

//Execution stage
adder target_address(ID_EX_PC, ID_EX_Imm, PC_target);
ALU_control ALUCU(ID_EX_ALUOp, ID_EX_Func[3:1], IF_ID_Inst[25], ID_EX_Func[0], ALUSelection);
mux_4X1 ALU_in1(ID_EX_RegR1, EX_MEM_ALU_out, write_data, forwardA, ALU_input1);
mux_4X1 ALU_in2(ID_EX_RegR2, EX_MEM_ALU_out, write_data, forwardB, ALU_input2_tmp);
n_bit_mux ALU_mux(ALU_input2_tmp, ID_EX_Imm, ID_EX_ALUsrc, ALU_input2);
prv32_ALU ALU(.a(ALU_input1), .b(ALU_input2), .shamt(ALU_input2), .r(ALUOutput), .cf(cf), .zf(zf), .vf(vf), .sf(sf), .alufn(ALUSelection));
branch_control BC(ID_EX_Func[3:1], zf, cf, vf, sf, output_signal);
forwarding_unit FW(ID_EX_RS1, ID_EX_RS2, EX_MEM_Rd, MEM_WB_Rd, EX_MEM_regWrite, MEM_WB_regWrite, forwardA, forwardB);
//EX_MEM reg
nbit_reg #(179) EX_MEM (!slow_clk,rst,1'b1,
 {ID_EX_regWrite, ID_EX_memToReg, ID_EX_branch, ID_EX_memRead, ID_EX_memWrite, ID_EX_jump_sel, PC_target, output_signal, ALUOutput, ALU_input2_tmp,  ID_EX_Rd, ID_EX_Imm, ID_EX_pc_plus4, ID_EX_Func},
 {EX_MEM_regWrite, EX_MEM_memToReg, EX_MEM_branch, EX_MEM_memRead, EX_MEM_memWrite, EX_MEM_jump_sel, EX_MEM_BranchAddOut, EX_MEM_out_sig, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd, EX_MEM_Imm, EX_MEM_pc_plus4, EX_MEM_Func} );
 
//Memory stage
 n_bit_mux #(9)mem_mux(EX_MEM_ALU_out[8:0], PC[8:0], slow_clk, mem_adddres);
 single_memory SM(slow_clk,1'b1, EX_MEM_memWrite, mem_adddres,EX_MEM_Func[3:1], EX_MEM_RegR2, mem_data_out);
//MEM_WB reg
nbit_reg #(169) MEM_WB (slow_clk,rst,1'b1,
 {EX_MEM_regWrite, EX_MEM_memToReg, mem_data_out, EX_MEM_ALU_out, EX_MEM_Rd, EX_MEM_Imm, EX_MEM_BranchAddOut, EX_MEM_pc_plus4},
 {MEM_WB_regWrite, MEM_WB_memToReg, MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Rd, MEM_WB_Imm, MEM_WB_BranchAddOut, MEM_WB_pc_plus4});
 
// Write Back stage
 reg_mux RM(MEM_WB_ALU_out, MEM_WB_Mem_out, MEM_WB_BranchAddOut, MEM_WB_pc_plus4, MEM_WB_Imm, MEM_WB_memToReg, write_data); //000->R-type, 001->LW&SW, 010->AUIPC, 011->JAL & JALR, 111->LUI


always @(*)
begin
	if(ledSel == 2'b00)
		temp = mem_data_out[15:0];
	else if(ledSel == 2'b01)
		temp = mem_data_out[31:16];
	else if(ledSel == 2'b10)
		temp= {8'b00000000, ALUOp, ALUSelection, output_signal, output_signal&branch};
end

always @(*) begin
    if(ssdSel == 4'b0000)
        ssdOut = PC;
    else if(ssdSel == 4'b0001)
        ssdOut = PC + 1;
    else if(ssdSel == 4'b0010)
        ssdOut = PC_target;
    else if(ssdSel == 4'b0011)
        ssdOut = next_pc;
    else if(ssdSel == 4'b0100)
        ssdOut = read_data1;
    else if(ssdSel == 4'b0101)
        ssdOut = read_data2;
    else if(ssdSel == 4'b0110)
        ssdOut = write_data;
    else if(ssdSel == 4'b0111)
        ssdOut = Immediate;
    else if(ssdSel == 4'b1000)
        ssdOut = Immediate;
    else if(ssdSel == 4'b1001)
        ssdOut = ALU_input2;
    else if(ssdSel == 4'b1010)
        ssdOut = ALUOutput;
    else if(ssdSel == 4'b1011)
        ssdOut = mem_data_out;
     else ssdOut =7'b1111111;
end
assign out_LED=temp;
seven_seg s(.clk(SSD_clk), .num(ssdOut), .Anode(Anode), .LED_out(leds));

endmodule