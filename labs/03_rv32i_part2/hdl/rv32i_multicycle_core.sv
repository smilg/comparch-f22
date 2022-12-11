`timescale 1ns/1ps
`default_nettype none

`include "alu_types.sv"
`include "rv32i_defines.sv"

module rv32i_multicycle_core(
  clk, rst, ena,
  mem_addr, mem_rd_data, mem_wr_data, mem_wr_ena,
  PC
);

parameter PC_START_ADDRESS=0;

// Standard control signals.
input  wire clk, rst, ena; // <- worry about implementing the ena signal last.

// Memory interface.
output logic [31:0] mem_addr, mem_wr_data;
input   wire [31:0] mem_rd_data;
output logic mem_wr_ena;

// Program Counter
output wire [31:0] PC;
wire [31:0] PC_old;
logic PC_ena;
logic [31:0] PC_next;
// Program Counter Registers
register #(.N(32), .RESET(PC_START_ADDRESS)) PC_REGISTER (
  .clk(clk), .rst(rst), .ena(PC_ena), .d(PC_next), .q(PC)
);
register #(.N(32)) PC_OLD_REGISTER(
  .clk(clk), .rst(rst), .ena(PC_ena), .d(PC), .q(PC_old)
);

// non-architectural register to store the current instruction
logic IR_ena;
logic [31:0] IR;
register #(.N(32)) INSTRUCTION_REGISTER(
  .clk(clk), .rst(rst), .ena(IR_ena), .d(mem_rd_data), .q(IR)
);

// non-architectural register to store data read from memory
logic mem_data_ena;
wire [31:0] mem_data;
register #(.N(32)) MEM_DATA_REGISTER(
  .clk(clk), .rst(rst), .ena(mem_data_ena), .d(mem_rd_data), .q(mem_data)
);

// Register file
logic reg_write;
logic [4:0] rd, rs1, rs2;
logic [31:0] rfile_wr_data;
wire [31:0] reg_data1, reg_data2;
register_file REGISTER_FILE(
  .clk(clk), 
  .wr_ena(reg_write), .wr_addr(rd), .wr_data(rfile_wr_data),
  .rd_addr0(rs1), .rd_addr1(rs2),
  .rd_data0(reg_data1), .rd_data1(reg_data2)
);

// non-architectural registers to store register file output
wire [31:0] reg_A, reg_B;
register #(.N(32)) REGISTER_A (
    .clk(clk), .rst(rst), .ena(1'b1), .d(reg_data1), .q(reg_A)
);
register #(.N(32)) REGISTER_B (
    .clk(clk), .rst(rst), .ena(1'b1), .d(reg_data2), .q(reg_B)
);
always_comb mem_wr_data = reg_B;

// ALU and related control signals
// Feel free to replace with your ALU from the homework.
logic [31:0] src_a, src_b;
alu_control_t alu_control;
wire [31:0] alu_result;
wire overflow, zero, equal;
alu_behavioural ALU (
  .a(src_a), .b(src_b), .result(alu_result),
  .control(alu_control),
  .overflow(overflow), .zero(zero), .equal(equal)
);

// muxes for alu inputs
enum logic [1:0] {ALU_SRC_A_PC, ALU_SRC_A_OLDPC, ALU_SRC_A_RF} alu_src_a;
enum logic [1:0] {ALU_SRC_B_RF, ALU_SRC_B_IMMEXT, ALU_SRC_B_4} alu_src_b;
always_comb begin : alu_src_a_mux
    case(alu_src_a)
        ALU_SRC_A_PC : src_a = PC;
        ALU_SRC_A_OLDPC : src_a = PC_old;
        ALU_SRC_A_RF : src_a = reg_A;
        default : src_a = 0;
    endcase
end
always_comb begin : alu_src_b_mux
    case(alu_src_b)
        ALU_SRC_B_4 : src_b = 32'd4;
        ALU_SRC_B_RF : src_b = reg_B;
        ALU_SRC_B_IMMEXT : src_b = extended_immediate;
        default : src_b = 0;
    endcase
end

