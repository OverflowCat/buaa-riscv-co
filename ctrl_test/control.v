module control(
       input[31:0] instr,
       output      branch,
       output      memread,
       output      memtoreg,
       output[3:0] aluctrl,
       output      alusrc,
       output      memwrite,
       output      regwrite
);

//请在这里补充你的控制器代码

    wire opcode = instr[6:0];
    wire instcode = instr[31:24];
    always @(*)
        begin
            case (instr):
                32'b_00000000_xxxxxx_xxx_000_xxxxx_0110011: // R add
                    begin
                        branch = 1'b0;
                        memread = 1'b0;
                        memtoreg = 1'b0;
                        aluctrl = 4'b0010;
                        alusrc = 1'b0;
                        memwrite = 1'b0;
                        regwrite = 1'b1;
                    end
                32'b_01000000_xxxxxx_xxx_000_xxxxx_0110011: // R sub
                    begin
                        branch = 1'b0;
                        memread = 1'b0;
                        memtoreg = 1'b0;
                        aluctrl = 4'b0110;
                        alusrc = 1'b0;
                        memwrite = 1'b0;
                        regwrite = 1'b1;
                    end
                32'b_00000000_xxxxxx_xxx_111_xxxxx_0110011: // R or
                    begin
                        branch = 1'b0;
                        memread = 1'b0;
                        memtoreg = 1'b0;
                        aluctrl = 4'b0001;
                        alusrc = 1'b0;
                        memwrite = 1'b0;
                        regwrite = 1'b1;
                    end
                32'b_00000000_xxxxxx_xxx_110_xxxxx_0110011: // R and
                    begin
                        branch = 1'b0;
                        memread = 1'b0;
                        memtoreg = 1'b0;
                        aluctrl = 4'b0000;
                        alusrc = 1'b0;
                        memwrite = 1'b0;
                        regwrite = 1'b1;
                    end
                32'b_xxxxxxxx_xxxxxx_xxx_010_xxxxx_0000011: // I lw
                    begin
                        branch = 1'b0;
                        memread = 1'b1;
                        memtoreg = 1'b1;
                        aluctrl = 4'b0000;
                        alusrc = 1'b1;
                        memwrite = 1'b0;
                        regwrite = 1'b1;
                    end
                32'b_xxxxxxxx_xxxxxx_xxx_010_xxxxx_0100011: // S sw
                    begin
                        branch = 1'b0;
                        memread = 1'b0;
                        memtoreg = 1'b0;
                        aluctrl = 4'b0000;
                        alusrc = 1'b1;
                        memwrite = 1'b1;
                        regwrite = 1'b0;
                    end
                32'b_xxxxxxxx_xxxxxx_xxx_000_xxxxx_1100011: // B Beq
                    begin
                        branch = 1'b1;
                        memread = 1'b0;
                        memtoreg = 1'b0;
                        aluctrl = 4'b0110;
                        alusrc = 1'b0;
                        memwrite = 1'b0;
                        regwrite = 1'b0;
                    end
                default:
                    begin
                        branch = 1'b0;
                        memread = 1'b0;
                        memtoreg = 1'b0;
                        aluctrl = 4'b0000;
                        alusrc = 1'b0;
                        memwrite = 1'b0;
                        regwrite = 1'b0;
                    end
            endcase
        end

endmodule
