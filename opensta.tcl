# OpenSTA Script for SMVDU TITAN-X

# 1. Read the 180nm library
read_liberty /home/anupam-sarashwat/vsdflow/library/osu018_stdcells.lib

# 2. Read Synthesized Verilog Netlist
read_verilog /home/anupam-sarashwat/titan_x_netlist.v

# 3. Link Design
link_design rv_core_top

# 4. Read SDC Constraints
read_sdc /home/anupam-sarashwat/Project_penguin3/titan_x.sdc

# 5. Report Timing
report_checks -path_delay max -format full
report_checks -path_delay min -format full
report_tns
report_wns
