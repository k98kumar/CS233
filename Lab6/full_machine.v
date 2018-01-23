// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst, PC, nextPC, rsData, rtData, B, out, imm32, // Old wires
                toPC_0, toPC_1, branch_offset, jump, addr, negzero, zeroadd, // New wires
                slt_out, mr_out, bl_out, rdData, B_out, addm_out, data_out, mr_in, lui_1, bl_in_change; // New module outputs
    wire [7:0] bl_in;
    wire [4:0] Rdest;
    wire [2:0] alu_op;
    wire [1:0] control_type;
    wire wr_enable, alu_src2, rd_src, lui, slt, byte_load, word_we, byte_we, mem_read, addm;
    wire overflow, zero, negative;

    reg [31:0] i;

    /* add other modules */

    assign jump[31:28] = PC[31:28];
    assign jump[1] = 0;
    assign jump[0] = 0;
    assign jump[27:2] = inst[25:0];

    // initial
    // begin
    //     for (i = 1 ; i < 32 ; i = i + 1 )
    //     begin
    //         negzero[i] <= 0;
    //     end
    // end
    // assign negzero[0] = negative;

    assign zeroadd[31:0] = {32{1'b0}};

    assign negzero[31:1] = {31{1'b0}};
    assign negzero[0] = negative;

    // initial
    // begin
    //     for (i = 0 ; i < 32 ; i = i + 1 )
    //     begin
    //         zeroadd[i] <= 0;
    //     end
    // end

    assign lui_1[31:16] = inst[15:0];
    assign lui_1[15:0]  = zeroadd[15:0];

    assign bl_in_change[7:0]  = bl_in;
    assign bl_in_change[31:8] = zeroadd[31:8];

    // DO NOT comment out or rename these modules or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1'b1, reset);
    instruction_memory im(inst, PC[31:2]);
    regfile rf (rsData, rtData, inst[25:21], inst[20:16], Rdest, rdData, wr_enable, clock, reset);
    // DO NOT comment out or rename these modules or the test bench will break

    alu32 #(32) regAlu(toPC_0, , , , PC, 32'b100, 3'b010);
    alu32 #(32) aluToAlu(toPC_1, , , , toPC_0, branch_offset, 3'b010);
    alu32 #(32) endAlu(out, overflow, zero, negative, rsData, B_out, alu_op);
    alu32 #(32) addmAlu(addm_out, , , , rtData, data_out, 3'b010);

    mux2v #(5)  m2v_rf_in(Rdest, inst[15:11], inst[20:16], rd_src);
    mux2v #(32) m2v_rf_out(B, rtData, imm32, alu_src2);
    mux2v #(32) m2v_slt_out(slt_out, out, negzero, slt);
    mux2v #(32) m2v_mem_read(mr_out, slt_out, mr_in, mem_read);
    mux2v #(32) m2v_byte_load(bl_out, data_out, bl_in_change, byte_load);
    mux2v #(32) m2v_rf_rdData(rdData, mr_out, lui_1, lui);
    mux2v #(32) m2v_addm(B_out, B, zeroadd, addm);
    mux2v #(32) m2v_bl_mr(mr_in, bl_out, addm_out, addm);

    mux4v #(32) m4toPC(nextPC, toPC_0, toPC_1, jump, rsData, control_type);
    mux4v #(8)  m4dataOut(bl_in, data_out[31:24], data_out[23:16], data_out[15:8], data_out[7:0], out[1:0]);

    sign_extender se(imm32, inst[15:0]);
    shift_left_2 sl2(branch_offset, imm32[29:0]);
    mips_decode md(alu_op, wr_enable, rd_src, alu_src2, except, control_type, mem_read, word_we, byte_we, byte_load, lui, slt, addm, inst[31:26], inst[5:0], zero);
    data_mem dm(data_out, out, rtData, word_we, byte_we, clock, reset);

endmodule // full_machine

module sign_extender(out, in);
    output [31:0] out;
    input  [15:0] in;

    assign out[15:0]  = in[15:0];
    assign out[31:16] = {16{in[15]}};

endmodule // sign_extender

module shift_left_2(out, in);
    output [31:0] out;
    input  [29:0] in;

    assign out[31:2] = in[29:0];
    assign out[1] = 0;
    assign out[0] = 0;

endmodule //shift_left_2
