module alu (
    input  wire [ 32-1:0] A,
    input  wire [ 32-1:0] B,
    input  wire [4-1 : 0] ALUCtrl,
    output wire           ZERO,
    output wire [ 32-1:0] Y
);

  //请在这里补充你的ALU实现代码

  reg [31:0] out;
  reg zero;

  initial begin
    out = 32'b0;
    zero = 1'b0;
  end

  always @(*) begin
    case (ALUCtrl)
      4'b0000: out = A & B;  // AND
      4'b0001: out = A | B;  // OR
      4'b0010: out = A + B;  // ADD
      4'b0110: out = A - B;  // SUB
      default: out = 32'b0;
    endcase

    // Set ZERO flag
    // BEQ 指令需要使用这个零标志来判断是否跳转
    if (out == 32'b0) begin
      zero = 1;
    end else begin
      zero = 0;
    end
  end

  assign Y = out;
  assign ZERO = zero;

endmodule
