`timescale 1ns/1ns

module tb_alu();

reg clk;
reg rst_n;

reg error_flag1 ;
reg error_flag2 ;
reg error_flag3 ;
reg error_flag4 ;
reg error_flag5 ;
reg error_flag6 ;
reg[4-1:0]    F;
reg[32-1:0]   A,B;
wire[32-1:0]  Y;
reg[32-1:0]   rand_dataA;
reg[32-1:0]   rand_dataB;
reg[32-1:0]   rand_seed;
wire          ZERO;


parameter clk_period = 10;
always#(clk_period/2) clk = !clk;
integer  i;
localparam  loop_count = 10;

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        rand_dataA <= 32'h1000_0000;
        rand_dataB <= 32'h0000_1000;
        rand_seed  <= 32'h0;
    end
    else begin
        rand_seed  <= ((rand_seed<<1) + 32'h98123456) ^ rand_seed ;
        rand_dataA <= rand_dataA > rand_dataB ?   rand_dataA : (rand_dataA + rand_seed) ;
        rand_dataB <= rand_dataA < rand_dataB ?   rand_dataB : (rand_dataB + rand_seed) ;
    end
end


alu  dut(
          .A(A),
          .B(B),
          .ALUCtrl(F),
          .ZERO(ZERO),
          .Y(Y)
        );

initial begin
    clk = 1'b0;
    rst_n = 1'b1;
    error_flag1 = 1'b0;
    error_flag2 = 1'b0;
    A     = 32'b0;
    B     = 32'b0;
    F     = 4'b0000;
#10
    @(negedge clk);
    rst_n = 1'b0;
    @(posedge clk);
    rst_n = #1 1'b1;
    #20
    $display("=============================================");
    $display("          Initial Done! Start Test");
    $display("=============================================");
    $display("=============================================");
    $display("        Test F=4'b0000 AND Function");
    $display("============================================="); 
    F     = 4'b0000;   
    auto_test(F,loop_count,error_flag1);
    $display("=============================================");
    $display("        Test F=4'b0001 OR Function");
    $display("=============================================");  
    F = 4'b0001;  
    auto_test(F,loop_count,error_flag2);
    $display("=============================================");
    $display("        Test F=4'b0010 ADD Function");
    $display("============================================="); 
    F     = 4'b0010;   
    auto_test(F,loop_count,error_flag3);
    $display("=============================================");
    $display("        Test F=4'b0110 SUB Function");
    $display("=============================================");  
    F     = 4'b0110;  
    auto_test(F,loop_count,error_flag4);
    // $display("=============================================");
    // $display("        Test F=4'b0111 SLT Function");
    // $display("============================================="); 
    // F     = 4'b0111;   
    // auto_test(F,loop_count,error_flag5);
    #10
    if(error_flag1 | error_flag2 | error_flag3 | error_flag4 | error_flag5)begin
    $display("    ______           ___            ____            __ ");
    $display("   / ____/          /   |          /  _/           / / ");
    $display("  / /_             / /| |          / /            / /  ");
    $display(" / __/            / ___ |        _/ /            / /___");
    $display("/_/              /_/  |_|       /___/           /_____/"); 
    $display(">>>>>>>>>>>>>>>>>>>>>>> FAIL <<<<<<<<<<<<<<<<<<<<<<<<<<");    
    end
    else begin
    $display("    ____            ___         _____            _____ "); 
    $display("   / __ \          /   |       / ___/           / ___/ ");    
    $display("  / /_/ /         / /| |       \__ \            \__ \  ");    
    $display(" / ____/         / ___ |      ___/ /           ___/ /  ");    
    $display("/_/             /_/  |_|     /____/           /____/   ");
    $display(">>>>>>>>>>>>>>>>>>>>>>> PASS <<<<<<<<<<<<<<<<<<<<<<<<<<");
    end  
        #100
    $finish();
end



task gen_rand_AB;
     begin
        A = $random % ({32{1'b1}});
        B = $random % ({32{1'b1}});
     end 
endtask

task auto_test;
    input[4-1:0] Fun;
    input[32-1:0] count;
    output       error_flag;
    reg[32-1:0]  res;
    reg          zero_flag;
    integer k;
    reg[31:0] test_a,test_b;
    begin
        error_flag = 1'b0;
        for(k=0;k<count;k=k+1)begin
        // rand_dataA = $random % ({32{1'b1}});
        // rand_dataB = $random % ({32{1'b1}});
        @(posedge clk);
        #1
        if( k == 0)begin
            A = rand_dataA;
            B = rand_dataA;
            test_a = rand_dataA;
            test_b = rand_dataA;
        end
        else begin
            A = rand_dataA;
            B = rand_dataB;
            test_a = rand_dataA;
            test_b = rand_dataB;
        end
        case(Fun)
        4'b0000:begin
            res = test_a & test_b;
            zero_flag = res == 32'h0;
        end
        4'b0001:begin
            res = test_a | test_b;
            zero_flag = res == 32'h0;
        end
        4'b0010:begin
            res = test_a + test_b;
            zero_flag = res == 32'h0;
        end
        4'b0110:begin
            res = test_a - test_b;
            zero_flag = res == 32'h0;
        end
        4'b0111:begin
            res = test_a < test_b ? 1'b1 : 1'b0;
            zero_flag = res == 32'h0;
        end
        default:begin
            $display("Unkown Function = %b",Fun) ;
        end 
        endcase
        #5
        if((res != Y) | (zero_flag != ZERO))begin
            error_flag = 1'b1;
            $display("Error -> Fun=%b,A=%x,B=%x,std_res=%x,Y=%x,std_ZERO=%x,ZERO=%x",Fun,A,B,res,Y,zero_flag,ZERO);
        end
        else begin
            $display("Pass  -> Fun=%b,A=%x,B=%x,std_res=%x,Y=%x,std_ZERO=%x,ZERO=%x",Fun,A,B,res,Y,zero_flag,ZERO);
        end      
    end
    if(error_flag1 == 1'b0)begin
    $display("=============================================");
    $display("          Test Fun=%b Pass",Fun);
    $display("=============================================");  
    end
    else begin
    $display("=============================================");
    $display("          Test Fun=%b Fail",Fun);
    $display("=============================================");  
    end
    end
endtask


endmodule
