`timescale 1ns/1ps
`default_nettype none

`include "alu_types.sv"

module alu(a, b, control, result, overflow, zero, equal);
parameter N = 32; // Don't need to support other numbers, just using this as a constant.

input wire [N-1:0] a, b; // Inputs to the ALU.
input alu_control_t control; // Sets the current operation.
output logic [N-1:0] result; // Result of the selected operation.

output logic overflow; // Is high if the result of an ADD or SUB wraps around the 32 bit boundary.
output logic zero;  // Is high if the result is ever all zeros.
output logic equal; // is high if a == b.

// Use *only* structural logic and previously defined modules to implement an 
// ALU that can do all of operations defined in alu_types.sv's alu_op_code_t.

logic c_out, slt, sltu, shifter_overflow;
adder_n #(.N(32)) ADDER (.a(a), .b(control[2] ? ~b : b), .c_in(control[2]), .sum(sum), .c_out(c_out));
always_comb begin
    overflow = control[3] & (a[N-1] ^ sum[N-1]) & (~(control[2] ^ a[N-1] ^ b[N-1]));
    zero = &(~result);
    equal = &(a~^b);
    slt = sum[N-1] ^ overflow;
    sltu = ~c_out;
    shifter_overflow = |b[N-1:5];
end

logic [N-1:0] sll_out, srl_out, sra_out, sum;
shift_left_logical      SLL (.in(a), .shamt(b[4:0]), .out(sll_out));
shift_right_logical     SRL (.in(a), .shamt(b[4:0]), .out(srl_out));
shift_right_arithmetic  SRA (.in(a), .shamt(b[4:0]), .out(sra_out));

mux16 #(.N(32)) OUTMUX (.in00(0), .in01(a&b), .in02(a|b), .in03(a^b), .in04(0),
    .in05(shifter_overflow ? 0 : sll_out), .in06(shifter_overflow ? 0 : srl_out), .in07(shifter_overflow ? 0 : sra_out), .in08(sum), .in09(0),
    .in10(0), .in11(0), .in12(sum), .in13({31'b0, slt}), .in14(0),
    .in15({31'b0, sltu}), .select(control), .out(result));

endmodule