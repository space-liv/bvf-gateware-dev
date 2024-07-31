# -------------------------------------------------------
# Source Custom Module
# -------------------------------------------------------

proc getModuleList { modules_string } {
    puts "========= PARSING MODULE LIST ========="
    puts "Module Input String: $modules_string"
    set module_list [split $modules_string ","]

    set module_output_list [list]

    foreach module $module_list {
        puts "Parsing Individual Module String: $module"
        set module_info [list]

        set module_meta [split $module ":"]

        lappend module_info [lindex $module_meta 0] ; # Module Name
        lappend module_info [lindex $module_meta 1] ; # Module Variant
        lappend module_info [lindex $module_meta 2] ; # Module Version

        set constraints [list]

        foreach constraint [split [lindex $module_meta 3] "%"] {
            lappend constraints $constraint
        }

        lappend module_info $constraints ; # Module Constraints (e.g. user.pdc, cape.pdc, etc)
        lappend module_output_list $module_info
    }

    puts "========= FINISHED PARSING MODULES ========="

    return $module_output_list ; # Return the list of modules
}

# -------------------------------------------------------
# Load Specific Module
# -------------------------------------------------------
proc loadModule { module module_dir } { ; # This expects a list of module information (as produced by the getModuleList proc)
    set module_name [lindex $module 0]
    set module_variant [lindex $module 1]
    set module_version [lindex $module 2]
    set module_constraints [lindex $module 3]

    puts "========= LOADING MODULE ========="
    puts "Module Dir: $module_dir"
    puts "Loading Module: $module_name:$module_variant"

    # Load the module
    source ${module_dir}/${module_name}/${module_variant}/build.tcl
    puts "========= FINISHED LOADING MODULE ========="
    return 0
}

proc loadModuleConstraints { module module_dir } { ; # This expects a list of module information (as produced by the getModuleList proc)
    set module_name [lindex $module 0]
    set module_variant [lindex $module 1]
    set module_version [lindex $module 2]
    set module_constraints [lindex $module 3]

    puts "========= LOADING MODULE CONSTRAINTS ========="
    puts "Loading constraints for module: $module_name:$module_variant"
    puts "Constraints: $module_constraints"

    set paths [list]

    foreach constraint $module_constraints {
        puts "Loading constraint: $constraint"
        set path "${module_dir}/${module_name}/${module_variant}/constraints/${constraint}"
        import_files -convert_EDN_to_HDL 0 \
            -io_pdc ${path}

        lappend paths $path
    }

    puts "========= FINISHED LOADING MODULE CONSTRAINTS ========="

    return $paths
}
