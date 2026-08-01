## ============================================================
##  basys3.xdc - Basys3 XC7A35T-1CPG236C
##  MicroBlaze CSA - only 4 top-level ports
## ============================================================

## Clock
set_property PACKAGE_PIN W5      [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
create_clock -period 10.000 -name sys_clk [get_ports sys_clk]

## UART TX - FPGA to PC
set_property PACKAGE_PIN A18     [get_ports tx_0]
set_property IOSTANDARD LVCMOS33 [get_ports tx_0]

## UART RX - PC to FPGA
set_property PACKAGE_PIN B18     [get_ports rx_0]
set_property IOSTANDARD LVCMOS33 [get_ports rx_0]

## False paths
set_false_path -from [get_ports rx_0]
set_false_path -to   [get_ports tx_0]