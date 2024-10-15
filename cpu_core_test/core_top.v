module core_top(             
    input  wire  clk,
    input  wire  rst_n
);

data_path u_data_path (
	//......
);

//其中 PC_ROM 的例化请按照下列命名格式

pc_rom  u_pc_rom(
    .A(pc),
    .RD(instr)
);

control  u_controller(
	//......
);

endmodule

//你需要例化的子模块代码可以跟在这后面,或者将子模块文件放在同文件夹下

module alu();
endmodule

module pc_rom();
endmodule

//......