// non-architectural register to store the output of the ALU
logic ALU_ena;
wire [31:0] ALU_reg_out;
register #(.N(32)) ALU_REGISTER (
    .clk(clk), .rst(rst), .ena(ALU_ena), .d(alu_result), .q(ALU_reg_out)
);

// mux for where to get the final result from
enum logic [1:0] {ALU_REG_OUT, MEM_DATA_REG, ALU_DIRECT_OUT} result_source;
logic [31:0] result;
always_comb begin : result_mux
    case(result_source)
        ALU_REG_OUT : result = ALU_reg_out;
        MEM_DATA_REG : result = mem_data;
        ALU_DIRECT_OUT : result = alu_result;
        default : result = alu_result;
    endcase
end

always_comb begin : RESULT_NAMES
    PC_next = result;
    rfile_wr_data = result;
end

// mux for where to get memory read address from (program counter or alu)
enum logic {MEM_SRC_PC, MEM_SRC_RESULT} mem_src;
always_comb begin : memory_read_address_mux
    case(mem_src)
        MEM_SRC_RESULT : mem_addr = result;
        MEM_SRC_PC : mem_addr = PC;
        default: mem_addr = 0;
    endcase
end

// decode instruction
logic [6:0] op;
logic [2:0] funct3;
logic [6:0] funct7;

always_comb begin : instruction_decoding
    op = IR[6:0];
    funct3 = IR[14:12];
    funct7 = IR[31:25];
    rs1 = IR[19:15];
    rs2 = IR[24:20];
    rd = IR[11:7];
end

