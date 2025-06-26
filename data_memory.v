`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 17:13:56
// Design Name: 
// Module Name: data_memory
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


module data_memory(
    input wire clk,
    input wire [31:0] address,
    input wire [31:0] write_data,
    input wire mem_read,
    input wire mem_write,
    output wire [31:0] read_data
);
    reg [31:0] memory [0:16383]; // 64KB data memory
    
    // Convert byte address to word address
    wire [13:0] word_addr = address[15:2];
    
    // Read operation (combinational)
    assign read_data = mem_read ? memory[word_addr] : 32'h00000000;
    
    // Write operation (sequential)
    always @(posedge clk) begin
        if (mem_write)
            memory[word_addr] <= write_data;
    end
endmodule