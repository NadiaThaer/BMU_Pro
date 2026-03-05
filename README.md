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

**6 bugs** were found, reported, and tracked via ClickUp during the verification process.

| # | Bug | Severity | Status | Component |
|---|-----|----------|--------|-----------|
| 1 | CPOP — Incorrect Bit Count | 🔴 High | Open | BitManip Unit |
| 2 | PACK — Incorrect Operand Order | 🔴 High | Open | BitManip Unit |
| 3 | SLT/SLTU — Incorrect Result | 🔴 High | Open | RTL |
| 4 | CTZ — Off-By-One Error | 🔴 High | Open | RTL, BitManip Unit |
| 5 | MAX — Wrong Operation Performed | 🔴 Critical | Open | BMU |
| 6 | ORN — b_in Not Inverted (ZBB) | 🔴 High | Open | BMU |

---

### 🐛 Bug 1 — CPOP Instruction: Incorrect Bit Count

| Field | Detail |
|-------|--------|
| **Component** | BitManip Unit (BMU) |
| **Priority** | High |
| **Affects** | v1.1 |

**Summary:** CPOP counts only the lower 16 bits of the operand instead of all 32 bits as required by the RISC-V BitManip specification.

**Failing Test Cases:**

| Input A | Expected | Actual | Status |
|---------|----------|--------|--------|
| `0xFFFFFFFF` | `0x00000020` (32) | `0x00000010` (16) | ❌ FAIL |
| `0x00000004` | `0x00000001` (1) | `0x00000001` (1) | ✅ PASS |

**Root Cause:** The population count logic only evaluates `a_in[15:0]` and ignores the upper 16 bits.

![CPOP Bug](imagebug1.png)

---

### 🐛 Bug 2 — PACK Operation: Incorrect Operand Order

| Field | Detail |
|-------|--------|
| **Component** | BitManip Unit (BMU) |
| **Priority** | High |

**Summary:** The PACK instruction uses the wrong operand order in bit field concatenation. The DUT concatenates as `{A[15:0], B[15:0]}` instead of the correct `{B[15:0], A[15:0]}`.

**Failing Test Cases:**

| Input A | Input B | Expected | Actual | Status |
|---------|---------|----------|--------|--------|
| `0x00001234` | `0x00005678` | `0x56781234` | `0x12345678` | ❌ FAIL |
| `0x0000AAAA` | `0x0000BBBB` | `0xBBBBAAAA` | `0xAAAABBBB` | ❌ FAIL |

**Root Cause:** The RTL concatenation expression has operand A and B swapped.

![PACK Bug](imagebug2.png)

---

### 🐛 Bug 3 — SLT/SLTU Operations: Incorrect Result

| Field | Detail |
|-------|--------|
| **Component** | RTL |
| **Priority** | High |

**Summary:** SLT (Set Less Than) and SLTU (Set Less Than Unsigned) return the value of `b_in` or `b_in + 1` instead of the expected boolean `0` or `1`. Indicates severe bus contention in the result multiplexing logic.

**Failing Test Cases:**

| Operation | Input A | Input B | Expected | Actual | Status |
|-----------|---------|---------|----------|--------|--------|
| SLT | `0x00000001` | `0x2f4e72a1` | `0x00000001` | `0x2f4e72a1` | ❌ FAIL |
| SLT | `0x2291ca68` | `0x27c12448` | `0x00000001` | `0x27c12449` | ❌ FAIL |

**Root Cause:** Bus contention in the result mux — `b_in` leaks into the output path instead of the comparison result.

![SLT Bug](imagebug3.png)

---

### 🐛 Bug 4 — CTZ: Off-By-One Error

| Field | Detail |
|-------|--------|
| **Component** | RTL, BitManip Unit (BMU) |
| **Priority** | High |
| **Affects** | v1.1 |
| **Tracked in** | ClickUp — BMU_Project |

