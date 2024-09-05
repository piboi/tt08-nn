/*
 * Copyright (c) 2024 Linyang Lee
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_neural_navigators (
    input signed [7:0] ui_in,              // din, 8-bit data path; din
    input signed [7:0] uio_in,             // w, 8-bit data path; IOs; weight, w 
    output signed [7:0] uo_out,            // outreg, output; sum 
    output [7:0] uio_out,           // Output; IOs
    output [7:0] uio_oe,            // IOs: Enable path (active high: 0=input, 1=output)
    input  ena,                     // always 1 when the design is powered, so you can ignore it
    input  clk,                     // clock
    input  rst_n                    // reset_n - low to reset
);
  

    // Assign output pins
    assign uio_out = 0; 
    assign uio_oe  = 0;

    // Instantiate the neuron module
    top_layer u_toplayer (
        .clk(clk),
        .rst_n(rst_n),
        .din(ui_in),
        .w(uio_in),                         
        .out(uo_out)
    );

endmodule 