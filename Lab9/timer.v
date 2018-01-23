module timer(TimerInterrupt, TimerAddress, cycle,
             address, data, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt, TimerAddress;
    output [31:0] cycle;
    input  [31:0] address, data;
    input         MemRead, MemWrite, clock, reset;

    // complete the timer circuit here

    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle

    wire [31:0] qCycleCounter, dCycleCounter, qInterruptCycle;
    wire        TimerRead, TimerWrite, Acknowledge;
    wire        enableInterruptLine, resetInterruptLine;
    wire        qEqual, equal1, equal2;

    assign qEqual = (qCycleCounter == qInterruptCycle);
    assign equal1 = (address == 32'hffff001c);
    assign equal2 = (address == 32'hffff006c);

    register cycleCounter(qCycleCounter, dCycleCounter, clock, 1'b1, reset);
    register interruptCycle(qInterruptCycle, data, clock, TimerWrite, reset);
    register #(1) interruptLine(TimerInterrupt, 1'b1, clock, qEqual, resetInterruptLine);

    and andTimerRead(TimerRead, equal1, MemRead);
    and andTimerWrite(TimerWrite, equal1, MemWrite);
    and andAcknowledge(Acknowledge, equal2, MemWrite);

    or orTimerAddress(TimerAddress, equal1, equal2);
    or orReset(resetInterruptLine, Acknowledge, reset);

    tristate tsTimerRead(cycle, qCycleCounter, TimerRead);

    alu32 aluCycle(dCycleCounter, , , 3'b010, qCycleCounter, 32'h00000001);

endmodule
