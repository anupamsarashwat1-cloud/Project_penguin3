# Memory Module

This directory contains the RTL sources for the memory subsystem of the TITAN-X SoC.

## File Descriptions

- **`ddr_ctrl_top.v`**: DDR Memory Controller top-level module.
- **`ddr_phy_if.v`**: DDR PHY interface logic.
- **`ddr_scheduler.v`**: DDR transaction scheduler and reordering buffer.
- **`l2_cache_ctrl.v`**: L2 Cache controller logic.
- **`l2_cache_top.v`**: Top-level wrapper for the L2 Cache subsystem.
- **`l2_data_array.v`**: L2 Cache data RAM arrays.
- **`l2_snoop_filter.v`**: Snoop filter for maintaining L1/L2 cache coherency.
- **`l2_tag_array.v`**: L2 Cache tag RAM arrays.
- **`sram_32x64_180nm.v`**: Foundry-specific (180nm) 32x64 SRAM macro.
- **`sram_512kx8_180nm.v`**: Foundry-specific (180nm) 512Kx8 SRAM macro.
