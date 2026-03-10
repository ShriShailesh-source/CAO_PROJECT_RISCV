// -----------------------------------------------------------------------------
// Module: Data Memory
// Purpose:
//   Provides data storage for load/store instructions.
//
// Inputs:
//   clk        : Clock used for synchronous store operations
//   mem_read   : Enables read for load instructions
//   mem_write  : Enables write for store instructions
//   addr       : Byte address from ALU result
//   write_data : Data to store (usually rs2 value)
//
// Output:
//   read_data : Data read from memory for load instructions
//
// Datapath connection:
//   EX stage computes address -> MEM stage accesses data memory.
//   Load result goes to MEM/WB for Write Back.
// -----------------------------------------------------------------------------
module data_memory (
    input  wire        clk,
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    output wire [31:0] read_data
);
    reg [31:0] mem [0:255];
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 32'b0;
        end
    end

    // Synchronous store
    always @(posedge clk) begin
        if (mem_write) begin
            mem[addr[31:2]] <= write_data;
        end
    end

    // Combinational load
    assign read_data = mem_read ? mem[addr[31:2]] : 32'b0;
endmodule
