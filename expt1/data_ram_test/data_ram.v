module data_ram (
    input         clk,
    input         WE,
    input         RE,
    input  [31:0] A,    // 地址
    input  [31:0] WD,   // 写入数据
    output [31:0] RD    // 读取数据
);

  // 4096 * 8 位（即 4096 字节）容量的存储单元
  reg [7:0] mem[0:4095];
  // 32 位初始化数据列表，直接按 32 位数据写入
  reg [31:0] init_data[0:10];

  integer i;
  initial begin
    init_data[0]  = 32'h00000001;
    init_data[1]  = 32'h00000001;
    init_data[2]  = 32'h00000004;
    init_data[3]  = 32'h00000016;
    init_data[4]  = 32'h00000008;
    init_data[5]  = 32'h0000000F;
    init_data[6]  = 32'h00000011;
    init_data[7]  = 32'h0000002E;
    init_data[8]  = 32'h00000000;
    init_data[9]  = 32'h00000001;
    init_data[10] = 32'h0000000F;

    // 将 32 位数据分解为字节存储到 mem 数组中
    for (i = 0; i < 11; i = i + 1) begin
      mem[i*4]   = init_data[i][7:0];
      mem[i*4+1] = init_data[i][15:8];
      mem[i*4+2] = init_data[i][23:16];
      mem[i*4+3] = init_data[i][31:24];
    end

    // 其余初始化为 0
    for (i = 10 * 4 + 1; i < 4096; i = i + 1) begin
      mem[i] = 8'h00;
    end
  end

  // 定义输出寄存器
  reg [31:0] out;

  // 写操作：当 WE 为 1 且 clk 上升沿时，将 WD 的 32 位数据分配到地址 A 对应的 4 个字节
  always @(posedge clk) begin
    if (WE) begin
      mem[A]   = WD[7:0];
      mem[A+1] = WD[15:8];
      mem[A+2] = WD[23:16];
      mem[A+3] = WD[31:24];
    end
  end

  // 读操作：当 RE 为 1 时，从地址 A 开始读取 4 个字节并组合成 32 位数据
  always @(*) begin
    if (RE) begin
      out = {mem[A+3], mem[A+2], mem[A+1], mem[A]};
      // $display("Reading from mem[%d]: %h", A, out);
    end
  end

  // 将读出的数据分配给输出端口 RD
  assign RD = out;

endmodule
