`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 17:33:28
// Design Name: 
// Module Name: fp_register_file
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

module fp_register_file(
    input  wire        clk,              // Clock signal
    input  wire        reset,            // Reset signal
    input  wire [4:0]  read_reg1,        // First register to read (rs)
    input  wire [4:0]  read_reg2,        // Second register to read (rt)
    input  wire [4:0]  write_reg,        // Register to write to
    input  wire [31:0] write_data,       // Data to write
    input  wire        write_enable,     // Write enable signal
    output wire [31:0] read_data1,       // Data from first register
    output wire [31:0] read_data2        // Data from second register
);

    // Floating-point register file (32 registers, 32 bits each)
    reg [31:0] registers [0:31];
    integer i;
    
    // Read operations (combinational)
    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];
    
    // Write operation (sequential)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize all floating-point registers to 0 on reset
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'h00000000;
            end
        end else if (write_enable) begin
            // Write data to the specified floating-point register
            registers[write_reg] <= write_data;
        end
    end
endmodule
