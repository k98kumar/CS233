module gcd_control(done, x_sel, y_sel, x_en, y_en, output_en, go, x_lt_y, x_ne_y, clock, reset);
	output	x_sel, y_sel, x_en, y_en, output_en, done;
	input	go, x_lt_y, x_ne_y;
	input	clock, reset;

	// IMPLEMENT YOUR STATE MACHINE HERE
    // W = wait  | x = x < y    | d = done
    // S = start | y = !(x < y) |
    // x_sel = x|y | x_en = x_lt_y | output_en = d
    // y_sel = x|y | y_en = x_lt_y | done = d

    wire w, s, x, y, d, tw, ts, tx, ty, td;
    assign tw = ((d | w) & ~go) | reset;
    assign ts = (w & go);
    assign tx = (s & x_lt_y & x_ne_y) | ((x | y) & x_lt_y);
    assign ty = (s & x_lt_y & ~x_ne_y) | ((x | y) & ~x_lt_y);
    assign td = ((s | x | y) & ~x_ne_y) | (d & go);

    dffe dw(w, tw, clock, 1'd1, reset);
    dffe dx(x, tx, clock, 1'd1, reset);
    dffe dy(y, ty, clock, 1'd1, reset);
    dffe ds(s, ts, clock, 1'd1, reset);
    dffe dd(d, td, clock, 1'd1, reset);

    assign x_sel = (x | y);
    assign y_sel = (x | y);
    assign x_en = ((~x_lt_y | s) & d); // Might be d instead of done
    assign y_en = ((x_lt_y | s) & d); // Might be d instead of done
    assign output_en = ~x_ne_y;
    assign done = d;

endmodule //GCD_control
