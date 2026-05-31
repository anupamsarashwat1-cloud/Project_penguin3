read_liberty /home/anupam-sarashwat/vsdflow/library/osu018_stdcells.lib
read_verilog /home/anupam-sarashwat/titan_x_netlist.v
link_design rv_core_top
create_clock -name clk -period 5.0 [get_ports clk]
report_net -min_fanout 50
