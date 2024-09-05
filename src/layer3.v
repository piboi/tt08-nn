module layer3(
    input clk,
    input rst_n,
    input start,
    input signed [7:0] b,             // 8-bit input for neurons
    input signed [7:0] w,               // 8-bit weight input for neurons
    input [255:0] reg_layer2,           // 256-bit register from layer1
    output reg [79:0] outreg, 
    output reg done                     // Done signal
);

   
    reg [5:0] neuron_index;             // Index to track current neuron 
    reg [8:0] stateout;                    // State counter for each neuron
    wire signed [7:0] sum;              // Sum output from neuron

    // Instantiate the neuron module
    neuron_hidden u_neuron (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .b(b),
        .w(w),
        .reg_layer1(reg_layer2),
        .sum(sum)
    );

    //offset stateout from state in neuron by half-clock cycle
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            neuron_index <= 0;
            outreg <= 0;
            done <= 0;
            stateout <= 0;
        end else if (start && !done) begin
            // Process each neuron for 260 states
            if (stateout < 37) begin
                stateout <= stateout + 1;
            end else if (stateout == 37) begin
                // Store the sum once the neuron processing is complete
                outreg[(neuron_index * 8) +: 8] <= sum;
                stateout <= 0;                // Reset state for next neuron
                neuron_index <= neuron_index + 1; // Move to the next neuron
            end
            
            // Check if all neurons are processed
            if (neuron_index == 10) begin
                done <= 1;  // Assert done when all neurons are processed
            end
        end
    end
endmodule