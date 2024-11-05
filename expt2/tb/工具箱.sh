#!/bin/bash

# 设置 UTF-8 编码
export LANG=en_US.UTF-8
echo "全局使用UTF-8编码"

# 显示菜单
function show_menu {
  echo "==============================="
  echo "输入编号并回车，执行对应项目"
  echo "编号: 功能--------------工具"
  echo "0: bin文件转为inst.txt"
  echo "1: 载入bin文件并仿真----iverilog"
  echo "2: 载入inst.txt并仿真---iverilog"
  echo "3: 执行RISC-V ISA测试集-iverilog"
  echo "4: 显示上一次的仿真波形-gtkwave"
  echo "5: 载入bin文件并仿真----modelsim"
  echo "6: 载入inst.txt并仿真---modelsim"
  echo "7: 执行RISC-V ISA测试集-modelsim"
  echo "c: 清理缓存文件"
  echo "==============================="
}

# 显示菜单并等待用户输入
while true; do
  show_menu
  read -p "输入命令编号: " cmchc

  case "$cmchc" in
    0)
      python3 tools/isa_test.py tsr_bin
      ;;
    1)
      python3 tools/isa_test.py sim_bin
      ;;
    2)
      python3 tools/isa_test.py sim_rtl
      ;;
    3)
      python3 tools/isa_test.py all_isa
      ;;
    4)
      gtkwave tb.vcd
      ;;
    5)
      python3 tools/isa_test.py vsim_bin
      ;;
    6)
      python3 tools/isa_test.py vsim_rtl
      ;;
    7)
      python3 tools/isa_test.py vsim_isa
      ;;
    c)
      rm -f tb *.lxt *.vcd inst.txt transcript vlog.opt vsim.wlf *.vstf modelsim.ini
      rm -rf work
      echo "缓存文件已清理"
      ;;
    *)
      echo "Err 0: 命令未找到"
      ;;
  esac
done
