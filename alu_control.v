`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2025 06:23:30
// Design Name: 
// Module Name: alu_control
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


module alu_control(
    input wire [1:0] alu_op,       // ALU operation type from control unit
    input wire [5:0] funct,
    input wire [5:0] opcode,        // Function code from instruction
    output reg [3:0] alu_control   // Specific ALU control signal
);

    always @(*) begin
        case(alu_op)
            2'b00: begin  // Memory address calculation or direct add
                alu_control = 4'b0010; // ADD operation
            end
            
            2'b01: begin  // Branch comparison
                alu_control = 4'b0110; // SUBTRACT for comparison
            end
            
            2'b10: begin  // R-type instruction
                case(funct)
                    6'b100000: alu_control = 4'b0010; // add
                    6'b100010: alu_control = 4'b0110; // sub
                    6'b100001: alu_control = 4'b0010; // addu (same hardware as add)
                    6'b100011: alu_control = 4'b0110; // subu (same hardware as sub)
                    6'b000000: alu_control = 4'b0000; // madd or sll
                    6'b000001: alu_control = 4'b0001; // maddu
                    6'b011000: alu_control = 4'b0011; // mul
                    6'b100100: alu_control = 4'b0000; // and
                    6'b100101: alu_control = 4'b0001; // or
                    6'b100111: alu_control = 4'b1100; // not
                    6'b100110: alu_control = 4'b0100; // xor
                    6'b000010: alu_control = 4'b0101; // srl
                    6'b000011: alu_control = 4'b0111; // sra
                    6'b101010: alu_control = 4'b1010; // slt
                    default:   alu_control = 4'b0000; // Default to AND
                endcase
            end
            
            2'b11: begin  // I-type logical/arithmetic
                case(opcode[2:0])
                    3'b100: alu_control = 4'b0000; // andi
                    3'b101: alu_control = 4'b0001; // ori
                    3'b110: alu_control = 4'b0100; // xori
                    3'b010: alu_control = 4'b1010; // slti
                    3'b011: alu_control = 4'b1011; // seqi
                    default: alu_control = 4'b0000;
                endcase
            end
            
            default: alu_control = 4'b0000; // Default to AND
        endcase
    end
endmodule

