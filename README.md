# 🔥 TITAN-X System-on-Chip (SoC)

**Project Penguin — Iteration 3 | SMVDU RISC-V ASIC Tapeout (SCL 180nm)**

TITAN-X is a high-performance, heterogeneous multi-core RISC-V System-on-Chip designed for compute-intensive and security-critical applications. It features a quad-core RV64GC application processor cluster, a dedicated RV64IMAC monitor core, hardware security enclave, video/imaging pipelines, and a rich peripheral set — all interconnected via a 15-Master / 9-Slave AXI4 crossbar fabric.

| Parameter | Value |
|---|---|
| **ISA** | RISC-V RV64GC (IMACFDZicsr\_Zifencei) |
| **Application Cores** | 4× RV64GC (Hart 0–3) |
| **Monitor Core** | 1× RV64IMAC (Hart 4) |
| **L1 I-Cache** | 16 KB, 4-Way Set Associative (per core) |
| **L1 D-Cache** | 16 KB, 4-Way Set Associative (per core) |
| **L2 Cache** | 512 KB Unified, Snoop Filter (MESI) |
| **MMU** | Sv39/Sv48 with Hardware PTW |
| **Physical Memory Protection** | 16 PMP Regions |
| **Interconnect** | AXI4 Crossbar (64-bit, 15M × 9S) → AHB → APB |
| **Target Process** | SCL 180nm (OSU018 Std Cell Library) |
| **Operating Frequency** | 138.8 MHz (Timing Closure Achieved) |
| **Setup WNS / TNS** | 0.00 ns / 0.00 ns ✅ |
| **Hold WNS / TNS** | 0.00 ns / 0.00 ns ✅ |

---

## 🏗️ SoC Architecture — High-Level Block Diagram

