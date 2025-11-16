# RISC-V CPU (5-stage pipeline)

This project implements a simple RISC-V processor  
with the following modules working:

- Program Counter (PC)
- Instruction Memory (IMEM)
- IF/ID Pipeline Register
- Register File
- Testbenches (Verilator + GTKWave)

# How to run
iverilog -o regfile_tb tb/regfile_tb.v src/regfile.v
vvp regfile_tb
gtkwave wave/regfile.vcd &

# Why
-This is a project is for Educational/Learning purposes, mainly to internalize and apply the principles of Electrionics.

