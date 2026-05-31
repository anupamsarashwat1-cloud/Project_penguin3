# Timing Constraints for SMVDU TITAN-X
# Target: 200 MHz target (5.0 ns period)

create_clock -name clk -period 7.2 [get_ports clk]

# Set input/output delays (assume 20% of clock period)
set_input_delay  1.0 -clock clk [all_inputs]
set_output_delay 1.0 -clock clk [all_outputs]
