module pc_rom(
    input  wire [31:0] A,
    output wire [31:0] RD,
    wire [31:0] cpu_instr_rom [2047:0]
);

// 请在这里补充你的指令存储器代码
// reg [31:0] cpu_instr_rom [0:1041];
// reg[32-1:0] cpu_instr_rom[2047:0];

// initial begin
    // $readmemb("code.dat", cpu_instr_rom); // testbench 单测
    // $readmemb("../pc_rom_test/code.dat", cpu_instr_rom);
    // $readmemb("../cpu_core_test/code_b.dat", cpu_instr_rom); // 本地测试
    // $readmemb("code_b.dat", cpu_instr_rom); // 希冀平台
// end

assign RD = cpu_instr_rom[A >> 2];

endmodule
