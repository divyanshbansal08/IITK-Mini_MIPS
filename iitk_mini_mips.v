`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 17:08:26
// Design Name: 
// Module Name: iitk_mini_mips
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


module iitk_mini_mips(
    input wire clk,
    input wire reset,
    output wire [31:0] result
);
    // Internal wires
    wire [31:0] pc;                  // Program counter
    
    wire [31:0] next_pc;             // Next program counter
    wire [31:0] instruction;         // Current instruction
    wire [31:0] reg_data1, reg_data2; // Register file outputs
    wire [31:0] fp_reg_data1, fp_reg_data2; // FP register outputs
    wire [31:0] sign_ext_imm;        // Sign-extended immediate
    wire [31:0] alu_operand2;        // Second ALU operand
    wire [31:0] alu_result;          // ALU result
    wire [31:0] mem_data;            // Data from memory
    wire [31:0] write_back_data;     // Data to write back to register
    wire [31:0] branch_target;       // Branch target address
    wire [31:0] jump_target;         // Jump target address
    wire [4:0] write_reg_addr;       // Register file write address
    
    // Control signals
    wire reg_dst, reg_write, alu_src;
    wire mem_read, mem_write, mem_to_reg;
    wire branch, jump, jump_reg, link;
    wire [2:0] branch_type;
    wire [3:0] alu_op;
    wire fp_op, fp_reg_write;
    
    // ALU flags
    wire zero_flag, overflow_flag, carry_out;
    wire branch_taken;
    
    // Instruction fields
    wire [5:0] opcode = instruction[31:26];
    wire [5:0] funct = instruction[5:0];
    wire [4:0] rs = instruction[25:21];
    wire [4:0] rt = instruction[20:16];
    wire [4:0] rd = instruction[15:11];
    wire [4:0] shamt = instruction[10:6];
    wire [15:0] immediate = instruction[15:0];
    wire [25:0] jump_addr = instruction[25:0];
    
    // Control unit
    control_unit ctrl(
        .clk(clk),
        .reset(reset),
        .opcode(opcode),
        .funct(funct),
        .rs_field(rs),
        .reg_dst(reg_dst),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .branch_type(branch_type),
        .jump(jump),
        .jump_reg(jump_reg),
        .link(link),
        .fp_op(fp_op),
        .fp_reg_write(fp_reg_write)
    );
    
    // Program counter
    pc_register program_counter(
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );
    
    // Instruction memory
    instruction_memory imem(
        .address(pc),
        .instruction(instruction)
    );
    
    // Register file
    register_file reg_file(
        .clk(clk),
        .reset(reset),
        .rs_addr(rs),
        .rt_addr(rt),
        .write_addr(write_reg_addr),
        .write_data(write_back_data),
        .write_enable(reg_write),
        .rs_data(reg_data1),
        .rt_data(reg_data2)
    );
    
    // Floating point register file
    fp_register_file fp_reg_file(
        .clk(clk),
        .reset(reset),
        .read_reg1(rs),
        .read_reg2(rt),
        .write_reg(write_reg_addr),
        .write_data(write_back_data),
        .write_enable(fp_reg_write),
        .read_data1(fp_reg_data1),
        .read_data2(fp_reg_data2)
    );
    
    // Sign extension
    assign sign_ext_imm = {{16{immediate[15]}}, immediate};
    
    // Register destination mux
    assign write_reg_addr = reg_dst ? rd : rt;
    
    // ALU source mux
    assign alu_operand2 = alu_src ? sign_ext_imm : reg_data2;
    
    // ALU
    alu main_alu(
        .a(reg_data1),
        .b(alu_operand2),
        .opcode(opcode),
        .funct(funct),
        .shamt(shamt),
        .result(alu_result),
        .zero_flag(zero_flag),
        .overflow_flag(overflow_flag),
        .carry_out(carry_out)
    );
    
    // Branch condition checking
    branch_checker branch_check(
        .branch_type(branch_type),
        .zero(zero_flag),
        .overflow(overflow_flag),
        .carry_out(carry_out),
        .branch_taken(branch_taken)
    );
    
    // Data memory
    data_memory dmem(
        .clk(clk),
        .address(alu_result),
        .write_data(reg_data2),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .read_data(mem_data)
    );
    
    // Write back mux
    assign write_back_data = link ? pc + 4 : 
                             mem_to_reg ? mem_data : alu_result;
    
    // Branch target calculation
    assign branch_target = pc + 4 + (sign_ext_imm << 2);
    
    // Jump target calculation
    assign jump_target = {pc[31:28], jump_addr, 2'b00};
    
    // Next PC calculation
    assign next_pc = jump ? jump_target : 
                     jump_reg ? reg_data1 : 
                     (branch & branch_taken) ? branch_target : 
                     pc + 4;
    
    // Output result (for observation)
    assign result = alu_result;
    
endmodule