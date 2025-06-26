`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 16:55:43
// Design Name: 
// Module Name: logic_unit
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


module logic_unit(
    input  wire [31:0] a, b,
    input  wire [5:0]  opcode,
    input  wire [5:0]  funct,
    output reg  [31:0] result
);

    always @(*) begin
        case (opcode)
            // R-type logical operations
            6'b000000: begin
                case (funct)
                    6'b100100: result = a & b;      // and
                    6'b100101: result = a | b;      // or
                    6'b100111: result = ~a;         // not
                    6'b100110: result = a ^ b;      // xor
                    default: result = 32'b0;
                endcase
            end
            
            // I-type logical operations
            6'b001100: result = a & b;              // andi
            6'b001101: result = a | b;              // ori
            6'b001110: result = a ^ b;              // xori
            
            default: result = 32'b0;
        endcase
    end
endmodule
