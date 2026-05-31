# Goal Description

Build a complete industrial-grade verification environment for Project Penguin (TITAN-X SoC) and achieve functional verification sign-off before synthesis. The project encompasses 11 Sign-Off Gates including design quality checks, block-level verification, interconnect fuzz testing, memory coherency, and full SoC boot/stress tests.

## User Review Required

> [!IMPORTANT]
> The verification matrix is massive, covering unit-level, sub-system, and full SoC-level testbenches. Achieving 100% verification closure across all 11 gates will require iterative development and significant compute time. Please review the proposed architecture below.

## Open Questions

> [!WARNING]
> 1. Are there specific Verilator or Icarus Verilog versions we should target to ensure compatibility?
> 2. Do we have external VIP archives available locally, or should I clone them from standard open-source repositories (e.g., alexforencich's verilog-axi)?
> 3. Are we relying on a specific memory compiler for SRAM models, or should I use generic behavioral models for the 180nm SRAMs?

## Proposed Changes

### Verification Directory Structure
- Create the mandatory directories under `verification/`: `cocotb/`, `unit_tests/`, `integration_tests/`, `system_tests/`, `assertions/`, `covergroups/`, `riscv_dv/`, `vip/`, `regressions/`, `reports/`, `docs/`, `scripts/`, `ci/`.

### Sign-off Gate 0: Design Quality
- Set up automated linting using `verible-verilog-lint` and `verilator --lint-only`.
- Develop static analysis scripts to identify CDC/RDC violations and generate HTML reports (`reports/cdc_report.html`, `reports/rdc_report.html`).

### Sign-off Gate 1: Common Infrastructure
- Develop Cocotb tests for `cdc_sync.v`, `fifo_async.v`, `fifo_sync.v`, and `reset_sync.v`. Focus on asynchronous FIFO stress testing across multiple clock ratios with 10M+ transactions.

### Sign-off Gate 2: Frontend Pipeline
- Develop unit tests and testbenches for `rv_fetch.v`, `rv_bpu.v`, `rv_decode.v`, and `rv_icache.v`. Validate branching logic, instruction decoding (R, I, S, B, U, J), and cache hit/miss/flush behavior.

### Sign-off Gate 3: CPU Backend
- Exhaustively verify execution units (`rv_execute.v`, `rv_fpu.v`), memory/MMU interfaces (`rv_mem.v`, `rv_mmu.v`, `rv_tlb.v`, `rv_ptw.v`), and privileges/interrupts (`rv_pmp.v`, `clint.v`, `plic.v`, `rv_core_top.v`). Integrate RISCV-DV for random instruction regressions (10K, 100K, 1M).

### Sign-off Gate 4: Interconnect
- Integrate Open-source AXI VIP for `axi4_crossbar.v`. Write SystemVerilog protocol assertions and Python-based fuzz testing injection scripts for `DECERR`/`SLVERR` recovery and deadlock-freedom verification.

### Sign-off Gate 5: Memory System
- Verify L2 Cache coherency, RVWMO memory model litmus tests (Store Buffering, Load Buffering, Message Passing, IRIW), and DDR controller stress testing using the Micron DDR4 model.

### Sign-off Gate 6 & 7: Security & Crypto
- Develop testbenches for `secure_boot.v`, `ecdsa_engine.v`, `aes_engine.v`, `sha256_engine.v`, `trng.v` using NIST/FIPS standard test vectors.

### Sign-off Gate 8, 9, 10: Peripherals, Storage, Video
- Develop targeted unit tests for `uart_16550.v`, `i2c_master.v`, `usb_otg.v`, `hdmi_ctrl.v`, `gem_ethernet.v`, `pcie_top.v` verifying functional protocols and interrupts.

### Sign-off Gate 11: Full SoC & Multicore Stress Test
- Develop the Full SoC integration boot test sequence (Reset -> Secure Boot -> DDR Init -> L2 Init -> MMU -> Core release -> UART).
- Implement a 100M+ cycle multicore stress test integrating CoreMark, Dhrystone, DMA traffic, and random interrupts.

### Assertions & Coverage
- Implement SystemVerilog Assertions (SVA) across all critical buses and controllers.
- Configure coverage collection to merge line, branch, toggle, FSM, and functional coverage aiming for >95% (Line/Branch) and 100% (FSM) targets.

### CI Automation
- Implement GitHub Actions CI pipeline executing the full regression flow on every commit, aggregating verification reports automatically.

## Verification Plan

### Automated Tests
- Scripts will be implemented in `verification/scripts/` to automatically compile and run the regressions using Verilator, Cocotb, Pytest, and RISCV-DV.

### Manual Verification
- None expected; fully automated via scripts and CI.