```mermaid
flowchart TD
    classDef core fill:#1a1a2e,stroke:#e94560,stroke-width:2px,color:#eee;
    classDef bus fill:#16213e,stroke:#0f3460,stroke-width:2px,color:#e2e2e2;
    classDef mem fill:#0a3d62,stroke:#3c6382,stroke-width:2px,color:#eee;
    classDef sec fill:#2c2c54,stroke:#706fd3,stroke-width:2px,color:#eee;
    classDef io fill:#1e3799,stroke:#4a69bd,stroke-width:2px,color:#eee;
    classDef periph fill:#2d3436,stroke:#636e72,stroke-width:2px,color:#eee;
    classDef vid fill:#6c5ce7,stroke:#a29bfe,stroke-width:2px,color:#eee;

    subgraph CPU_CLUSTER["Quad-Core RV64GC Application Processor Cluster (Hart 0–3)"]
        direction TB

        subgraph FE["Frontend Pipeline"]
            FETCH["rv_fetch\nInstruction Fetch"]
            BPU["rv_bpu\nBranch Predictor (BTB/BHT)"]
            DECODE["rv_decode\nInstruction Decode & Issue"]
        end

        subgraph BE["Backend Pipeline"]
            EXEC["rv_execute\nALU / Branch / CSR"]
            FPU["rv_fpu\nIEEE-754 FPU"]
            MEM_S["rv_mem\nMemory Access"]
            WB["rv_writeback\nCommit to RegFile"]
        end

        subgraph CACHE["L1 Cache Hierarchy"]
            L1I["rv_icache\n16KB L1I (4-Way)"]
            L1D["rv_dcache\n16KB L1D (4-Way)"]
        end

        subgraph VM["Virtual Memory & Protection"]
            MMU["rv_mmu\nSv39/Sv48"]
            TLB["rv_tlb\nITLB & DTLB"]
            PTW["rv_ptw\nHW Page Table Walker"]
            PMP["rv_pmp\n16 PMP Regions"]
        end

        FETCH -- "Inst[31:0], PC[63:0]" --> DECODE
        FETCH <.-> BPU
        DECODE -- "Micro-ops" --> EXEC
        EXEC <--> FPU
        EXEC -- "ALU Result" --> MEM_S
        MEM_S -- "Load Data" --> WB
        FETCH <== "I-Fetch 64b" ==> L1I
        MEM_S <== "L/S 64b" ==> L1D
        L1I -.-> TLB
        L1D -.-> TLB
        TLB <--> MMU
        MMU <--> PTW
        PMP --> MMU
    end

    subgraph MON_CORE["Monitor Core (Hart 4)"]
        MONITOR["rv_monitor_core\nRV64IMAC"]
    end

    subgraph INT_CTRL["Interrupt Controllers"]
        PLIC["PLIC\n32 External IRQ Lines"]
        CLINT["CLINT\n5 Timer + 5 SW IRQs"]
    end

    AXI["AXI4 Crossbar\n64-bit Data, 40-bit Addr\n15 Masters × 9 Slaves\n4-bit Transaction ID"]:::bus
    QOS["QoS Controller\nBandwidth Arbiter"]:::bus

    subgraph MEM_SUB["Memory Subsystem"]
        L2["L2 Cache\n512KB Unified\nSnoop Filter (MESI)"]
        DDR["DDR3/DDR4 Controller\nddr_ctrl_top + ddr_phy_if\nddr_scheduler"]
        SRAM["On-Chip SRAM Macros\nsram_32x64_180nm\nsram_512kx8_180nm"]
    end

    subgraph SEC_ENCLAVE["Hardware Security Enclave"]
        SBOOT["secure_boot\nBoot ROM & Verification"]
        AES["aes_engine\nAES-128/256 Accelerator"]
        SHA["sha256_engine\nSHA-256 Hashing"]
        ECDSA["ecdsa_engine\nECDSA Signing"]
        TRNG["trng\nEntropy Source"]
        DRBG["drbg\nDeterministic RBG"]
        ENVM["envm_ctrl\neNVM Secure Storage"]
    end

    subgraph HS_IO["High-Speed I/O & Storage"]
        PCIE["pcie_top\nPCIe Gen2/3 Root Complex\n+ pcie_pipe_if"]
        GEM["gem_ethernet\nGigabit Ethernet MAC\n+ gem_sgmii_pcs"]
        USB["usb_otg\nUSB 2.0/3.0 OTG"]
        MMC["mmc_controller\neMMC / SD Host"]
        QSPI["qspi_controller\nQuad-SPI Flash"]
    end

    AXI2AHB["axi4_to_ahb\nAXI4 → AHB Bridge"]:::bus
    AHB2APB["ahb_to_apb\nAHB → APB Bridge"]:::bus

    subgraph LS_PERIPH["Low-Speed Peripherals (APB, 32-bit)"]
        UART["uart_16550 × 5\n(UART0–4)"]
        CAN["can_controller × 2\nCAN 2.0B (CAN0, CAN1)"]
        I2C["i2c_master"]
        SPI["spi_master"]
        GPIO["gpio_ctrl\n32-pin GPIO"]
        RTC["rtc\nReal-Time Clock"]
        WDT["watchdog_timer"]
    end

    subgraph VIDEO["Video & Multimedia"]
        CSI2["mipi_csi2_rx\nMIPI CSI-2 Receiver"]
        ISP["isp_pipeline\nImage Signal Processor"]
        HDMI["hdmi_ctrl\nHDMI TX Controller"]
        VDMA["vdma\nVideo DMA Engine"]
    end

    %% === AXI MASTER CONNECTIONS ===
    L1I <== "M[0–3]: I-Cache Refill (AR/R)" ==> AXI
    L1D <== "M[4–7]: D-Cache + PTW (Full AXI)" ==> AXI
    MONITOR <== "M[8–9]: Mon I+D" ==> AXI
    GEM <== "M[10]: GEM DMA" ==> AXI
    PCIE <== "M[11]: PCIe DMA" ==> AXI
    USB <== "M[12]: USB DMA" ==> AXI

    %% === AXI SLAVE CONNECTIONS ===
    AXI <== "S[0]: DDR" ==> L2
    L2 <== "MESI Coherent" ==> DDR
    AXI <== "S[1]: APB Decode" ==> AXI2AHB
    AXI2AHB <== "AHB" ==> AHB2APB
    AHB2APB <== "APB3" ==> LS_PERIPH

    %% === Interrupts ===
    PLIC -. "ext_irq[0–4]" .-> CPU_CLUSTER & MON_CORE
    CLINT -. "timer_irq / sw_irq" .-> CPU_CLUSTER & MON_CORE

    %% === APB-Mapped Security ===
    AHB2APB -. "APB" .-> SEC_ENCLAVE
    TRNG --> DRBG
    SBOOT -. "boot_pass" .-> CPU_CLUSTER

    %% === Video Pipeline ===
    CSI2 -- "AXI-Stream" --> ISP
    ISP -- "AXI-Stream" --> VDMA
    VDMA <== "M[?]: VDMA" ==> AXI

    %% === Classes ===
    class CPU_CLUSTER core;
    class MON_CORE core;
    class INT_CTRL core;
    class MEM_SUB mem;
    class SEC_ENCLAVE sec;
    class HS_IO io;
    class LS_PERIPH periph;
    class VIDEO vid;
```

