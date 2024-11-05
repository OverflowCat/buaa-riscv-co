module data_path (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] imm,
    input  wire        branch,
    input  wire        zero,
    output reg  [31:0] pc,
    output wire [31:0] instr
);

  // 初始PC值
  // initial pc = 0; // oj 的 Answer 是 xxxxxxxx

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) pc <= 32'h0;
    else if (branch && zero) pc <= pc + imm;  // 分支跳转
    else pc <= pc + 4;  // 顺序执行
    // $display("Time=%0t | branch=%b | zero=%b | pc=%h | imm=%h", $time, branch, zero, pc, imm);
  end

endmodule
