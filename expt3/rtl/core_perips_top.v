
module core_perips_top(
       input  wire CLOCK_50,
       input  wire rst_n_in,
       input  wire key_in,
       input  wire debug_sw0,
       input  wire IorD_sw17,
       output wire locked,
       output wire[56-1:0] HEX_o
);

wire clk;
wire rst_n;
wire[32-1:0] instr_o;
wire[32-1:0] dram0;
wire[32-1:0] dram1;
wire[32-1:0] dram2;
wire[32-1:0] dram3;
wire[32-1:0] dram4;
wire[32-1:0] dram5;
wire[32-1:0] dram6;
wire[32-1:0] dram7;
assign locked = clk;

       clk_gen_new u_clk_gen_new(
              .clk_in(CLOCK_50),
              .rst_n_in(rst_n_in),
              .debug_sw0(debug_sw0),
              .key_in(key_in),
              .rst_n(rst_n),
              .clk(clk)
              );

       core_top u_core_top(
              .clk(clk),
              .rst_n(rst_n),
              .instr_o(instr_o),
              .dram0(dram0),
              .dram1(dram1),
              .dram2(dram2),
              .dram3(dram3),
              .dram4(dram4),
              .dram5(dram5),
              .dram6(dram6),
              .dram7(dram7)
              );

wire [31:0] hex_in;
assign hex_in = (IorD_sw17) ? instr_o : {dram0[3:0],dram1[3:0],dram2[3:0],dram3[3:0],dram4[3:0],dram5[3:0],dram6[3:0],dram7[3:0]};
                
show_IorD u_show_IorD(
       .IorD(hex_in),
       .HEX_o(HEX_o)
);

endmodule
