module layer1(
    input clk,
    input rst_n,
    input signed [7:0] din,             // 8-bit input for neurons
    input signed [7:0] w,               // 8-bit weight input for neurons
    output reg [255:0] reg_layer1,      // Register to store the sum of each neuron
    output reg done                     // Done signal
);

    reg [5:0] neuron_index;             // Index to track current neuron
    reg [8:0] statel1;                    // State counter for each neuron
    wire signed [7:0] sum;              // Sum output from neuron

    // Instantiate the neuron module
    neuron u_neuron (
        .clk(clk),
        .rst_n(rst_n),
        .din(din),
        .w(w),
        .sum(sum)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            neuron_index <= 0;
            reg_layer1 <= 0;
            done <= 0;
            statel1 <= 0;

        end else if (!done) begin
            // Process each neuron 
            if (statel1 < 259) begin
                statel1 <= statel1 + 1;
            end else if (statel1 == 259) begin
                // Store the sum once the neuron processing is complete
                reg_layer1[(neuron_index * 8) +: 8] <= sum;
                statel1 <= 0;                // Reset state for next neuron
                neuron_index <= neuron_index + 1; // Move to the next neuron
            end
            
            // Check if all neurons are processed
            if (neuron_index == 32) begin
                done <= 1;  // Assert done when all neurons are processed
            end
        end
    end
endmodule
