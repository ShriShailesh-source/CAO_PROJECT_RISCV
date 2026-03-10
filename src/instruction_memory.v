// Instruction Memory
// Stores a small sample RISC-V program and returns one 32-bit instruction
// based on the current PC address.
module instruction_memory (
    input  wire [31:0] addr,
    output wire [31:0] instruction
);
    reg [31:0] mem [0:255];

    // Word-aligned instruction fetch
    assign instruction = mem[addr[31:2]];

    initial begin
        integer i;
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 32'h00000013; // NOP (addi x0, x0, 0)
        end

        // Sample program with NOP spacing for a pipeline without forwarding/stall logic:
        // x1 = 5
        // x2 = 10
        // x3 = x1 + x2 = 15
        // x4 = x2 - x1 = 5
        // MEM[0] = x3
        // x5 = MEM[0]
        // x6 = x1 & x2 = 0
        // x7 = x1 | x2 = 15
        // x8 = x5 + x4 = 20
        mem[0]  = 32'h00500093; // addi x1, x0, 5
        mem[1]  = 32'h00A00113; // addi x2, x0, 10
        mem[2]  = 32'h00000013; // nop
        mem[3]  = 32'h00000013; // nop
        mem[4]  = 32'h00000013; // nop
        mem[5]  = 32'h002081B3; // add x3, x1, x2
        mem[6]  = 32'h40110233; // sub x4, x2, x1
        mem[7]  = 32'h00000013; // nop
        mem[8]  = 32'h00000013; // nop
        mem[9]  = 32'h00000013; // nop
        mem[10] = 32'h00302023; // sw x3, 0(x0)
        mem[11] = 32'h00000013; // nop
        mem[12] = 32'h00000013; // nop
        mem[13] = 32'h00000013; // nop
        mem[14] = 32'h00002283; // lw x5, 0(x0)
        mem[15] = 32'h0020F333; // and x6, x1, x2
        mem[16] = 32'h0020E3B3; // or x7, x1, x2
        mem[17] = 32'h00000013; // nop
        mem[18] = 32'h00000013; // nop
        mem[19] = 32'h00000013; // nop
        mem[20] = 32'h00428433; // add x8, x5, x4
    end
endmodule
