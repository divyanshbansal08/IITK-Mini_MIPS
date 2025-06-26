`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2025 00:13:50
// Design Name: 
// Module Name: instruction_fetch
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


module instruction_fetch(
    input wire clk,             
    input wire reset,            
    input wire [31:0] branch_pc, // Target address for branch/jump instructions
    input wire pc_src,           // Control signal for PC source selection
    output reg [31:0] ir,        // Instruction Register
    output wire [31:0] pc_plus_4 // PC+4 value for branch calculation
);
    reg [31:0] pc;
    reg [31:0] instruction_memory [0:16383]; // 2^14 words
    wire [31:0] fetched_instruction;
    
    initial begin
        pc = 32'h00400000; // Initial PC value at text segment base address
        ir = 32'h00000000; // Initialize IR to NOP instruction  
        $readmemh("instructions.mem", instruction_memory);
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'h00400000;
        end else begin
            // pc_src = 0: PC = PC + 4 (sequential execution)
            // pc_src = 1: PC = branch_pc (branch/jump taken)
            pc <= pc_src ? branch_pc : pc + 4;
        end
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ir <= 32'h00000000; // NOP instruction on reset
        end else begin
            ir <= fetched_instruction;
        end
    end
    
    // Calculate memory index from PC (combinational)
    wire [13:0] mem_index = (pc - 32'h00400000) >> 2;   
    // Instruction fetch from memory (combinational)
    assign fetched_instruction = instruction_memory[mem_index];
   
    assign pc_plus_4 = pc + 4;

endmodule


