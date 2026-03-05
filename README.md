# 🔧 UVM Environment for BMU (Bit Manipulation Unit)

> **Internship Project** — Design Verification Engineer Intern  
> **Author:** Nadia Thaer  
> **Date:** September 8, 2025  
> **Company:** Orion VLSI Technologies / Rawabi VLSI Design

---

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Training & Skills Acquired](#training--skills-acquired)
- [Design Under Test (DUT)](#design-under-test-dut)
- [UVM Testbench Architecture](#uvm-testbench-architecture)
- [Verification Strategy](#verification-strategy)
- [BMU Operations Under Verification](#bmu-operations-under-verification)
- [Corner Cases](#corner-cases)
- [Bugs Discovered](#bugs-discovered)
- [Tools & Technologies](#tools--technologies)
- [Results & Coverage](#results--coverage)
- [Deliverables](#deliverables)

---

## 📌 Project Overview

This project involved building a complete **UVM (Universal Verification Methodology) testbench** to verify the functionality of a **Bit Manipulation Unit (BMU)** based on the RISC-V BitManip specification.

| Item | Details |
|------|---------|
| **Goal** | Verify BMU unit functionality using constrained-random testing + reference model |
| **Methodology** | UVM-based verification environment |
| **Language** | SystemVerilog + UVM |
| **Simulator** | Cadence Xcelium (xrun 24.03-s013) |

### Key Verification Steps:
1. **Stimulus Generation** — Constrained-random + directed test cases
2. **Checking with Scoreboard** — Reference model comparison
3. **Collecting Coverage** — Functional & code coverage closure

---

## 🎓 Training & Skills Acquired

During the internship training phase, the following topics were studied and practiced:

### SystemVerilog Basics
- Data types, interfaces, and assertions
- Object-oriented features used in verification

### UVM Methodology
- Agents, Drivers, Monitors, and Sequences
- Scoreboards & Functional Coverage
- Hands-on practice with simulation tools

---

## 🖥️ Design Under Test (DUT)

### Block Diagram & Interface

The BMU integrates multiple functional units with a unified control and data path.

| Signal | Width | Direction | Description |
|--------|-------|-----------|-------------|
| `clk` | 1 | Input | System clock signal |
| `rst_l` | 1 | Input | Active-low synchronous reset |
| `scan_mode` | 1 | Input | Scan test mode control signal |
| `valid_in` | 1 | Input | Instruction valid flag |
| `ap` | struct | Input | Decoded instruction control signals package |
| `csr_ren_in` | 1 | Input | CSR read enable signal |
| `csr_rddata_in` | 32 | Input | CSR read data input |
| `a_in` | 32 | Input | First operand (A) for operations |
| `b_in` | 32 | Input | Second operand (B) for operations |
| `result_ff` | 32 | Output | Final computed result (registered) |
| `error` | 1 | Output | Error indicator for invalid operations |

---

## 🏗️ UVM Testbench Architecture

The testbench follows a standard UVM layered architecture:

```
┌─────────────────────────────────────────────┐
│                  UVM Test                   │
├─────────────────────────────────────────────┤
│               UVM Environment               │
│  ┌──────────────┐     ┌───────────────────┐ │
│  │  UVM Agent   │     │    Scoreboard     │ │
│  │  ┌────────┐  │     │  (Ref Model +     │ │
│  │  │ Driver │  │     │   Checker)        │ │
│  │  ├────────┤  │     └───────────────────┘ │
│  │  │Monitor │  │     ┌───────────────────┐ │
│  │  ├────────┤  │     │  Coverage         │ │
│  │  │Sequencer│ │     │  Subscriber       │ │
│  │  └────────┘  │     └───────────────────┘ │
│  └──────────────┘                           │
├─────────────────────────────────────────────┤
│          Interface / DUT (BMU)              │
└─────────────────────────────────────────────┘
```

### Components:
- **Driver** — Drives stimulus onto the DUT interface
- **Monitor** — Observes and captures DUT transactions
- **Scoreboard** — Compares DUT output with reference model
- **Sequencer** — Controls the flow of sequence items to driver
- **Coverage Subscriber** — Collects functional coverage data

---

## ✅ Verification Strategy

The verification plan uses **UVM** to create a scalable, reusable, and comprehensive verification environment:

- **Reference Model:** SystemVerilog-based reference model integrated in the scoreboard
- **Constrained Random Testing:** Intelligent stimulus generation with directed corner cases
- **Functional Coverage:** Comprehensive coverage model for all operations and scenarios
- **Regression Testing:** Automated regression suite with multiple test configurations

---

## ⚙️ BMU Operations Under Verification

### Logic Operations
| Operation | Control Signal | Description |
|-----------|---------------|-------------|
| OR | `ap.lor = 1` | Bitwise OR between `a_in` and `b_in` (or inverted `b_in` when ZBB set) |
| XOR | `ap.lxor = 1` | Bitwise XOR between `a_in` and `b_in` |

### Shifting & Masking
| Operation | Control Signal | Description |
|-----------|---------------|-------------|
| SRL | `ap.srl = 1` | Logical right shift (lower 5 bits of `b_in` as shift amount) |
| SRA | `ap.sra = 1` | Arithmetic right shift (sign bit preserved) |
| ROR | `ap.ror = 1` | Rotate right (lower 5 bits of `b_in`) |
| BINV | `ap.binv = 1` | Invert single bit at position given by lower 5 bits of `b_in` |
| SH2ADD | `ap.sh2add = 1, ap.zba = 1` | Shift `a_in` left by 2, then add `b_in` |

### Arithmetic
| Operation | Control Signal | Description |
|-----------|---------------|-------------|
| SUB | `ap.sub = 1, ap.zba = 0` | Subtract `b_in` from `a_in` |
| SLT | `ap.slt = 1, ap.sub = 1` | Set result to 1 if `a_in < b_in` (signed or unsigned) |

### Bit Manipulation
| Operation | Control Signal | Description |
|-----------|---------------|-------------|
| CTZ | `ap.ctz = 1` | Count trailing zeros in `a_in` |
| CPOP | `ap.cpop = 1` | Population count (count all 1-bits in `a_in`) |
| SEXT.B | `ap.siext_b = 1` | Sign-extend lower byte of `a_in` to 32-bit |
| MAX | `ap.max = 1, ap.sub = 1` | Return larger of `a_in` and `b_in` (signed) |
| PACK | `ap.pack = 1` | Concatenate lower 16 bits of `b_in` and `a_in` |
| GREV | `ap.grev = 1, b_in[4:0] = 24` | Byte-reverse `a_in` |

---

## 🔍 Corner Cases

A comprehensive set of corner cases were defined and tested, including:

- **Logic:** Max/min values, alternating bit patterns, ZBB mode (ORN, XNOR), self-XOR
- **Shift/Rotate:** Shift by 0 and 31, large `b_in` values (only lower 5 bits used), full rotation
- **Arithmetic:** Underflow in subtraction, signed vs unsigned boundary for SLT, equal value comparison
- **Bit Manipulation:** All-zero and all-one inputs for CTZ/CPOP, power-of-2 patterns, sparse/dense patterns
- **Error Conditions:** Multiple conflicting control signals, CSR conflict scenarios, extension dependency violations
- **Reset & Timing:** Reset during active operation, valid signal transitions, back-to-back operations

---

## 🐛 Bugs Discovered

Three bugs were found and reported during the verification process:

---

### Bug 1 — CPOP Instruction: Incorrect Bit Count

**Summary:** CPOP counts only the lower 16 bits of the operand instead of all 32 bits as required by the RISC-V BitManip specification.

**Example:**
- Input A: `0xFFFFFFFF` → Expected: `0x00000020` (32) | Actual: `0x00000010` (16) ❌

![CPOP Bug](CPOPBUG.png)

---

### Bug 2 — PACK Operation: Incorrect Operand Order

**Summary:** The PACK instruction uses incorrect operand order in bit field concatenation. The DUT concatenates operands as `{A[15:0], B[15:0]}` instead of the correct `{B[15:0], A[15:0]}`.

**Example:**
- Input A: `0x00001234`, Input B: `0x00005678`
- Expected: `0x56781234` | Actual: `0x12345678` ❌

![PACK Bug](imagebug2.png)

---

### Bug 3 — SLT/SLTU Operations: Incorrect Result

**Summary:** The SLT (Set Less Than) and SLTU (Set Less Than Unsigned) operations return the value of `b_in` (or `b_in + 1`) instead of the expected boolean result (`0x00000000` or `0x00000001`). This indicates severe bus contention in the result multiplexing logic.

**Example:**
- Input A: `0x00000001`, Input B: `0x2f4e72a1`
- Expected: `0x00000001` | Actual: `0x2f4e72a1` ❌

![SLT Bug](imagebug3.png)

---

## 🛠️ Tools & Technologies

| Tool | Details |
|------|---------|
| **Simulator** | Cadence Xcelium (xrun 24.03-s013) |
| **Language** | SystemVerilog with UVM |
| **Coverage** | Functional and Code Coverage tools |
| **Regression** | Automated test execution framework |
| **Documentation** | Coverage and Test Reports |

---

## 📊 Results & Coverage

### Success Criteria

| Metric | Target |
|--------|--------|
| Code Coverage | 100% (all RTL lines and branches) |
| Functional Coverage | 100% (all operations and scenarios) |
| High/Medium Severity Bugs | Zero remaining |
| Regression Pass Rate | > 98% |
| Documentation | Complete — all verification artifacts delivered |

### Regression Suite Includes:
- **Nightly Regression:** Full test suite execution
- **Smoke Tests:** Quick functionality verification
- **Parameter Sweep:** All extension parameter combinations
- **Random Seed Variation:** Multiple seeds for stress testing

---

## 📦 Deliverables

1. **UVM Testbench** — Complete verification environment
2. **Test Suite** — All directed and random tests (15 operation categories)
3. **Coverage Model** — Comprehensive functional coverage
4. **Reference Model** — Behavioral model for scoreboard checking
5. **Documentation** — Test plans, coverage reports, bug reports
6. **Regression Framework** — Automated test execution system

---

## 📁 Project Structure

```
bmu_uvm_env/
├── tb/
│   ├── bmu_if.sv              # Interface
│   ├── bmu_transaction.sv     # Sequence item
│   ├── bmu_sequence.sv        # Test sequences
│   ├── bmu_driver.sv          # Driver
│   ├── bmu_monitor.sv         # Monitor
│   ├── bmu_scoreboard.sv      # Scoreboard + Reference Model
│   ├── bmu_coverage.sv        # Coverage subscriber
│   ├── bmu_agent.sv           # Agent
│   ├── bmu_env.sv             # Environment
│   └── bmu_test.sv            # Test
├── rtl/
│   └── bmu.sv                 # DUT (Design Under Test)
├── sim/
│   └── run.sh                 # Simulation script
├── reports/
│   ├── coverage/              # Coverage reports
│   └── bugs/                  # Bug reports
└── README.md
```

---

*Prepared as part of the Final Internship Presentation — Orion VLSI Technologies*
