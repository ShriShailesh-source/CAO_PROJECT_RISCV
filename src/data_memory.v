// Data Memory
// Simple word-addressed memory used by LW/SW in MEM stage.
// Address comes from ALU result; load data moves to WB and stores use rs2 data.
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
