// IF/ID Pipeline Register
// Transfers PC and instruction from IF stage to ID stage.
module if_id_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] if_pc,
    input  wire [31:0] if_instr,
    output reg  [31:0] id_pc,
    output reg  [31:0] id_instr
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            id_pc    <= 32'b0;
            id_instr <= 32'h00000013;
        end else begin
            id_pc    <= if_pc;
            id_instr <= if_instr;
        end
    end
endmodule

module id_ex_reg (
    // ID/EX Pipeline Register
    // Transfers decoded operands, immediate, destination register,
    // and control signals from ID stage to EX stage.
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] id_pc,
    input  wire [31:0] id_read_data1,
    input  wire [31:0] id_read_data2,
    input  wire [31:0] id_imm,
    input  wire [4:0]  id_rs1,
    input  wire [4:0]  id_rs2,
    input  wire [4:0]  id_rd,
    input  wire [1:0]  id_alu_ctrl,
    input  wire        id_alu_src,
    input  wire        id_mem_read,
    input  wire        id_mem_write,
    input  wire        id_mem_to_reg,
    input  wire        id_reg_write,
    output reg  [31:0] ex_pc,
    output reg  [31:0] ex_read_data1,
    output reg  [31:0] ex_read_data2,
    output reg  [31:0] ex_imm,
    output reg  [4:0]  ex_rs1,
    output reg  [4:0]  ex_rs2,
    output reg  [4:0]  ex_rd,
    output reg  [1:0]  ex_alu_ctrl,
    output reg         ex_alu_src,
    output reg         ex_mem_read,
    output reg         ex_mem_write,
    output reg         ex_mem_to_reg,
    output reg         ex_reg_write
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ex_pc         <= 32'b0;
            ex_read_data1 <= 32'b0;
            ex_read_data2 <= 32'b0;
            ex_imm        <= 32'b0;
            ex_rs1        <= 5'b0;
            ex_rs2        <= 5'b0;
            ex_rd         <= 5'b0;
            ex_alu_ctrl   <= 2'b0;
            ex_alu_src    <= 1'b0;
            ex_mem_read   <= 1'b0;
            ex_mem_write  <= 1'b0;
            ex_mem_to_reg <= 1'b0;
            ex_reg_write  <= 1'b0;
        end else begin
            ex_pc         <= id_pc;
            ex_read_data1 <= id_read_data1;
            ex_read_data2 <= id_read_data2;
            ex_imm        <= id_imm;
            ex_rs1        <= id_rs1;
            ex_rs2        <= id_rs2;
            ex_rd         <= id_rd;
            ex_alu_ctrl   <= id_alu_ctrl;
            ex_alu_src    <= id_alu_src;
            ex_mem_read   <= id_mem_read;
            ex_mem_write  <= id_mem_write;
            ex_mem_to_reg <= id_mem_to_reg;
            ex_reg_write  <= id_reg_write;
        end
    end
endmodule

module ex_mem_reg (
    // EX/MEM Pipeline Register
    // Transfers ALU result, store data, destination register,
    // and memory/write-back control signals from EX to MEM.
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] ex_alu_result,
    input  wire [31:0] ex_write_data,
    input  wire [4:0]  ex_rd,
    input  wire        ex_mem_read,
    input  wire        ex_mem_write,
    input  wire        ex_mem_to_reg,
    input  wire        ex_reg_write,
    output reg  [31:0] mem_alu_result,
    output reg  [31:0] mem_write_data,
    output reg  [4:0]  mem_rd,
    output reg         mem_mem_read,
    output reg         mem_mem_write,
    output reg         mem_mem_to_reg,
    output reg         mem_reg_write
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_alu_result <= 32'b0;
            mem_write_data <= 32'b0;
            mem_rd         <= 5'b0;
            mem_mem_read   <= 1'b0;
            mem_mem_write  <= 1'b0;
            mem_mem_to_reg <= 1'b0;
            mem_reg_write  <= 1'b0;
        end else begin
            mem_alu_result <= ex_alu_result;
            mem_write_data <= ex_write_data;
            mem_rd         <= ex_rd;
            mem_mem_read   <= ex_mem_read;
            mem_mem_write  <= ex_mem_write;
            mem_mem_to_reg <= ex_mem_to_reg;
            mem_reg_write  <= ex_reg_write;
        end
    end
endmodule

module mem_wb_reg (
    // MEM/WB Pipeline Register
    // Transfers memory/ALU results and write-back control signals
    // from MEM stage to WB stage.
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] mem_read_data,
    input  wire [31:0] mem_alu_result,
    input  wire [4:0]  mem_rd,
    input  wire        mem_mem_to_reg,
    input  wire        mem_reg_write,
    output reg  [31:0] wb_read_data,
    output reg  [31:0] wb_alu_result,
    output reg  [4:0]  wb_rd,
    output reg         wb_mem_to_reg,
    output reg         wb_reg_write
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wb_read_data  <= 32'b0;
            wb_alu_result <= 32'b0;
            wb_rd         <= 5'b0;
            wb_mem_to_reg <= 1'b0;
            wb_reg_write  <= 1'b0;
        end else begin
            wb_read_data  <= mem_read_data;
            wb_alu_result <= mem_alu_result;
            wb_rd         <= mem_rd;
            wb_mem_to_reg <= mem_mem_to_reg;
            wb_reg_write  <= mem_reg_write;
        end
    end
endmodule
