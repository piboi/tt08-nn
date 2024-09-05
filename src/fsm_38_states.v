module fsm_38_states(
    input clk,
    input rst_n,
    input start,
    output reg [8:0] state
);

// State definitions
parameter s1   = 9'd0;
parameter s2   = 9'd1;
parameter s3   = 9'd2;
parameter s4   = 9'd3;
parameter s5   = 9'd4;
parameter s6   = 9'd5;
parameter s7   = 9'd6;
parameter s8   = 9'd7;
parameter s9   = 9'd8;
parameter s10  = 9'd9;
parameter s11  = 9'd10;
parameter s12  = 9'd11;
parameter s13  = 9'd12;
parameter s14  = 9'd13;
parameter s15  = 9'd14;
parameter s16  = 9'd15;
parameter s17  = 9'd16;
parameter s18  = 9'd17;
parameter s19  = 9'd18;
parameter s20  = 9'd19;
parameter s21  = 9'd20;
parameter s22  = 9'd21;
parameter s23  = 9'd22;
parameter s24  = 9'd23;
parameter s25  = 9'd24;
parameter s26  = 9'd25;
parameter s27  = 9'd26;
parameter s28  = 9'd27;
parameter s29  = 9'd28;
parameter s30  = 9'd29;
parameter s31  = 9'd30;
parameter s32  = 9'd31;
parameter s33  = 9'd32;
parameter s34  = 9'd33;
parameter s35  = 9'd34;
parameter s36  = 9'd35;
parameter s37  = 9'd36;
parameter s38  = 9'd37;


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
            s16: state <= s17;
            s17: state <= s18;
            s18: state <= s19;
            s19: state <= s20;
            s20: state <= s21;
            s21: state <= s22;
            s22: state <= s23;
            s23: state <= s24;
            s24: state <= s25;
            s25: state <= s26;
            s26: state <= s27;
            s27: state <= s28;
            s28: state <= s29;
            s29: state <= s30;
            s30: state <= s31;
            s31: state <= s32;
            s32: state <= s33;
            s33: state <= s34;
            s34: state <= s35;
            s35: state <= s36;
            s36: state <= s37;
            s37: state <= s38;
            s38: state <= s1;
            //s36: state <= s1;

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
