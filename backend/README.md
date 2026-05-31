# Backend Module

This directory contains the RTL sources for the backend subsystem of the TITAN-X SoC.

## File Descriptions

- **`clint.v`**: Core Local Interruptor (CLINT) for timer and software interrupts.
- **`plic.v`**: Platform-Level Interrupt Controller (PLIC) for external interrupt routing.
- **`rv_core_top.v`**: Top-level wrapper for the RISC-V CPU core, tying frontend and backend together.
- **`rv_dcache.v`**: L1 Data Cache (L1D) controller and arrays.
- **`rv_debug.v`**: Hardware Debug Module (DTM/DMI/Abstract Command).
- **`rv_execute.v`**: Execution stage of the CPU pipeline (ALU, Branch resolution).
- **`rv_fpu.v`**: Floating Point Unit (FPU) supporting IEEE 754 operations.
- **`rv_mem.v`**: Memory access stage of the CPU pipeline.
- **`rv_mmu.v`**: Memory Management Unit (MMU) for virtual address translation.
- **`rv_monitor_core.v`**: Performance monitoring and event counters.
- **`rv_pmp.v`**: Physical Memory Protection (PMP) unit.
- **`rv_ptw.v`**: Hardware Page Table Walker (PTW) for MMU TLB misses.
- **`rv_tlb.v`**: Translation Lookaside Buffer (TLB) for instruction and data caching.
- **`rv_writeback.v`**: Writeback stage for committing results to the register file.