---

## 🧠 CPU Core Microarchitecture — Detailed Pinout (`rv_core_top`)

This diagram zooms into a single RV64GC core instance, showing every I/O pin at the module boundary, all internal submodule instantiations, and the data/control signal routing between them.

```mermaid
flowchart TD
    classDef inp fill:#e6ffe6,stroke:#00cc00,stroke-width:1px,color:#004d00;
    classDef outp fill:#ffe6e6,stroke:#cc0000,stroke-width:1px,color:#800000;
    classDef wire fill:none,stroke:#ffa500,stroke-width:1px,color:#d2691e,stroke-dasharray: 2 2;
    classDef mod fill:#f0f8ff,stroke:#4682b4,stroke-width:2px,color:#00008b;
    classDef cache fill:#fff0f5,stroke:#db7093,stroke-width:2px,color:#8b008b;
    classDef prot fill:#f5fffa,stroke:#3cb371,stroke-width:2px,color:#006400;

    subgraph CORE ["`rv_core_top` — Module Boundary"]
        direction TB

        subgraph SYS ["System"]
            P_clk("⬇ clk"):::inp
            P_rst("⬇ rst_n"):::inp
        end

        subgraph IRQ ["Interrupts"]
            P_irq_ext("⬇ irq_m_ext"):::inp
            P_irq_timer("⬇ irq_m_timer"):::inp
            P_irq_soft("⬇ irq_m_soft"):::inp
        end

        subgraph DBG ["Debug (JTAG)"]
            P_halt("⬇ halt_req"):::inp
            P_resume("⬇ resume_req"):::inp
            P_halted("⬆ hart_halted"):::outp
            P_running("⬆ hart_running"):::outp
        end

        subgraph SNOOP ["L2 Snoop Port"]
            P_sv("⬇ snoop_valid"):::inp
            P_sa("⬇ snoop_addr[39:0]"):::inp
            P_st("⬇ snoop_type[1:0]"):::inp
            P_sack("⬆ snoop_ack"):::outp
            P_sdv("⬆ snoop_data_valid"):::outp
            P_sd("⬆ snoop_data[511:0]"):::outp
        end

        subgraph IAXI ["AXI4 Master — I-Cache (Read-Only)"]
            direction LR
            P_iar("⬆ imem_arvalid, araddr[39:0],\narlen[7:0], arsize[2:0], arburst[1:0]"):::outp
            P_ird("⬇ imem_arready, rvalid,\nrdata[63:0], rlast, rresp[1:0]"):::inp
            P_irr("⬆ imem_rready"):::outp
        end

        subgraph DAXI ["AXI4 Master — D-Cache (Full R/W)"]
            direction LR
            P_daw("⬆ dmem_awvalid, awaddr[39:0],\nawlen[7:0], awsize[2:0], awburst[1:0]"):::outp
            P_dw("⬆ dmem_wvalid, wdata[63:0],\nwstrb[7:0], wlast"):::outp
            P_db("⬇ dmem_bvalid, bresp[1:0]\n⬆ dmem_bready"):::outp
            P_dar("⬆ dmem_arvalid, araddr[39:0],\narlen[7:0], arsize[2:0], arburst[1:0], arlock"):::outp
            P_dr("⬇ dmem_rvalid, rdata[63:0],\nrlast, rresp[1:0]\n⬆ dmem_rready"):::outp
        end

        subgraph PIPE ["5-Stage Integer Pipeline"]
            direction TB
            u_fetch["rv_fetch"]:::mod
            u_decode["rv_decode"]:::mod
            u_execute["rv_execute\n(ALU, Branch, CSR)"]:::mod
            u_mem["rv_mem"]:::mod
            u_wb["rv_writeback"]:::mod
        end

        subgraph ACC ["Accelerators"]
            u_bpu["rv_bpu\n(BTB + BHT)"]:::mod
            u_fpu["rv_fpu\n(IEEE-754)"]:::mod
        end

        subgraph CACHES ["L1 Caches"]
            u_ic["rv_icache"]:::cache
            u_dc["rv_dcache"]:::cache
        end

        subgraph VMPROT ["Virtual Memory & Protection"]
            u_mmu["rv_mmu"]:::prot
            u_tlb["rv_tlb"]:::prot
            u_ptw["rv_ptw"]:::prot
            u_pmp["rv_pmp"]:::prot
        end

        subgraph CTRL ["Control & Telemetry"]
            u_debug["rv_debug"]:::mod
            u_monitor["rv_monitor_core"]:::mod
        end

        %% === Pipeline Data Path ===
        u_fetch ==>|"Inst[31:0]\nPC[63:0]"| u_decode
        u_decode ==>|"RS1/RS2/RS3\nImmediate\nControl"| u_execute
        u_execute ==>|"ALU Res[63:0]\nLS Addr[63:0]"| u_mem
        u_mem ==>|"Load Data[63:0]\nRd Index[4:0]"| u_wb
        u_execute <==>|"FP Operands\nFP Flags"| u_fpu

        %% === Pipeline Control ===
        flush("flush_de_raw\n(BUFX4 buffered)"):::wire
        u_execute -.->|"branch_taken\nexception"| flush
        flush -.->|"flush"| u_fetch & u_decode
        u_mem -.->|"stall_req\n(D$ miss)"| u_execute & u_decode & u_fetch

        %% === Branch Prediction ===
        u_fetch <.->|"BTB/BHT\nR/W"| u_bpu
        u_execute -.->|"Resolve\nMispredict"| u_bpu
        u_execute -.->|"Target PC\nException PC"| u_fetch

        %% === Cache Access ===
        u_fetch <==>|"I-Fetch / Inst"| u_ic
        u_mem <==>|"L/S Req / Data"| u_dc

        %% === Address Translation ===
        priv("priv_mode[1:0]\nsatp[63:0]"):::wire
        u_execute -.->|"CSR Write"| priv
        priv -.-> u_mmu & u_tlb
        u_ic -.->|"VA (I)"| u_tlb
        u_dc -.->|"VA (D)"| u_tlb
        u_tlb <==>|"TLB Miss"| u_mmu
        u_mmu <==>|"PTE Req"| u_ptw
        u_ptw <==>|"L1D Bypass"| u_dc

        %% === PMP ===
        pmpcfg("pmpcfg[63:0]\npmpaddr[0:7]"):::wire
        u_execute -.->|"PMP CSR"| pmpcfg
        pmpcfg -.-> u_pmp
        u_mmu -.->|"PA Check"| u_pmp
        u_pmp -.->|"Fault"| u_mmu

        %% === External I/O Mapping ===
        u_ic ==>|"AR / R"| IAXI
        u_dc ==>|"AW / W / B / AR / R"| DAXI
        SNOOP ==> u_dc
        IRQ -.-> u_execute
        DBG <==> u_debug
        u_debug -.->|"Halt / Step"| u_execute
        u_monitor -.->|"Counters"| u_execute
    end
```

