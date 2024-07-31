
# Clean up the local directory
set mss_component_dir $local_dir/fpga/mss/component
if {[file isdirectory $mss_component_dir]} {
    file delete -force $mss_component_dir
}

# -----------------------------------------------------------
# Generate and Import the MSS component
# -----------------------------------------------------------

# Import MSS component
import_mss_component -file $mss_output_dir/PF_SOC_MSS.cxz

# -----------------------------------------------------------
# Execute remaining component scripts
# -----------------------------------------------------------
set fpga_dir $local_dir/fpga
set core_dir $fpga_dir/core
set components_dir $fpga_dir/components
set clocks_dir ${components_dir}/clocks

source ${core_dir}/hdl.tcl
source ${clocks_dir}/corereset_0.tcl
source ${clocks_dir}/init_monitor.tcl
source ${clocks_dir}/fpga_ccc_c0.tcl
source ${components_dir}/fic/fic0_initiator.tcl
source ${clocks_dir}/clk_div.tcl
source ${clocks_dir}/glitchless_mux.tcl
source ${clocks_dir}/transmit_pll.tcl
source ${clocks_dir}/pcie_ref_clk.tcl
source ${components_dir}/fic/fic3_initiator.tcl
source ${clocks_dir}/oscillator_160mhz.tcl
source ${clocks_dir}/adc_mclk_ccc.tcl
source ${clocks_dir}/clocks.tcl
source ${components_dir}/ihc/ihc_apb.tcl
source ${components_dir}/ihc/ihc_subsystem.tcl
source $fpga_dir/bvf_riscv_subsystem.tcl
source $fpga_dir/gateware.tcl

set_root -module ${::top_level_name}::work
