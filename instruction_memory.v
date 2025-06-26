`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 17:12:56
// Design Name: 
// Module Name: instruction_memory
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


module instruction_memory(
    input wire [31:0] address,
    output wire [31:0] instruction
);
    reg [31:0] memory [0:16383]; // 64KB instruction memory
    
    // Convert byte address to word address (ignoring the top bits)
    wire [13:0] word_addr = address[15:2];
    
    assign instruction = memory[word_addr];
endmodule
