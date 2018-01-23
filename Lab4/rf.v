// register: A register which may be reset to an arbirary value
//
// q      (output) - Current value of register
// d      (input)  - Next value of register
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset    (reset = 1)
//
module register(q, d, clk, enable, reset);

    parameter
        width = 32,
        reset_value = 0;
 
    output [(width-1):0] q;
    reg    [(width-1):0] q;
    input  [(width-1):0] d;
    input                clk, enable, reset;
 
    always@(reset)
      if (reset == 1'b1)
        q <= reset_value;
 
    always@(posedge clk)
      if ((reset == 1'b0) && (enable == 1'b1))
        q <= d;

endmodule // register

module decoder2 (out, in, enable);
    input     in;
    input     enable;
    output [1:0] out;
 
    and a0(out[0], enable, ~in);
    and a1(out[1], enable, in);
endmodule // decoder2

module decoder4 (out, in, enable);
    input [1:0]    in;
    input     enable;
    output [3:0]   out;
    wire [1:0]    w_enable;
 
    // implement using decoder2's
    decoder2 d2_4(w_enable, in[1], enable);
    decoder2 d2_a(out[1:0], in[0], w_enable[0]);
    decoder2 d2_b(out[3:2], in[0], w_enable[1]);
    
endmodule // decoder4

module decoder8 (out, in, enable);
    input [2:0]    in;
    input     enable;
    output [7:0]   out;
    wire [1:0]    w_enable;
 
    // implement using decoder2's and decoder4's
    decoder2 d2_8(w_enable, in[2], enable);
    decoder4 d4_a(out[3:0], in[1:0], w_enable[0]);
    decoder4 d4_b(out[7:4], in[1:0], w_enable[1]);
 
endmodule // decoder8

module decoder16 (out, in, enable);
    input [3:0]    in;
    input     enable;
    output [15:0]  out;
    wire [1:0]    w_enable;
 
    // implement using decoder2's and decoder8's
    decoder2 d2_16(w_enable, in[3], enable);
    decoder8 d8_a(out[7:0], in[2:0], w_enable[0]);
    decoder8 d8_b(out[15:8], in[2:0], w_enable[1]);

endmodule // decoder16

module decoder32 (out, in, enable);
    input [4:0]    in;
    input     enable;
    output [31:0]  out;
    wire [1:0]    w_enable;
 
    // implement using decoder2's and decoder16's
    decoder2 d2_32(w_enable, in[4], enable);
    decoder16 d16_a(out[15:0], in[3:0], w_enable[0]);
    decoder16 d16_b(out[31:16], in[3:0], w_enable[1]);
 
endmodule // decoder32

module mips_regfile (rd1_data, rd2_data, rd1_regnum, rd2_regnum, 
             wr_regnum, wr_data, writeenable, 
             clock, reset);

    output [31:0]  rd1_data, rd2_data;
    input   [4:0]  rd1_regnum, rd2_regnum, wr_regnum;
    input  [31:0]  wr_data;
    input          writeenable, clock, reset;
 
    // build a register file!
    wire [31:0] decoder_out;
    decoder32 d(decoder_out, wr_regnum, writeenable);
    
    wire [31:0] w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, w21, w22, w23, w24, w25, w26, w27, w28, w29, w30, w31;
    register r1(w1, wr_data, clock, decoder_out[1], reset);
    register r2(w2, wr_data, clock, decoder_out[2], reset);
    register r3(w3, wr_data, clock, decoder_out[3], reset);
    register r4(w4, wr_data, clock, decoder_out[4], reset);
    register r5(w5, wr_data, clock, decoder_out[5], reset);
    register r6(w6, wr_data, clock, decoder_out[6], reset);
    register r7(w7, wr_data, clock, decoder_out[7], reset);
    register r8(w8, wr_data, clock, decoder_out[8], reset);
    register r9(w9, wr_data, clock, decoder_out[9], reset);
    register r10(w10, wr_data, clock, decoder_out[10], reset);
    register r11(w11, wr_data, clock, decoder_out[11], reset);
    register r12(w12, wr_data, clock, decoder_out[12], reset);
    register r13(w13, wr_data, clock, decoder_out[13], reset);
    register r14(w14, wr_data, clock, decoder_out[14], reset);
    register r15(w15, wr_data, clock, decoder_out[15], reset);
    register r16(w16, wr_data, clock, decoder_out[16], reset);
    register r17(w17, wr_data, clock, decoder_out[17], reset);
    register r18(w18, wr_data, clock, decoder_out[18], reset);
    register r19(w19, wr_data, clock, decoder_out[19], reset);
    register r20(w20, wr_data, clock, decoder_out[20], reset);
    register r21(w21, wr_data, clock, decoder_out[21], reset);
    register r22(w22, wr_data, clock, decoder_out[22], reset);
    register r23(w23, wr_data, clock, decoder_out[23], reset);
    register r24(w24, wr_data, clock, decoder_out[24], reset);
    register r25(w25, wr_data, clock, decoder_out[25], reset);
    register r26(w26, wr_data, clock, decoder_out[26], reset);
    register r27(w27, wr_data, clock, decoder_out[27], reset);
    register r28(w28, wr_data, clock, decoder_out[28], reset);
    register r29(w29, wr_data, clock, decoder_out[29], reset);
    register r30(w30, wr_data, clock, decoder_out[30], reset);
    register r31(w31, wr_data, clock, decoder_out[31], reset);
    mux32v m32_a(rd1_data, 1'b0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, w21, w22, w23, w24, w25, w26, w27, w28, w29, w30, w31, rd1_regnum);
    mux32v m32_b(rd2_data, 1'b0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, w21, w22, w23, w24, w25, w26, w27, w28, w29, w30, w31, rd2_regnum);
    
endmodule // mips_regfile

