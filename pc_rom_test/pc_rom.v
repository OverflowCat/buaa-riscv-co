module pc_rom(
    input  wire [31:0] A,
    output wire [31:0] RD
);

//请在这里补充你的指令存储器代码
reg [31:0] mem [0:255];

initial begin
    $readmemb("code.dat", mem);
end

assign RD = mem[A];

endmodule
