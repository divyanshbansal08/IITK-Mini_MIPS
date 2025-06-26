`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 16:59:34
// Design Name: 
// Module Name: adder_32bit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module adder_32bit(
    input  wire [31:0] a, b,
    input  wire        cin,
    output wire [31:0] sum,
    output wire        cout,
    output wire        overflow
);
    // Internal carry signals
    wire [32:0] carry;
    assign carry[0] = cin;
    
    // Generate sum bits
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin: adder_loop
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate
    
    // Final carry out
    assign cout = carry[32];
    
    // Overflow detection (for signed operations)
    assign overflow = carry[31] ^ carry[32];
endmodule
