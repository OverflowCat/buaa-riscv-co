module pc_rom(
    input  wire [31:0] A,
    output wire [31:0] RD
);

// 请在这里补充你的指令存储器代码
// reg [31:0] mem [0:255];
reg [31:0] mem [0:1041];

initial begin
    // $readmemb("code.dat", mem);
    // $readmemb("../pc_rom_test/code.dat", mem);
    $readmemb("../cpu_core_test/code_b.dat", mem); // 本地测试
    // $readmemb("code_b.dat", mem); // 希冀平台
end

assign RD = mem[A >> 2];

endmodule
