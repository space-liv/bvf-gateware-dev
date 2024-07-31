# -------------------------------------------------------
# Create Smart Design for BVF Gateware
# -------------------------------------------------------
set sd_name ${::top_level_name}
create_smartdesign -sd_name ${sd_name}

auto_promote_pad_pins -promote_all 0

# -------------------------------------------------------
# Import Component Loader
# -------------------------------------------------------
source $local_dir/fpga/component_loader.tcl

# -------------------------------------------------------
# Create Top Level Ports
# -------------------------------------------------------
sd_create_scalar_port -sd_name ${sd_name} -port_name {REFCLK} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {REFCLK_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {USB0_CLK} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {USB0_DIR} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {USB0_NXT} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {USB0_STP} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {USB0_DATA0} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {USB0_DATA1} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {USB0_DATA2} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {USB0_DATA3} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {USB0_DATA4} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {USB0_DATA5} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {USB0_DATA6} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {USB0_DATA7} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {USB0_OCn} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {UART0_TXD} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {UART0_RXD} -port_direction {IN}


sd_create_scalar_port -sd_name ${sd_name} -port_name {RESET_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {ODT} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CKE} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CS} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CK} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CK_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {USB0_RESETB} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SGMII_RX0_P} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SGMII_RX0_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SGMII_TX0_P} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SGMII_TX0_N} -port_direction {OUT} -port_is_pad {1}

sd_create_scalar_port -sd_name ${sd_name} -port_name {SGMII_RX1_P} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SGMII_RX1_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SGMII_TX1_P} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SGMII_TX1_N} -port_direction {OUT} -port_is_pad {1}

sd_create_scalar_port -sd_name ${sd_name} -port_name {I2C_1_SCL} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {I2C_1_SDA} -port_direction {INOUT} -port_is_pad {1}


sd_create_bus_port -sd_name ${sd_name} -port_name {CA} -port_direction {OUT} -port_range {[5:0]} -port_is_pad {1}
sd_create_bus_port -sd_name ${sd_name} -port_name {DQ} -port_direction {INOUT} -port_range {[31:0]} -port_is_pad {1}
sd_create_bus_port -sd_name ${sd_name} -port_name {DQS} -port_direction {INOUT} -port_range {[3:0]} -port_is_pad {1}
sd_create_bus_port -sd_name ${sd_name} -port_name {DQS_N} -port_direction {INOUT} -port_range {[3:0]} -port_is_pad {1}
sd_create_bus_port -sd_name ${sd_name} -port_name {DM} -port_direction {OUT} -port_range {[3:0]} -port_is_pad {1}

sd_create_scalar_port -sd_name ${sd_name} -port_name {P9_19} -port_direction {INOUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {P9_20} -port_direction {INOUT}

sd_create_scalar_port -sd_name ${sd_name} -port_name {USER_BUTTON} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SD_CARD_CS} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SD_DET} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {M2_W_DISABLE1} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {M2_W_DISABLE2} -port_direction {OUT}

# -------------------------------------------------------
# ADC Pins
# -------------------------------------------------------
sd_create_scalar_port -sd_name ${sd_name} -port_name {ADC_CSn} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {ADC_SCK} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {ADC_MOSI} -port_direction {INOUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {ADC_MISO} -port_direction {INOUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {ADC_IRQn} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {ADC_MCLK} -port_direction {OUT}

# -------------------------------------------------------
# Ethernet PHY Pins
# -------------------------------------------------------
sd_create_scalar_port -sd_name ${sd_name} -port_name {PHY_RSTn} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PHY_INTn} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PHY_MDC} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PHY_MDIO} -port_direction {INOUT}

# -------------------------------------------------------
# Instantiate Submodules
# -------------------------------------------------------

# Add RISC-V Subsystem (from BVF_RISCV_SUBSYSTEM)
sd_instantiate_component -sd_name ${sd_name} -component_name {BVF_RISCV_SUBSYSTEM} -instance_name {BVF_RISCV_SUBSYSTEM}

# Add clocks module (from clocks.tcl)
sd_instantiate_component -sd_name ${sd_name} -component_name {CLOCKS} -instance_name {CLOCKS}

