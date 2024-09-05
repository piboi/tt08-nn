module top_layer(
    input clk,
    input rst_n,
    input signed [7:0] din,             // 8-bit input for neurons + bias in layer1 and as bias in layer2 and outlayer
    input signed [7:0] w,               // 8-bit weight input for all neurons
    output [7:0] out                   // Output   
);

    // Intermediate signals
    wire [255:0] reg_layer1;            // Output from layer1 to input of layer2
    wire done_layer1;                   // Done signal from layer1
    wire [255:0] reg_layer2;            // Output from layer2 to input of layer3
    wire done_layer2;                   // Done signal from layer2
    wire [79:0] outreg;
    wire done_layer3;                   // Done signal from layer3
    wire done_outlayer;

    // Internal signals for delay
    reg delayed_done_layer1;
    reg delayed_done_layer2;
    reg delayed_done_layer3;            // Delayed done signal for layer3
    reg [1:0] delay_counter_layer1;
    reg [1:0] delay_counter_layer2;
    reg [1:0] delay_counter_layer3;     // Delay counter for layer3

    // Instantiate layer1
    layer1 u_layer1 (
        .clk(clk),
        .rst_n(rst_n),
        .din(din),                      // Input to layer1
        .w(w),                          // Weight input for layer1
        .reg_layer1(reg_layer1),        // Output register to layer2
        .done(done_layer1)              // Done signal from layer1
    );

    // Instantiate layer2
    layer2 u_layer2 (
        .clk(clk),
        .rst_n(rst_n),
        .start(delayed_done_layer1),    // Start layer2 when delayed_done_layer1 is asserted
        .b(din),                        // Use din as bias input for layer2
        .w(w),                          // Weight input for layer2
        .reg_layer1(reg_layer1),        // Input register from layer1
        .reg_layer2(reg_layer2),        // Output register to layer3
        .done(done_layer2)              // Done signal from layer2
    );

    // Instantiate layer3
    layer3 u_layer3 (
        .clk(clk),
        .rst_n(rst_n),
        .start(delayed_done_layer2),    // Start layer3 when delayed_done_layer2 is asserted
        .b(din),                        // Use din as bias input for layer3
        .w(w),                          // Weight input for layer3
        .reg_layer2(reg_layer2),        // Input register from layer2
        .outreg(outreg),                // Final output register
        .done(done_layer3)              // Done signal for layer3
    );

    // Instantiate neuron_out
    outlayer u_outlayer (
        .clk(clk),
        .rst_n(rst_n),
        .start(delayed_done_layer3),    // Start neuron_out when delayed_done_layer3 is asserted
        .b(din),                        // Use din as bias input for neuron_out
        .w(w),                          // Weight input for neuron_out
        .outreg(outreg),                // Input register, connect outreg from layer3
        .out(out),           // Output sum from neuron_out
        .done(done_outlayer)
    );

    // Handle delays for done_layer1, done_layer2, and done_layer3
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            delayed_done_layer1 <= 0;
            delayed_done_layer2 <= 0;
            delayed_done_layer3 <= 0;
            delay_counter_layer1 <= 0;
            delay_counter_layer2 <= 0;
            delay_counter_layer3 <= 0;
        end else begin
            // Handle delay for done_layer1
            if (done_layer1) begin
                delay_counter_layer1 <= 2;  // Start 2-cycle delay
            end else if (delay_counter_layer1 > 0) begin
                delay_counter_layer1 <= delay_counter_layer1 - 1;
            end
            delayed_done_layer1 <= (delay_counter_layer1 > 0);

            // Handle delay for done_layer2
            if (done_layer2) begin
                delay_counter_layer2 <= 2;  // Start 2-cycle delay
            end else if (delay_counter_layer2 > 0) begin
                delay_counter_layer2 <= delay_counter_layer2 - 1;
            end
            delayed_done_layer2 <= (delay_counter_layer2 > 0);

            // Handle delay for done_layer3
            if (done_layer3) begin
                delay_counter_layer3 <= 2;  // Start 2-cycle delay
            end else if (delay_counter_layer3 > 0) begin
                delay_counter_layer3 <= delay_counter_layer3 - 1;
            end
            delayed_done_layer3 <= (delay_counter_layer3 > 0);
        end
    end

endmodule
