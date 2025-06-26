`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 17:10:38
// Design Name: 
// Module Name: iitk-mini_mips_tb
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



module iitk_mini_mips_tb;
    // Testbench signals
    reg clk;
    reg reset;
    wire [31:0] result;
    integer i;
    
    // Instantiate the processor
    iitk_mini_mips dut(
        .clk(clk),
        .reset(reset),
        .result(result)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end
    
    // Test program initialization
    initial begin
        // Initialize instruction memory with test program
        
        // Test 1: Basic arithmetic operations
        dut.imem.memory[0] = 32'h20080005;  // addi $t0, $zero, 5
        dut.imem.memory[1] = 32'h20090003;  // addi $t1, $zero, 3
        dut.imem.memory[2] = 32'h01095020;  // add $t2, $t0, $t1
        dut.imem.memory[3] = 32'h01096022;  // sub $t2, $t0, $t1
        dut.imem.memory[4] = 32'h312A0007;  // andi $t2, $t1, 7
        
        // Test 2: Data transfer operations
        dut.imem.memory[5] = 32'hAD0A0000;  // sw $t2, 0($t0)
        dut.imem.memory[6] = 32'h8D0B0000;  // lw $t3, 0($t0)
        
        // Test 3: Branch operations
        dut.imem.memory[7] = 32'h11090001;  // beq $t0, $t1, 1 (should not branch)
        dut.imem.memory[8] = 32'h01285020;  // add $t2, $t1, $t0
        dut.imem.memory[9] = 32'h15090001;  // bne $t0, $t1, 1 (should branch)
        dut.imem.memory[10] = 32'h01096022; // sub $t2, $t0, $t1 (skipped)
        dut.imem.memory[11] = 32'h01695020; // add $t2, $t3, $t1
        
        // Test 4: Jump operations
        dut.imem.memory[12] = 32'h0C000010; // jal 0x10 (should jump to instruction 16)
        dut.imem.memory[13] = 32'h01096020; // add $t2, $t0, $t1 (skipped)
        dut.imem.memory[14] = 32'h01096020; // add $t2, $t0, $t1 (skipped)
        dut.imem.memory[15] = 32'h01096020; // add $t2, $t0, $t1 (skipped)
        
        // Jump target
        dut.imem.memory[16] = 32'h01CE5020; // add $t2, $t6, $t6
        dut.imem.memory[17] = 32'h03E00008; // jr $ra (return to instruction after jal)
        
        // Test 5: Float point operations
        dut.imem.memory[18] = 32'h44C80800; // mtc1 $t0, $f1
        dut.imem.memory[19] = 32'h44C90000; // mtc1 $t1, $f0
        dut.imem.memory[20] = 32'h46000880; // add.s $f2, $f1, $f0
    end
    
    // Initialize register file for testing
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            dut.reg_file.registers[i] = 32'h00000000;
        end
        
        for (i = 0; i < 32; i = i + 1) begin
            dut.fp_reg_file.registers[i] = 32'h00000000;
        end
    end
    
    // Test sequence
    initial begin
        // Initialize and reset
        reset = 1;
        #15 reset = 0;
        
        // Monitor execution of each instruction
        #10 $display("----- Starting IITK-Mini-MIPS Simulation -----");
        
        // Test 1: Basic arithmetic operations
        #10 $display("Test 1: Basic Arithmetic Operations");
        #10 $display("$t0 = %d, $t1 = %d, $t2 = %d", 
                    dut.reg_file.registers[8], 
                    dut.reg_file.registers[9], 
                    dut.reg_file.registers[10]);
        
        // Test 2: Data transfer operations
        #30 $display("Test 2: Memory Operations");
        #10 $display("$t2 = %d, $t3 = %d, Memory[%d] = %d", 
                    dut.reg_file.registers[10], 
                    dut.reg_file.registers[11], 
                    dut.reg_file.registers[8], 
                    dut.dmem.memory[dut.reg_file.registers[8]]);
        
        // Test 3: Branch operations
        #20 $display("Test 3: Branch Operations");
        #10 $display("PC = %h, $t0 = %d, $t1 = %d, $t2 = %d", 
                    dut.pc, 
                    dut.reg_file.registers[8], 
                    dut.reg_file.registers[9], 
                    dut.reg_file.registers[10]);
        
        // Test 4: Jump operations
        #20 $display("Test 4: Jump Operations");
        #10 $display("PC = %h, $ra = %h", dut.pc, dut.reg_file.registers[31]);
        
        // Test 5: Floating point operations
        #20 $display("Test 5: Floating Point Operations");
        #10 $display("$f0 = %h, $f1 = %h, $f2 = %h", 
                    dut.fp_reg_file.registers[0], 
                    dut.fp_reg_file.registers[1], 
                    dut.fp_reg_file.registers[2]);
        
        // Run for a few more cycles and finish
        #50 $display("----- Simulation Complete -----");
        $finish;
    end
    
    // Monitor signals for debugging
    initial begin
        $monitor("Time: %3d, PC: %h, Instruction: %h, ALU Result: %h", 
                $time, dut.pc, dut.instruction, dut.alu_result);
    end
endmodule