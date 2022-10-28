// Generates "triangle" waves (counts from 0 to 2^N-1, then back down again)
// The triangle should increment/decrement only if the ena signal is high, and hold its value otherwise.
module triangle_generator(clk, rst, ena, out);

parameter N = 8;
input wire clk, rst, ena;
output logic [N-1:0] out;

typedef enum logic {COUNTING_UP, COUNTING_DOWN} state_t;
state_t state;

logic [N-1:0]count_add;
always_comb count_add = state ? -1 : 1;

always_ff @(posedge clk) begin
    if (rst) begin
        out <= 0;
        state <= COUNTING_UP;
    end else if (ena) begin
        case (state)
            COUNTING_UP   : if (out === (2**(N-1))) state <= COUNTING_DOWN;
            COUNTING_DOWN : if (out === 1) state <= COUNTING_UP;
            default: state <= 1'bx;
        endcase
        out <= out + count_add;
    end
end

endmodule