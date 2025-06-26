`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2025 06:19:33
// Design Name: 
// Module Name: control_unit
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


module control_unit(
    input wire clk,
    input wire reset,
    input wire [5:0] opcode,
    input wire [5:0] funct,
    input wire [4:0] rs_field,
    
    // Register control signals
    output reg reg_dst,        // 0: rt as destination, 1: rd as destination
    output reg reg_write,      // Enable writing to register file
    output reg alu_src,        // 0: second ALU operand from register, 1: from immediate
    output reg [3:0] alu_op,   // ALU operation code
    
    // Memory control signals
    output reg mem_read,       // Enable memory read
    output reg mem_write,      // Enable memory write
    output reg mem_to_reg,     // 0: register write data from ALU, 1: from memory
    
    // Branch and jump control
    output reg branch,         // Branch instruction
    output reg [2:0] branch_type, // Type of branch comparison
    output reg jump,           // Jump instruction
    output reg jump_reg,       // Jump to register
    output reg link,           // Write return address to $ra
    
    // Floating point control
    output reg fp_op,          // Floating point operation
    output reg fp_reg_write    // Write to floating point register
);

    // FSM state definitions
    parameter FETCH = 1'b0;
    parameter EXECUTE = 1'b1;
    
    // State register
    reg state, next_state;
    
    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= FETCH;
        else
            state <= next_state;
    end
    
    // Next state logic
    always @(*) begin
        case (state)
            FETCH:   next_state = EXECUTE;
            EXECUTE: next_state = FETCH;
            default: next_state = FETCH;
        endcase
    end
    
    // Output logic based on current state and opcode
    always @(*) begin
        // Default control signals
        reg_dst = 0;
        reg_write = 0;
        alu_src = 0;
        alu_op = 4'b0000;
        mem_read = 0;
        mem_write = 0;
        mem_to_reg = 0;
        branch = 0;
        branch_type = 3'b000;
        jump = 0;
        jump_reg = 0;
        link = 0;
        fp_op = 0;
        fp_reg_write = 0;
        
        if (state == EXECUTE) begin
            case (opcode)
                // R-type instructions
                6'b000000: begin
                    case (funct)
                        // jr instruction
                        6'b001000: begin
                            jump_reg = 1;
                        end
                        // Standard arithmetic operations
                        6'b100000, 6'b100001, 6'b100010, 6'b100011: begin // add, addu, sub, subu
                            reg_dst = 1;
                            reg_write = 1;
                            alu_op = {1'b0, funct[3:1]};
                        end
                        // Multiply operations
                        6'b000000, 6'b000001, 6'b011000: begin // madd, maddu, mul
                            reg_dst = 1;
                            reg_write = 1;
                            alu_op = {2'b10, funct[1:0]};
                        end
                        // Logical operations
                        6'b100100, 6'b100101, 6'b100110, 6'b100111: begin // and, or, xor, not
                            reg_dst = 1;
                            reg_write = 1;
                            alu_op = {2'b01, funct[1:0]};
                        end
                        // Shift operations
                        6'b000000, 6'b000010, 6'b000011: begin // sll, srl, sra
                            reg_dst = 1;
                            reg_write = 1;
                            alu_op = {3'b001, funct[0]};
                        end
                        // Comparison operations
                        6'b101010: begin // slt
                            reg_dst = 1;
                            reg_write = 1;
                            alu_op = 4'b1010;
                        end
                        default: alu_op = 4'b0000;
                    endcase
                end
                
                // Load instruction
                6'b100011: begin // lw
                    alu_src = 1;
                    mem_to_reg = 1;
                    reg_write = 1;
                    mem_read = 1;
                    alu_op = 4'b0000; // Add for address calculation
                end
                
                // Store instruction
                6'b101011: begin // sw
                    alu_src = 1;
                    mem_write = 1;
                    alu_op = 4'b0000; // Add for address calculation
                end
                
                // Branch instructions
                6'b000100: begin // beq
                    branch = 1;
                    branch_type = 3'b000; // Equal comparison
                    alu_op = 4'b0001; // Subtract for comparison
                end
                6'b000101: begin // bne
                    branch = 1;
                    branch_type = 3'b001; // Not equal comparison
                    alu_op = 4'b0001;
                end
                6'b000111: begin // bgt
                    branch = 1;
                    branch_type = 3'b010; // Greater than comparison
                    alu_op = 4'b0001;
                end
                6'b001000: begin // blt
                    branch = 1;
                    branch_type = 3'b011; // Less than comparison
                    alu_op = 4'b0001;
                end
                6'b000110: begin // bge
                    branch = 1;
                    branch_type = 3'b100; // Greater than or equal
                    alu_op = 4'b0001;
                end
                6'b000001: begin // ble
                    branch = 1;
                    branch_type = 3'b101; // Less than or equal
                    alu_op = 4'b0001;
                end
                6'b000010: begin // bgtu (jump opcode, BUT NOT actual jump for IITK-Mini-MIPS)
                    branch = 1;
                    branch_type = 3'b110; // Greater than unsigned
                    alu_op = 4'b0001;
                end
                6'b000011: begin // bleu (jump opcode, BUT NOT actual jump for IITK-Mini-MIPS)
                    branch = 1;
                    branch_type = 3'b111; // Less than or equal unsigned
                    alu_op = 4'b0001;
                end
                
                // I-type arithmetic operations
                6'b001000: begin // addi
                    alu_src = 1;
                    reg_write = 1;
                    alu_op = 4'b0000; // Add
                end
                6'b001001: begin // addiu
                    alu_src = 1;
                    reg_write = 1;
                    alu_op = 4'b0000; // Add (unsigned)
                end
                
                // I-type logical operations
                6'b001100: begin // andi
                    alu_src = 1;
                    reg_write = 1;
                    alu_op = 4'b0100; // AND
                end
                6'b001101: begin // ori
                    alu_src = 1;
                    reg_write = 1;
                    alu_op = 4'b0101; // OR
                end
                6'b001110: begin // xori
                    alu_src = 1;
                    reg_write = 1;
                    alu_op = 4'b0110; // XOR
                end
                
                // Comparison operations
                6'b001010: begin // slti
                    alu_src = 1;
                    reg_write = 1;
                    alu_op = 4'b1010; // Set less than
                end
                6'b001011: begin // seqi
                    alu_src = 1;
                    reg_write = 1;
                    alu_op = 4'b1011; // Set equal
                end
                
                // Jump operations
                6'b000010: begin // j
                    jump = 1;
                end
                6'b000011: begin // jal
                    jump = 1;
                    link = 1;
                    reg_write = 1;
                end
                
                // Floating point operations
                6'b010001: begin
                    fp_op = 1;
                    // Additional decoding based on RS field
                    case (rs_field)
                        5'b00000: begin // mfc1
                            reg_write = 1;
                        end
                        5'b00100: begin // mtc1
                            fp_reg_write = 1;
                        end
                        5'b10000: begin // FP arithmetic
                            fp_reg_write = 1;
                            // Additional decoding would be done for specific FP operations
                        end
                        default: fp_reg_write = 0;
                    endcase
                end
                
                default: begin
                    // No operation or unrecognized instruction
                end
            endcase
        end
    end
endmodule

