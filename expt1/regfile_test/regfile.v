module regfile (
    input  wire          clk,  // 时钟信号，上升沿采样
    input  wire          WE,   // 写使能
    input  wire [ 5-1:0] A1,   // 读寄存器地址 1
    input  wire [ 5-1:0] A2,   // 读寄存器地址 2
    input  wire [ 5-1:0] A3,   // 写寄存器地址
    input  wire [32-1:0] WD3,  // 写入寄存器的数据
    output wire [32-1:0] RD1,  // 寄存器地址 1（A1）对应的数据
    output wire [32-1:0] RD2   // 寄存器地址 2（A2）对应数据值
);

  //请在这里补充你设计的寄存器堆代码
  integer i;
  // 由 32 个 32 位宽的寄存器组成
  reg [31:0] regfile[31:0];
  initial begin
    for (i = 0; i < 32; i = i + 1) begin
      regfile[i] = 32'h0;  // 将所有寄存器初始化为0
    end
  end
  // 包含两个读端口(A1/RD1 和 A2/RD2)和一个写端口(A3/WD3)
  // 其中 A1、A2 为 5bit 的寄存器地址，RD1、RD2 为 32bit 的寄存器数据

  // 在 RSIC-V 处理器寄存器堆的 32 个寄存器中，0 号寄存器中存储的数据应该恒为 0
  assign RD1 = (A1 == 5'h0) ? 32'h0 : regfile[A1];
  assign RD2 = (A2 == 5'h0) ? 32'h0 : regfile[A2];

  // 在写使能信号 WE 为 1 时，WD3(32bit) 的数据将在时钟上升沿写入 A3(5bit)对应的寄存器
  always @(posedge clk) begin
    if (WE) begin
      $display("Writing to x%d: %h", A3, WD3);
      regfile[A3] <= WD3;
    end
    // $display("x11 = %h | x13 = %h", regfile[11], regfile[13]);
  end
endmodule
