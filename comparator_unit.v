`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 16:57:35
// Design Name: 
// Module Name: comparator_unit
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


module comparator_unit(
    input  wire [31:0] a, b,
    input  wire [5:0]  opcode,
    input  wire [5:0]  funct,
    output reg  [31:0] result
);

    always @(*) begin
        // Default value
        result = 32'b0;
        
        case (opcode)
            // R-type comparison
            6'b000000: begin
                if (funct == 6'b101010) begin // slt
                    result = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
                end
            end
            
            // I-type comparison
            6'b001010: begin // slti
                result = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
            end
            
            6'b001011: begin // seqi
                result = (a == b) ? 32'b1 : 32'b0;
            end
            
            default: result = 32'b0;
        endcase
    end
endmodule