---

## 📌 SoC Top-Level I/O Pin Table (`titan_x_top`)

These are the physical pins exposed at the chip boundary.

### Clock & Reset

| Pin | Direction | Width | Description |
|---|---|---|---|
| `clk` | Input | 1 | System clock (138.8 MHz) |
| `rst_n` | Input | 1 | Active-low system reset |

### DDR4 Memory Interface

| Pin | Direction | Width | Description |
|---|---|---|---|
| `ddr_addr` | Output | 16 | DDR row/column address |
| `ddr_ba` | Output | 3 | Bank address |
| `ddr_bg` | Output | 2 | Bank group |
| `ddr_ck_p / ddr_ck_n` | Output | 1+1 | Differential DDR clock |
| `ddr_cke` | Output | 1 | Clock enable |
| `ddr_cs_n` | Output | 1 | Chip select (active low) |
| `ddr_ras_n / cas_n / we_n` | Output | 3 | Command pins |
| `ddr_reset_n` | Output | 1 | DDR reset |
| `ddr_odt` | Output | 1 | On-die termination |
| `ddr_act_n` | Output | 1 | Activate command |
| `ddr_dq` | Bidir | 64 | Data bus |
| `ddr_dqs_p / ddr_dqs_n` | Bidir | 8+8 | Differential data strobe |

