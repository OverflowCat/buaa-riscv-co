// Auto-generated file - DO NOT EDIT

// File: control.v
module control (
    input  [31:0] instr,
    output        branch,
    output        memread,
    output        memtoreg,
    output [ 3:0] aluctrl,
    output        alusrc,
    output        memwrite,
    output        regwrite
);

  //请在这里补充你的控制器代码
  localparam [3:0] ALU_AND = 4'b0000;
  localparam [3:0] ALU_OR = 4'b0001;
  localparam [3:0] ALU_XOR = 4'b0011;
  localparam [3:0] ALU_ADD = 4'b0010;
  localparam [3:0] ALU_SUB = 4'b0110;
  localparam [3:0] ALU_SLTU = 4'b1000;
  localparam [3:0] ALU_SLT = 4'b1001;
  localparam [3:0] ALU_SLL = 4'b1100;
  localparam [3:0] ALU_SRL = 4'b1110;
  localparam [3:0] ALU_SRA = 4'b1111;

  reg xbranch = 1'b0;
  reg xmemread = 1'b0;
  reg xmemtoreg = 1'b0;
  reg [3:0] xaluctrl = 4'b0000;
  reg xalusrc = 1'b0;
  reg xmemwrite = 1'b0;
  reg xregwrite = 1'b0;

  wire [6:0] opcode = instr[6:0];
  wire [2:0] funct3 = instr[14:12];
  wire [6:0] funct7 = instr[31:25];

  always @(*) begin
    if (opcode == 7'b0110011) begin
      // R-type instructions
      case (funct3)
        3'h0: xaluctrl = funct7[5]  /* 0x20 = 0010 0000 */ ? ALU_SUB : ALU_ADD;
        3'h6: xaluctrl = ALU_OR;  // or
        3'h7: xaluctrl = ALU_AND;  // and
        3'h1: xaluctrl = ALU_SLL;  // sll
        3'h5: xaluctrl = funct7[5] ? ALU_SRA : ALU_SRL;  // srl or sra
        3'h2: xaluctrl = ALU_SLT;
        3'h3: xaluctrl = ALU_SLTU;
      endcase
      xbranch   = 1'b0;
      xalusrc   = 1'b0;
      xmemtoreg = 1'b0;
      xmemwrite = 1'b0;
      xregwrite = 1'b1;
    end else if (opcode == 7'b0010011) begin
      // I-type immediate instructions
      // 虽然都是I型指令，但数据通路不一样。
      // xxi 是 rd =  rs1 op imm，而 lx 是先计算 rs1 + imm 然后再从内存里取 M[rs1 + imm]
      xalusrc   = 1'b1;  // 使用立即数作为 ALU 的第二个操作数
      xregwrite = 1'b1;  // 写回寄存器
      xmemtoreg = 1'b0;  // 不从内存写回数据
      xmemread  = 1'b1;  // 读内存
      xmemwrite = 1'b0;  // 不写内存
      xbranch   = 1'b0;  // 不是分支指令
      case (funct3)
        3'h0: xaluctrl = ALU_ADD;  // addi
        3'h4: xaluctrl = ALU_XOR;  // xori
        3'h6: xaluctrl = ALU_OR;  // ori
        3'h7: xaluctrl = ALU_AND;  // andi
        3'h1: xaluctrl = ALU_SLL;  // slli
        3'h5: xaluctrl = funct7[5] ? ALU_SRA : ALU_SRL;  // srli or srai
        3'h2: xaluctrl = ALU_SLT;  // slti
        3'h3: xaluctrl = ALU_SLTU;  // sltiu
      endcase
    end else if (opcode == 7'b0000011) begin
      // I-type load instructions
      // Only lw
      xalusrc   = 1'b1;
      xregwrite = 1'b1;
      xmemread  = 1'b1;
      xmemtoreg = 1'b1;
      xmemwrite = 1'b0;
      xaluctrl  = ALU_ADD;
    end else if (opcode == 7'b0100011 && funct3 == 3'b010) begin
      xalusrc   = 1'b1;
      xregwrite = 1'b0;
      xmemwrite = 1'b1;
      // xmemtoreg = 1'b0;
      xmemread  = 1'b0;
      xbranch   = 1'b0;
      xaluctrl  = 4'b0010;
    end else if (opcode == 7'b1100011) begin
      // B-type branch instructions (beq)
      xalusrc   = 0;  // ALU 的第二个操作数选择 reg_rdata2 而不是立即数
                      // 因为 beq 需要比较两个寄存器的值

      xregwrite = 0;  // 不需要写回寄存器
                      // beq 是分支指令，不需要保存结果

      xmemread  = 0;  // 不需要读内存
      xmemwrite = 0;  // 不需要写内存
                      // beq 只进行比较，不涉及内存操作

      xbranch   = 1;  // 这是分支指令
                      // 当 branch=1 且 ALU 结果为零(zero=1)时执行跳转

      xaluctrl  = 4'b0110;  // ALU 执行减法操作
                            // beq 通过比较两个寄存器是否相等来决定是否跳转
                            // 实现方式是做减法，如果结果为 0 则相等
    end else begin
      xalusrc   = 1'b0;
      xregwrite = 1'b0;
      xmemtoreg = 1'b0;
      xmemread  = 1'b0;
      xmemwrite = 1'b0;
      xbranch   = 1'b0;
      xaluctrl  = 4'b0000;
    end
  end
  assign branch   = xbranch;
  assign memread  = xmemread;
  assign memtoreg = xmemtoreg;
  assign aluctrl  = xaluctrl;
  assign alusrc   = xalusrc;
  assign memwrite = xmemwrite;
  assign regwrite = xregwrite;
endmodule


// File: instr_rom.v
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


// File: alu.v
module alu (
    input  wire [ 32-1:0] A,
    input  wire [ 32-1:0] B,
    input  wire [4-1 : 0] ALUCtrl,
    output wire           ZERO,
    output wire [ 32-1:0] Y
);

  //请在这里补充你的ALU实现代码
  localparam [3:0] ALU_AND = 4'b0000;
  localparam [3:0] ALU_OR = 4'b0001;
  localparam [3:0] ALU_XOR = 4'b0011;
  localparam [3:0] ALU_ADD = 4'b0010;
  localparam [3:0] ALU_SUB = 4'b0110;
  localparam [3:0] ALU_SLTU = 4'b1000;
  localparam [3:0] ALU_SLT = 4'b1001;
  localparam [3:0] ALU_SLL = 4'b1100;
  localparam [3:0] ALU_SRL = 4'b1110;
  localparam [3:0] ALU_SRA = 4'b1111;

  reg [31:0] out;
  reg zero;

  initial begin
    out  = 32'b0;
    zero = 1'b0;
  end

  always @(*) begin
    case (ALUCtrl)
      ALU_AND: out = A & B;  // AND
      ALU_OR: out = A | B;  // OR
      ALU_XOR: out = A ^ B;  // XOR
      ALU_ADD: out = A + B;  // ADD
      ALU_SUB: out = A - B;  // SUB
      ALU_SLTU: out = ($unsigned(A) < $unsigned(B)) ? 32'b1 : 32'b0;  // SLTU
      ALU_SLT: out = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;  // SLT
      ALU_SLL: out = A << B;  // SLL
      ALU_SRL: out = A >> B;  // SRL
      ALU_SRA: out = A >>> B;  // SRA
      default: out = 32'b0;
      // beq/bne:   使用 SUB 运算，检查 zero flag
      // blt/bge:   使用 SLT 运算，检查 ALU 输出
      // bltu/bgeu: 使用 SLTU 运算，检查 ALU 输出
    endcase

    // Set ZERO flag
    // BEQ、BNE 指令需要使用这个零标志来判断是否跳转
    if (out == 32'b0) begin
      zero = 1;
    end else begin
      zero = 0;
    end
  end

  assign Y = out;
  assign ZERO = zero;

endmodule


// File: regfile.v
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
  reg [31:0] rf[31:0];
  initial begin
    for (i = 0; i < 32; i = i + 1) begin
      rf[i] = 32'h0;  // 将所有寄存器初始化为0
    end
  end
  // 包含两个读端口(A1/RD1 和 A2/RD2)和一个写端口(A3/WD3)
  // 其中 A1、A2 为 5bit 的寄存器地址，RD1、RD2 为 32bit 的寄存器数据

  // 在 RSIC-V 处理器寄存器堆的 32 个寄存器中，0 号寄存器中存储的数据应该恒为 0
  assign RD1 = (A1 == 5'h0) ? 32'h0 : rf[A1];
  assign RD2 = (A2 == 5'h0) ? 32'h0 : rf[A2];

  // 在写使能信号 WE 为 1 时，WD3(32bit) 的数据将在时钟上升沿写入 A3(5bit)对应的寄存器
  always @(posedge clk) begin
    if (WE) begin
      // $display("Writing to x%d: %h", A3, WD3);
      rf[A3] <= WD3;
    end
    // $display("x11 = %h | x13 = %h", regfile[11], regfile[13]);
  end
endmodule


// File: data_ram.v
module data_ram (
    input         clk,
    input         WE,
    input         RE,
    input  [31:0] A,          // 地址
    input  [ 1:0] LOAD_SIZE,  // 读取数据类型
    // lw: 00, lh: 01, lb: 10
    input         U,          // U extend?
    input  [31:0] WD,         // 写入数据
    output [31:0] RD          // 读取数据
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

  reg extend_bit;

  // 读操作：当 RE 为 1 时，从地址 A 开始读取 4 个字节并组合成 32 位数据
  always @(*) begin
    if (RE) begin
      out = {mem[A+3], mem[A+2], mem[A+1], mem[A]};
      case (LOAD_SIZE)
        2'b01: begin
          extend_bit = U ? 1'b0 : mem[A+1][7];
          out = {{24{extend_bit}}, out[7:0]};
        end
        2'b10: begin
          extend_bit = U ? 1'b0 : mem[A][7];
          out = {{16{extend_bit}}, out[15:0]};
        end
      endcase
      // $display("Reading from mem[%d]: %h", A, out);
    end
  end

  // 将读出的数据分配给输出端口 RD
  assign RD = out;

endmodule


// File: imm_gen.v
module imm_gen (
    input  [31:0] instr,
    output [31:0] imm
);

  //请在这里补充你的立即数生成模块代码

  // 取出操作码
  wire [6:0] opcode = instr[6:0];
  wire sgn = instr[31];

  reg [31:0] im; // always 块中无法赋值

  always @(*) begin
    case (opcode)
      // R-type X

      // I-type
      7'b0000011: begin
        //  op[31:30]
        // imm[11: 0]
        im = {{20{sgn}}, instr[31:20]};
      end

      // S-type
      7'b0100011: begin
        //  op[31:25]  op[11:7] 
        // imm[11: 5] imm[ 4:0]
        im = {{20{sgn}}, instr[31:25], instr[11:7]};
      end

      // B-type
      7'b1100011: begin
        //  op[31]  op[30:25]  op[11:8]  op[ 7]
        // imm[12] imm[10: 5] imm[ 4:1] imm[11]
        im = {{(19+1){sgn}}, instr[7], instr[30:25], instr[11:8], 1'b0};
      end
      // U-type
      7'b0010111: begin
        //  op[31:12]
        // imm[31:12]
        im = {{12{sgn}}, instr[31:12], 12'b0};
      end
      // J-type
      7'b1101111: begin
        //  op[      31        :       12      ]
        //  op[31]  op[30:21]  op[20]  op[19:12]
        // imm[20] imm[10: 1] imm[11] imm[19:12]
        im = {{(12+1){sgn}}, instr[30:21], instr[20], instr[19:12], 1'b0};
      end
      default: begin
        im = 32'b0;
      end
    endcase
  end
  assign imm = im;
endmodule


// File: core_top.v
// 本地测试
// `include "./control.v"
// `include "./instr_rom.v"
// `include "./alu.v"
// `include "./regfile.v"
// `include "./data_ram.v"
// `include "./imm_gen.v"
module core_top (
    input wire clk,
    input wire rst_n
);

  data_path u_data_path (
      .clk  (clk),
      .rst_n(rst_n)
  );

endmodule

module data_path (
    input wire clk,
    input wire rst_n
);
  // 声明内部信号
  reg  [31:0] pc;  // 程序计数器
  wire [31:0] instr;  // 指令
  wire [31:0] mem_addr;  // 内存地址
  wire [31:0] mem_wdata;  // 内存写入数据
  wire [31:0] mem_rdata;  // 内存读取数据
  wire [31:0] reg_rdata1;  // 从寄存器读取的数据1
  wire [31:0] reg_rdata2;  // 从寄存器读取的数据2
  wire [31:0] alu_out;
  wire [31:0] alu_a;  // ALU 输入 A
  wire [31:0] alu_b;  // ALU 输入 B
  wire [31:0] imm;  // 立即数
  wire        zero;  // 零标志

  // 控制信号
  wire        branch;
  wire        memread;
  wire        memtoreg;
  wire [ 3:0] aluctrl;
  wire        alusrc;
  wire        memwrite;
  wire        regwrite;
  wire [31:0] reg_wdata;

  // PC 更新逻辑
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) pc <= 32'h0;
    else if (branch && zero) pc <= pc + imm;  // 分支跳转
    else pc <= pc + 4;  // 顺序执行
  end

  assign alu_a = reg_rdata1;
  assign alu_b = (alusrc ? imm : reg_rdata2);

  assign mem_addr = alu_out;
  assign mem_wdata = reg_rdata2;

  assign reg_wdata = memtoreg ? mem_rdata : alu_out;

  wire [31:0] cpu_instr_rom [2047:0];

  wire [1:0] LOAD_SIZE;
  wire U;

  // 指令存储器例化
  pc_rom u_instr_rom (
      .A (pc),
      .RD(instr),
      .cpu_instr_rom(cpu_instr_rom)
  );

  // 控制单元例化
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

  // 寄存器堆例化
  regfile rf (
      .clk(clk),
      .WE (regwrite),
      .A1 (instr[19:15]),
      .A2 (instr[24:20]),
      .A3 (instr[11:7]),
      .WD3(reg_wdata),
      .RD1(reg_rdata1),
      .RD2(reg_rdata2)
  );

  // 立即数生成器例化
  imm_gen u_imm_gen (
      .instr(instr),
      .imm  (imm)
  );

  // 数据存储器例化
  data_ram u_data_ram (
      .clk(clk),
      .WE (memwrite),
      .RE (memread),
      .A  (mem_addr),
      .WD (mem_wdata),
      .LOAD_SIZE(LOAD_SIZE),
      .U(U),
      .RD (mem_rdata)
  );

  // ALU例化
  alu u_alu (
      .A(alu_a),
      .B(alu_b),
      .ALUCtrl(aluctrl),
      .ZERO(zero),
      .Y(alu_out)
  );

endmodule


