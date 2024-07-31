# -------------------------------------------------------
# Check Libero Version
# -------------------------------------------------------

set project_name "SMC_BVFGW_025T"

set libero_release [split [get_libero_version] .]

if {[string compare [lindex $libero_release 0] "2024"] == 0 && [string compare [lindex $libero_release 1] "1"] == 0} { ;# Ensure correct version (v2024.1)
    puts "Correct Libero version detected (Libero v2024.1)"
} else {
    error "Invalid Libero version detected. Please use Libero v2024.1"
}

# -------------------------------------------------------
# Process Script Arguments
# -------------------------------------------------------
puts $::argc
puts $::argv
puts "========= PARSING ARGUMENTS ========="
if { $::argc > 0 } {
    foreach arg $::argv {
        if {[string match "*=*" $arg]} {
            set temp [split $arg =]
            puts "ARG_CREATE: Setting argument [lindex $temp 0] to [lindex $temp 1]"
            set [lindex $temp 0] "[lindex $temp 1]"
        } else {
            puts "ARG_CREATE: Skipping $arg as it does not match the pattern 'name=value'"
        }
    }
} else {
    error "No parameters passed to the script"
}

if {[ info exists TOP_LEVEL_NAME]} {
    set ::top_level_name $TOP_LEVEL_NAME
} else {
    puts stderr "========= NO TOP LEVEL DEFINED ========="
    puts stderr "Please define a top level name (TOP_LEVEL_NAME=\"HelloWorld\")"
    puts stderr "========================================"
    exit 3
}

if {[ info exists DESIGN_VERSION ]} {
    set design_version $DESIGN_VERSION
} else {
    puts stderr "========= NO DESIGN VERSION DEFINED ========="
    puts stderr "Please define a design version"
    puts stderr "============================================="
    exit 4
}

if {[ info exists SILICON_SIGNATURE ]} {
    set silicon_signature $SILICON_SIGNATURE
} else {
    puts stderr "========= NO SILICON SIGNATURE DEFINED ========="
    puts stderr "Please define a silicon signature"
    puts stderr "================================================"
    exit 5
}

if {[ info exists OUTPUT_DIR ]} {
    set project_dir $OUTPUT_DIR
} else {
    puts stderr "========= NO OUTPUR DIR DEFINED ========="
    puts stderr "Please define an output dir"
    puts stderr "========================================="
    exit 6
}

if {[ info exists MSS_OUTPUT_DIR]} {
    set mss_output_dir $MSS_OUTPUT_DIR
} else {
    puts stderr "========= NO MSS OUTPUT DIR DEFINED ========="
    puts stderr "Please define an MSS output dir"
    puts stderr "========================================="
    exit 7
}

if {[ info exists PROGFILE_DIR]} {
    set progfile_dir $PROGFILE_DIR
} else {
    puts stderr "========= NO PROGFILE DIR DEFINED ========="
    puts stderr "Please define a programming file dir"
    puts stderr "========================================="
    exit 8
}

if {[ info exists MSS_CONFIG_PATH ]} {
    set mss_config_file $MSS_CONFIG_PATH
} else {
    puts stderr "========= NO MSS CONFIG PATH DEFINED ========="
    puts stderr "Please define an MSS config path"
    puts stderr "============================================="
}


puts "========= FINISHED PARSING ========="

# -------------------------------------------------------
# Import the required misc scripts
# -------------------------------------------------------
source ./misc/functions.tcl
source ./fpga/component_loader.tcl ; # Contains component loading helper functions (including argument parsing)

# -------------------------------------------------------
# Load Modules
# -------------------------------------------------------

if { [info exists MODULES]} {
    set ::defined_modules [getModuleList $MODULES] ; # Get the list of modules from the MODULES variable
} else {
    puts stderr "========= NO MODULES DEFINED ========="
    puts stderr "There must be at least one module defined in the build strategy"
    puts stderr "======================================"
    exit 2
}

# -------------------------------------------------------
# Create Project
# -------------------------------------------------------

