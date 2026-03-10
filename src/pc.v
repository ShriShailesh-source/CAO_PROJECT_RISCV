// -----------------------------------------------------------------------------
// Module: Program Counter (PC)
// Purpose:
//   Stores the address of the current instruction.
//   Updates each cycle with next_pc (typically PC + 4 in this project).
//
// Inputs:
//   clk     : Clock signal
//   reset   : Asynchronous reset to address 0
//   next_pc : Next instruction address from IF logic
//
// Output:
//   pc_out : Current instruction address sent to instruction memory
//
// Datapath connection:
//   IF stage starts here: PC -> Instruction Memory.
// -----------------------------------------------------------------------------
module pc (
	input  wire        clk,
	input  wire        reset,
	input  wire [31:0] next_pc,
	output reg  [31:0] pc_out
);
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			pc_out <= 32'b0;
		end else begin
			pc_out <= next_pc;
		end
	end
endmodule
