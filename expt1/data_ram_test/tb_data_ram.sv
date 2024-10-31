`include "data_ram.v"
`timescale 1ns/1ns

module tb_data_ram();

reg clk;
reg rst_n;
reg WE,RE;
reg error_flag ;
reg[32-1:0]    A;
reg[32-1:0]   WD;
reg[32-1:0]   std_rf[1023:0];
wire[32-1:0]  RD;
reg[32-1:0]   rand_data;

parameter clk_period = 10;
always#(clk_period/2) clk = !clk;
integer  i;

data_ram   dut_ram(
    .clk(clk),
    .WE(WE),
    .RE(RE),
    .A(A),
    .WD(WD),
    .RD(RD)
);

reg[31:0] stdmem[1023:0];

initial begin
    RE = 1'b0;
    WE = 1'b0;
    A  = 32'h0;
    WD = 32'h0;
    clk = 1'b0;
    error_flag = 1'b0;
    #200
    $display("=============================================");
    $display("                Test DATA-RAM ");
    $display("          simulator Run at least 1us ");
    $display("=============================================");
    // read 0~10
    RE = 1;
    stdmem[0] = 32'h00000001;
    stdmem[1] = 32'h00000001;
    stdmem[2] = 32'h00000004;
    stdmem[3] = 32'h00000016;
    stdmem[4] = 32'h00000008;
    stdmem[5] = 32'h0000000F;
    stdmem[6] = 32'h00000011;
    stdmem[7] = 32'h0000002E;
    stdmem[8] = 32'h00000000;
    stdmem[9] = 32'h00000001;
    stdmem[10] = 32'h0000000F;
    for (i=0;i<10;i=i+1)begin
        A = i*4;
        #1
        $display("RD = %x, i = %x, A = %x", RD, i, A);
        if (RD != stdmem[i]) begin
            error_flag = 1'b1;
            $display("Error : Read DATA-RAM Addr %x is %x,should be %x!", A, RD, stdmem[i]);
        end
    end
    RE = 0;
    for(i=0;i<1024;i=i+64)begin
        rand_data = i;
        write_to_regfile(i,rand_data);
    end
    //----------- Read Part
    #200
    RE = 1'b1;
    for(i=0;i<1024;i=i+64)begin
        A = i*4;
        #1
        // if((RD != i) | $isunknown(RD))begin
        $display("RD = %x, i = %x, A = %x", RD, i, A);
        if (RD != i) begin
            error_flag = 1'b1;
            $display("Error : Read DATA-RAM Addr %x is %x,should be %x!",A,RD,std_rf[i]);
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
    $dumpfile("data_ram.vcd");
    $dumpvars;
    $finish();
end

task write_to_regfile;
     input[32-1:0] addr;
     input[32-1:0] data;
     begin
        WE = 1'b0;
        @(posedge clk);
        WE = #1 1'b1;
        A = #1 (addr<<2);
        WD= #1 data;
        std_rf[addr] = #1 data;
        @(posedge clk);
        #1
        WE = #1 1'b0;
     end
endtask


endmodule
