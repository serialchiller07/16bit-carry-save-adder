# 32-bit ALU on Basys3 FPGA

## Overview

This project implements a 32-bit Arithmetic Logic Unit (ALU) using Verilog HDL and deploys it on the Digilent Basys3 FPGA board.

The ALU performs multiple arithmetic and logical operations on two 32-bit operands. Since the Basys3 board provides only 16 switches, each 32-bit operand is entered in two parts: the lower 16 bits and the upper 16 bits.

Push buttons are used to control the loading of operands and the selection of operations. The result and status flags are displayed using the onboard LEDs and 7-segment display.

---

## Features

- 32-bit ALU design using Verilog HDL
- Supports two 32-bit input operands
- Performs arithmetic and logical operations
- Two-step input loading using 16-bit switches
- Push-button controlled FSM
- Button debouncing
- Edge detection for reliable button presses
- 7-segment display for output visualization
- LED-based status flag display
- Simulation using a self-checking testbench
- FPGA implementation on the Basys3 board

---

## ALU Operations

The ALU supports the following operations:

| Opcode | Operation | Description |
|--------|-----------|-------------|
| `000` | ADD | A + B |
| `001` | SUB | A - B |
| `010` | AND | A & B |
| `011` | OR | A \| B |
| `100` | XOR | A ^ B |
| `101` | NOT | ~A |
| `110` | MUL | A × B |
| `111` | Reserved | Reserved for future use |

The multiplication operation produces a 64-bit result, while the other operations produce a 32-bit result.

---

## Architecture

The overall system consists of the following modules:

```text
                  +----------------------+
                  |    16-bit Switches   |
                  |       SW[15:0]       |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  |   Input Loading FSM  |
                  +----------+-----------+
                             |
                 +-----------+-----------+
                 |                       |
                 v                       v
              Operand A               Operand B
              32-bit                  32-bit
                 |                       |
                 +-----------+-----------+
                             |
                             v
                  +----------------------+
                  |       32-bit ALU     |
                  +----------+-----------+
                             |
                +------------+------------+
                |            |            |
                v            v            v
             Result       Carry Flag   Overflow Flag
                |
                v
       +----------------------+
       |   LEDs / 7-Segment   |
       |       Display        |
       +----------------------+
````

---

## 32-bit Operand Input

The Basys3 FPGA board has 16 switches, while the ALU requires 32-bit operands.

Therefore, each operand is entered in two steps.

For operand A:

```text
Step 1:
SW[15:0] → A[15:0]
Press button

Step 2:
SW[15:0] → A[31:16]
Press button
```

The same process is repeated for operand B.

The operand registers retain the previously entered values while the switches are reused for the next input.

```text
A[31:16] + A[15:0] → 32-bit A

B[31:16] + B[15:0] → 32-bit B
```

This allows a 32-bit ALU to be implemented using the 16 physical switches available on the Basys3 board.

---

## FSM-Based Control

A Finite State Machine (FSM) controls the input sequence.

A typical sequence is:

```text
LOAD_A_LOW
      |
      v
LOAD_A_HIGH
      |
      v
LOAD_B_LOW
      |
      v
LOAD_B_HIGH
      |
      v
SELECT_OPERATION
      |
      v
COMPUTE
      |
      v
DISPLAY_RESULT
```

Each button press advances the FSM to the next state.

The operand registers store each 16-bit portion and combine them to form the complete 32-bit operands.

---

## Button Debouncing

Mechanical push buttons do not generate a perfectly clean digital signal. When a button is pressed, the signal may rapidly switch between `0` and `1` for a short period. This phenomenon is known as button bouncing.

A debouncer is used to ensure that the FPGA recognizes a stable button press.

The signal processing flow is:

```text
Physical Button
      |
      v
Synchronizer
      |
      v
Debouncer
      |
      v
Stable Button Signal
      |
      v
Edge Detector
      |
      v
Single-Cycle Pulse
      |
      v
