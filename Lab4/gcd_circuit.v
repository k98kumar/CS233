// GCD datapath
module gcd_circuit(out, x_lt_y, x_ne_y, X, Y, x_sel, y_sel, x_en, y_en, output_en, clock, reset);
	output  [31:0] out;
	output  x_lt_y, x_ne_y;
	input	[31:0]	X, Y;
	input   x_sel, y_sel, x_en, y_en, output_en, clock, reset;

    // IMPLEMENT gcd_circuit HERE

    // wire w_ma_rx, w_mb_ry, w_rx_sa, w_ry_sb, w_sa_ma, w_sb_mb;
    wire [31:0] w_ma_rx, w_mb_ry, w_sa_ma, w_sb_mb, w_rx_sa, w_ry_sb;

    mux2v m2a(w_ma_rx, X, w_sa_ma, x_sel);
    mux2v m2b(w_mb_ry, Y, w_sb_mb, y_sel);

    register tmp_x(w_rx_sa, w_ma_rx, clock, x_en, reset);
    register tmp_y(w_ry_sb, w_mb_ry, clock, y_en, reset);

    subtractor sub_a(w_sa_ma, w_rx_sa, w_ry_sb);
    subtractor sub_b(w_sb_mb, w_ry_sb, w_rx_sa);

    comparator comp(x_lt_y, x_ne_y, w_rx_sa, w_ry_sb);

    register reg_a(out, w_rx_sa, clock, output_en, reset);

endmodule // gcd_circuit
