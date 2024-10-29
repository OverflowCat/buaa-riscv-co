`timescale 1ns/1ns
module tb_cpu_core(); 

`define CorePath u_cpu_core

//测试DUT信号
logic clk;//时钟信号
logic rst_n;//复位

//例化core_top
core_top  u_cpu_core(            
    .clk(clk),
    .rst_n(rst_n)
);

//仿真显示信号
logic [63:0] sim_cycle_cnt = '0;//仿真周期计数器

integer r;//计数工具人

//寄存器监测
wire [31:0] x3 = `CorePath.u_data_path.rf.rf[3];
wire [31:0] x26 = `CorePath.u_data_path.rf.rf[26];
wire [31:0] x27 = `CorePath.u_data_path.rf.rf[27];


// 读入程序
initial begin
    for(r=0; r<1024; r=r+1) begin//先填充0
        `CorePath.u_data_path.u_instr_rom.cpu_instr_rom[r] = 32'h0;
    end
    $readmemh ("inst.txt", `CorePath.u_data_path.u_instr_rom.cpu_instr_rom);//把程序(inst.txt)写进去
end

// 生成clk
initial begin
    clk = '0;
    forever #(5) clk = ~clk;
end

//仿真周期计数
always @(posedge clk) 
    sim_cycle_cnt <= sim_cycle_cnt+1;

//启动仿真流程
initial begin
    sysrst();//复位系统
    #10;
    wait(x26 == 32'b1);   // x26 == 1，结束仿真
    @(posedge clk);//等3个周期
    @(posedge clk);
    @(posedge clk);
    if (x27 == 32'b1) begin
    $display("~~~~~~~~~~~~~~~~~~~ TEST_PASS ~~~~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~ #####     ##     ####    #### ~~~~~~~~~");
    $display("~~~~~~~~~ #    #   #  #   #       #     ~~~~~~~~~");
    $display("~~~~~~~~~ #    #  #    #   ####    #### ~~~~~~~~~");
    $display("~~~~~~~~~ #####   ######       #       #~~~~~~~~~");
    $display("~~~~~~~~~ #       #    #  #    #  #    #~~~~~~~~~");
    $display("~~~~~~~~~ #       #    #   ####    #### ~~~~~~~~~");
    $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    end else begin
    $display("~~~~~~~~~~~~~~~~~~~ TEST_FAIL ~~~~~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~######    ##       #    #     ~~~~~~~~~~");
    $display("~~~~~~~~~~#        #  #      #    #     ~~~~~~~~~~");
    $display("~~~~~~~~~~#####   #    #     #    #     ~~~~~~~~~~");
    $display("~~~~~~~~~~#       ######     #    #     ~~~~~~~~~~");
    $display("~~~~~~~~~~#       #    #     #    #     ~~~~~~~~~~");
    $display("~~~~~~~~~~#       #    #     #    ######~~~~~~~~~~");
    $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    $display("fail testnum = %2d", x3);
    for (r = 1; r < 32; r = r + 1)
        $display("x%2d = 0x%x", r, `CorePath.u_data_path.rf.rf[r]);
    end
    $stop;//结束
end

initial begin//超时强制结束
    #300000;
    $display("*Sim tool:TEST Timeout, Err");
    $display("*Sim tool:Sim cycle = %d", sim_cycle_cnt);
    $stop;
end

task sysrst;//复位任务
    rst_n <= '0;//复位
    #15
    rst_n <= '1;
    #10;
endtask : sysrst

initial begin
    wait(rst_n===1'b1);
    if(`CorePath.u_data_path.u_pc_rom.cpu_instr_rom[0]==32'h0) begin//如果inst.txt读入失败，停止仿真
        $display("*Sim tool:Inst load error");
        #10;
        $stop;
    end
end

//输出波形
initial begin
    $dumpfile("tb.vcd");  //生成lxt的文件名称
    $dumpvars(0,tb_cpu_core);   //tb中实例化的仿真目标实例名称   
end


endmodule