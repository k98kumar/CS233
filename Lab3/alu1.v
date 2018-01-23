module full_adder(sum, cout, a, b, cin);
    output sum, cout;
    input  a, b, cin;
    wire   partial_s, partial_c1, partial_c2;

    xor x0(partial_s, a, b);
    xor x1(sum, partial_s, cin);
    and a0(partial_c1, a, b);
    and a1(partial_c2, partial_s, cin);
    or  o1(cout, partial_c1, partial_c2);
endmodule // full_adder

`define ALU_ADD    3'h2
`define ALU_SUB    3'h3
`define ALU_AND    3'h4
`define ALU_OR     3'h5
`define ALU_NOR    3'h6
`define ALU_XOR    3'h7

// 01x - arithmetic, 1xx - logic
module alu1(out, carryout, A, B, carryin, control);
    output      out, carryout;
    input       A, B, carryin;
    input [2:0] control;
    wire sum_adder_out, xor_adder_in, logic_out;

    // add code here!!!
    xor x1(xor_adder_in, B, control[0]);
    full_adder fa(sum_adder_out, carryout, A, xor_adder_in, carryin);
    logicunit lu(logic_out, A, B, control[1:0]);
    mux2 m(out, sum_adder_out, logic_out, control[2]);

endmodule // alu1
