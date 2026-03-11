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

    // Clock generation: 100 MHz
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // -------- STEP 3 FIX: Shadow wires for registers x1–x8 --------
    // Make sure these are **outside any initial block**
    wire [31:0] x1 = uut.u_regfile.regs[1];
    wire [31:0] x2 = uut.u_regfile.regs[2];
    wire [31:0] x3 = uut.u_regfile.regs[3];
    wire [31:0] x4 = uut.u_regfile.regs[4];
    wire [31:0] x5 = uut.u_regfile.regs[5];
    wire [31:0] x6 = uut.u_regfile.regs[6];
    wire [31:0] x7 = uut.u_regfile.regs[7];
    wire [31:0] x8 = uut.u_regfile.regs[8];

    initial begin
        $dumpfile("dump.vcd");

        // Dump everything needed for GTKWave
        $dumpvars(0, uut);   // PC, ALU, memory
        $dumpvars(0, x1, x2, x3, x4, x5, x6, x7, x8); // registers

        cycle = 0;
        reset = 1'b1;

        // Hold reset for 20 ns
        #20;
        reset = 1'b0;

        // Run simulation for 35 cycles
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