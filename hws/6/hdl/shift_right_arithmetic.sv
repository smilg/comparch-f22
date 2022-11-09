`timescale 1ns/1ps
`default_nettype none
module shift_right_arithmetic(in,shamt,out);
parameter N = 32; // only used as a constant! Don't feel like you need to a shifter for arbitrary N.

//port definitions
input  wire [N-1:0] in;    // A 32 bit input
input  wire [$clog2(N)-1:0] shamt; // Shift ammount
output wire [N-1:0] out; // The same as SRL, but maintain the sign bit (MSB) after the shift! 
// It's similar to SRL, but instead of filling in the extra bits with zero, we
// fill them in with the sign bit.
// Remember the *repetition operator*: {n{bits}} will repeat bits n times.

/*
def ins(length):
    ins_list = [f'in[{i}]' for i in range(length)]
    yield f'.in00({{{", ".join(ins_list)}}})'
    shift_amount = 1
    ins_list.insert(0, 0)
    while shift_amount < length:
        ins_list = ins_list[1:-1]
        ins_list.insert(0, f"{{{shift_amount}{{in[N-1]}}}}")
        yield f'.in{shift_amount:02d}({{{", ".join(ins_list)}}})'
        shift_amount += 1

print('mux32 #(.N(32)) MUX_RIGHTSHIFT_ARITHMETIC ('+f',\n\t'.join([i for i in ins(32)])+',\n.select(shamt), .out(out));')
*/

mux32 #(.N(32)) MUX_RIGHTSHIFT_ARITHMETIC (.in00({in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31]}),
        .in01({{1{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30]}),
        .in02({{2{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29]}),
        .in03({{3{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28]}),
        .in04({{4{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27]}),
        .in05({{5{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26]}),
        .in06({{6{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25]}),
        .in07({{7{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24]}),
        .in08({{8{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23]}),
        .in09({{9{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22]}),
        .in10({{10{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21]}),
        .in11({{11{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20]}),
        .in12({{12{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19]}),
        .in13({{13{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18]}),
        .in14({{14{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17]}),
        .in15({{15{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16]}),
        .in16({{16{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15]}),
        .in17({{17{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14]}),
        .in18({{18{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13]}),
        .in19({{19{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12]}),
        .in20({{20{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11]}),
        .in21({{21{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10]}),
        .in22({{22{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9]}),
        .in23({{23{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8]}),
        .in24({{24{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]}),
        .in25({{25{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5], in[6]}),
        .in26({{26{in[N-1]}}, in[0], in[1], in[2], in[3], in[4], in[5]}),
        .in27({{27{in[N-1]}}, in[0], in[1], in[2], in[3], in[4]}),
        .in28({{28{in[N-1]}}, in[0], in[1], in[2], in[3]}),
        .in29({{29{in[N-1]}}, in[0], in[1], in[2]}),
        .in30({{30{in[N-1]}}, in[0], in[1]}),
        .in31({{31{in[N-1]}}, in[0]}),
.select(shamt), .out(out));

endmodule
