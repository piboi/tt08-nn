module neuron_out (
    input clk, rst_n, start,
    input signed [7:0] b,                // 8-bit data input, including bias at state 256
    input signed [7:0] w,                // Signed Weight input
    input [79:0] outreg,                 // 256-bit register from layer1
    output reg signed [7:0] sum         // Signed Accumulated result
);

    reg signed [23:0] acc;               // Internal Accumulator
    reg signed [15:0] mult;              // Signed Multiplication result
    wire [4:0] state_nout;               // State wire from FSM
    reg signed [7:0] din;                // 8-bit register to hold din
    wire signed [23:0] b_ext;            // 24-bit extended bias
    wire signed [7:0] relu_out;          // ReLU module output
    

    // Instantiate FSM
    fsm_16_states instCtrl(.clk(clk), .rst_n(rst_n), .start(start),.state(state_nout));

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
            din <= 8'b0;

        end else if (start) begin
            if (state_nout < 9'd12) begin
                // Select the correct din segment from outreg based on state
                din <= outreg[(state_nout * 8) +: 8]; // Extract the correct 8-bit segment
                
                // Perform signed multiplication with selected din and w
                mult <= din * w;
                
                // Accumulate the result
                acc <= acc + mult;
            end else if (state_nout == 9'd13) begin
                din <= 8'b0;
                acc <= acc + b_ext;
            end else if (state_nout == 9'd14) begin
                // Final output with ReLU activation
                sum <= relu_out;
                
                // Reset acc for the next operation
                acc <= 24'b0;
                mult <= 16'b0;
               
            end
        end
    end
endmodule