FSM
```

The edge detector ensures that one physical button press generates only one FSM transition.

---

## Status Flags

The ALU generates status flags to indicate specific conditions.

### Carry Flag

The carry flag indicates a carry generated during an unsigned addition operation.

### Overflow Flag

The overflow flag indicates that the result of a signed arithmetic operation cannot be represented within the 32-bit signed range.

### Zero Flag

The zero flag is set when the ALU result is equal to zero.

```text
Zero Flag = 1  →  Result = 0
Zero Flag = 0  →  Result ≠ 0
```

These flags can be displayed using the onboard LEDs.

---

## Display

The ALU result is displayed using the FPGA's onboard display hardware.

Since the 32-bit result is larger than what can be displayed simultaneously, the result can be viewed in sections.

The display can show:

```text
Result[31:16]
```

or

```text
Result[15:0]
```

A push button can be used to toggle between the upper and lower 16 bits of the result.

The status flags are displayed separately using LEDs.

---

## Simulation

A self-checking Verilog testbench is used to verify the functionality of the ALU.

The testbench checks:

* Reset behavior
* Operand loading sequence
* Addition
* Subtraction
* AND operation
* OR operation
* XOR operation
* NOT operation
* Multiplication
* Carry generation
* Overflow detection
* Zero detection
* Display switching

Example test cases:

```text
A = 10
B = 5

ADD:
10 + 5 = 15

SUB:
10 - 5 = 5

AND:
10 & 5

OR:
10 | 5

XOR:
10 ^ 5
```

The testbench compares the ALU output with the expected result and reports `PASS` or `FAIL`.

---

## FPGA Implementation

The project is designed for the:

* Digilent Basys3 FPGA Board
* Xilinx Artix-7 FPGA
* XC7A35T FPGA device

### Inputs

```text
SW[15:0]  → 16-bit input data
Buttons   → Operand loading and control
```

### Outputs

```text
LEDs      → Status flags and output indication
7-Segment → ALU result
```

---

## Tools Used

* Verilog HDL
* Xilinx Vivado
* Vivado Simulator
* Digilent Basys3 FPGA Board
* Xilinx Artix-7 FPGA

---

## Project Structure

```text
32-bit-ALU/
│
├── src/
│   ├── alu.v
│   ├── debouncer.v
│   ├── edge_detect.v
│   ├── seven_segment.v
│   └── main.v
│
├── simulation/
│   └── tb_main.v
│
├── constraints/
│   └── basys3.xdc
│
└── README.md
```

---

## How to Run

### 1. Create a Vivado Project

Create a new RTL project in Xilinx Vivado.

Select the appropriate Basys3 Artix-7 FPGA device.

### 2. Add Design Sources

Add all Verilog source files to the project.

### 3. Add Simulation Sources

Add the testbench file:

```text
tb_main.v
```

### 4. Add Constraints

Add the Basys3 `.xdc` file containing the required pin assignments.

### 5. Set the Top Module

Set the main FPGA wrapper module as the top module.

For example:

```text
main
```

### 6. Run Simulation

Run behavioral simulation and verify that all ALU operations produce the expected results.

### 7. Run Synthesis

Run synthesis and check for errors and warnings.

### 8. Run Implementation

Run implementation to perform placement and routing.

### 9. Generate Bitstream

Generate the FPGA bitstream.

### 10. Program the FPGA

Connect the Basys3 board to the computer through USB and program the FPGA using Vivado Hardware Manager.

---

## Hardware Usage

1. Power on the Basys3 FPGA board.
2. Enter the lower 16 bits of operand A using the switches.
3. Press the assigned button to store the lower half.
4. Enter the upper 16 bits of operand A.
5. Press the button to store the upper half.
6. Repeat the process for operand B.
7. Select the required ALU operation.
8. The ALU performs the selected operation.
9. View the result on the 7-segment display.
10. Check the status flags on the LEDs.
11. Use the display toggle button to switch between the upper and lower 16 bits of the result.

---

## Example

Consider:

```text
A = 32'd100
B = 32'd50
Operation = ADD
```

The ALU performs:

```text
100 + 50 = 150
```

The output is:

```text
Result = 32'd150
```

The corresponding hexadecimal result is:

```text
00000096
```

---

## Future Improvements

* Add more arithmetic operations
* Add shift and rotate operations
* Implement signed and unsigned arithmetic modes
* Add a dedicated opcode input interface
* Add UART-based input and output
* Optimize multiplication hardware
* Implement pipelining for higher operating frequency
* Compare performance with different ALU architectures
* Extend the design to a complete 32-bit processor datapath

---

## Author

**Rutva Gandhi**

Electronics and Communication Engineering
IIIT Nagpur

---

## License

This project is intended for educational and academic purposes.
