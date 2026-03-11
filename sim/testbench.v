`timescale 1ns/1ps

module testbench;
    reg clk;
    reg reset;
    integer cycle;

    // Instantiate CPU top module
    cpu_top uut (
        .clk(clk),
        .reset(reset)
    );

    // Instantiate your register file if it's separate in testbench
    // (assuming you have: regfile u_regfile (...); already)

    // Clock generation: 100 MHz
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Shadow wires for registers x1–x8 (so GTKWave can see them)
    wire [31:0] x1 = u_regfile.regs[1];
    wire [31:0] x2 = u_regfile.regs[2];
    wire [31:0] x3 = u_regfile.regs[3];
    wire [31:0] x4 = u_regfile.regs[4];
    wire [31:0] x5 = u_regfile.regs[5];
    wire [31:0] x6 = u_regfile.regs[6];
    wire [31:0] x7 = u_regfile.regs[7];
    wire [31:0] x8 = u_regfile.regs[8];

    // Shadow wires for clock and reset (optional, for GTKWave clarity)
    wire clk_wire = clk;
    wire reset_wire = reset;

    initial begin
        $dumpfile("dump.vcd");

        // Dump top-level CPU, shadow registers, clock, reset
        $dumpvars(0, uut);
        $dumpvars(0, x1, x2, x3, x4, x5, x6, x7, x8);
        $dumpvars(0, clk_wire, reset_wire);

        cycle = 0;
        reset = 1'b1;

        // Hold reset for 20 ns
        #20;
        reset = 1'b0;

        // Run simulation for 35 clock cycles
        repeat (35) begin
            @(posedge clk);
            cycle = cycle + 1;
            $display(
                "Cycle=%0d PC=%h | x1=%0d x2=%0d x3=%0d x4=%0d x5=%0d x6=%0d x7=%0d x8=%0d | MEM[0]=%0d",
                cycle,
                uut.pc_current,
                u_regfile.regs[1],
                u_regfile.regs[2],
                u_regfile.regs[3],
                u_regfile.regs[4],
                u_regfile.regs[5],
                u_regfile.regs[6],
                u_regfile.regs[7],
                u_regfile.regs[8],
                uut.u_dmem.mem[0]
            );
        end

        $display("Simulation finished.");
        $finish;
    end
endmodule