// Arithmetic Logic Unit (ALU)
// Supports ADD, SUB, AND, OR operations used in the EX stage.
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
