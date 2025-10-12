# ===========================
# Vivado Project Automation Script
# ===========================

# ---- Configuration ----
set proj_name "Counter_usingVIO"
set part_name "xc7s50csga324-1"    ;# Change this to your FPGA part
set top_module "Counter_usingVIO"         ;# Change this for each project
set constr_file "./constraints/boolean.xdc" ;# Or change to any other constraint file
set jobs 10
# ---- Create project ----
create_project $proj_name ./vivado_proj -part $part_name -force

# ---- Add all Verilog source files from src ----
set verilog_files [glob ./src/*.v]
add_files $verilog_files

# ---- Add constraint file ----
#add_files -fileset constrs_1 $constr_file

# ---- Set top module ----
#set_property top $top_module [current_fileset]

# ---- Run synthesis ----
#launch_runs synth_1 -jobs $jobs
#wait_on_run synth_1

# ---- Run implementation (until bitstream) ----
#launch_runs impl_1 -to_step write_bitstream -jobs $jobs
#wait_on_run impl_1

# ---- Generate reports ----
#report_timing_summary -file ./reports/timing_summary.rpt
#report_utilization -file ./reports/utilization.rpt

# ---- Exit ----
exit

