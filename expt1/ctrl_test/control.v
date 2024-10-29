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
        3'h0:
        xaluctrl = funct7[5]  /* 0x20 = 0010 0000 */ ? 4'b0110  /* sub */ : 4'b0010  /* add */;
        3'h6: xaluctrl = 4'b0001;  // or
        3'h7: xaluctrl = 4'b0000;  // and
      endcase
      xbranch   = 1'b0;
      xalusrc   = 1'b0;
      xmemtoreg = 1'b0;
      xmemwrite = 1'b0;
      xregwrite = 1'b1;
    end else if (opcode == 7'b0000011) begin
      // I-type load instructions
      xalusrc   = 1'b1;
      xregwrite = 1'b1;
      xmemread  = 1'b1;
      xmemtoreg = 1'b1;
      xmemwrite = 1'b0;
      xaluctrl  = 4'b0010;
    end else if (opcode == 7'b0100011 && funct3 == 3'b010) begin
      xalusrc   = 1'b1;
      xregwrite = 1'b0;
      xmemwrite = 1'b1;
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
