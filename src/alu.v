// -----------------------------------------------------------------------------
// Module: ALU
// Purpose:
//   Performs arithmetic and logic operations in the Execute (EX) stage.
//
// Inputs:
//   a        : First 32-bit operand (usually rs1 value from register file)
//   b        : Second 32-bit operand (rs2 value or immediate value)
//   alu_ctrl : Operation select
//              00 = ADD, 01 = SUB, 10 = AND, 11 = OR
//
// Outputs:
//   result : 32-bit ALU output used by later stages
//   zero   : High when result is 0 (useful for branch-style logic)
//
// Datapath connection:
//   Register File/Immediate -> ALU (EX) -> EX/MEM pipeline register.
// -----------------------------------------------------------------------------
module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [1:0]  alu_ctrl,
    output reg  [31:0] result,
    output wire        zero
);
    localparam ALU_ADD = 2'b00;
    localparam ALU_SUB = 2'b01;
    localparam ALU_AND = 2'b10;
    localparam ALU_OR  = 2'b11;

    always @(*) begin
        case (alu_ctrl)
            ALU_ADD: result = a + b;
            ALU_SUB: result = a - b;
            ALU_AND: result = a & b;
            ALU_OR : result = a | b;
            default: result = 32'b0;
        endcase
    end

    assign zero = (result == 32'b0);
endmodule