### High-Speed Peripheral Clocks

| Pin | Direction | Width | Description |
|---|---|---|---|
| `pipe_clk` | Input | 1 | PCIe PIPE interface clock |
| `eth_tx_clk` | Input | 1 | Ethernet transmit clock |
| `eth_rx_clk` | Input | 1 | Ethernet receive clock |
| `ulpi_clk` | Input | 1 | USB ULPI PHY clock |

### Video / Imaging Interface

| Pin | Direction | Width | Description |
|---|---|---|---|
| `mipi_rxbyteclkhs` | Input | 1 | MIPI CSI-2 byte clock |
| `hdmi_clk_pixel` | Input | 1 | HDMI pixel clock |
| `hdmi_clk_tmds` | Input | 1 | HDMI TMDS serializer clock |
| `hdmi_tmds_clk_p/n` | Output | 1+1 | Differential TMDS clock output |
| `hdmi_tmds_data_p/n` | Output | 3+3 | Differential TMDS data lanes |

### Low-Speed Peripherals

| Pin | Direction | Width | Description |
|---|---|---|---|
| `rtc_clk` | Input | 1 | 32.768 kHz RTC crystal clock |
| `uart_tx[4:0]` | Output | 5 | UART transmit (5 channels) |
| `uart_rx[4:0]` | Input | 5 | UART receive (5 channels) |
| `can_tx[1:0]` | Output | 2 | CAN bus transmit (2 channels) |
| `can_rx[1:0]` | Input | 2 | CAN bus receive (2 channels) |

---

## 🗺️ AXI Crossbar Port Map

### Masters (15 Ports)

| Port | Module | Description |
|---|---|---|
| M[0–3] | `rv_core_top` × 4 | I-Cache refill (AR/R only) |
| M[4–7] | `rv_core_top` × 4 | D-Cache + PTW (Full AXI) |
| M[8] | `rv_monitor_core` | Monitor I-Fetch |
| M[9] | `rv_monitor_core` | Monitor D-Access |
| M[10] | `gem_ethernet` | Gigabit Ethernet DMA |
| M[11] | `pcie_top` | PCIe DMA |
| M[12] | `usb_otg` | USB OTG DMA |
| M[13–14] | — | Reserved (tied off) |

### Slaves (9 Ports)

| Port | Module | Description |
|---|---|---|
| S[0] | `ddr_ctrl_top` | DDR Memory Controller |
| S[1] | `axi4_to_ahb` | AHB → APB Peripheral Bridge |
| S[2–8] | — | Reserved (tied off, future expansion) |

---

## 🗂️ APB Address Map

