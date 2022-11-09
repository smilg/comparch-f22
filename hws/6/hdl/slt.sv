`timescale 1ns/1ps
`default_nettype none
module slt(a, b, out);
parameter N = 32;
input wire signed [N-1:0] a, b;
output logic out;

// Using only *structural* combinational logic, make a module that computes if a is less than b!
// Note: this assumes that the two inputs are signed: aka should be interpreted as two's complement.

// Copy any other modules you use into this folder and update the Makefile accordingly.

logic [N-1:0] sum;

adder_n #(.N(N)) ADDER_INV (.a(a), .b(~b), .c_in(1'b1), .sum(sum), .c_out()); 
always_comb out = sum[N-1] ^ ((a[N-1] ^ sum[N-1]) & (a[N-1] ^ b[N-1]));


endmodule


