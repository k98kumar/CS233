// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst, PC, nextPC, rsData, rtData, B, out, imm32;
    wire [4:0] Rdest;
    wire [2:0] alu_op;
    wire wr_enable, alu_src2, rd_src, overflow, zero, negative;

    // DO NOT comment out or rename this module or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1'b1, reset);

    // DO NOT comment out or rename this module or the test bench will break
    instruction_memory im(inst, PC[31:2]);

    // DO NOT comment out or rename this module or the test bench will break
    regfile rf (rsData, rtData, inst[25:21], inst[20:16], Rdest, out, wr_enable, clock, reset);

    /* add other modules */
    alu32 #(32) regAlu(nextPC, , , , PC, 32'b100, 3'b010);
    sign_extender se(imm32, inst[15:0]);
    mips_decode md(alu_op, wr_enable, rd_src, alu_src2, except, inst[31:26], inst[5:0]);
    mux2v #(5) m2vrfin(Rdest, inst[15:11], inst[20:16], rd_src);
    mux2v #(32) m2vrfout(B, rtData, imm32, alu_src2);
    alu32 #(32) endAlu(out, overflow, zero, negative, rsData, B, alu_op);
   
endmodule // arith_machine


module sign_extender(out, in);
    output [31:0] out;
    input  [15:0] in;

    assign out[15:0] = in[15:0];
    assign out[16]   = in[15];
    assign out[17]   = in[15];
    assign out[18]   = in[15];
    assign out[19]   = in[15];
    assign out[20]   = in[15];
    assign out[21]   = in[15];
    assign out[22]   = in[15];
    assign out[23]   = in[15];
    assign out[24]   = in[15];
    assign out[25]   = in[15];
    assign out[26]   = in[15];
    assign out[27]   = in[15];
    assign out[28]   = in[15];
    assign out[29]   = in[15];
    assign out[30]   = in[15];
    assign out[31]   = in[15];

endmodule // sign_extender
