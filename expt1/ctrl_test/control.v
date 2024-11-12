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

  localparam ALU_ADD = 4'b0010;
  localparam ALU_SUB = 4'b0110;
  localparam ALU_AND = 4'b0000;
  localparam ALU_OR = 4'b0001;

  //请在这里补充你的控制器代码

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
      endcase
      xbranch   = 1'b0;
      xalusrc   = 1'b0;
      xmemtoreg = 1'b0;
      xmemwrite = 1'b0;
      xregwrite = 1'b1;
    end else if (opcode == 7'b0110111) begin
      // U-type, lui, rd = imm << 12
      xalusrc   = 1'b1;  // 需要立即数
      xregwrite = 1'b1;  // 需要写入寄存器
      xmemtoreg = 1'b0;  // 不需要从内存写回寄存器
      xmemread  = 1'b0;  // 不需要读内存
      xmemwrite = 1'b0;  // 不需要写内存
      xaluctrl  = ALU_ADD;  // 加法
    end else if (opcode == 7'b0000011 && funct3 == 3'b010) begin
      // I-type, lw
      xalusrc   = 1'b1;  // 需要立即数
      xregwrite = 1'b1;  // 需要写入寄存器
      xmemread  = 1'b1;  // 需要读内存
      xmemtoreg = 1'b1;  // 需要写回寄存器
      xmemwrite = 1'b0;  // 不需要写内存
      xaluctrl  = ALU_ADD;  // 加法
    end else if (opcode == 7'b0010011 && funct3 == 3'b000) begin
      // I-type, addi
      xalusrc   = 1'b1;  // 需要立即数
      xregwrite = 1'b1;  // 需要写入寄存器
      xmemread  = 1'b0;  // 不需要读内存
      xmemtoreg = 1'b0;  // 不需要写回寄存器
      xmemwrite = 1'b0;  // 不需要写内存
      xaluctrl  = ALU_ADD;  // 加法
    end else if (opcode == 7'b0100011 && funct3 == 3'b010) begin
      xalusrc   = 1'b1;
      xregwrite = 1'b0;
      xmemwrite = 1'b1;
      // xmemtoreg = 1'b0;
      xmemread  = 1'b0;
      xbranch   = 1'b0;
      xaluctrl  = ALU_ADD;
    end else if (opcode == 7'b1100011) begin
      // B-type branch instructions
      // beq 的 funct3 是 0x0, 而 bne 的 funct3 是 0x1
      if (funct3 == 3'b000) begin
        // beq
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
      end else if (funct3 == 3'b001) begin
        // bne
        xalusrc   = 0;
        xregwrite = 0;
        xmemread  = 0;
        xmemwrite = 0;
        xbranch   = 1;
        xaluctrl  = 4'b0110;
      end
    end else if (opcode == 7'b1101111) begin  // 1101111 J-type
      // jal 跳转并链接（Jump And Link），跳转到指定的目标地址
      // 并将返回地址（当前 PC + 4）存入指定寄存器。
      // 因此，alu 需要计算当前 PC + 4
      xalusrc   = 1'b0;  // 不需要立即数
      xregwrite = 1'b1;  // 需要写入返回地址
      xmemtoreg = 1'b0;  // 不需要写回内存
      xmemread  = 0;  // 不需要读内存
      xmemwrite = 0;  // 不需要写内存
      xbranch   = 1;  // 这是跳转指令
      xaluctrl  = ALU_ADD;  // 加法
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
