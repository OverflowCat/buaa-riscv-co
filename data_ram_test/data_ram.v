module data_ram(
    input clk,
    input WE,
    input RE,
    input[31:0] A,
    input[31:0] WD,
    output[31:0] RD
);

//请在这里补充你的数据存储器代码

// 设计一个数据存储器(容量为 32 * 1024bit)。当 RE=1 时，将存储器中地址 A
// 对应的数据读出至 RD；当 WE=1 且 clk 时钟处于上升沿时，将 WD 端口的数据
// 写入到地址 A 所对应的存储单元中

// 1024 个 32 位宽的存储单元
reg [31:0] mem [0:1023];

initial begin
    mem[0] = 32'h00000001;
    mem[1] = 32'h00000001;
    mem[2] = 32'h00000004;
    mem[3] = 32'h00000016;
    mem[4] = 32'h00000008;
    mem[5] = 32'h0000000F;
    mem[6] = 32'h00000011;
    mem[7] = 32'h0000002E;
    mem[8] = 32'h00000000;
    mem[9] = 32'h00000001;
    mem[10] = 32'h0000000F;
end

reg out;

always @(posedge clk) begin
    if (WE) begin
        mem[A] <= WD;
    end
end

always @(*) begin
    if (RE == 1) begin
        out = mem[A];
    end
end

assign RD = out;

endmodule
