# Yosys synthesis script for SMVDU Titan-X (CPU Core Only)

read_verilog -Icommon -sv \
    ./common/cdc_sync.v \
    ./common/fifo_async.v \
    ./common/fifo_sync.v \
    ./common/interfaces.sv \
    ./common/reset_sync.v \
    ./backend/clint.v \
    ./backend/plic.v \
    ./backend/rv_core_top.v \
    ./backend/rv_execute.v \
    ./backend/rv_fpu.v \
    ./backend/rv_mem.v \
    ./backend/rv_mmu.v \
    ./backend/rv_monitor_core.v \
    ./backend/rv_pmp.v \
    ./backend/rv_ptw.v \
    ./backend/rv_tlb.v \
    ./backend/rv_writeback.v \
    ./frontend/rv_bpu.v \
    ./frontend/rv_decode.v \
    ./frontend/rv_fetch.v

# Elaborate design (Target CPU Core instead of full SoC)
# Do NOT use synth macro because it enforces -check, which fails on blackboxed caches
hierarchy -top rv_core_top

# Standard optimization passes
proc; flatten; opt_expr; opt_clean; check; opt -nodffe -nosdff; fsm; opt; wreduce; peepopt; opt_clean; share; opt

# Map memories to DFFs (prevents 2D arrays and initial blocks in netlist)
memory_dff
memory_collect
memory_map

opt -full
techmap
opt -fast

# Map to standard cell library
# 4. Map DFFs to 180nm library
dfflibmap -liberty /home/anupam-sarashwat/vsdflow/library/osu018_stdcells.lib
    
# 5. Map combinational logic to 180nm library (Timing Driven)
abc -D 7100 -liberty /home/anupam-sarashwat/vsdflow/library/osu018_stdcells.lib

clean

# Write synthesized Netlist for OpenSTA
write_verilog -noattr /home/anupam-sarashwat/titan_x_netlist.v
