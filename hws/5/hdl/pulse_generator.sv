/*
  Outputs a pulse generator with a period of "ticks".
  out should go high for one cycle ever "ticks" clocks.
*/
module pulse_generator(clk, rst, ena, ticks, out);

parameter N = 8;
input wire clk, rst, ena;
input wire [N-1:0] ticks;
output logic out;

logic [N-1:0] counter;

always_comb out = counter === ticks;

always_ff @(posedge clk) begin : pulse_gen_counter
    if (rst) counter <= 0;
    else if (ena) begin
        counter <= counter + 1;
        if (out) counter <= 0;
    end
end

endmodule
