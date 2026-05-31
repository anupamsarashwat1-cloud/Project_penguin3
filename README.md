# Project_Penguin (TITAN-X SoC)

Project_Penguin is the full RTL implementation of the **TITAN-X System-on-Chip (SoC)**. TITAN-X is a high-performance, multi-core RISC-V SoC designed for compute-intensive and secure applications. It features a 15-Master / 9-Slave AXI4 crossbar interconnect, a heterogeneous multi-core processor subsystem, high-speed peripheral interfaces, video/imaging pipelines, and a dedicated security enclave.

## Repository Structure

The repository is organized functionally to separate the core logic from interconnect, memory, peripherals, and security domains:

```text
[Project_Penguin]
|-- .gitignore
|-- README.md
|-- rtl_completion_plan.md
|-- run_sim.sh
|-- yosys_synth.tcl
|-- backend/
|   |-- clint.v
|   |-- plic.v
|   |-- rv_core_top.v
|   |-- rv_dcache.v
|   |-- rv_debug.v
|   |-- rv_execute.v
|   |-- rv_fpu.v
|   |-- rv_mem.v
|   |-- rv_mmu.v
|   |-- rv_monitor_core.v
|   |-- rv_pmp.v
|   |-- rv_ptw.v
|   |-- rv_tlb.v
|   |-- rv_writeback.v
|-- common/
|   |-- cdc_sync.v
|   |-- fifo_async.v
|   |-- fifo_sync.v
|   |-- interfaces.sv
|   |-- isa_constants.vh
|   |-- isa_pkg.vh
|   |-- params.vh
|   |-- reset_sync.v
|-- frontend/
|   |-- rv_bpu.v
|   |-- rv_decode.v
|   |-- rv_fetch.v
|   |-- rv_icache.v
|-- interconnect/
|   |-- ahb_to_apb.v
|   |-- apb_bridge.v
|   |-- axi4_crossbar.v
|   |-- axi4_to_ahb.v
|   |-- mmu_arbiter.v
|   |-- mpu.v
|   |-- qos_controller.v
|-- memory/
|   |-- ddr_ctrl_top.v
|   |-- ddr_phy_if.v
|   |-- ddr_scheduler.v
|   |-- l2_cache_ctrl.v
|   |-- l2_cache_top.v
|   |-- l2_data_array.v
|   |-- l2_snoop_filter.v
|   |-- l2_tag_array.v
|   |-- sram_32x64_180nm.v
|   |-- sram_512kx8_180nm.v
|-- peripherals/
|   |-- aes_engine.v
|   |-- can_controller.v
|   |-- gem_ethernet.v
|   |-- gem_sgmii_pcs.v
|   |-- gpio_ctrl.v
|   |-- i2c_master.v
|   |-- pcie_pipe_if.v
|   |-- pcie_top.v
|   |-- rtc.v
|   |-- sha256_engine.v
|   |-- spi_master.v
|   |-- trng.v
|   |-- uart_16550.v
|   |-- watchdog_timer.v
|-- scripts/
|   |-- verilator_lint.sh
|-- security/
|   |-- drbg.v
|   |-- ecdsa_engine.v
|   |-- envm_ctrl.v
|   |-- secure_boot.v
|-- storage/
|   |-- mmc_controller.v
|   |-- qspi_controller.v
|   |-- usb_otg.v
|-- top/
|   |-- titan_x_top.v
|-- verification/
|   |-- tb_titan_x_top.sv
|-- video/
|   |-- hdmi_ctrl.v
|   |-- isp_pipeline.v
|   |-- mipi_csi2_rx.v
|   |-- vdma.v
```

## Status & Verification

This iteration of TITAN-X has successfully passed strict structural verification via Verilator (`verilator --lint-only`). The top-level (`titan_x_top.v`) flawlessly interconnects the 15 AXI Masters, 9 AXI Slaves, and dynamically decoded APB peripherals without floating inputs or unsupported type conversions.

## Getting Started

To verify the RTL integrity locally, ensure you have `iverilog` and `verilator` installed, and run:
```bash
./scripts/verilator_lint.sh
```

---
*Developed by the world's leading RTL Design team.*
