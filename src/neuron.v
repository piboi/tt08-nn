module neuron (
    input clk, rst_n,
    input signed [7:0] din,             // 8-bit data input, including bias at state 256
    input signed [7:0] w,               // Signed Weight input
    output reg signed [7:0] sum         // Signed Accumulated result
);

    reg signed [23:0] acc;              // Internal Accumulator
    reg signed [15:0] mult;             // Signed Multiplication result
    wire [8:0] state;                   // State wire from FSM
    reg signed [7:0] b;                 // 8-bit register to hold the bias value
    wire signed [23:0] b_ext;           // 24-bit extended bias
    wire signed [7:0] relu_out;         // ReLU module output

    // Instantiate fsm_260_states with the slower clock
    fsm_260_states instCtrl(.clk(clk), .rst_n(rst_n), .state(state));

    // Instantiate ReLU module with 24-bit input
    relu #(.IN_WIDTH(24)) relu_ins(
        .out(relu_out),
        .in(acc) // Pass the accumulator value to ReLU
    );

    // Sign extension for bias to 24 bits
    assign b_ext = {{16{b[7]}}, b}; // Extend b from 8-bit to 24-bit

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc <= 24'b0;
            sum <= 8'b0;
            mult <= 16'b0;
            b <= 8'b0;
        end else begin
            if (state < 9'd256) begin
                // Perform signed multiplication with updated din and w
                mult <= din * w;
                // Accumulate the result
                acc <= acc + mult;
            end else if (state == 9'd256) begin
                // Assign din to b when state is 256
                b <= din;
            end else if (state == 9'd257) begin
                // Add bias (extended) at state 256
                acc <= acc + b_ext;
            end else if (state == 9'd258) begin
                sum <= relu_out;
                // Reset acc for the next operation
                acc <= 24'b0;
                mult <= 16'b0;
            /*end else if (state == 9'd259) begin
                // Reset acc for the next operation
                mult <= 16'b0;*/
            end
        end
    end
endmodule
