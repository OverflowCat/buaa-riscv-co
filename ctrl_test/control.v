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
      // S-type store instructions
    //   wire[10-1:0] dut_res = {alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop};
//     sw control signal gen error! instr = 0020a223,std_res=1x00100010,control signal=1100100000
      xalusrc   = 1'b1;
      xregwrite = 1'b0;
      xmemwrite = 1'b1;
      xmemread  = 1'b0;
      xbranch   = 1'b0;
      xaluctrl  = 4'b0010;
    end else if (opcode == 7'b1100011) begin
      // B-type branch instructions
      xalusrc=0;
      // xmemtoreg=x;
      xregwrite=0;
      xmemread=0;
      xmemwrite=0;
      xbranch=1;
      xaluctrl=4'b0110;
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
