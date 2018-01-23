module machine(clk, reset);
   input        clk, reset;

   wire [31:0]  PC;
   wire [31:2]  next_PC, PC_plus4, PC_target;
   wire [31:0]  inst;

   wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
   wire [4:0]   rs = inst[25:21];
   wire [4:0]   rt = inst[20:16];
   wire [4:0]   rd = inst[15:11];

   wire [4:0]   wr_regnum;
   wire [2:0]   ALUOp;

   wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, MFC0, MTC0, ERET;
   wire         PCSrc, zero, negative;
   wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;

   wire [31:0]  mfc0_mux_in, t_address, cycle, c0_rd_data;   // ++++++++
   wire         newMemRead, newMemWrite;
   wire [31:0]  t_data, c0_wr_data;
   wire [29:0]  EPC;
   wire         NotIO, TimerInterrupt, TimerAddress, TakenInterrupt;
   wire [31:2]  eret_out, taken_int_out;                                          // ++++++++

   mux2v #(30) eret_mux(eret_out, next_PC[31:2], EPC, ERET);                      // ++++++++
   mux2v #(30) take_int_mux(taken_int_out, eret_out, 30'b100000000000000000000001100000, TakenInterrupt); // ++++++++

   register #(30, 30'h100000) PC_reg(PC[31:2], taken_int_out, clk, /* enable */1'b1, reset);
   assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
   adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
   adder30 target_PC_adder(PC_target, PC_plus4, imm[29:0]);
   mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
   assign PCSrc = BEQ & zero;

   instruction_memory imem (inst, PC[31:2]);

   mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, MFC0, MTC0, ERET,
                      inst);

   regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum, wr_data,
               RegWrite, clk, reset);

   mux2v #(32) imm_mux(B_data, rd2_data, imm, ALUSrc);
   alu32 alu(alu_out_data, zero, negative, ALUOp, rd1_data, B_data);

   data_mem data_memory(load_data, alu_out_data, rd2_data, newMemRead, newMemWrite, clk, reset);

   mux2v #(32) wb_mux(mfc0_mux_in, alu_out_data, load_data, MemToReg);
   mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);

   // Add ---------------- Add \\

   assign t_address = alu_out_data;
   assign t_data = rd2_data;
   assign c0_wr_data = rd2_data;
   assign cycle = load_data;

   not notTimerAddress(NotIO, TimerAddress);      // ++++++++
   and andMemRead(newMemRead, MemRead, NotIO);    // ++++++++
   and andMemWrite(newMemWrite, NotIO, MemWrite); // ++++++++

   mux2v mfc0_mux(wr_data, mfc0_mux_in, c0_rd_data, MFC0); // ++++++++

   cp0 cp(c0_rd_data, EPC, TakenInterrupt, rd, c0_wr_data, next_PC, TimerInterrupt, MTC0, ERET, clk, reset);
   timer t(TimerInterrupt, TimerAddress, load_data, t_address, t_data, MemRead, MemWrite, clk, reset);

endmodule // machine
