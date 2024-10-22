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

  // 由 32 个 32 位宽的寄存器组成
  reg [31:0] regfile[31:0];

  // 包含两个读端口(A1/RD1 和 A2/RD2)和一个写端口(A3/WD3)
  // 其中 A1、A2 为 5bit 的寄存器地址，RD1、RD2 为 32bit 的寄存器数据

  assign RD1 = regfile[A1];
  assign RD2 = regfile[A2];

  // 在写使能信号 WE 为 1 时，WD3(32bit) 的数据将在时钟上升沿写入 A3(5bit)对应的寄存器
  always @(posedge clk) begin
    if (WE) begin
      regfile[A3] <= WD3;
    end
  end

endmodule
