`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 17:04:19
// Design Name: 
// Module Name: jump_unit
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



module jump_unit(
    input  wire [31:0] pc,             // Current program counter
    input  wire [31:0] rs_data,        // For jr instruction (jump to register)
    input  wire [25:0] jump_target,    // Jump target from instruction
    input  wire [5:0]  opcode,         // Instruction opcode
    output wire        jump_taken,     // Signal indicating if jump should be taken
    output reg  [31:0] jump_address,   // Jump target address
    output wire        link_enable,    // Enable writing to link register ($ra)
    output wire [31:0] link_address    // Return address (PC+4)
);

    // PC + 4 calculation
    wire [31:0] pc_plus_4 = pc + 32'd4;
    
    // Return address for jal
    assign link_address = pc_plus_4;
    
    // Enable writing to $ra register for jal
    assign link_enable = (opcode == 6'b000011);
    
    // Determine if this is a jump instruction
    assign jump_taken = (opcode == 6'b000010) || // j
                        (opcode == 6'b000011) || // jal
                        (opcode == 6'b000000 && rs_data === 32'bx); // jr (opcode with special funct code, simplified here)
    
    // Compute jump target address
    always @(*) begin
        case (opcode)
            6'b000010, 6'b000011: // j, jal
                // Jump address = top 4 bits of (PC+4) concatenated with 26-bit target shifted left 2 bits
                jump_address = {pc_plus_4[31:28], jump_target, 2'b00};
            
            6'b000000: // jr
                // Jump to address in register
                jump_address = rs_data;
                
            default:
                jump_address = pc_plus_4;
        endcase
    end
    
endmodule
