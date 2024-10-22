`include "pc_rom.v"
`timescale 1ns/1ns

module tb_pc_rom();

reg[31:0] A;
wire[31:0] RD;
reg       error_flag;

integer i;

pc_rom dut_rom(
    .A(A),
    .RD(RD)
);

initial begin
    error_flag = 1'b0;
    $display("=============================================");
    $display("                Test PC-ROM");
    $display("============================================="); 
    for(i=0;i<256;i=i+1)begin
        A = i*4;
        #1
        if((RD != i)/*  | $isunknown(RD) */)begin
            error_flag = 1'b1;
            $display("Error : Read PC-ROM Addr %x is %x,should be %x!",i,RD,i);
        end
    end
    if((!error_flag))begin
    $display("    ____     ___    _____   _____ "); 
    $display("   / __ \\   /   |  / ___/  / ___/ ");    
    $display("  / /_/ /  / /| |  \\__ \\   \\__ \\  ");    
    $display(" / ____/  / ___ | ___/ /  ___/ /  ");    
    $display("/_/      /_/  |_|/____/  /____/   "); 
    $display(">>>>>>>>>>>>>>> PASS <<<<<<<<<<<<<");     
    end
    else begin
    $display("    ______    ___     ____    __ ");
    $display("   / ____/   /   |   /  _/   / / ");
    $display("  / /_      / /| |   / /    / /  ");
    $display(" / __/     / ___ | _/ /    / /___");
    $display("/_/       /_/  |_|/___/   /_____/");
    $display(">>>>>>>>>>>>>>> FAIL <<<<<<<<<<<<<"); 
    end  
    #200
    $dumpfile("pc_rom.vcd");
    $dumpvars;
    $finish();
end


endmodule
