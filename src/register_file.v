// -----------------------------------------------------------------------------
// Module: Register File
// Purpose:
//   Implements 32 general-purpose 32-bit registers (x0 to x31).
//   Provides two read ports and one write port.
//
// Inputs:
//   clk, reset  : Sequential update and initialization
//   reg_write   : Write enable from WB control
//   rs1, rs2    : Source register addresses for read ports
//   rd          : Destination register address for write port
//   write_data  : Data written during Write Back (WB)
//
// Outputs:
//   read_data1, read_data2 : Source operand values for decode/execute path
//
// Datapath connection:
//   ID stage reads rs1/rs2 values.
//   WB stage writes result back to rd when reg_write is enabled.
//   Register x0 is hardwired to zero by ignoring writes to rd = 0.
// -----------------------------------------------------------------------------
module register_file (
    input  wire        clk,
    input  wire        reset,
    input  wire        reg_write,
    input  wire [4:0]  rs1,
    input  wire [4:0]  rs2,
    input  wire [4:0]  rd,
    input  wire [31:0] write_data,
    output wire [31:0] read_data1,
    output wire [31:0] read_data2
);
    integer i;
    reg [31:0] regs [0:31];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= 32'b0;
            end
        end else if (reg_write && (rd != 5'b0)) begin
            regs[rd] <= write_data;
        end
    end

    assign read_data1 = (rs1 == 5'b0) ? 32'b0 : regs[rs1];
    assign read_data2 = (rs2 == 5'b0) ? 32'b0 : regs[rs2];
endmodule
