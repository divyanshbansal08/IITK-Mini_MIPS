`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 17:05:21
// Design Name: 
// Module Name: execution_control
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



module execution_control(
    input  wire [31:0] pc,            // Current program counter
    input  wire [31:0] instruction,   // Current instruction
    input  wire [31:0] rs_data,       // RS register data
    input  wire [31:0] rt_data,       // RT register data
    input  wire        zero_flag,     // Zero flag from ALU
    input  wire        overflow_flag, // Overflow flag from ALU
    input  wire        carry_out,     // Carry out from ALU
    output wire        pc_write,      // Enable writing to PC
    output wire [31:0] next_pc,       // Next PC value
    output wire        ra_write,      // Enable writing to $ra
    output wire [31:0] ra_data        // Data to write to $ra
);

    // Extract instruction fields
    wire [5:0]  opcode = instruction[31:26];
    wire [15:0] immediate = instruction[15:0];
    wire [25:0] jump_target = instruction[25:0];
    
    // Branch handling
    wire branch_taken;
    wire [31:0] branch_target;
    
    branching_unit branch_unit(
        .pc(pc),
        .rs_data(rs_data),
        .rt_data(rt_data),
        .immediate(immediate),
        .opcode(opcode),
        .zero_flag(zero_flag),
        .overflow_flag(overflow_flag),
        .carry_out(carry_out),
        .branch_taken(branch_taken),
        .branch_target(branch_target)
    );
    
    // Jump handling
    wire jump_taken;
    wire [31:0] jump_address;
    wire link_enable;
    wire [31:0] link_address;
    
    jump_unit jump_ctrl(
        .pc(pc),
        .rs_data(rs_data),
        .jump_target(jump_target),
        .opcode(opcode),
        .jump_taken(jump_taken),
        .jump_address(jump_address),
        .link_enable(link_enable),
        .link_address(link_address)
    );
    
    // Default next PC is PC+4
    wire [31:0] pc_plus_4 = pc + 32'd4;
    
    // Select next PC value
    assign next_pc = jump_taken ? jump_address :
                     branch_taken ? branch_target :
                     pc_plus_4;
    
    // Always write to PC in a single-cycle implementation
    assign pc_write = 1'b1;
    
    // Return address handling for jal
    assign ra_write = link_enable;
    assign ra_data = link_address;
    
endmodule