**Summary:** The CTZ (Count Trailing Zeros) instruction produces a result that is off by one for a specific, reproducible class of inputs. The failure is systematic — not random — indicating a logical flaw in the counter's termination condition.

**Failing Test Cases (Pattern A):**

| Input A | Expected | Actual | Status |
|---------|----------|--------|--------|
| `0xFFFFFFFE` | `0x1` (1) | `0x0` (0) | ❌ FAIL |
| `0xFFFFFFE0` | `0x5` (5) | `0x4` (4) | ❌ FAIL |
| `0x00000001` | `0x0` (0) | `0x1` (1) | ❌ FAIL |

**Passing Test Cases (Pattern B):**

| Input A | Expected | Actual | Status |
|---------|----------|--------|--------|
| `0x0F000000` | `0x18` (24) | `0x18` (24) | ✅ PASS |
| `0x00000000` | `0x20` (32) | `0x20` (32) | ✅ PASS |

**Root Cause (Black-Box Analysis):** Off-by-one error in the internal counting algorithm. The state machine or counter logic has a faulty final adjustment/termination condition for inputs where the least-significant set bit is isolated (not part of a contiguous group).

![CTZ Bug](imagebug4.png)

---

### 🐛 Bug 5 — MAX Operation: Wrong Operation Performed

| Field | Detail |
|-------|--------|
| **Component** | Bit Manipulation Unit (BMU) |
| **Priority** | 🔴 Critical |
| **Tracked in** | ClickUp — BMU_Project |

**Summary:** The MAX operation does not perform a comparison at all. Instead, the DUT either performs addition (A+B) or returns the minimum value. The `ap.sub` signal incorrectly overrides the MAX logic.

**Failing Test Cases:**

| Test | Input A | Input B | Expected | Actual | Root Cause |
|------|---------|---------|----------|--------|-----------|
| TC1 | `0x0000000A` (10) | `0x00000014` (20) | `0x00000014` (20) | `0x0000001E` (30) | A+B performed |
| TC2 | `0x00000005` (5) | `0x00000003` (3) | `0x00000005` (5) | `0x00000003` (3) | MIN returned |

**Root Cause:**
- `ap.sub` incorrectly overrides the MAX selection logic
- Comparison logic is inverted or missing entirely
- No proper handling for the `ap.max && ap.sub` control signal combination

**Required Fix:**
- Review operation decoder in BMU RTL
- Add correct comparison logic for `ap.max && ap.sub`
- Ensure signed & unsigned comparison handling
- Verify fix with extended test suite

![MAX Bug](imagebug5.png)

---

### 🐛 Bug 6 — ORN Operation: b_in Not Inverted When ZBB Mode Active

| Field | Detail |
|-------|--------|
| **Component** | Bit Manipulation Unit (BMU) |
| **Priority** | High |
| **Tracked in** | ClickUp — BMU_Project |

**Summary:** When `ap.zbb = 1` and `ap.lor = 1`, the DUT should perform `a_in | ~b_in` (ORN — OR-Not). Instead, it performs a standard `a_in | b_in`, violating the RISC-V Zbb extension specification.

**Steps to Reproduce:**
1. Set `ap.lor = 1`
2. Set `ap.zbb = 1` (to enable ORN mode per spec)
3. Apply non-zero inputs to `a_in` and `b_in`
4. Observe output `result`

**Failing Test Case:**

| Input A | Input B | Expected (`A \| ~B`) | Actual (`A \| B`) | Status |
|---------|---------|----------------------|-------------------|--------|
| `0x0F0F0F0F` | `0xF0F0F0F0` | `0x0F0F0F0F` | `0xFFFFFFFF` | ❌ FAIL |

**Root Cause:** The RTL does not include the inversion of `b_in` when `ap.zbb` is asserted. The code uses `b_in` directly instead of `~b_in`.

![ORN Bug](imagebug6.png)

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
| Bugs Discovered | 6 total (all tracked in ClickUp) |
| High/Medium Severity Bugs Remaining | Target: Zero after fixes |
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
