`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 16:56:33
// Design Name: 
// Module Name: shifter_unit
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


module shifter_unit(
    input  wire [31:0] value,
    input  wire [4:0]  shamt,
    input  wire [5:0]  opcode,
    input  wire [5:0]  funct,
    output reg  [31:0] result
);

    always @(*) begin
        // Default value
        result = 32'b0;
        
        // Only process if it's an R-type instruction
        if (opcode == 6'b000000) begin
            case (funct)
                6'b000000: result = value << shamt;                     // sll
                6'b000010: result = value >> shamt;                     // srl
                6'b000011: result = value >>> shamt;                    // sra 
                // For sla (arithmetic left shift), use logical left shift as they are equivalent
                default: result = 32'b0;
            endcase
        end
    end
endmodule
