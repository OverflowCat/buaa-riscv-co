`include "regfile.v"

`timescale 1ns/1ns

module tb_regfile();

reg clk;
reg rst_n;
reg WE;
reg error_flag1 ;
reg error_flag2 ;
reg[5-1:0]    A1,A2,A3;
reg[32-1:0]   WD3;
reg[32-1:0]   std_rf[31:0];
wire[32-1:0]  RD1,RD2;
reg[32-1:0]   rand_data;

parameter clk_period = 10;
always#(clk_period/2) clk = !clk;
integer  i;

regfile dut(
    .clk(clk),
    .WE(WE),
    .A1(A1),
    .A2(A2),
    .A3(A3),
    .WD3(WD3),
    .RD1(RD1),
    .RD2(RD2)
);

initial begin
    error_flag1 = 1'b0;
    error_flag2 = 1'b0;
    A1    = 5'b0;
    A2    = 5'b0;
    A3    = 5'b0;
    clk   = 1'b0;
    rst_n = 1'b1;
    #20
    @(negedge clk);
    rst_n = 1'b0;
    #20
    @(negedge clk);
    rst_n = 1'b1;
    #20
    $display("=============================================");
    $display("          Initial Done! Start Test");
    $display("=============================================");
    #20
    $display("=============================================");
    $display("          Test Port A1");
    $display("=============================================");   
    for(i=0;i<32;i=i+1)begin
        write_to_regfile(i,i+1);
    end
    @(posedge clk);
    A1 = 5'h0;
    #1
    if(RD1 != 32'h0)begin
        $display("Error : Read register-0 is not zero!");
    end
    for(i=1;i<32;i=i+1)begin
        @(posedge clk);
        A1 = i;
        #1
        if(RD1 != std_rf[i])begin
            $display("Error : Read register-%d = %d,should be %d !",i,RD1,std_rf[i]);
            error_flag1 = 1'b1;
        end        
    end
    if(error_flag1 == 1'b0)begin
    $display("=============================================");
    $display("          Test Port A1 Pass");
    $display("=============================================");  
    end
    else begin
    $display("=============================================");
    $display("          Test Port A1 Fail");
    $display("=============================================");  
    end
    #100
    $display("=============================================");
    $display("          Test Port A2");
    $display("=============================================");   
    for(i=0;i<32;i=i+1)begin
        rand_data = $random %({32{1'b1}});
        write_to_regfile(i,rand_data);
    end
    @(posedge clk);
    A2 = 5'h0;
    #1
    if(RD2 != 32'h0)begin
        $display("Error : Read register-0 is not zero!");
    end
    for(i=1;i<32;i=i+1)begin
        @(posedge clk);
        A2 = i;
        #1
        if(RD2 != std_rf[i])begin
            $display("Error : Read register-%d = %d,should be %d !",i,RD2,std_rf[i]);
            error_flag2 = 1'b1;
        end        
    end
    if(error_flag2 == 1'b0)begin
    $display("=============================================");
    $display("          Test Port A2 Pass");
    $display("=============================================");  
    end
    else begin
    $display("=============================================");
    $display("          Test Port A2 Fail");
    $display("=============================================");  
    end  
    #100
    if((!error_flag1) & (!error_flag2))begin
    $display("    ____     ___    _____   _____ "); 
    $display("   / __ \   /   |  / ___/  / ___/ ");    
    $display("  / /_/ /  / /| |  \__ \   \__ \  ");    
    $display(" / ____/  / ___ | ___/ /  ___/ /  ");    
    $display("/_/      /_/  |_|/____/  /____/   ");      
    end
    else begin
    $display("    ______    ___     ____    __ ");
    $display("   / ____/   /   |   /  _/   / / ");
    $display("  / /_      / /| |   / /    / /  ");
    $display(" / __/     / ___ | _/ /    / /___");
    $display("/_/       /_/  |_|/___/   /_____/");
    end  
    #200
    $dumpfile("tb_regfile.vcd");
    $dumpvars;
    $finish();
end


task write_to_regfile;
     input[5-1:0]  index;
     input[32-1:0] data;
     begin
        WE = 1'b0;
        @(posedge clk);
        WE = #1 1'b1;
        A3 = #1 index;
        WD3= #1 data;
        std_rf[index] = #1 data;
        @(posedge clk);
        #1
        WE = #1 1'b0;
     end
endtask



endmodule