sd_connect_pins -sd_name ${sd_name} -pin_names {"CLOCKS:FIC_0_ACLK" "BVF_RISCV_SUBSYSTEM:FIC_0_ACLK"}
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLOCKS:FIC_1_ACLK" "BVF_RISCV_SUBSYSTEM:FIC_1_ACLK"}
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLOCKS:FIC_2_ACLK" "BVF_RISCV_SUBSYSTEM:FIC_2_ACLK"}
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLOCKS:FIC_3_PCLK" "BVF_RISCV_SUBSYSTEM:FIC_3_PCLK"}
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLOCKS:FIC_0_FABRIC_RESET_N" "USB0_RESETB" "PHY_RSTn"}
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLOCKS:FIC_3_FABRIC_RESET_N" "BVF_RISCV_SUBSYSTEM:presetn"}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CLOCKS:FIC_1_FABRIC_RESET_N}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CLOCKS:FIC_2_FABRIC_RESET_N}

sd_connect_pins -sd_name ${sd_name} -pin_names {"CK" "BVF_RISCV_SUBSYSTEM:CK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CK_N" "BVF_RISCV_SUBSYSTEM:CK_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CKE" "BVF_RISCV_SUBSYSTEM:CKE" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CS" "BVF_RISCV_SUBSYSTEM:CS" }

sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:I2C0_SDA" "P9_20"}
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:I2C0_SCL" "P9_19"}

sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:I2C_1_SCL" "I2C_1_SCL" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:I2C_1_SDA" "I2C_1_SDA" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:UART0_RXD" "UART0_RXD" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:UART0_TXD" "UART0_TXD" }


sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:MSS_RESET_N_M2F" "CLOCKS:EXT_RST_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:MSS_DLL_LOCKS" "CLOCKS:MSS_DLL_LOCKS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ODT" "BVF_RISCV_SUBSYSTEM:ODT" }

# -------------------------------------------------------
# Misc. Pins
# -------------------------------------------------------
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:USER_BUTTON" "USER_BUTTON"}
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:SD_CARD_CS" "SD_CARD_CS"}
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:SD_DET" "SD_DET"}

# -------------------------------------------------------
# eMMC
# -------------------------------------------------------
sd_connect_pin_to_port -sd_name ${sd_name} -pin_name {BVF_RISCV_SUBSYSTEM:EMMC} -port_name {}
sd_connect_pin_to_port -sd_name ${sd_name} -pin_name {BVF_RISCV_SUBSYSTEM:EMMC_IN} -port_name {}

# -------------------------------------------------------
# Connect ADC Pins
# -------------------------------------------------------
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:ADC_SCK" "ADC_SCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:ADC_CSn" "ADC_CSn" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:ADC_MOSI" "ADC_MOSI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:ADC_MISO" "ADC_MISO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ADC_IRQn" "BVF_RISCV_SUBSYSTEM:ADC_IRQn" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLOCKS:ADC_MCLK_4_915MHz" "ADC_MCLK"}

# -------------------------------------------------------
# Connect Misc. Clock/Reset Pins
# -------------------------------------------------------
sd_connect_pins -sd_name ${sd_name} -pin_names {"REFCLK" "BVF_RISCV_SUBSYSTEM:REFCLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"REFCLK_N" "BVF_RISCV_SUBSYSTEM:REFCLK_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"RESET_N" "BVF_RISCV_SUBSYSTEM:RESET_N" }

