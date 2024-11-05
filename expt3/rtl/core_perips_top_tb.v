`timescale 1ns/1ns

module core_top_perips_tb();

reg clk_50M;
reg rst_n_in;

reg debug_sw0;
reg IorD_sw17;

wire[56-1:0] HEX_o;
wire locked;

//-------- for key press simulation
localparam jitter_unit     = 32'h50;
localparam press_unit      = 32'h200;
reg key ;


parameter clk_period = 20;       // 50MHz 
always#(clk_period/2) clk_50M = !clk_50M;


core_perips_top  u_core(
    .CLOCK_50(clk_50M),
    .rst_n_in(rst_n_in),
    .key_in(key),
    .debug_sw0(debug_sw0),
    .IorD_sw17(IorD_sw17),
    .locked(locked),
    .HEX_o(HEX_o)
);


initial begin
    key     = 1'b1;
    clk_50M = 1'b0;
    rst_n_in = 1'b1;
    debug_sw0 = 1'b1;
    IorD_sw17 = 1'b1;
#20
    @(negedge clk_50M);
    rst_n_in = 1'b0;
#20
    @(negedge clk_50M);
    rst_n_in = 1'b1;
    $display("============SIM Start =============");
#10000000;
    $display("============ Time Out =============");
    $finish();
end

initial begin
    #200
    forever begin
        #20
        key_gen_a_clock(jitter_unit,press_unit);
    end
end

task key_gen_a_clock;
     input[32-1:0] jitter_cycle;
     input[32-1:0] press_cycle;
     begin
        key = 1'b1;
        repeat(jitter_cycle)begin
            @(posedge clk_50M);
            key = !key;
        end
        repeat(press_cycle)begin
            @(posedge clk_50M);
            key = 1'b0;
        end     
        repeat(jitter_cycle)begin
            @(posedge clk_50M);
            key = !key;
        end   
        repeat(press_cycle)begin
            @(posedge clk_50M);
            key = 1'b1;
        end        
        key = 1'b1;  
        @(posedge clk_50M);      
     end
endtask

endmodule


