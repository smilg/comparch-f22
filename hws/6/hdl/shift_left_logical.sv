`timescale 1ns/1ps
`default_nettype none
module shift_left_logical(in, shamt, out);

parameter N = 32; // only used as a constant! Don't feel like you need to a shifter for arbitrary N.

input wire [N-1:0] in;            // the input number that will be shifted left. Fill in the remainder with zeros.
input wire [$clog2(N)-1:0] shamt; // the amount to shift by (think of it as a decimal number from 0 to 31). 
output logic [N-1:0] out;       

/*
def ins(length):
    ins_list = [f'in[{i}]' for i in range(length)]
    yield f'.in00({{{", ".join(ins_list)}}})'
    shift_amount = 1
    ins_list.append(0)
    while shift_amount < length:
        ins_list = ins_list[1:-1]
        ins_list.append(f"{shift_amount}'b0")
        yield f'.in{shift_amount:02d}({{{", ".join(ins_list)}}})'
        shift_amount += 1

print('mux32 #(.N(32)) MUX_LEFTSHIFT ('+f',\n\t'.join([i for i in ins(32)])+',\n.select(shamt), .out(out));')
*/

mux32 #(.N(32)) MUX_LEFTSHIFT (.in00({in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31]}),
        .in01({in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 1'b0}),
        .in02({in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 2'b0}),
        .in03({in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 3'b0}),
        .in04({in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 4'b0}),
        .in05({in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 5'b0}),
        .in06({in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 6'b0}),
        .in07({in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 7'b0}),
        .in08({in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 8'b0}),
        .in09({in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 9'b0}),
        .in10({in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 10'b0}),
        .in11({in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 11'b0}),
        .in12({in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 12'b0}),
        .in13({in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 13'b0}),
        .in14({in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 14'b0}),
        .in15({in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 15'b0}),
        .in16({in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 16'b0}),
        .in17({in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 17'b0}),
        .in18({in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 18'b0}),
        .in19({in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 19'b0}),
        .in20({in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 20'b0}),
        .in21({in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 21'b0}),
        .in22({in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 22'b0}),
        .in23({in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 23'b0}),
        .in24({in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], 24'b0}),
        .in25({in[25], in[26], in[27], in[28], in[29], in[30], in[31], 25'b0}),
        .in26({in[26], in[27], in[28], in[29], in[30], in[31], 26'b0}),
        .in27({in[27], in[28], in[29], in[30], in[31], 27'b0}),
        .in28({in[28], in[29], in[30], in[31], 28'b0}),
        .in29({in[29], in[30], in[31], 29'b0}),
        .in30({in[30], in[31], 30'b0}),
        .in31({in[31], 31'b0}),
.select(shamt), .out(out));

endmodule