new_project \
    -location $project_dir \
    -name $project_name \
    -project_description {} \
    -block_mode 0 \
    -standalone_peripheral_initialization 0 \
    -instantiate_in_smartdesign 1 \
    -ondemand_build_dh 1 \
    -use_relative_path 0 \
    -linked_files_root_dir_env {} \
    -hdl {VERILOG} \
    -family {PolarFireSoC} \
    -die {MPFS025T} \
    -package {FCVG484} \
    -speed {STD} \
    -die_voltage {1.0} \
    -part_range {EXT} \
    -adv_options {IO_DEFT_STD:LVCMOS 1.8V} \
    -adv_options {RESTRICTPROBEPINS:0} \
    -adv_options {RESTRICTSPIPINS:0} \
    -adv_options {SYSTEM_CONTROLLER_SUSPEND_MODE:0} \
    -adv_options {TARGETDEVICESFORMIGRATION:MPFS095T;MPFS160T;MPFS095TL;MPFS160TL;} \
    -adv_options {TEMPR:EXT} \
    -adv_options {VCCI_1.2_VOLTR:EXT} \
    -adv_options {VCCI_1.5_VOLTR:EXT} \
    -adv_options {VCCI_1.8_VOLTR:EXT} \
    -adv_options {VCCI_2.5_VOLTR:EXT} \
    -adv_options {VCCI_3.3_VOLTR:EXT} \
    -adv_options {VOLTR:EXT}

# -------------------------------------------------------
# Download IP Cores
# -------------------------------------------------------
download_core -vlnv {Actel:SgCore:PF_OSC:*} -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv {Actel:SgCore:PF_CCC:*} -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv {Actel:DirectCore:CORERESET_PF:*} -location {www.microchip-ip.com/repositories/DirectCore}
download_core -vlnv {Microsemi:SgCore:PFSOC_INIT_MONITOR:*} -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv {Actel:DirectCore:COREAXI4INTERCONNECT:2.8.103} -location {www.microchip-ip.com/repositories/DirectCore}
download_core -vlnv {Actel:SgCore:PF_CLK_DIV:*} -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv {Actel:SgCore:PF_DRI:*} -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv {Actel:SgCore:PF_NGMUX:*} -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv {Actel:SgCore:PF_PCIE:*} -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv {Actel:SgCore:PF_TX_PLL:*} -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv {Actel:SgCore:PF_XCVR_REF_CLK:*} -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv {Actel:DirectCore:CoreAPB3:4.2.100} -location {www.microchip-ip.com/repositories/DirectCore}
download_core -vlnv {Actel:DirectCore:CoreGPIO:3.2.102} -location {www.microchip-ip.com/repositories/DirectCore}
download_core -vlnv {Actel:SystemBuilder:PF_SRAM_AHBL_AXI:1.2.108} -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv {Actel:Simulation:CLK_GEN:1.0.1} -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv {Actel:Simulation:RESET_GEN:1.0.1} -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv {Actel:DirectCore:corepwm:4.5.100} -location {www.microchip-ip.com/repositories/DirectCore}
download_core -vlnv {Actel:DirectCore:COREI2C:7.2.101} -location {www.microchip-ip.com/repositories/DirectCore}
download_core -vlnv {Actel:DirectCore:CoreUARTapb:5.7.100} -location {www.microchip-ip.com/repositories/DirectCore}
download_core -vlnv {Actel:SystemBuilder:PF_IOD_GENERIC_RX:*} -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv {Actel:SgCore:PF_IO:*} -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv {Actel:SystemBuilder:PF_XCVR_ERM:*} -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv {Microchip:SolutionCore:mipicsi2rxdecoderPF:4.7.0} -location {www.microchip-ip.com/repositories/DirectCore}

# TODO: Add core downloading from custom modules

# -------------------------------------------------------
# Generate Base Design
# -------------------------------------------------------

set local_dir [pwd]
source ./fpga/bvf_builder.tcl

# -------------------------------------------------------
# Import Constraints
# -------------------------------------------------------

