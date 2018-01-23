module alu32_test;
    reg [31:0] A = 0, B = 0;
    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, alu32_test);

             A = 8; B = 4; control = `ALU_ADD; // try adding 8 and 4
        # 10 A = 2; B = 5; control = `ALU_SUB; // try subtracting 5 from 2
        // add more test cases here!
        # 10 A = 8; B = 9; control = `ALU_AND; // try "and"ing 8 and 9
        # 10 A = 9; B = 10; control = `ALU_OR; // try "or"ing 9 and 10
        # 10 A = 4; B = 2; control = `ALU_NOR; // try "nor"ing 4 and 2
        # 10 A = 6; B = 9; control = `ALU_XOR; // try "xor"ing 6 and 9
        # 10 A = 9; B = 9; control = `ALU_SUB; // try subtracting to 0
        # 10 A = 5; B = 10; control = `ALU_AND; // try "and"ing to 0
        # 10 A = 0; B = 0; control = `ALU_OR; // try "or"ing to 0
        # 10 A = 5; B = 10; control = `ALU_NOR; // try "nor"ing to 0
        # 10 A = 5; B = 5; control = `ALU_XOR; // try "xor"ing to 0
        # 10 A = 36; B = 16'h4FFF; control = `ALU_SUB; // try subtracting a very large number from a small number
        # 10 A = 16'h3FFF; B = 16'h4FFF; control = `ALU_ADD; // try overflow by adding two large negative numbers
        # 10 A = 16'h3FFF; B = 16'h4FFF; control = `; // try subtracting two large negative numbers
        # 10 $finish;
    end

    wire [31:0] out;
    wire overflow, zero, negative;
    alu32 a(out, overflow, zero, negative, A, B, control);  
endmodule // alu32_test
