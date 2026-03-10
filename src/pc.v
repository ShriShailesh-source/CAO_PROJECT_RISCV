// Program Counter (PC)
// Holds the current instruction address and updates every clock cycle.
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
