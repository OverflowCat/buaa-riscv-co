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
    // $display("A = %h, B = %h", A, B);
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
