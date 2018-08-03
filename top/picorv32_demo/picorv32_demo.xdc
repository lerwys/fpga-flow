#######################################################################
##                      Kintex 7 KC705 Kit                           ##
#######################################################################

# Clocks
#IO_L12P_T1_MRCC_14 Sch=gclk
set_property IOSTANDARD LVCMOS33 [get_ports sysclk_i]
set_property PACKAGE_PIN L17 [get_ports sysclk_i]

# LEDs
#IO_L12N_T1_MRCC_16 Sch=led[1]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_led_o[0]}]
set_property PACKAGE_PIN A17  [get_ports {gpio_led_o[0]}]
#IO_L13P_T2_MRCC_16 Sch=led[2]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_led_o[1]}]
set_property PACKAGE_PIN C16  [get_ports {gpio_led_o[1]}]
#IO_L14N_T2_SRCC_16 Sch=led0_b
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_led_o[2]}]
set_property PACKAGE_PIN B17  [get_ports {gpio_led_o[2]}]
#IO_L13N_T2_MRCC_16 Sch=led0_g
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_led_o[3]}]
set_property PACKAGE_PIN B16  [get_ports {gpio_led_o[3]}]
#IO_L14P_T2_SRCC_16 Sch=led0_r
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_led_o[4]}]
set_property PACKAGE_PIN C17 [get_ports {gpio_led_o[4]}]

#######################################################################
##                          Clocks                                   ##
#######################################################################

create_clock -add -name sys_clk_pin -period 83.33 -waveform {0 41.66} [get_ports {sysclk_i}];

#######################################################################
##                         Bitstream Settings                        ##
#######################################################################

set_property CFGBVS VCCO [current_design]
