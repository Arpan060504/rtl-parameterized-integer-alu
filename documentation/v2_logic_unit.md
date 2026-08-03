# V2 Logic Unit

## Overview

The Logic Unit is the second building block of the modular Integer ALU.

It performs bitwise logical operations between two input operands. Unlike the Arithmetic Unit, this module does not generate carry or overflow flags because logical operations are independent of arithmetic properties.

The module is implemented as a purely combinational circuit and is parameterized by data width for easy reuse.

---

# Features

- Parameterized Data Width
- Combinational RTL
- Bitwise AND
- Bitwise OR
- Bitwise XOR
- Self-checking Testbench
- Synthesizable Design

---

# Module Interface

## Inputs

| Signal | Width | Description |
|---------|------:|-------------|
| a | DATA_WIDTH | Operand A |
| b | DATA_WIDTH | Operand B |
| logic_op | 2 | Logic operation selector |

---

## Outputs

| Signal | Width | Description |
|---------|------:|-------------|
| result | DATA_WIDTH | Logic operation result |

---

# Supported Operations

| logic_op | Operation |
|----------|-----------|
| 2'b00 | AND |
| 2'b01 | OR |
| 2'b10 | XOR |
| 2'b11 | Reserved (Outputs Zero) |

---

# Block Diagram

```
                   +-----------------------+
                   |      Logic Unit       |
                   |                       |
A ---------------->|                       |
                   |                       |
B ---------------->|  AND / OR / XOR Core  |------> Result
                   |                       |
logic_op --------->|                       |
                   +-----------------------+
```

---

# Operation Examples

## AND

```
10101010
11110000
---------
10100000
```

---

## OR

```
10101010
11110000
---------
11111010
```

---

## XOR

```
10101010
11110000
---------
01011010
```

---

# RTL Design

The Logic Unit is implemented using a combinational `case` statement.

No clock.

No reset.

No internal state.

```
always @(*)
```

The selected operation depends entirely on the input control signal (`logic_op`).

---

# Verification

The module is verified using a self-checking Verilog testbench.

Directed test cases include:

- Normal AND operations
- Normal OR operations
- Normal XOR operations
- All-zero operands
- All-one operands
- Alternating bit patterns
- Default opcode verification

Waveforms are generated using GTKWave.

---

# Design Philosophy

The Logic Unit is intentionally implemented as an independent RTL module instead of embedding logical operations directly inside the ALU.

This modular design provides:

- Better readability
- Easier verification
- Reusable RTL IP
- Cleaner processor datapath architecture

---

# Future Integration

This module will later be connected to the top-level Integer ALU.

```
                Integer ALU
                     |
      --------------------------------
      |              |              |
      ▼              ▼              ▼

 Arithmetic      Logic Unit      Shift Unit
      |              |              |
      --------------------------------
                     |
                Result MUX
                     |
              Flag Generator
```

---

# Version

Version 2

Status

✔ Verified

✔ Synthesizable

✔ Ready for Integration