| Base Address | Peripheral | PLIC IRQ |
|---|---|---|
| `0x1000_0000` | UART 0 | 20 |
| `0x1000_1000` | UART 1 | 21 |
| `0x1000_2000` | UART 2 | 22 |
| `0x1000_3000` | UART 3 | 23 |
| `0x1000_4000` | UART 4 | 24 |
| `0x1001_0000` | RTC | timer_irq[4:0] |
| `0x1002_0000` | Gigabit Ethernet (APB Cfg) | 27 |
| `0x1003_0000` | USB OTG (APB Cfg) | 28 |
| `0x1004_0000` | MIPI CSI-2 RX | — |
| `0x1005_0000` | ISP Pipeline | — |
| `0x1006_0000` | HDMI Controller | — |
| `0x2000_0000` | DRBG | 10 |
| `0x2001_0000` | AES Engine | 11 |
| `0x2002_0000` | eNVM Controller | — |
| `0x2003_0000` | Secure Boot ROM | — |
| `0x3000_0000` | CAN 0 | 25 |
| `0x3000_1000` | CAN 1 | 26 |

---

## 📁 Repository Structure

```text
Project_Penguin3/
├── README.md                    # This file
├── rtl_completion_plan.md       # Design specification & milestones
├── run_sim.sh                   # Simulation runner
│
├── top/                         # SoC top-level integration
│   └── titan_x_top.v
│
├── frontend/                    # CPU frontend pipeline
│   ├── rv_fetch.v               #   Instruction Fetch stage
│   ├── rv_decode.v              #   Instruction Decode & Issue
│   ├── rv_bpu.v                 #   Branch Prediction Unit (BTB/BHT)
│   └── rv_icache.v              #   L1 Instruction Cache
│
├── backend/                     # CPU backend pipeline
│   ├── rv_core_top.v            #   Core top-level wrapper
│   ├── rv_execute.v             #   Execution stage (ALU, Branch, CSR)
│   ├── rv_fpu.v                 #   IEEE-754 Floating Point Unit
│   ├── rv_mem.v                 #   Memory access stage
│   ├── rv_writeback.v           #   Writeback / commit stage
│   ├── rv_mmu.v                 #   Memory Management Unit (Sv39/Sv48)
│   ├── rv_tlb.v                 #   Translation Lookaside Buffer
│   ├── rv_ptw.v                 #   Hardware Page Table Walker
│   ├── rv_pmp.v                 #   Physical Memory Protection (16 regions)
│   ├── rv_dcache.v              #   L1 Data Cache
│   ├── rv_debug.v               #   JTAG Debug Module
│   ├── rv_monitor_core.v        #   RV64IMAC Monitor Core (Hart 4)
│   ├── clint.v                  #   Core Local Interruptor
│   └── plic.v                   #   Platform-Level Interrupt Controller
│
├── interconnect/                # Bus fabric
│   ├── axi4_crossbar.v          #   15×9 AXI4 Crossbar
│   ├── axi4_to_ahb.v            #   AXI4 → AHB Bridge
│   ├── ahb_to_apb.v             #   AHB → APB Bridge
│   ├── apb_bridge.v             #   APB peripheral bridge
│   ├── mmu_arbiter.v            #   MMU request arbiter
│   ├── mpu.v                    #   Memory Protection Unit
│   └── qos_controller.v         #   QoS bandwidth arbiter
│
├── memory/                      # Memory subsystem
│   ├── l2_cache_top.v           #   L2 Cache top wrapper
│   ├── l2_cache_ctrl.v          #   L2 Cache controller
│   ├── l2_tag_array.v           #   L2 tag RAM
│   ├── l2_data_array.v          #   L2 data RAM
│   ├── l2_snoop_filter.v        #   L1/L2 coherency snoop filter
│   ├── ddr_ctrl_top.v           #   DDR memory controller
│   ├── ddr_phy_if.v             #   DDR PHY interface
│   ├── ddr_scheduler.v          #   DDR transaction scheduler
│   ├── sram_32x64_180nm.v       #   SCL 180nm SRAM macro (32×64)
│   └── sram_512kx8_180nm.v      #   SCL 180nm SRAM macro (512K×8)
│
├── peripherals/                 # I/O peripherals
│   ├── uart_16550.v             #   16550-compatible UART
│   ├── can_controller.v         #   CAN 2.0B controller
│   ├── i2c_master.v             #   I2C master
│   ├── spi_master.v             #   SPI master
│   ├── gpio_ctrl.v              #   32-pin GPIO controller
│   ├── rtc.v                    #   Real-Time Clock
│   ├── watchdog_timer.v         #   Watchdog timer
│   ├── gem_ethernet.v           #   Gigabit Ethernet MAC
│   ├── gem_sgmii_pcs.v          #   SGMII PCS for GbE
│   ├── pcie_top.v               #   PCIe Root Complex
│   ├── pcie_pipe_if.v           #   PCIe PIPE PHY interface
│   ├── aes_engine.v             #   AES crypto accelerator
│   ├── sha256_engine.v          #   SHA-256 hashing engine
│   └── trng.v                   #   True Random Number Generator
│
├── security/                    # Hardware security enclave
│   ├── secure_boot.v            #   Secure Boot ROM & verification
│   ├── ecdsa_engine.v           #   ECDSA crypto accelerator
│   ├── drbg.v                   #   Deterministic Random Bit Generator
│   └── envm_ctrl.v              #   eNVM secure storage controller
│
├── storage/                     # Storage interfaces
│   ├── mmc_controller.v         #   eMMC / SD card host
│   ├── qspi_controller.v       #   Quad-SPI flash controller
│   └── usb_otg.v                #   USB 2.0/3.0 OTG controller
│
├── video/                       # Video & multimedia
│   ├── mipi_csi2_rx.v           #   MIPI CSI-2 camera receiver
│   ├── isp_pipeline.v           #   Image Signal Processor
│   ├── hdmi_ctrl.v              #   HDMI display controller
│   └── vdma.v                   #   Video DMA engine
│
├── common/                      # Shared RTL utilities
│   ├── params.vh                #   Global parameters & config macros
│   ├── isa_pkg.vh               #   RISC-V ISA type definitions
│   ├── isa_constants.vh         #   Opcode / funct3 / funct7 constants
│   ├── interfaces.sv            #   AXI / AHB / APB SystemVerilog interfaces
│   ├── cdc_sync.v               #   Clock-domain crossing synchronizer
│   ├── fifo_async.v             #   Asynchronous FIFO
│   ├── fifo_sync.v              #   Synchronous FIFO
│   └── reset_sync.v             #   Reset synchronizer
│
├── verification/                # Testbenches
│   └── tb_titan_x_top.sv        #   Top-level SoC testbench
│
└── scripts/                     # Build & lint utilities
    └── verilator_lint.sh        #   Verilator lint-only checker
```

