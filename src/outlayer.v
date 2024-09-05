module outlayer(
    input clk,
    input rst_n,
    input start,
    input signed [7:0] b,             // 8-bit input for neurons
    input signed [7:0] w,               // 8-bit weight input for neurons
    input [79:0] outreg,      // Register to store the sum of each neuron
    output signed [7:0] out,
    output reg done                     // Done signal
);

    //reg [5:0] neuron_index;             // Index to track current neuron 
    reg [8:0] state_nout;                    // State counter
    //wire signed [7:0] sum;              // Sum output from neuron

    // Instantiate the neuron module
    neuron_out u_neuron (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .b(b),
        .w(w),
        .outreg(outreg),
        .sum(out)
    );

    //offset state_nout from state in neuron by half-clock cycle
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            //neuron_index <= 0;
            done <= 0;
            state_nout <= 0;
        end else if (start && !done) begin
            // Process each neuron for 260 states
            if (state_nout < 15) begin
                state_nout <= state_nout + 1;
            end else if (state_nout == 15) begin

                state_nout <= 0;               
                done<=1;
            end
            
        end
    end
endmodule