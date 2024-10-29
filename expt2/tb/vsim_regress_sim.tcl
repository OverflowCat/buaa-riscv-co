 # 退出之前仿真
quit -sim

vsim -voptargs=+acc work.tb_cpu_core
run -all
exit