---

## ✅ Synthesis & Timing Closure Status

| Metric | Result |
|---|---|
| **Synthesis Tool** | Yosys + ABC (timing-driven, `-D 7200`) |
| **Target Library** | `osu018_stdcells.lib` (OSU 180nm, proxy for SCL 180nm) |
| **STA Tool** | OpenSTA 2.3.1 |
| **Clock Period** | 7.2 ns (138.8 MHz) |
| **Setup WNS** | 0.00 ns ✅ MET |
| **Setup TNS** | 0.00 ns ✅ MET |
| **Hold WNS** | 0.00 ns ✅ MET |
| **Hold TNS** | 0.00 ns ✅ MET |
| **Critical Path** | Execute → ALU Carry Chain → D-Cache → Writeback |
| **Key Optimization** | Explicit `BUFX4` instantiation on `flush` fanout tree (300+ FF → 4 balanced subtrees) |

---

## 🚀 Getting Started

```bash
# Lint the entire RTL
./scripts/verilator_lint.sh
```

> **Note:** Synthesis scripts, STA scripts, SDC constraints, and all verification logs are maintained in the companion repository:
> [functional_verification_2](https://github.com/anupamsarashwat1-cloud/functional_verification_2)

---

*SMVDU TITAN-X SoC — Designed for SCL 180nm ASIC Tapeout*
