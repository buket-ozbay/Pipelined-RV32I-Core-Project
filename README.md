# Pipelined RV32I Core Project

This project implements a **5-stage pipelined** RISC-V **RV32I** core, featuring hazard handling.

**Author**: Buket Özbay  
**Email**: ozbayb21@itu.edu.tr

---

## Overview

This project aims to implement a **5-stage pipelined** RISC-V **RV32I** core with robust **hazard handling**. The design correctly handles all integer instructions in the RV32I base instruction set with no stalling.

## Key Features

- **5-Stage Pipeline**: IF, ID, EX, MEM, WB  
- **Hazard Unit**: Detects data and control hazards, generates flush or forwarding signals     
- **Complete RV32I Support**: Arithmetic, logic, load/store, jumps, branches  
- **Modular Design**: Each pipeline stage, hazard logic, ALU, register file, and memory is in a separate module

## Architecture

1. **Fetch (IF)**  
   - Fetches the instruction from instruction memory  
   - Calculates `PC + 4`  
   - Outputs instruction and PC to the next stage

2. **Decode (ID)**  
   - Decodes the instruction fields (opcode, funct3, funct7, rs1, rs2, rd, etc.)  
   - Reads registers from the register file  
   - Extends immediate (I-type, S-type, B-type, U-type, J-type)  
   - Sends control signals and operand data to the Execute stage

3. **Execute (EX)**  
   - ALU operations (add, sub, and, or, xor, shifts, comparisons for branch)  
   - Calculates branch targets, checks branch conditions  
   - Forwards data from MEM/WB if needed  
   - If branch is taken, signals the Hazard Unit to flush invalid instructions

4. **Memory (MEM)**  
   - Accesses data memory for load/store  
   - Applies byte/half/word alignment as needed by `funct3`  
   - Outputs data to the next stage for potential Write Back

5. **Write Back (WB)**  
   - Selects the final result to write to the register file (ALU result, memory data, or other specialized results like `PC + 4`)

### Hazard Handling

- **Hazard Unit**  
  - Monitors pipeline registers and control signals to detect:  
    1. **Data Hazards** (read-after-write hazards)  
    2. **Control Hazards** (branch/jump instructions)  
  - Generates flush signals to prevent reading incorrect data  
  - Generates forwarding signals to route data from later pipeline stages (MEM, WB) back to the EX stage inputs, reducing stalls

- **Forwarding Paths**  
  - **MEM → EX**: Bypass from the memory stage for loads or previous ALU results  
  - **WB → EX**: Forward from the final write-back stage if needed

---

## Getting Started

### Prerequisites

- A Verilog/SystemVerilog simulator (e.g., **Vivado**)  
- A hardware platform if synthesizing to an FPGA (e.g., **Xilinx**)

### Simulation

1. **Clone** or **download** the repository.
2. Create a project, copy downloaded files. 
3. **Compile** and **elaborate** the RTL files plus the testbench.

---
### Known Issues / Future Improvements
- Branch Prediction Enhancements: The current core cannot predict branches. It is possible to integrate a branch predictor algorithm with advanced techniques (e.g., BHT, BTB).

Feel free to open issues or contribute enhancements!

