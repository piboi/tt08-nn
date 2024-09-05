module relu #(
    parameter IN_WIDTH = 1
) (
    output reg signed [7:0] out,
    input signed [IN_WIDTH-1:0] in
);

always @(*) begin
    if (in >= 128) begin
        out = 8'd127;  // Clamp to 127
    end else if (in <= -128) begin
        out = -8'd128;  // Clamp to -128
    end else begin
        out = $signed(in[7:0]);  // Safely truncate to 8-bit signed output
    end
end

endmodule