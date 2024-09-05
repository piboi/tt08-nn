module layer2(
    input clk,
    input rst_n,
    input start,
    input signed [7:0] b,             // 8-bit input for neurons
    input signed [7:0] w,               // 8-bit weight input for neurons
    input [255:0] reg_layer1,           // 256-bit register from layer1
    output reg [255:0] reg_layer2,      // Register to store the sum of each neuron
    output reg done                     // Done signal
);

    reg [5:0] neuron_index;             // Index to track current neuron (0 to 31)
    reg [8:0] statel2;                    // State counter for each neuron
    wire signed [7:0] sum;              // Sum output from neuron


    // Instantiate the neuron module
    neuron_hidden u_neuron (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .b(b),
        .w(w),
        .reg_layer1(reg_layer1),
        .sum(sum)
    );


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            neuron_index <= 0;
            reg_layer2 <= 0;
            done <= 0;
            statel2 <= 0;
        end else if (start && !done) begin
            // Process each neuron 
            if (statel2 < 37) begin
                statel2 <= statel2 + 1;
            end else if (statel2 == 37) begin
                // Store the sum once the neuron processing is complete
                reg_layer2[(neuron_index * 8) +: 8] <= sum;
                statel2 <= 0;                // Reset state for next neuron
                neuron_index <= neuron_index + 1; // Move to the next neuron
            end
            
            // Check if all neurons are processed
            if (neuron_index == 32) begin
                done <= 1;  // Assert done when all neurons are processed
            end
        end
    end
endmodule