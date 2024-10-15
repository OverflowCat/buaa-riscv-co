`timescale 1ns/1ns

module top_tb();

reg clk;
reg rst_n;

parameter clk_period = 10;
always#(clk_period/2) clk = !clk;

core_top  u_top(
             
    .clk(clk),
    .rst_n(rst_n)
);

initial begin
    clk = 1'b1;
    rst_n = 1'b1;
#2
    @(negedge clk);
    rst_n = 1'b0;
#2
    @(negedge clk);
    rst_n = 1'b1;
    $display("============SIM Start =============");
#200;
    $display("============SIM End =============");
    $finish();
end

always@(posedge clk)begin
     $display("PC=%x,instr=%x",u_top.u_data_path.pc,u_top.instr);
end

endmodule


