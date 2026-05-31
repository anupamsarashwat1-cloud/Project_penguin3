# Common Module

This directory contains the RTL sources for the common subsystem of the TITAN-X SoC.

## File Descriptions

- **`cdc_sync.v`**: Clock Domain Crossing (CDC) synchronizer primitives.
- **`fifo_async.v`**: Asynchronous FIFO for cross-clock-domain data transfer.
- **`fifo_sync.v`**: Synchronous FIFO for same-clock-domain buffering.
- **`interfaces.sv`**: SystemVerilog interface definitions for AXI, AHB, and APB buses.
- **`isa_constants.vh`**: RISC-V ISA constant definitions (opcodes, funct3, funct7).
- **`isa_pkg.vh`**: Package definitions for global ISA types and structs.
- **`params.vh`**: Global parameters and configuration macros for TITAN-X.
- **`reset_sync.v`**: Reset synchronizer for safe asynchronous reset deassertion.
