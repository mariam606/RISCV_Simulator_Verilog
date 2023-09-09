module prv32_ALU(
	input   wire [31:0] a, b,
	input   wire [31:0]  shamt,
	output  reg  [31:0] r,
	output  wire        cf, zf, vf, sf,
	input   wire [4:0]  alufn
);

    wire [31:0] add, sub, op_b;
    wire cfa, cfs;
    //M extension
   wire [63:0] product_unsigned = a*b;
   wire [63:0] product_signed = $signed(a)*$signed(b);
   wire [63:0] product_su = $signed(a)*$signed({1'b0, b});
   
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b);
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
    
    wire[31:0] sh;
    shifter shifter0(.a(a), .shamt(shamt), .type(alufn[1:0]),  .r(sh));
    
    always @ * begin
        r = 0;
        (* parallel_case *)
        case (alufn)
            // arithmetic
            5'b000_00 : r = add;
            5'b000_01 : r = add;
            5'b000_11 : r = b;
            // logic
            5'b001_00:  r = a | b;
            5'b001_01:  r = a & b;
            5'b001_11:  r = a ^ b;
            // shift
            5'b010_00:  r=sh;
            5'b010_01:  r=sh;
            5'b010_10:  r=sh;
            //shift imm 
            
            // slt & sltu
            5'b011_01:  r = {31'b0,(sf != vf)}; 
            5'b011_11:  r = {31'b0,(~cf)};
            //lw 0010 
            5'b00010: r= add;    
            //M extension
            `ALU_MUL:  r = product_unsigned[31:0];
            `ALU_MULH: r = product_signed[63:32];
            `ALU_MULHU: r = product_unsigned[63:32]; 
            `ALU_MULHSU: r = product_su[63:32];
            
            
            `ALU_DIV: begin
             if(b == 32'd0)r = -1;
             else r = $signed(a)/$signed(b);
             end
            `ALU_DIVU: begin
             if(b == 32'd0)r = -1;
             else r = a/b;
             end 
             
             `ALU_REM: begin
             if(b == 32'b1) r = 0;
             else r = $signed(a)%$signed(b);
             end
            `ALU_REMU: r =  a%b;         
        endcase
    end
endmodule