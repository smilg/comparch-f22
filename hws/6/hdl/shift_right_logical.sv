`timescale 1ns/1ps
`default_nettype none
module shift_right_logical(in,shamt,out);
parameter N = 32; // only used as a constant! Don't feel like you need to a shifter for arbitrary N.

//port definitions
input  wire [N-1:0] in;    // A 32 bit input
input  wire [$clog2(N)-1:0] shamt; // Amount we shift by.
output wire [N-1:0] out;  // Output.

/*
def ins(length):
    ins_list = [f'in[{i}]' for i in range(length-1,-1,-1)]
    yield f'.in00({{{", ".join(ins_list)}}})'
    shift_amount = 1
    ins_list.insert(0, 0)
    while shift_amount < length:
        ins_list = ins_list[1:-1]
        ins_list.insert(0, f"{shift_amount}'b0")
        yield f'.in{shift_amount:02d}({{{", ".join(ins_list)}}})'
        shift_amount += 1

print('mux32 #(.N(32)) MUX_RIGHTSHIFT ('+f',\n\t'.join([i for i in ins(32)])+',\n.select(shamt), .out(out));')
*/

mux32 #(.N(32)) MUX_RIGHTSHIFT (.in00({in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19], in[18], in[17], in[16], in[15], in[14], in[13], in[12], in[11], in[10], in[9], in[8], in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]}),
        .in01({1'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19], in[18], in[17], in[16], in[15], in[14], in[13], in[12], in[11], in[10], in[9], in[8], in[7], in[6], in[5], in[4], in[3], in[2], in[1]}),
        .in02({2'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19], in[18], in[17], in[16], in[15], in[14], in[13], in[12], in[11], in[10], in[9], in[8], in[7], in[6], in[5], in[4], in[3], in[2]}),
        .in03({3'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19], in[18], in[17], in[16], in[15], in[14], in[13], in[12], in[11], in[10], in[9], in[8], in[7], in[6], in[5], in[4], in[3]}),
        .in04({4'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19], in[18], in[17], in[16], in[15], in[14], in[13], in[12], in[11], in[10], in[9], in[8], in[7], in[6], in[5], in[4]}),
        .in05({5'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19], in[18], in[17], in[16], in[15], in[14], in[13], in[12], in[11], in[10], in[9], in[8], in[7], in[6], in[5]}),
        .in06({6'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19], in[18], in[17], in[16], in[15], in[14], in[13], in[12], in[11], in[10], in[9], in[8], in[7], in[6]}),
        .in07({7'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19], in[18], in[17], in[16], in[15], in[14], in[13], in[12], in[11], in[10], in[9], in[8], in[7]}),
        .in08({8'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19], in[18], in[17], in[16], in[15], in[14], in[13], in[12], in[11], in[10], in[9], in[8]}),
        .in09({9'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19], in[18], in[17], in[16], in[15], in[14], in[13], in[12], in[11], in[10], in[9]}),
        .in10({10'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19], in[18], in[17], in[16], in[15], in[14], in[13], in[12], in[11], in[10]}),
        .in11({11'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19], in[18], in[17], in[16], in[15], in[14], in[13], in[12], in[11]}),
        .in12({12'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19], in[18], in[17], in[16], in[15], in[14], in[13], in[12]}),
        .in13({13'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19], in[18], in[17], in[16], in[15], in[14], in[13]}),
        .in14({14'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19], in[18], in[17], in[16], in[15], in[14]}),
        .in15({15'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19], in[18], in[17], in[16], in[15]}),
        .in16({16'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19], in[18], in[17], in[16]}),
        .in17({17'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19], in[18], in[17]}),
        .in18({18'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19], in[18]}),
        .in19({19'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20], in[19]}),
        .in20({20'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21], in[20]}),
        .in21({21'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22], in[21]}),
        .in22({22'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23], in[22]}),
        .in23({23'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24], in[23]}),
        .in24({24'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25], in[24]}),
        .in25({25'b0, in[31], in[30], in[29], in[28], in[27], in[26], in[25]}),
        .in26({26'b0, in[31], in[30], in[29], in[28], in[27], in[26]}),
        .in27({27'b0, in[31], in[30], in[29], in[28], in[27]}),
        .in28({28'b0, in[31], in[30], in[29], in[28]}),
        .in29({29'b0, in[31], in[30], in[29]}),
        .in30({30'b0, in[31], in[30]}),
        .in31({31'b0, in[31]}),
.select(shamt), .out(out));

endmodule
