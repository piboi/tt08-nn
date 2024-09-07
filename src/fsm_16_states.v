module fsm_16_states(
    input clk,
    input rst_n,
    input start,
    output reg [4:0] state
);

// State definitions
parameter s1   = 5'd0;
parameter s2   = 5'd1;
parameter s3   = 5'd2;
parameter s4   = 5'd3;
parameter s5   = 5'd4;
parameter s6   = 5'd5;
parameter s7   = 5'd6;
parameter s8   = 5'd7;
parameter s9   = 5'd8;
parameter s10  = 5'd9;
parameter s11  = 5'd10;
parameter s12  = 5'd11;
parameter s13  = 5'd12;
parameter s14  = 5'd13;
parameter s15  = 5'd14;
parameter s16  = 5'd15;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= s1;
    end else if (start) begin
        case (state)
            s1: state <= s2;
            s2: state <= s3;
            s3: state <= s4;
            s4: state <= s5;
            s5: state <= s6;
            s6: state <= s7;
            s7: state <= s8;
            s8: state <= s9;
            s9: state <= s10;
            s10: state <= s11;
            s11: state <= s12;
            s12: state <= s13;
            s13: state <= s14;
            s14: state <= s15;
            s15: state <= s16;
            s16: state <= s1;

            default: begin
                // Handle any unexpected states
                state <= s1; // or some error state
            end
        endcase
    end else begin
        state <=s1;
    end
end

endmodule
