# IITK-Mini-MIPS 🚀

A Verilog-based single-cycle MIPS-like processor built as part of a computer architecture project at IIT Kanpur. The **IITK-Mini-MIPS** supports integer and floating-point instructions, with dedicated instruction and data memory, general-purpose and floating-point registers, and a modular hardware design.

---

## 🧠 Objective

To design and implement a custom MIPS-like processor supporting a simplified Instruction Set Architecture (ISA), using Verilog HDL. The processor is capable of executing arithmetic, memory, branch, and floating-point instructions in a single cycle per instruction.

---

## ⚙️ Architecture Overview

- **ISA**: Custom, MIPS-inspired 32-bit RISC architecture
- **Registers**:
  - 32 General Purpose Registers (GPR)
  - 32 Floating Point Registers (FPR)
- **Memory**:
  - Separate Instruction and Data Memory
  - 32-bit word size
- **Execution**: Single-cycle instruction execution

---

## 🧩 Module Breakdown

| Module        | Description |
|---------------|-------------|
| `iitk_mini_mips.v` | Top-level integration of all components |
| `pc_register.v`        | Program Counter with update logic |
| `instruction_memory.v` | ROM-based instruction memory |
| `data_memory.v` | RAM-based data memory |
| `register_file.v` | 32 GPRs with read/write ports |
| `fp_register_file.v` | 32 FPRs with read/write access |
| `alu.v`       | Arithmetic and logic unit for integer operations |
| `control_unit.v` | Generates control signals based on opcode and funct | 
| `instruction_fetch.v` | Fetches the instruction from instruction memory based on the current PC |
| `logic_unit.v` | Performs bitwise operations (AND, OR, XOR, NOR) between two 32-bit inputs using a control select signal |
| `full_adder.v` | Simple adder to perform 32-bit addition |
| `jump_unit.v` | Controls jump register execution |
| `iitk_mini_mips_tb.v` | Testbench with sample instruction memory and validation |

---

## 📜 Supported Instruction Types

- **Integer ALU Ops**: `add`, `sub`, `and`, `or`, `slt`, `sll`, `srl`
- **Memory Ops**: `lw`, `sw`
- **Branch/Jump**: `beq`, `bne`, `j`, `jal`, `jr`
- **Floating Point Ops**: `add.s`, `sub.s`, `mul.s`
- **Register Move**: `mov.s`

---

## 🧪 How to Run

### Prerequisites

- Verilog simulator (ModelSim / Icarus Verilog / Vivado / etc.)
- GTKWave (optional, for waveform viewing)

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/iitk-mini-mips.git
   cd iitk-mini-mips
