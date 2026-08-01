# 16-bit Carry Save Adder (CSA)

## Overview

This project implements a **16-bit Carry Save Adder (CSA)** using Verilog HDL. The design adds three 16-bit binary numbers along with an optional carry-in and produces a 16-bit sum with additional carry outputs.

The design is implemented using **4-bit CSA blocks**, which are combined to form the complete 16-bit architecture.

The project is designed and simulated using **Xilinx Vivado** and can be implemented on a **Digilent Basys3 FPGA board** based on the Xilinx Artix-7 FPGA.

Also I tried to use microblaze implementation but was unsuccessful but just for reference i have attached the design. [Do help me out if u can in solving microblaze stuck to reset error :) ]

---

## Features

- 16-bit Carry Save Adder
- Adds three 16-bit operands:
  - `A`
  - `B`
  - `C`
- Supports an additional `Carry-In (Cin)`
- Modular design using 4-bit CSA blocks
- Full Adder based implementation
- Hierarchical Verilog design
- Simulation and functional verification using a testbench
- FPGA implementation on Basys3
- Push-button controlled operand loading
- Switches used as 16-bit input data
- LEDs used to display the output result

---

## Block Diagram

The overall architecture consists of:

```text
             A[15:0]
                 |
             B[15:0]
                 |
             C[15:0]
                 |
             Cin
                 |
                 v
       +-------------------+
       |   16-bit CSA      |
       |                   |
       |  +-------------+  |
       |  | 4-bit CSA   |  |
       |  +-------------+  |
       |         |         |
       |  +-------------+  |
       |  | 4-bit CSA   |  |
       |  +-------------+  |
       |         |         |
       |  +-------------+  |
       |  | 4-bit CSA   |  |
       |  +-------------+  |
       |         |         |
       |  +-------------+  |
       |  | 4-bit CSA   |  |
       |  +-------------+  |
       +-------------------+
                 |
                 v
          16-bit Sum
                 |
          Carry Outputs



