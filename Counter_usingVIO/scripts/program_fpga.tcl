set top_module "top_module"
set project_name "project_1"
open_hw
connect_hw_server
open_hw_target
refresh_hw_device -update_hw_probes true [lindex [get_hw_devices] 0]
set_property PROGRAM.FILE ./vivado_proj/${project_name}.runs/impl_1/${top_module}.bit [lindex [get_hw_devices] 0]
program_hw_devices [lindex [get_hw_devices] 0]

