# V2 Arithmetic Unit

## Overview

The Arithmetic Unit is the first building block of the modular Integer ALU.

It is responsible for performing signed and unsigned integer arithmetic while generating processor-style status flags.

Unlike Version 1, where all operations were implemented inside a single ALU module, Version 2 separates arithmetic functionality into an independent RTL block. This makes the design reusable, easier to verify, and closer to industrial RTL development.

---

## Features

✔ Addition (ADD)

✔ Subtraction (SUB)

✔ Carry Detection

✔ Signed Overflow Detection

✔ Parameterized Data Width

---

## Inputs

| Signal | Width | Description |
|---------|------:|-------------|
| a | DATA_WIDTH | Operand A |
| b | DATA_WIDTH | Operand B |
| alu_op | 1 | 0 = ADD, 1 = SUB |

---

## Outputs

| Signal | Width | Description |
|---------|------:|-------------|
| result | DATA_WIDTH | Arithmetic result |
| carry | 1 | Carry-out generated during addition/subtraction |
| overflow | 1 | Signed arithmetic overflow |

---

## Supported Operations

| alu_op | Operation |
|---------|-----------|
| 0 | ADD |
| 1 | SUB |

---

## Block Diagram

```
                +----------------------------+
                |     Arithmetic Unit        |
                |                            |
A ------------->|                            |
                |                            |
B ------------->|      ADD / SUB Logic       |-------> Result
                |                            |
alu_op -------->|                            |
                +-------------+--------------+
                              |
                 -------------------------
                 |                       |
                 ▼                       ▼
             Carry Flag          Overflow Flag
```

---

## Addition

```
result = a + b
```

Carry is generated when the addition exceeds the selected data width.

Example

```
255 + 1

11111111
00000001
---------
1 00000000

Carry = 1
Result = 00000000
```

---

## Signed Overflow

Overflow occurs when

Positive + Positive → Negative

or

Negative + Negative → Positive

Examples

```
127 + 1

01111111
00000001
---------
10000000

Overflow = 1
```

```
-128 + (-1)

10000000
11111111
---------
01111111

Overflow = 1
```

---

## Subtraction

Subtraction is implemented using

```
result = a - b
```

Signed overflow occurs when

Positive − Negative → Negative

or

Negative − Positive → Positive

Examples

```
127 - (-1)

01111111
11111111
---------
10000000

Overflow = 1
```

```
-128 - 1

10000000
00000001
---------
01111111

Overflow = 1
```

---

## Verification

Verification is performed using a self-checking Verilog testbench.

Directed test cases include

- Normal addition
- Carry generation
- Positive overflow
- Negative overflow
- Normal subtraction
- Negative result
- Zero result
- Subtraction overflow

Waveforms are generated using GTKWave.

---

## Design Philosophy

This module is intentionally implemented as a purely combinational circuit.

No clock or reset signals are used because arithmetic operations are performed combinationally between pipeline registers in a processor datapath.

The Arithmetic Unit will later become one of the building blocks of the complete Integer ALU.

---

## Future Improvements

Version 3 will integrate this module into a complete Integer ALU containing

- Logic Unit
- Shift Unit
- Compare Unit
- Flag Generator
