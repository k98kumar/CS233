// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// lui          (output) - the instruction is a lui
// slt          (output) - the instruction is an slt
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, lui, slt, addm,
                   opcode, funct, zero);
    output [2:0] alu_op; // Used in last lab
    output       writeenable, rd_src, alu_src2, except; // Used in last lab
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, lui, slt, addm;
    input  [5:0] opcode, funct; // Used in last lab
    input        zero;

    wire add, sub, and_, or_, nor_, xor_, addi, andi, ori, xori;
    wire bne, beq, j, jr, lw, lbu, sw, sb;

    assign add =  ((opcode == `OP_OTHER0) & (funct == `OP0_ADD));
    assign sub =  ((opcode == `OP_OTHER0) & (funct == `OP0_SUB));
    assign and_ = ((opcode == `OP_OTHER0) & (funct == `OP0_AND));
    assign or_ =  ((opcode == `OP_OTHER0) & (funct == `OP0_OR));
    assign nor_ = ((opcode == `OP_OTHER0) & (funct == `OP0_NOR));
    assign xor_ = ((opcode == `OP_OTHER0) & (funct == `OP0_XOR));
    assign addi = (opcode == `OP_ADDI);
    assign andi = (opcode == `OP_ANDI);
    assign ori =  (opcode == `OP_ORI);
    assign xori = (opcode == `OP_XORI);

    assign alu_op[0] = (sub | or_ | xor_ | ori | xori | bne | beq | slt);
    assign alu_op[1] = (add | sub | nor_ | xor_ | addi | xori | bne | beq | lw | lbu | sw | sb | slt | addm);
    assign alu_op[2] = (and_ | or_ | nor_ | xor_ | andi | ori | xori);

    assign writeenable = (add | sub | and_ | or_ | nor_ | xor_ | addi | andi | ori | xori | bne | beq | j | jr | lw | lbu | sw | sb | lui | slt | addm);
    assign rd_src = (addi | andi | ori | xori | lw | lbu | lui);
    assign alu_src2 = (addi | andi | ori | xori | lw | lbu | sw | sb);
    assign except = (add | sub | and_ | or_ | nor_ | xor_ | addi | andi | ori | xori | lw | lbu | lui | slt | addm);

    assign bne = (opcode == `OP_BNE);
    assign beq = (opcode == `OP_BEQ);
    assign j = (opcode == `OP_J);
    assign jr = ((opcode == `OP_OTHER0) & (funct == `OP0_JR));
    assign lw = (opcode == `OP_LW);
    assign lbu = (opcode == `OP_LBU);
    assign sw = (opcode == `OP_SW);
    assign sb = (opcode == `OP_SB);

    assign lui = (opcode == `OP_LUI);
    assign slt = ((opcode == `OP_OTHER0) & (funct == `OP0_SLT));
    assign addm = ((opcode == `OP_OTHER0) & (funct == `OP0_ADDM));
    assign mem_read = (lw|lbu);
    assign word_we = sw;
    assign byte_we = sb;
    assign byte_load = lbu;
    assign control_type[0] = ((beq&zero) | (bne& ~zero) | jr);
    assign control_type[1] = (j | jr);

endmodule // mips_decode