# -------------------------------------------------------
# Connect ETH PHY Pins
# -------------------------------------------------------
sd_connect_pins -sd_name ${sd_name} -pin_names {"PHY_MDIO" "BVF_RISCV_SUBSYSTEM:PHY_MDIO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PHY_MDC" "BVF_RISCV_SUBSYSTEM:PHY_MDC" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PHY_INTn" "BVF_RISCV_SUBSYSTEM:PHY_INTn" }

sd_connect_pins -sd_name ${sd_name} -pin_names {"SGMII_RX0_N" "BVF_RISCV_SUBSYSTEM:SGMII_RX0_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"SGMII_RX0_P" "BVF_RISCV_SUBSYSTEM:SGMII_RX0_P" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"SGMII_TX0_N" "BVF_RISCV_SUBSYSTEM:SGMII_TX0_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"SGMII_TX0_P" "BVF_RISCV_SUBSYSTEM:SGMII_TX0_P" }

sd_connect_pins -sd_name ${sd_name} -pin_names {"SGMII_RX1_N" "BVF_RISCV_SUBSYSTEM:SGMII_RX1_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"SGMII_RX1_P" "BVF_RISCV_SUBSYSTEM:SGMII_RX1_P" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"SGMII_TX1_N" "BVF_RISCV_SUBSYSTEM:SGMII_TX1_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"SGMII_TX1_P" "BVF_RISCV_SUBSYSTEM:SGMII_TX1_P" }

# -------------------------------------------------------
# Connect USB OTG Pins
# -------------------------------------------------------
sd_connect_pins -sd_name ${sd_name} -pin_names {"USB0_OCn" "BVF_RISCV_SUBSYSTEM:USB_OCn" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:USB_CLK" "USB0_CLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:USB_DATA0" "USB0_DATA0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:USB_DATA1" "USB0_DATA1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:USB_DATA2" "USB0_DATA2" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:USB_DATA3" "USB0_DATA3" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:USB_DATA4" "USB0_DATA4" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:USB_DATA5" "USB0_DATA5" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:USB_DATA6" "USB0_DATA6" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:USB_DATA7" "USB0_DATA7" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:USB_DIR" "USB0_DIR" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:USB_NXT" "USB0_NXT" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:USB_STP" "USB0_STP" }

# -------------------------------------------------------
# Add Bus Connections
# -------------------------------------------------------
sd_connect_pins -sd_name ${sd_name} -pin_names {"BVF_RISCV_SUBSYSTEM:CA" "CA" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DM" "BVF_RISCV_SUBSYSTEM:DM" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DQ" "BVF_RISCV_SUBSYSTEM:DQ" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DQS" "BVF_RISCV_SUBSYSTEM:DQS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DQS_N" "BVF_RISCV_SUBSYSTEM:DQS_N" }

# -------------------------------------------------------
# High Speed VIO_ENABLE (for High Speed Connector)
# -------------------------------------------------------
sd_connect_pin_to_port -sd_name ${sd_name} -pin_name {BVF_RISCV_SUBSYSTEM:VIO_ENABLE} -port_name {}

# -------------------------------------------------------
# Unused Ports
# -------------------------------------------------------
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:FIC_2_AXI4_TARGET}

sd_mark_pins_unused -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:HSI_APB_MTARGET}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:CSI_APB_MTARGET}

sd_mark_pins_unused -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:MAC_1_MDO_M2F}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:MAC_1_MDO_OE_M2F}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:MAC_1_MDC_M2F}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:MAC_1_MDI_F2M} -value {GND}

sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {M2_W_DISABLE1} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {M2_W_DISABLE2} -value {GND}

sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:MMUART_3_RXD} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:MMUART_2_RXD} -value {GND}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:MMUART_3_TXD}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:MMUART_2_TXD}

sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:SPI_0_DI} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:SPI_1_DI} -value {GND}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:SPI_1_DO}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:SPI_0_CLK}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:SPI_0_DO}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:SPI_0_SS1}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:SPI_1_SS1}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:SPI_1_CLK}

sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:MSS_INT_F2M_56_58} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:MSS_INT_F2M_3_7} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:MSS_INT_F2M_A} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:MSS_INT_F2M_B} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:MSS_INT_F2M_C} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:MSS_INT_F2M_D} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:MSS_INT_F2M_E} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BVF_RISCV_SUBSYSTEM:MSS_INT_F2M_F} -value {GND}

# -------------------------------------------------------
# Source Custom Modules
# -------------------------------------------------------
set modules_dir [pwd]/fpga/components
foreach module $::defined_modules {
    puts "Loading module ${module}"
    set success [loadModule $module $modules_dir]
    unset success ; # We don't care but TCL makes us return a shitty value so we might as well unset it immediately
}


# -------------------------------------------------------
# Finish and Clean Up
# -------------------------------------------------------

source $components_dir/cleanup_unused.tcl ; # Cleanup any unused gateware pins

auto_promote_pad_pins -promote_all 1
save_smartdesign -sd_name ${sd_name}
generate_component -component_name ${sd_name}
