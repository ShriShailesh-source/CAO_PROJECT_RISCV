`timescale 1ns/1ps

module testbench;
    reg clk;
    reg reset;
    integer cycle;

    cpu_top uut (
        .clk(clk),
        .reset(reset)
    );

    // 100 MHz clock (10 ns period)
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        cycle = 0;
        reset = 1'b1;

        // Hold reset for a short duration
        #20;
        reset = 1'b0;

        // Run simulation for multiple cycles
        repeat (35) begin
            @(posedge clk);
            cycle = cycle + 1;
            $display(
                "Cycle=%0d PC=%h | x1=%0d x2=%0d x3=%0d x4=%0d x5=%0d x6=%0d x7=%0d x8=%0d | MEM[0]=%0d",
                cycle,
                uut.pc_current,
                uut.u_regfile.regs[1],
                uut.u_regfile.regs[2],
                uut.u_regfile.regs[3],
                uut.u_regfile.regs[4],
                uut.u_regfile.regs[5],
                uut.u_regfile.regs[6],
                uut.u_regfile.regs[7],
                uut.u_regfile.regs[8],
                uut.u_dmem.mem[0]
            );
        end

        $display("Simulation finished.");
        $finish;
    end
endmodule
