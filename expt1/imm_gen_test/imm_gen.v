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
