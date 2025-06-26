`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2025 06:10:21
// Design Name: 
// Module Name: instruction_decode
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


module instruction_decode(
    input wire clk,                   
    input wire reset,                
    input wire [31:0] instruction,    // Instruction from IR
    input wire [31:0] pc_plus_4,      // PC+4 from fetch stage
    
    input wire [31:0] write_data,     // Data to write to register file
    input wire write_enable,          // Register write enable signal
    input wire [4:0] write_reg_addr,  // Register address to write to
    
    // Decoded instruction fields
    output wire [5:0] opcode,         // Instruction opcode
    output wire [5:0] funct,          // Function code for R-type
    output wire [4:0] rs_addr,        // Source register 1 address
    output wire [4:0] rt_addr,        // Source register 2 address
    output wire [4:0] rd_addr,        // Destination register address
    output wire [4:0] shamt,          // Shift amount
    
    // Data outputs
    output wire [31:0] rs_data,       // Data from RS register
    output wire [31:0] rt_data,       // Data from RT register
    output wire [31:0] imm_extended,  // Sign-extended immediate
    output wire [31:0] jump_target,   // Jump target address
    
    // Control signals
    output wire [3:0] alu_control,    // ALU operation control
    output wire alu_src,              // ALU source selection (0=reg, 1=imm)
    output wire reg_dst,              // Register destination selection
    output wire reg_write,            // Register write enable
    output wire mem_read,             // Memory read enable
    output wire mem_write,            // Memory write enable
    output wire mem_to_reg,           // Memory to register control
    output wire branch,               // Branch control
    output wire branch_type,          // Branch type (0=eq, 1=ne, etc.)
    output wire jump,                 // Jump control
    output wire jr_control,           // Jump register control
    output wire fp_op                 // Floating point operation flag
);

    // Instruction field extraction
    assign opcode = instruction[31:26];
    assign rs_addr = instruction[25:21];
    assign rt_addr = instruction[20:16];
    assign rd_addr = instruction[15:11];
    assign shamt = instruction[10:6];
    assign funct = instruction[5:0];
    
    // Sign extension for immediate value
    wire [15:0] immediate = instruction[15:0];
    assign imm_extended = {{16{immediate[15]}}, immediate};
    
    // Jump target calculation
    wire [25:0] jump_addr = instruction[25:0];
    assign jump_target = {pc_plus_4[31:28], jump_addr, 2'b00};
    
    // Internal control signals
    wire [1:0] alu_op;  // ALU operation type
    
    // Main control unit
    control_unit main_control(
        .opcode(opcode),
        .funct(funct),
        .rs_field(rs_addr),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .reg_dst(reg_dst),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .branch_type(branch_type),
        .jump(jump),
        .jr_control(jr_control),
        .fp_op(fp_op)
    );
    
    // ALU control unit
    alu_control alu_ctrl(
        .alu_op(alu_op),
        .funct(funct),
        .opcode(opcode),
        .alu_control(alu_control)
    );
    
    // Register file
    register_file reg_file(
        .clk(clk),
        .reset(reset),
        .rs_addr(rs_addr),
        .rt_addr(rt_addr),
        .write_addr(write_reg_addr),
        .write_data(write_data),
        .write_enable(write_enable),
        .rs_data(rs_data),
        .rt_data(rt_data)
    );

endmodule