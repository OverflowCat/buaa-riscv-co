# 退出之前仿真
quit -sim

# 建立新的工程库
vlib work

# 映射逻辑库到物理目录
vmap work work

vlog +incdir+./../rtl_us/  +define+MODELSIM +define+ISA_TEST ./tb_cpu_core.sv
vlog +incdir+./../rtl_us/  +define+HDL_SIM                   ./../rtl_us/*.v

exit
