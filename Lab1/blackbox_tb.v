module blackbox_test;

	reg v_in, i_in, h_in;
	wire f_out;
	blackbox bb1(f_out, v_in, i_in, h_in);

	initial begin
		$dumpfile("blackbox.vcd");
		$dumpvars(0,blackbox_test);

		v_in = 0; i_in = 0; h_in = 0; # 10;
		v_in = 0; i_in = 0; h_in = 1; # 10;
		v_in = 0; i_in = 1; h_in = 0; # 10;
		v_in = 0; i_in = 1; h_in = 1; # 10;
		v_in = 1; i_in = 0; h_in = 0; # 10;
		v_in = 1; i_in = 0; h_in = 1; # 10;
		v_in = 1; i_in = 1; h_in = 0; # 10;
		v_in = 1; i_in = 1; h_in = 1; # 10;

		$finish;
	end

	initial
		$monitor("At time %2t, v_in = %d i_in = %d h_in = %d f_out = %d",
                 $time, v_in, i_in, h_in, f_out);

endmodule // blackbox_test
