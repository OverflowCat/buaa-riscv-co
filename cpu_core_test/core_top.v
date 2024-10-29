`include "../ctrl_test/control.v"
`include "../pc_rom_test/pc_rom.v"
`include "../alu_test/alu.v"
`include "../regfile_test/regfile.v"
`include "../data_ram_test/data_ram.v"

module core_top (
    input wire clk,
    input wire rst_n
);
  // 声明内部信号
  wire [31:0] pc;  // 程序计数器
  wire [31:0] instr;  // 指令
  wire [31:0] mem_addr;  // 内存地址
  wire [31:0] mem_wdata;  // 内存写入数据
  wire [31:0] mem_rdata;  // 内存读取数据
  wire [31:0] reg_rdata1;  // 从寄存器读取的数据1
  wire [31:0] reg_rdata2;  // 从寄存器读取的数据2
  wire [31:0] alu_out;  // ALU 结果
  wire [31:0] alu_a;  // ALU 输入 A
  wire [31:0] alu_b;  // ALU 输入 B
  wire        zero;  // 零标志

  // 控制信号
  wire        branch;
  wire        memread;
  wire        memtoreg;
  wire [ 3:0] aluctrl;
  wire        alusrc;
  wire        memwrite;
  wire        regwrite;

  data_path u_data_path (
      .clk  (clk),
      .rst_n(rst_n),
      .pc   (pc),
      .instr(instr)
  );

  // PC_ROM 的例化
  pc_rom u_pc_rom (
      .A (pc),
      .RD(instr)
  );

  control u_controller (
      .instr   (instr),     // 从 pc_rom 获取的指令
      .branch  (branch),    // 分支控制信号
      .memread (memread),   // 内存读使能
      .memtoreg(memtoreg),  // 写回寄存器的数据选择
      .aluctrl (aluctrl),   // ALU 控制信号
      .alusrc  (alusrc),    // ALU 源操作数选择
      .memwrite(memwrite),  // 内存写使能
      .regwrite(regwrite)   // 寄存器写使能
  );

  regfile u_regfile (
      .clk(clk),
      .WE (regwrite),
      .A1 (instr[19:15]),
      .A2 (instr[24:20]),
      .A3 (instr[11:7]),
      .WD3(alu_out),
      .RD1(reg_rdata1),
      .RD2(reg_rdata2)
  );

  data_ram u_data_ram (
      .clk(clk),
      .WE (memwrite),
      .RE (memread),
      .A  (mem_addr),
      .WD (mem_wdata),
      .RD (mem_rdata)
  );

  alu u_alu (
      .A      (alu_a),
      .B      (alu_b),
      .ALUCtrl(aluctrl),
      .ZERO   (zero),
      .Y      (alu_out)
  );

endmodule

// 你需要例化的子模块代码可以跟在这后面,或者将子模块文件放在同文件夹下

module data_path (
    input  wire        clk,
    input  wire        rst_n,
    output reg  [31:0] pc,
    output wire [31:0] instr
);

  // 初始PC值
  initial pc = 0;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) pc <= 32'h0;  // 复位时PC清零
    else pc <= pc + 4;  // 每个周期增加4，指向下一条指令
  end

endmodule
