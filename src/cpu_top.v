// Top-level 5-stage pipelined RISC-V CPU
// Connects IF, ID, EX, MEM, WB stages and their pipeline registers.
// Includes integrated control-unit logic in the ID decode block.
module cpu_top (
    input wire clk,
    input wire reset
);
    // ALU control encodings
    localparam ALU_ADD = 2'b00;
    localparam ALU_SUB = 2'b01;
    localparam ALU_AND = 2'b10;
    localparam ALU_OR  = 2'b11;

    // ---------------- IF stage ----------------
    wire [31:0] pc_current;
    wire [31:0] pc_next;
    wire [31:0] if_instruction;

    assign pc_next = pc_current + 32'd4;

    pc u_pc (
        .clk(clk),
        .reset(reset),
        .next_pc(pc_next),
        .pc_out(pc_current)
    );

    instruction_memory u_imem (
        .addr(pc_current),
        .instruction(if_instruction)
    );

    // IF/ID pipeline register
    wire [31:0] id_pc;
    wire [31:0] id_instruction;

    if_id_reg u_if_id (
        .clk(clk),
        .reset(reset),
        .if_pc(pc_current),
        .if_instr(if_instruction),
        .id_pc(id_pc),
        .id_instr(id_instruction)
    );

    // ---------------- ID stage ----------------
    wire [6:0] id_opcode;
    wire [2:0] id_funct3;
    wire [6:0] id_funct7;
    wire [4:0] id_rs1;
    wire [4:0] id_rs2;
    wire [4:0] id_rd;

    wire [31:0] id_imm_i;
    wire [31:0] id_imm_s;
    reg  [31:0] id_imm;

    reg  [1:0] id_alu_ctrl;
    reg        id_alu_src;
    reg        id_mem_read;
    reg        id_mem_write;
    reg        id_mem_to_reg;
    reg        id_reg_write;

    wire [31:0] id_read_data1;
    wire [31:0] id_read_data2;

    // WB stage signals used for register file write-back
    wire [4:0]  wb_rd;
    wire        wb_reg_write;
    wire [31:0] wb_write_data;

    assign id_opcode = id_instruction[6:0];
    assign id_rd     = id_instruction[11:7];
    assign id_funct3 = id_instruction[14:12];
    assign id_rs1    = id_instruction[19:15];
    assign id_rs2    = id_instruction[24:20];
    assign id_funct7 = id_instruction[31:25];

    assign id_imm_i = {{20{id_instruction[31]}}, id_instruction[31:20]};
    assign id_imm_s = {{20{id_instruction[31]}}, id_instruction[31:25], id_instruction[11:7]};

    register_file u_regfile (
        .clk(clk),
        .reset(reset),
        .reg_write(wb_reg_write),
        .rs1(id_rs1),
        .rs2(id_rs2),
        .rd(wb_rd),
        .write_data(wb_write_data),
        .read_data1(id_read_data1),
        .read_data2(id_read_data2)
    );

    // Main control + ALU control decode (Control Unit functionality)
    // Generates datapath control signals from opcode/funct fields.
    always @(*) begin
        // Defaults = NOP
        id_alu_ctrl   = ALU_ADD;
        id_alu_src    = 1'b0;
        id_mem_read   = 1'b0;
        id_mem_write  = 1'b0;
        id_mem_to_reg = 1'b0;
        id_reg_write  = 1'b0;
        id_imm        = 32'b0;

        case (id_opcode)
            7'b0110011: begin // R-type: add/sub/and/or
                id_alu_src    = 1'b0;
                id_reg_write  = 1'b1;
                case ({id_funct7, id_funct3})
                    10'b0000000_000: id_alu_ctrl = ALU_ADD;
                    10'b0100000_000: id_alu_ctrl = ALU_SUB;
                    10'b0000000_111: id_alu_ctrl = ALU_AND;
                    10'b0000000_110: id_alu_ctrl = ALU_OR;
                    default:         id_alu_ctrl = ALU_ADD;
                endcase
            end

            7'b0010011: begin // I-type ALU (only ADDI used here)
                id_alu_ctrl   = ALU_ADD;
                id_alu_src    = 1'b1;
                id_reg_write  = 1'b1;
                id_imm        = id_imm_i;
            end

            7'b0000011: begin // LW
                id_alu_ctrl   = ALU_ADD;
                id_alu_src    = 1'b1;
                id_mem_read   = 1'b1;
                id_mem_to_reg = 1'b1;
                id_reg_write  = 1'b1;
                id_imm        = id_imm_i;
            end

            7'b0100011: begin // SW
                id_alu_ctrl   = ALU_ADD;
                id_alu_src    = 1'b1;
                id_mem_write  = 1'b1;
                id_imm        = id_imm_s;
            end

            default: begin
                // Keep NOP defaults
            end
        endcase
    end

    // ID/EX pipeline register
    wire [31:0] ex_pc;
    wire [31:0] ex_read_data1;
    wire [31:0] ex_read_data2;
    wire [31:0] ex_imm;
    wire [4:0]  ex_rs1;
    wire [4:0]  ex_rs2;
    wire [4:0]  ex_rd;
    wire [1:0]  ex_alu_ctrl;
    wire        ex_alu_src;
    wire        ex_mem_read;
    wire        ex_mem_write;
    wire        ex_mem_to_reg;
    wire        ex_reg_write;

    id_ex_reg u_id_ex (
        .clk(clk),
        .reset(reset),
        .id_pc(id_pc),
        .id_read_data1(id_read_data1),
        .id_read_data2(id_read_data2),
        .id_imm(id_imm),
        .id_rs1(id_rs1),
        .id_rs2(id_rs2),
        .id_rd(id_rd),
        .id_alu_ctrl(id_alu_ctrl),
        .id_alu_src(id_alu_src),
        .id_mem_read(id_mem_read),
        .id_mem_write(id_mem_write),
        .id_mem_to_reg(id_mem_to_reg),
        .id_reg_write(id_reg_write),
        .ex_pc(ex_pc),
        .ex_read_data1(ex_read_data1),
        .ex_read_data2(ex_read_data2),
        .ex_imm(ex_imm),
        .ex_rs1(ex_rs1),
        .ex_rs2(ex_rs2),
        .ex_rd(ex_rd),
        .ex_alu_ctrl(ex_alu_ctrl),
        .ex_alu_src(ex_alu_src),
        .ex_mem_read(ex_mem_read),
        .ex_mem_write(ex_mem_write),
        .ex_mem_to_reg(ex_mem_to_reg),
        .ex_reg_write(ex_reg_write)
    );

    // ---------------- EX stage ----------------
    wire [31:0] ex_operand_b;
    wire [31:0] ex_alu_result;
    wire        ex_zero;

    assign ex_operand_b = ex_alu_src ? ex_imm : ex_read_data2;

    alu u_alu (
        .a(ex_read_data1),
        .b(ex_operand_b),
        .alu_ctrl(ex_alu_ctrl),
        .result(ex_alu_result),
        .zero(ex_zero)
    );

    // EX/MEM pipeline register
    wire [31:0] mem_alu_result;
    wire [31:0] mem_write_data;
    wire [4:0]  mem_rd;
    wire        mem_mem_read;
    wire        mem_mem_write;
    wire        mem_mem_to_reg;
    wire        mem_reg_write;

    ex_mem_reg u_ex_mem (
        .clk(clk),
        .reset(reset),
        .ex_alu_result(ex_alu_result),
        .ex_write_data(ex_read_data2),
        .ex_rd(ex_rd),
        .ex_mem_read(ex_mem_read),
        .ex_mem_write(ex_mem_write),
        .ex_mem_to_reg(ex_mem_to_reg),
        .ex_reg_write(ex_reg_write),
        .mem_alu_result(mem_alu_result),
        .mem_write_data(mem_write_data),
        .mem_rd(mem_rd),
        .mem_mem_read(mem_mem_read),
        .mem_mem_write(mem_mem_write),
        .mem_mem_to_reg(mem_mem_to_reg),
        .mem_reg_write(mem_reg_write)
    );

    // ---------------- MEM stage ----------------
    wire [31:0] mem_read_data;

    data_memory u_dmem (
        .clk(clk),
        .mem_read(mem_mem_read),
        .mem_write(mem_mem_write),
        .addr(mem_alu_result),
        .write_data(mem_write_data),
        .read_data(mem_read_data)
    );

    // MEM/WB pipeline register
    wire [31:0] wb_read_data;
    wire [31:0] wb_alu_result;
    wire        wb_mem_to_reg;

    mem_wb_reg u_mem_wb (
        .clk(clk),
        .reset(reset),
        .mem_read_data(mem_read_data),
        .mem_alu_result(mem_alu_result),
        .mem_rd(mem_rd),
        .mem_mem_to_reg(mem_mem_to_reg),
        .mem_reg_write(mem_reg_write),
        .wb_read_data(wb_read_data),
        .wb_alu_result(wb_alu_result),
        .wb_rd(wb_rd),
        .wb_mem_to_reg(wb_mem_to_reg),
        .wb_reg_write(wb_reg_write)
    );

    // ---------------- WB stage ----------------
    assign wb_write_data = wb_mem_to_reg ? wb_read_data : wb_alu_result;

endmodule
