`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2025 06:26:22
// Design Name: 
// Module Name: register_file
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



module register_file(
    input wire clk,                // Clock signal
    input wire reset,              // Reset signal
    input wire [4:0] rs_addr,      // Source register 1 address
    input wire [4:0] rt_addr,      // Source register 2 address
    input wire [4:0] write_addr,   // Register to write to
    input wire [31:0] write_data,  // Data to write to register
    input wire write_enable,       // Register write enable
    output wire [31:0] rs_data,    // Source register 1 data
    output wire [31:0] rt_data     // Source register 2 data
);

    // 32 general-purpose registers (32 bits each)
    reg [31:0] registers [0:31];
    
    // Read operations (combinational)
    assign rs_data = (rs_addr == 5'b00000) ? 32'h00000000 : registers[rs_addr];
    assign rt_data = (rt_addr == 5'b00000) ? 32'h00000000 : registers[rt_addr];
    
    // Write operation (sequential)
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize all registers to 0 on reset
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'h00000000;
            end
        end else if (write_enable && write_addr != 5'b00000) begin
            // Write data to the specified register (except $zero)
            registers[write_addr] <= write_data;
        end
    end
endmodule