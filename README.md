# 5-Stage RISC-V Pipelined CPU Simulator (Verilog + Verilator + GTKWave)

Author: Krish Patel
Repo: https://github.com/EasTERNSalad/riscv-cpu-sim
Domain: Computer Architecture / Digital Design / Hardware Simulation

# Project Overview

This project implements a 5-stage pipelined RISC-V RV32I CPU using Verilog, following the classic IF–ID–EX–MEM–WB pipeline model.
The goal was to explore instruction-level parallelism, hazard resolution, and pipeline performance through simulation.
The CPU is simulated using Verilator, and pipeline behavior is visualized through GTKWave, allowing detailed study of hazards, forwarding, stalling, and CPI behavior.

# Objectives

Implement a modular & synthesizable RISC-V pipeline
Understand and test pipeline hazards (RAW, load-use)
Implement data forwarding and stalling logic
Measure pipeline performance (CPI, cycle count)
Visualize pipeline timing through waveform analysis
Build skills relevant to microarchitecture, HDL design, and architecture research

# Pipeline Architecture

The design follows the standard 5 stages:

IF – Instruction Fetch
ID – Instruction Decode & Register Read
EX – Execute / ALU
MEM – Data Memory Access
WB – Register Writeback

# Key datapath components include:

Program Counter (PC)
Instruction Memory
Register File
ALU
Data Memory
Control Unit
Hazard Detection Unit
Forwarding Unit
Pipeline Registers (IF/ID, ID/EX, EX/MEM, MEM/WB)

# Features Implemented
# Core ISA Support (RV32I)

ADD, SUB, AND, OR, XOR
ADDI
LW / SW
BEQ, BNE (if implemented)
NOP / Stall insertion

# Pipeline Functionality

Full 5-stage datapath
Pipeline register propagation
Control signal propagation
Branch/ALU result forwarding
Hazard detection logic

# Simulation & Validation

Verilator-based C++ simulation
GTKWave waveform viewing
Testbench for instruction sequences

Tools & Environment
Tool                          Purpose
Verilog (Icarus/Verilator)	  HDL implementation & simulation
Verilator	                  Fast C++ cycle-accurate simulation
GTKWave	                      Pipeline visualization
VS Code	                      Editing & debugging
Ubuntu / WSL2	              Linux environment for Verilator

#How to Run the Simulation

1. Install Dependencies
sudo apt install verilator gtkwave

2. Compile the CPU
verilator --cc src/cpu_top.v --exe testbench/tb_cpu.cpp
make -C obj_dir -f Vcpu_top.mk Vcpu_top

3. Run Simulation
./obj_dir/Vcpu_top

4. View Waveforms
gtkwave cpu_pipeline.vcd

Contact

Krish Patel
Email: krishpatel2022@gmail.com
GitHub: https://github.com/EasTERNSalad
