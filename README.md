# RISC-V Processor Simulation (CAO Project)

## Project Description

This repository contains a simple 32-bit RISC-V processor simulation written in Verilog for a Computer Architecture (CAO) university project. The processor follows a classic 5-stage pipelined datapath and supports basic arithmetic and memory instructions.

The implementation is designed for learning and demonstration, with modular Verilog files and a straightforward testbench for simulation.

## Architecture Overview

The processor is organized as a 5-stage pipeline:

1. Instruction Fetch (IF)
2. Instruction Decode (ID)
3. Execute (EX)
4. Memory Access (MEM)
5. Write Back (WB)

Datapath flow:

Program Counter -> Instruction Memory -> Control/Decode -> Register File -> ALU -> Data Memory -> Write Back

## Architecture

### Program Counter (PC)
Stores the current instruction address and updates to the next instruction address (PC + 4).

### Instruction Memory
Provides a 32-bit instruction based on the current PC value.

### Control Unit
Decodes opcode/funct fields and generates control signals for ALU operation, memory access, and register write-back.

### Register File
Contains 32 general-purpose registers with two read ports and one write port; register x0 remains zero.

### Arithmetic Logic Unit (ALU)
Executes arithmetic and logic operations such as ADD, SUB, AND, and OR.

### Data Memory
Handles load/store operations for memory instructions during the MEM stage.

## Modules Implemented

- pc.v (Program Counter)
- instruction_memory.v
- register_file.v
- alu.v
- data_memory.v
- pipeline_registers.v (IF/ID, ID/EX, EX/MEM, MEM/WB)
- cpu_top.v (top-level datapath + decode/control logic)
- sim/testbench.v

Note: A separate control_unit.v file is not used; control logic is implemented inside cpu_top.v.

## Repository Structure

```text
CAO_PROJECT_RISCV
│
├── src        (Verilog source files for processor modules)
├── sim        (testbench and simulation files)
├── sim_out    (simulation outputs)
├── README.md
```

## Tools Used

- Verilog HDL
- Icarus Verilog (iverilog, vvp)
- ModelSim (optional)
- Vivado Simulator (optional)

## Simulation Instructions

Run from repository root:

```bash
iverilog -o riscv_sim src/*.v sim/*.v
vvp riscv_sim
```

Alternative command used in this project:

```bash
iverilog -g2012 -o sim_out src/*.v sim/testbench.v
vvp sim_out
```

## Suggested Architecture Diagram

Program Counter -> Instruction Memory -> Control Unit  
Control Unit -> Register File -> ALU -> Data Memory -> Write Back

You can represent it as:

```mermaid
flowchart LR
    PC[Program Counter] --> IMEM[Instruction Memory]
    IMEM --> CU[Control Unit]
    CU --> RF[Register File]
    RF --> ALU[ALU]
    ALU --> DMEM[Data Memory]
    DMEM --> WB[Write Back]
    WB --> RF
```

## Author

Shri Shailesh  
VIT Vellore
