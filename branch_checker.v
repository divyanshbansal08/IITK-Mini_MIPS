`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 17:09:34
// Design Name: 
// Module Name: branch_checker
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


module branch_checker(
    input wire [2:0] branch_type,
    input wire zero,
    input wire overflow,
    input wire carry_out,
    output reg branch_taken
);
    always @(*) begin
        case (branch_type)
            3'b000: branch_taken = zero;                         // beq
            3'b001: branch_taken = ~zero;                        // bne
            3'b010: branch_taken = ~zero & ~overflow;            // bgt
            3'b011: branch_taken = overflow | zero;              // blt
            3'b100: branch_taken = ~overflow;                    // bge
            3'b101: branch_taken = overflow | zero;              // ble
            3'b110: branch_taken = ~carry_out;                   // bgtu (unsigned)
            3'b111: branch_taken = carry_out | zero;             // bleu (unsigned)
            default: branch_taken = 1'b0;
        endcase
    end
endmodule
