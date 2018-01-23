// 00 - AND, 01 - OR, 10 - NOR, 11 - XOR
module logicunit(out, A, B, control);
    output      out;
    input       A, B;
    input [1:0] control;
    wire		mca, mco, mcn, mcx;

    and a1(mca, A, B);
    or o1(mco, A, B);
    nor n1(mcn, A, B);
    xor x1(mcx, A, B);

    mux4 m4a(out, mca, mco, mcn, mcx, control);

endmodule // logicunit
