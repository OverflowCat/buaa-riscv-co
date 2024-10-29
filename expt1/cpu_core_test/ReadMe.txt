testbench，利用该文件进行测试
	top_tb.v

执行的汇编程序
	assembler.dump

指令存储器初始化文件(二选一即可)：
	code_h.dat (十六进制)
	code_b.dat (二进制)

数据存储器初始化文件:
	data.txt

需要自行修改的待测试模块：
	core_top.v

注意：初始化文件与modelsim工程(.mpf)文件同目录，确保能正确初始化
你可以直接利用在此文件夹建立modelsim工程，仅需对core_top.v文件完成相应的修改

以上文件均可用 记事本/vscode 等编辑器打开