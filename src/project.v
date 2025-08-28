/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none

// 1-bit Full Adder module
module full_adder (
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (cin & a);
endmodule

// 32-bit Ripple Carry Adder module
module ripple_carry_adder_32bit (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire cin,
    output wire [31:0] sum,
    output wire cout
);
    wire [30:0] carry; // Internal carry wires
    
    // Generate 32 full adders
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_full_adder
            if (i == 0) begin
                // First full adder with external carry input
                full_adder fa0 (
                    .a(a[0]),
                    .b(b[0]),
                    .cin(cin),
                    .sum(sum[0]),
                    .cout(carry[0])
                );
            end else if (i == 31) begin
                // Last full adder with external carry output
                full_adder fa31 (
                    .a(a[31]),
                    .b(b[31]),
                    .cin(carry[30]),
                    .sum(sum[31]),
                    .cout(cout)
                );
            end else begin
                // Middle full adders
                full_adder fa_mid (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(carry[i-1]),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end
        end
    endgenerate
endmodule

// Top-level module integrating with the provided template
module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Internal signals for 32-bit adder
    reg [31:0] operand_a;
    reg [31:0] operand_b;
    wire [31:0] adder_sum;
    wire adder_cout;
    
    // Instantiate 32-bit ripple carry adder
    ripple_carry_adder_32bit rca32 (
        .a(operand_a),
        .b(operand_b),
        .cin(1'b0),          // No carry input for this example
        .sum(adder_sum),
        .cout(adder_cout)
    );
    
    // Register inputs on clock edge for demonstration
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            operand_a <= 32'b0;
            operand_b <= 32'b0;
        end else if (ena) begin
            // Example: Load 32-bit values from 8-bit inputs
            // This is just for demonstration - in practice you'd need
            // multiple clock cycles or wider inputs to load 32-bit values
            operand_a <= {24'b0, ui_in};     // Zero-extend ui_in to 32 bits
            operand_b <= {24'b0, uio_in};    // Zero-extend uio_in to 32 bits
        end
    end
    
    // Output assignments
    assign uo_out = adder_sum[7:0];  // Lower 8 bits of sum
    assign uio_out = {adder_sum[15:8]}; // Next 8 bits of sum (bits 15-8)
    assign uio_oe = 8'hFF;           // Set all uio pins as outputs
    
    // List all unused inputs to prevent warnings
    wire _unused = &{adder_sum[31:16], adder_cout, 1'b0};
    
endmodule