logic [31:0] extended_immediate;
enum logic [1:0] {IMM_SRC_ITYPE, IMM_SRC_STYPE, IMM_SRC_BTYPE, IMM_SRC_JTYPE} imm_src;
always_comb begin : extended_immediate_mux
    case(op)
        OP_ITYPE, OP_JALR : imm_src = IMM_SRC_ITYPE;
        OP_STYPE : imm_src = IMM_SRC_STYPE;
        OP_BTYPE : imm_src = IMM_SRC_BTYPE;
        OP_JAL : imm_src = IMM_SRC_JTYPE;
        default : imm_src = IMM_SRC_ITYPE;  // doesn't actually matter what goes here
    endcase

    case (imm_src)
        IMM_SRC_ITYPE /*2'b00*/ : begin
            case (funct3)
                FUNCT3_SHIFT_RIGHT : extended_immediate = {27'b0, IR[24:20]};
                default : extended_immediate = {{20{IR[31]}}, IR[31:20]};
            endcase
        end
        IMM_SRC_STYPE /*2'b01*/ : extended_immediate = {{20{IR[31]}}, IR[31:25], IR[11:7]};
        IMM_SRC_BTYPE /*2'b10*/ : extended_immediate = {{20{IR[31]}}, IR[7], IR[30:25], IR[11:8], 1'b0};
        IMM_SRC_JTYPE /*2'b11*/ : extended_immediate = {{12{IR[31]}}, IR[19:12], IR[20], IR[30:21], 1'b0};
    endcase
end

enum logic [3:0] {
    S_FETCH,
    S_DECODE,
    S_MEM_ADDR, S_EXEC_R, S_EXEC_I, S_JAL, S_JALR, S_BRANCH,
    S_ALU_WRITEBACK, S_MEM_READ, S_MEM_WRITE,
    S_MEM_WRITEBACK=12,
    S_ERROR
} state;

always_ff @(posedge clk) begin : main_fsm
    if(rst) state <= S_FETCH;
    else begin
    case(state)
        S_FETCH : state <= S_DECODE;
        S_DECODE : begin
            case(op)
                OP_RTYPE : state <= S_EXEC_R;
                OP_ITYPE : state <= S_EXEC_I;
                OP_LTYPE, OP_LUI, OP_STYPE : state <= S_MEM_ADDR;
                OP_BTYPE : state <= S_BRANCH;
                OP_JAL : state <= S_JAL;
                OP_JALR : state <= S_JALR;
                default : state <= S_ERROR;
            endcase
        end
        S_EXEC_R, S_EXEC_I, S_JAL : state <= S_ALU_WRITEBACK;
        S_JALR : state <= S_JAL;
        S_ALU_WRITEBACK, S_MEM_WRITEBACK, S_MEM_WRITE, S_BRANCH : state <= S_FETCH;
        S_MEM_ADDR : begin
            case(op)
                OP_LTYPE, OP_LUI : state <= S_MEM_READ;
                OP_STYPE : state <= S_MEM_WRITE;
                default : state <= S_ERROR;
            endcase
        end
        S_MEM_READ : state <= S_MEM_WRITEBACK;
        default : state <= S_ERROR;
    endcase
    end
end

always_comb begin : state_comb
    case(state)
        S_FETCH : begin
            PC_ena = 1;
            mem_wr_ena = 0;
            IR_ena = 1;
            mem_data_ena = 0;
            reg_write = 0;
            ALU_ena = 0;
            mem_src = MEM_SRC_PC;
            alu_src_a = ALU_SRC_A_PC;
            alu_src_b = ALU_SRC_B_4;
            alu_control = ALU_ADD;
            result_source = ALU_DIRECT_OUT;
        end
        S_DECODE : begin
            PC_ena = 0;
            mem_wr_ena = 0;
            IR_ena = 0;
            mem_data_ena = 0;
            reg_write = 0;
            ALU_ena = 1;
            mem_src = MEM_SRC_PC;
            // alu used for calculating branch/jump target addr
            alu_src_a = ALU_SRC_A_OLDPC;
            alu_src_b = ALU_SRC_B_IMMEXT;
            alu_control = ALU_ADD;
            result_source = ALU_REG_OUT;
        end
        S_EXEC_R : begin
            PC_ena = 0;
            mem_wr_ena = 0;
            IR_ena = 0;
            mem_data_ena = 0;
            reg_write = 0;
            ALU_ena = 1;
            mem_src = MEM_SRC_PC;
            alu_src_a = ALU_SRC_A_RF;
            alu_src_b = ALU_SRC_B_RF;
            case(funct3)
                FUNCT3_ADD : begin  // icarus gets angry if i use a ternary operator here
                    if (funct7[5]) alu_control = ALU_SUB;
                    else alu_control = ALU_ADD;
                end
                FUNCT3_SLL : alu_control = ALU_SLL;
                FUNCT3_SLT : alu_control = ALU_SLT;
                FUNCT3_SLTU : alu_control = ALU_SLTU;
                FUNCT3_XOR : alu_control = ALU_XOR;
                FUNCT3_SHIFT_RIGHT : begin
                    if (funct7[5]) alu_control = ALU_SRA;
                    else alu_control = ALU_SRL;
                end
                FUNCT3_OR : alu_control = ALU_OR;
                FUNCT3_AND : alu_control = ALU_AND;
                default : alu_control = ALU_INVALID;
            endcase
            result_source = ALU_DIRECT_OUT;
        end
        S_EXEC_I : begin
            PC_ena = 0;
            mem_wr_ena = 0;
            IR_ena = 0;
            mem_data_ena = 0;
            reg_write = 0;
            ALU_ena = 1;
            mem_src = MEM_SRC_PC;
            alu_src_a = ALU_SRC_A_RF;
            alu_src_b = ALU_SRC_B_IMMEXT;
            case(funct3)
                FUNCT3_ADD : alu_control = ALU_ADD;
                FUNCT3_SLL : alu_control = ALU_SLL;
                FUNCT3_SLT : alu_control = ALU_SLT;
                FUNCT3_SLTU : alu_control = ALU_SLTU;
                FUNCT3_XOR : alu_control = ALU_XOR;
                FUNCT3_SHIFT_RIGHT : begin
                    if (funct7[5]) alu_control = ALU_SRA;
                    else alu_control = ALU_SRL;
                end
                FUNCT3_OR : alu_control = ALU_OR;
                FUNCT3_AND : alu_control = ALU_AND;
                default : alu_control = ALU_INVALID;
            endcase
            result_source = ALU_DIRECT_OUT;
        end
        S_ALU_WRITEBACK : begin
            PC_ena = 0;
            mem_wr_ena = 0;
            IR_ena = 0;
            mem_data_ena = 0;
            reg_write = 1;
            ALU_ena = 0;
            mem_src = MEM_SRC_PC;
            alu_src_a = ALU_SRC_A_RF;
            alu_src_b = ALU_SRC_B_RF;
            alu_control = ALU_INVALID;
            result_source = ALU_REG_OUT;
        end
        S_MEM_ADDR : begin
            PC_ena = 0;
            mem_wr_ena = 0;
            IR_ena = 0;
            mem_data_ena = 0;
            reg_write = 0;
            ALU_ena = 1;
            mem_src = MEM_SRC_PC;
            alu_src_a = ALU_SRC_A_RF;
            alu_src_b = ALU_SRC_B_IMMEXT;
            alu_control = ALU_ADD;
            result_source = ALU_DIRECT_OUT;
        end
        S_MEM_READ : begin
            PC_ena = 0;
            mem_wr_ena = 0;
            IR_ena = 0;
            mem_data_ena = 1;
            reg_write = 0;
            ALU_ena = 0;
            mem_src = MEM_SRC_RESULT;
            alu_src_a = ALU_SRC_A_RF;
            alu_src_b = ALU_SRC_B_IMMEXT;
            alu_control = ALU_ADD;
            result_source = ALU_REG_OUT;
        end
        S_MEM_WRITEBACK : begin
            PC_ena = 0;
            mem_wr_ena = 0;
            IR_ena = 0;
            mem_data_ena = 0;
            reg_write = 1;
            ALU_ena = 0;
            mem_src = MEM_SRC_RESULT;
            alu_src_a = ALU_SRC_A_RF;
            alu_src_b = ALU_SRC_B_IMMEXT;
            alu_control = ALU_ADD;
            result_source = MEM_DATA_REG;
        end
        S_MEM_WRITE : begin
            PC_ena = 0;
            mem_wr_ena = 1;
            IR_ena = 0;
            mem_data_ena = 0;
            reg_write = 0;
            ALU_ena = 0;
            mem_src = MEM_SRC_RESULT;
            alu_src_a = ALU_SRC_A_RF;
            alu_src_b = ALU_SRC_B_IMMEXT;
            alu_control = ALU_ADD;
            result_source = ALU_REG_OUT;
        end
        S_BRANCH : begin
            case(funct3)
                FUNCT3_BEQ : PC_ena = equal ? 1 : 0;
                FUNCT3_BNE : PC_ena = equal ? 0 : 1;
                default : PC_ena = 0;
            endcase
            mem_wr_ena = 0;
            IR_ena = 0;
            mem_data_ena = 0;
            reg_write = 0;
            ALU_ena = 0;
            mem_src = MEM_SRC_RESULT;
            alu_src_a = ALU_SRC_A_RF;
            alu_src_b = ALU_SRC_B_RF;
            alu_control = ALU_SUB;
            result_source = ALU_REG_OUT;
        end
        S_JAL : begin
            PC_ena = 1;
            mem_wr_ena = 0;
            IR_ena = 0;
            mem_data_ena = 0;
            reg_write = 0;
            ALU_ena = 1;
            mem_src = MEM_SRC_RESULT;
            alu_src_a = ALU_SRC_A_OLDPC;
            alu_src_b = ALU_SRC_B_4;
            alu_control = ALU_ADD;
            result_source = ALU_REG_OUT;
        end
        S_JALR : begin
            PC_ena = 0;
            mem_wr_ena = 0;
            IR_ena = 0;
            mem_data_ena = 0;
            reg_write = 0;
            ALU_ena = 1;
            mem_src = MEM_SRC_RESULT;
            alu_src_a = ALU_SRC_A_RF;
            alu_src_b = ALU_SRC_B_IMMEXT;
            alu_control = ALU_ADD;
            result_source = ALU_REG_OUT;
        end
        default : begin
            
        end
    endcase
end

endmodule
