`timescale 1ns/1ps
module decoder_2_to_4(ena, in, out);

input wire ena;
input wire [1:0] in;
output logic [3:0] out;

wire [1:0] enas;
decoder_1_to_2 DECODER_ENA(ena, in[1], enas);
decoder_1_to_2 DECODER_0(enas[0], in[0], out[1:0]);
decoder_1_to_2 DECODER_1(enas[1], in[0], out[3:2]);

endmodule