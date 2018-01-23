module alu1_test;
    // exhaustively test your 1-bit ALU by adapting mux4_tb.v
    reg A = 0;
    always #1 A = !A;
    reg B = 0;
    always #2 B = !B;
    reg C = 0;
    always #4 C = !C;
     
    reg [2:0] control = 0;
     
    initial begin
        $dumpfile("alu1.vcd");
        $dumpvars(0, alu1_test);

        // control is initially 0
        # 16 control = 3'h1; // wait 16 time units (why 16?) and then set it to 1
        # 16 control = 3'h2; // wait 16 time units and then set it to 2
        # 16 control = 3'h3; // wait 16 time units and then set it to 3
        # 16 control = 3'h4; // wait 16 time units and then set it to 4
        # 16 control = 3'h5; // wait 16 time units and then set it to 5
        # 16 control = 3'h6; // wait 16 time units and then set it to 6
        # 16 control = 3'h7; // wait 16 time units and then set it to 7
        # 16 $finish; // wait 16 time units and then end the simulation
    end

    wire out;
    alu1 al(out, carryout, A, B, C, control);

    // you really should be using gtkwave instead
    /*
    initial begin
        $display("A B C D s o");
        $monitor("%d %d %d %d %d %d (at time %t)", A, B, C, D, control, out, $time);
    end
    */
endmodule
