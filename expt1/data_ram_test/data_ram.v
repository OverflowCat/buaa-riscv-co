module data_ram(
    input clk,
    input WE,
    input RE,
    input [31:0] A,       // 地址
    input [31:0] WD,      // 写入数据
    output [31:0] RD      // 读取数据
);

// 4096 * 8 位（即 4096 字节）容量的存储单元
reg [7:0] mem [0:4095];

integer i;
initial begin
    // 初始化内存单元，前 11 个单元数据初始化
    mem[0] = 8'h01;
    mem[1] = 8'h00;
    mem[2] = 8'h00;
    mem[3] = 8'h00;

    mem[4] = 8'h01;
    mem[5] = 8'h00;
    mem[6] = 8'h00;
    mem[7] = 8'h00;

    mem[8] = 8'h04;
    mem[9] = 8'h00;
    mem[10] = 8'h00;
    mem[11] = 8'h00;

    mem[12] = 8'h16;
    mem[13] = 8'h00;
    mem[14] = 8'h00;
    mem[15] = 8'h00;

    // 按需初始化其余内存单元
    for (i = 16; i < 4096; i = i + 1) begin
        mem[i] = 8'h00;
    end
end

// 定义输出寄存器
reg [31:0] out;

// 写操作：当 WE 为 1 且 clk 上升沿时，将 WD 的 32 位数据分配到地址 A 对应的 4 个字节
always @(posedge clk) begin
    if (WE) begin
        mem[A]     <= WD[7:0];
        mem[A + 1] <= WD[15:8];
        mem[A + 2] <= WD[23:16];
        mem[A + 3] <= WD[31:24];
    end
end

// 读操作：当 RE 为 1 时，从地址 A 开始读取 4 个字节并组合成 32 位数据
always @(*) begin
    if (RE) begin
        out = {mem[A + 3], mem[A + 2], mem[A + 1], mem[A]};
        $display("Reading from mem[%d]: %h", A, out);
    end
end

// 将读出的数据分配给输出端口 RD
assign RD = out;

endmodule
