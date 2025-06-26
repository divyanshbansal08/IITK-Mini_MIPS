`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 17:03:03
// Design Name: 
// Module Name: branching_sort
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


module branching_unit(
    input  wire [31:0] pc,            // Current program counter
    input  wire [31:0] rs_data,       // First register value
    input  wire [31:0] rt_data,       // Second register value
    input  wire [15:0] immediate,     // Branch offset immediate value
    input  wire [5:0]  opcode,        // Instruction opcode
    input  wire        zero_flag,     // Zero flag from ALU
    input  wire        overflow_flag, // Overflow flag from ALU
    input  wire        carry_out,     // Carry out from ALU
    output wire        branch_taken,  // Signal indicating if branch should be taken
    output wire [31:0] branch_target  // Target address if branch is taken
);

    // Sign-extend the immediate value for branch offset
    wire [31:0] sign_extended_imm = {{16{immediate[15]}}, immediate};
    
    // Shift left by 2 (multiply by 4) for word alignment
    wire [31:0] shifted_offset = {sign_extended_imm[29:0], 2'b00};
    
    // Compute branch target: PC + 4 + (immediate << 2)
    wire [31:0] pc_plus_4 = pc + 32'd4;
    assign branch_target = pc_plus_4 + shifted_offset;
    
    // Branch condition evaluation
    reg branch_condition;
    
    always @(*) begin
        // Default - no branch
        branch_condition = 1'b0;
        
        case (opcode)
            6'b000100: branch_condition = zero_flag;                   // beq
            6'b000101: branch_condition = ~zero_flag;                  // bne
            6'b000111: branch_condition = ~zero_flag & ~overflow_flag; // bgt
            6'b001000: branch_condition = overflow_flag | zero_flag;   // blt
            6'b000110: branch_condition = ~overflow_flag;              // bge
            6'b000001: branch_condition = overflow_flag | zero_flag;   // ble
            6'b000010: branch_condition = ~carry_out;                  // bgtu (unsigned)
            6'b000011: branch_condition = carry_out | zero_flag;       // bleu (unsigned)
            default:   branch_condition = 1'b0;
        endcase
    end
    
    // Branch taken if it's a branch instruction and condition is met
    assign branch_taken = (opcode[5:3] == 3'b000 && opcode != 6'b000000) && branch_condition;
    
endmodule
