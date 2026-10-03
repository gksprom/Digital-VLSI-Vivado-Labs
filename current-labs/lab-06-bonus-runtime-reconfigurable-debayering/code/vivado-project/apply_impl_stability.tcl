set script_dir [file dirname [info script]]
set hook_file [file join $script_dir vivado_threads_1.tcl]
set top_file [file join $script_dir bonus_lab_2.srcs sources_1 new design_1_ps_top.vhd]
set impl_run [get_runs impl_1]

set_param general.maxThreads 1
catch { config_webtalk -user off }
catch { config_webtalk -install off }

# The Docker image preloads libudev for Vivado, but this project crashes in
# udev_enumerate_scan_devices during Vivado's post-route WebTalk/host scan.
# Preload a tiny shim first so that one scan returns an empty list instead.
set udev_shim [file join $script_dir no_udev_scan.so]
set ::env(LD_PRELOAD) "$udev_shim /lib/x86_64-linux-gnu/libudev.so.1 /lib/x86_64-linux-gnu/libselinux.so.1 /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/libgdk-x11-2.0.so.0"

if {[llength [get_files -quiet $top_file]] == 0} {
    add_files -norecurse $top_file
}
set_property top design_1_ps_top [current_fileset]
update_compile_order -fileset sources_1

foreach step {INIT_DESIGN OPT_DESIGN PLACE_DESIGN PHYS_OPT_DESIGN ROUTE_DESIGN WRITE_BITSTREAM} {
    set_property "STEPS.${step}.TCL.PRE" $hook_file $impl_run
}

puts "INFO: Applied implementation stability hook: $hook_file"
puts "INFO: Top module is now: [get_property top [current_fileset]]"
puts "INFO: ROUTE_DESIGN hook is now: [get_property STEPS.ROUTE_DESIGN.TCL.PRE $impl_run]"
puts "INFO: general.maxThreads is now: [get_param general.maxThreads]"
puts "INFO: child LD_PRELOAD is now: $::env(LD_PRELOAD)"
