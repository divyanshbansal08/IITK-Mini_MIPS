`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 16:52:58
// Design Name: 
// Module Name: alu
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


module alu(
    input  wire [31:0] a, b,          // 32-bit operands
    input  wire [5:0]  opcode,        // Operation code from instruction
    input  wire [5:0]  funct,         // Function code for R-type instructions
    input  wire [4:0]  shamt,         // Shift amount
    output reg  [31:0] result,        // 32-bit result
    output reg         zero_flag,     // Zero flag
    output reg         overflow_flag, // Overflow flag
    output reg         carry_out      // Carry out flag
);

    // Internal wires for results from different functional units
    wire [31:0] arith_result;
    wire [31:0] logic_result;
    wire [31:0] shift_result;
    wire [31:0] comp_result;
    
    // Carry and overflow flags from arithmetic unit
    wire arith_overflow, arith_carry;
    
    // Instantiate functional sub-modules
    arithmetic_unit arith(
        .a(a),
        .b(b),
        .opcode(opcode),
        .funct(funct),
        .result(arith_result),
        .overflow(arith_overflow),
        .carry_out(arith_carry)
    );
    
    logic_unit logic_op(
        .a(a),
        .b(b),
        .opcode(opcode),
        .funct(funct),
        .result(logic_result)
    );
    
    shifter_unit shifter(
        .value(a),
        .shamt(shamt),
        .opcode(opcode),
        .funct(funct),
        .result(shift_result)
    );
    
    comparator_unit comparator(
        .a(a),
        .b(b),
        .opcode(opcode),
        .funct(funct),
        .result(comp_result)
    );
    
    // Result selection based on operation
    always @(*) begin
        // Default values
        overflow_flag = 1'b0;
        carry_out = 1'b0;
        
        // Select output based on operation category
        case (opcode)
            // R-type arithmetic operations
            6'b000000: begin
                case (funct)
                    // Arithmetic operations
                    6'b100000, 6'b100001, 6'b100010, 6'b100011,
                    6'b000000, 6'b000001, 6'b011000: begin
                        result = arith_result;
                        overflow_flag = arith_overflow;
                        carry_out = arith_carry;
                    end
                    
                    // Logical operations
                    6'b100100, 6'b100101, 6'b100111, 6'b100110: begin
                        result = logic_result;
                    end
                    
                    // Shift operations
                    6'b000000, 6'b000010, 6'b000011: begin
                        result = shift_result;
                    end
                    
                    // Comparison
                    6'b101010: begin
                        result = comp_result;
                    end
                    
                    default: result = 32'b0;
                endcase
            end
            
            // I-type arithmetic operations
            6'b001000, 6'b001001: begin // addi, addiu
                result = arith_result;
                overflow_flag = arith_overflow;
                carry_out = arith_carry;
            end
            
            // I-type logical operations
            6'b001100, 6'b001101, 6'b001110: begin // andi, ori, xori
                result = logic_result;
            end
            
            // Comparison operations
            6'b001010, 6'b001011: begin // slti, seqi
                result = comp_result;
            end
            
            // Default case
            default: result = 32'b0;
        endcase
        
        // Set zero flag if result is zero
        zero_flag = (result == 32'b0);
    end

endmodule