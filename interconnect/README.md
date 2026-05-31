# Interconnect Module

This directory contains the RTL sources for the interconnect subsystem of the TITAN-X SoC.

## File Descriptions

- **`ahb_to_apb.v`**: AHB to APB bridge for peripheral access.
- **`apb_bridge.v`**: APB bridge controller for low-speed slaves.
- **`axi4_crossbar.v`**: Main 15x9 AXI4 crossbar interconnect.
- **`axi4_to_ahb.v`**: AXI4 to AHB bridge.
- **`mmu_arbiter.v`**: Arbiter for MMU translation requests.
- **`mpu.v`**: Memory Protection Unit for the interconnect.
- **`qos_controller.v`**: Quality of Service (QoS) arbiter for AXI crossbar.
