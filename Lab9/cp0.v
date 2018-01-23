`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           regnum, wr_data, next_pc, TimerInterrupt,
           MTC0, ERET, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input   [4:0] regnum;
    input  [31:0] wr_data;
    input  [29:0] next_pc;
    input         TimerInterrupt, MTC0, ERET, clock, reset;

    // your Verilog for coprocessor 0 goes here
    wire   [31:0] status_register, cause_register, user_status;
    wire          exception_level;
    wire   [31:0] decoder_out, epc_extend;
    wire   [29:0] d_epc_register;
    wire          cause_status, status_out, sr1_not;
    wire          exception_level_reset, epc_register_enable;

    assign status_register[31:16] = {16{1'b0}};
    assign status_register[15:8]  = user_status[15:8];
    assign status_register[7:2]   = {6{1'b0}};
    assign status_register[1]     = exception_level;
    assign status_register[0]     = user_status[0];

    assign cause_register[31:16]  = {16{1'b0}};
    assign cause_register[15]     = TimerInterrupt;
    assign cause_register[14:0]   = {15{1'b0}};

    assign epc_extend[31:2]       = EPC[29:0];
    assign epc_extend[1:0]        = {2{1'b0}};

    register #(32) userStatus(user_status, wr_data, clock, decoder_out[12], reset);
    register #(30) epcRegister(EPC, d_epc_register, clock, epc_register_enable, reset);
    dffe exceptionLevel(exception_level, 1'b1, clock, TakenInterrupt, exception_level_reset);

    decoder32 decoderRegnum(decoder_out, regnum, MTC0);

    mux2v #(30) muxTI(d_epc_register, wr_data[31:2], next_pc, TakenInterrupt);
    mux3v #(32) muxRdDtata(rd_data, status_register, cause_register, epc_extend, regnum[1:0]);

    or orReset(exception_level_reset, reset, ERET);
    or orEnable(epc_register_enable, decoder_out[14], TakenInterrupt);
    not notSR1(sr1_not, status_register[1]);
    and andStatusCause(cause_status, cause_register[15], status_register[15]);
    and andStatus(status_out, sr1_not, status_register[0]);
    and andAnds(TakenInterrupt, cause_status, status_out);

endmodule
