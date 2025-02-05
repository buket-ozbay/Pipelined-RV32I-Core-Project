# Pipelined-RV32I-Processor-Project
This project implements a 5-stage pipelined RISC-V RV32I processor, featuring hazard handling and branch prediction.

Author: Buket Özbay

Overview
This project implements a 5-stage pipelined RISC-V RV32I processor, featuring robust hazard handling and branch prediction. The design aims for correct behavior of all integer instructions in the RV32I base instruction set while minimizing pipeline stalls and flushes.

Key Features
5-Stage Pipeline: IF, ID, EX, MEM, WB
Hazard Unit: Detects data and control hazards, generates flush/stall or forwarding signals
Forwarding: Minimizes load-use delays and reduces stalls
Branch Prediction (Optional): Global or simple predictor to reduce control hazard penalties
Complete RV32I Support: Handles base integer instructions (arithmetic, logic, load/store, jumps, branches, etc.)
Modular Design: Separate modules for each pipeline stage, hazard logic, ALU, register file, and memory
Architecture
Fetch (IF)

Fetches the instruction from instruction memory
Calculates PC + 4
Outputs instruction and PC to the next stage
Decode (ID)

Decodes the instruction fields (opcode, funct3, funct7, rs1, rs2, rd, etc.)
Reads registers from the register file
Extends immediate (I-type, S-type, B-type, U-type, J-type)
Sends control signals and operand data to the Execute stage
Execute (EX)

ALU operations (add, sub, and, or, xor, shifts, comparisons for branch)
Calculates branch targets, checks branch conditions
Forwards data from MEM/WB if needed
If branch is taken, signals the Hazard Unit to flush invalid instructions
Memory (MEM)

Accesses data memory for load/store
Applies byte/half/word alignment as needed by funct3
Outputs data to the next stage for potential Write Back
Write Back (WB)

Selects the final result to write to the register file (ALU result, memory data, or other specialized results like PC+4)
Hazard Handling
Hazard Unit:

Monitors pipeline registers and control signals to detect:
Data Hazards (e.g., read-after-write hazards)
Control Hazards (branch/jump instructions)
Generates stall and flush signals to prevent the pipeline from reading incorrect data
Generates forwarding signals to route data from later pipeline stages (MEM, WB) back to the EX stage inputs, reducing stalls
Forwarding Paths:

EX → EX: Bypass from ALU result of previous instruction
MEM → EX: Bypass from memory stage for loads or previous ALU results
WB → EX: Forward from final write-back stage if needed
Branch Prediction (Optional)
A simple global branch predictor or a static predictor can be implemented to reduce the branch penalty.
On misprediction, the Hazard Unit flushes the instructions that were fetched under the wrong assumption.

Getting Started
Prerequisites
A Verilog/SystemVerilog simulator (e.g. Vivado)
(Optional) A hardware platform if synthesizing to FPGA (e.g. Xilinx)
Simulation
Clone or download the repository.
Compile and elaborate the RTL files plus the testbench:

Known Issues / Future Improvements
Branch Prediction Enhancements: The current processor cannot predict branches. It is possible to integrate a branch predictor algorithm with advanced techniques (e.g., BHT, BTB).

Contact
Author: Buket Özbay
Email: ozbayb21@itu.edu.tr
Feel free to open issues or contribute enhancements!