set constraint_path "${local_dir}/fpga/constraints"
set module_dir "${local_dir}/fpga/components"

puts "contraint_path: ${constraint_path}"

import_files \
    -io_pdc ${constraint_path}/base.pdc \
    -fp_pdc ${constraint_path}/nw_pll.pdc \
    -sdc ${constraint_path}/fic_clocks.sdc \
    -convert_EDN_to_HDL 0

set component_constraint_paths [list]

foreach module $::defined_modules {
    set path [loadModuleConstraints $module $module_dir]
    lappend component_constraint_paths $path
}

# Note: Everything below this point uses directories relative to libero project directory (not this projects directory)

# -------------------------------------------------------
# Organise Tool Files
# -------------------------------------------------------

organize_tool_files \
    -tool {SYNTHESIZE} \
    -file "${project_dir}/constraint/fic_clocks.sdc" \
    -module ${::top_level_name}::work \
    -input_type {constraint}


set placeroute_organize "organize_tool_files -tool {PLACEROUTE} -file \"${project_dir}/constraint/io/base.pdc\" -file \"${project_dir}/constraint/fp/nw_pll.pdc\" -file \"${project_dir}/constraint/fic_clocks.sdc\""
foreach module $::defined_modules {
    set module_constraints [lindex $module 3]
    foreach constraint_elem $module_constraints {
        append placeroute_organize " -file \"${project_dir}/constraint/io/${constraint_elem}\""
    }
}
append placeroute_organize " -module ${::top_level_name}::work -input_type {constraint}"
puts "placeroute_organize: ${placeroute_organize}"
eval $placeroute_organize ; # Evaluate the constructed command

organize_tool_files \
    -tool {VERIFYTIMING} \
    -file "${project_dir}/constraint/fic_clocks.sdc" \
    -module ${::top_level_name}::work \
    -input_type {constraint}

configure_tool \
    -name {CONFIGURE_PROG_OPTIONS} \
    -params {back_level_version:0} \
    -params design_version:$design_version \
    -params silicon_signature:$silicon_signature

# -------------------------------------------------------
# Derive Timing
# -------------------------------------------------------

build_design_hierarchy
derive_constraints_sdc

# -------------------------------------------------------
# Run design flow and add eNVM if required
# -------------------------------------------------------

set linux_export_path "${progfile_dir}/linux"
set fpe_export_path "${progfile_dir}/flashpro"
set directc_export_path "${progfile_dir}/directc"

exec mkdir -p $linux_export_path
exec mkdir -p $fpe_export_path
exec mkdir -p $directc_export_path

if !{[info exists PREVIEW_DESIGN]} { ; # If not for preview generation (i.e. actually building prog files)
    run_tool -name {SYNTHESIZE}
    run_tool -name {PLACEROUTE}
    run_tool -name {VERIFYTIMING}

    if {[info exists HSS_IMAGE_PATH]} {
        create_eNVM_config "${mss_output_dir}/ENVM.cfg" "${HSS_IMAGE_PATH}"
        run_tool -name {GENERATEPROGRAMMINGDATA}
        configure_envm -cfg_file $mss_output_dir/ENVM.cfg ; # Does this need to be a local path?
        source ./misc/export/export_spi_prog_file.tcl
        configure_spiflash -cfg_file {./fpga/spi_flash.cfg} ; # Configure the SPI Flash
        run_tool -name {GENERATEPROGRAMMINGFILE}
        source ./misc/export/export_flashproexpress.tcl ; # Generate FlashPro Express programming file
        source ./misc/export/export_directc.tcl ; # Generate DirectC programming file
    } else {
        run_tool -name {GENERATEPROGRAMMINGDATA}
        puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        puts "!!!              No Hart Software Services (HSS) image provided.             !!!"
        puts "!!! Make sure this is what you were planning. If so, you know what you are   !!!"
        puts "!!! doing: Open the Libero project to generate the design's programming      !!!"
        puts "!!! bitstream flavor you need.                                               !!!"
        puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        exit 0 ; # Exit Program
    }
}
