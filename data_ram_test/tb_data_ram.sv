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
        if((RD != i) | $isunknown(RD))begin
            error_flag = 1'b1;
            $display("Error : Read DATA-RAM Addr %x is %x,should be %x!",A,RD,std_rf[i]);
        end
    end
    if((!error_flag))begin
    $display("    ____     ___    _____   _____ "); 
    $display("   / __ \   /   |  / ___/  / ___/ ");    
    $display("  / /_/ /  / /| |  \__ \   \__ \  ");    
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



