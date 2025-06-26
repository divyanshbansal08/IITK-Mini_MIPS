`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 16:54:33
// Design Name: 
// Module Name: arithmetic_unit
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


module arithmetic_unit(
    input  wire [31:0] a, b,
    input  wire [5:0]  opcode,
    input  wire [5:0]  funct,
    output reg  [31:0] result,
    output reg         overflow,
    output reg         carry_out
);

    // Internal nets for shared components
    wire [31:0] add_result;
    wire [31:0] sub_result;
    wire add_overflow, add_carry;
    wire sub_overflow, sub_carry;
    
    // Shared adder - can be used for add, addu, addi, addiu
    adder_32bit adder(
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(add_result),
        .cout(add_carry),
        .overflow(add_overflow)
    );
    
    // Shared subtractor (reuses adder with inverted B)
    adder_32bit subtractor(
        .a(a),
        .b(~b),
        .cin(1'b1), // Adding 1 for two's complement
        .sum(sub_result),
        .cout(sub_carry),
        .overflow(sub_overflow)
    );
    
    // HI-LO registers for multiplication
    reg [31:0] hi, lo;
    
    always @(*) begin
        // Default values
        overflow = 1'b0;
        carry_out = 1'b0;
        
        case (opcode)
            // R-type arithmetic
            6'b000000: begin
                case (funct)
                    6'b100000: begin // add
                        result = add_result;
                        overflow = add_overflow;
                        carry_out = add_carry;
                    end
                    
                    6'b100001: begin // addu
                        result = add_result;
                        carry_out = add_carry;
                    end
                    
                    6'b100010: begin // sub
                        result = sub_result;
                        overflow = sub_overflow;
                        carry_out = sub_carry;
                    end
                    
                    6'b100011: begin // subu
                        result = sub_result;
                        carry_out = sub_carry;
                    end
                    
                    6'b000000: begin // madd
                        {hi, lo} = {hi, lo} + {{32{a[31]}}, a} * {{32{b[31]}}, b};
                        result = lo;
                    end
                    
                    6'b000001: begin // maddu
                        {hi, lo} = {hi, lo} + {32'b0, a} * {32'b0, b};
                        result = lo;
                    end
                    
                    6'b011000: begin // mul
                        {hi, lo} = {{32{a[31]}}, a} * {{32{b[31]}}, b};
                        result = lo;
                    end
                    
                    default: result = 32'b0;
                endcase
            end
            
            // I-type arithmetic
            6'b001000: begin // addi
                result = add_result;
                overflow = add_overflow;
                carry_out = add_carry;
            end
            
            6'b001001: begin // addiu
                result = add_result;
                carry_out = add_carry;
            end
            
            default: result = 32'b0;
        endcase
    end
endmodule

