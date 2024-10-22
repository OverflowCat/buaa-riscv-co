`include "control.v"

`timescale 1ns/1ns

module controller_tb();

reg clk;
always#(5) clk = !clk;
reg[31:0]  instr;
reg[10-1:0]  std_res;
reg[10-1:0]  bit_cmp_info;
reg error_flag1 ;
reg error_flag2 ;
reg error_flag3 ;
reg error_flag4 ;

wire      branch  ;
wire      memread ;
wire      memtoreg;
wire[3:0] aluop   ;
wire      alusrc  ;
wire      memwrite;
wire      regwrite; 

reg[31:0] instr_buffer[12:0];

localparam lw_f  = 4'd0;
localparam sw_f  = 4'd1;
localparam beq_f = 4'd2;
localparam r_f   = 4'd3;
integer i ;

control u_dut(
       .instr(instr),
       .branch  ( branch   ),
       .memread ( memread  ),
       .memtoreg( memtoreg ),
       .aluctrl   ( aluop    ),
       .alusrc  ( alusrc   ),
       .memwrite( memwrite ),
       .regwrite( regwrite ) 
);

wire[10-1:0] dut_res = {alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop};
// test lw、sw、beq

initial begin
    i               = 0           ;
    clk             = 0           ;
    instr           = 0           ;
    error_flag1     = 0           ;
    error_flag2     = 0           ;
    error_flag3     = 0           ;
    error_flag4     = 0           ;
    instr_buffer[0] = 32'h0080af03;    //0080af03          	lw	t5,8(ra)
    instr_buffer[1] = 32'hff80af03;    //ff80af03          	lw	t5,-8(ra)
    instr_buffer[2] = 32'h0200a283;    //0200a283          	lw	t0,32(ra)

    instr_buffer[3] = 32'h0020a223;    //0020a223          	sw	sp,4(ra)
    instr_buffer[4] = 32'hfe20aa23;    //fe20aa23          	sw	sp,-12(ra)
    instr_buffer[5] = 32'h0020a023;    //0020a023          	sw	sp,0(ra)

    instr_buffer[6] = 32'h00208463;    //00208463          	beq	ra,sp,7c <test_5+0x14>
    instr_buffer[7] = 32'h00208663;    //00208663          	beq	ra,sp,60 <test_4+0x18>
    instr_buffer[8] = 32'hfeb289e3;    //feb289e3          	beq	t0,a1,b54 <__adddf3+0x374>

    instr_buffer[9 ]= 32'h40208f33;    //40208f33          	sub	t5,ra,sp
    instr_buffer[10]= 32'h0020ef33;    //0020ef33          	or	t5,ra,sp
    instr_buffer[11]= 32'h00208f33;    //00208f33          	add	t5,ra,sp
    instr_buffer[12]= 32'h0020ff33;    //0020ff33          	and	t5,ra,sp
    $display("=============================================");
    $display("          Initial Done! Start Test");
    $display("control bit - flow -> control signal :");
    $display("alusrc,memtoreg,regwrite,memread,memwrite,branch,aluctrl[3:0]");
    $display("aluctrl=0000b-> and function");
    $display("aluctrl=0001b-> or  function");
    $display("aluctrl=0010b-> add function");
    $display("aluctrl=0110b-> sub function");
    $display("=============================================");
    $display("=============================================");
    $display("        Test LW instr control signal gen");
    $display("============================================="); 
    //0080af03          	lw	t5,8(ra)
    //ff80af03          	lw	t5,-8(ra)
    //0200a283          	lw	t0,32(ra)
    for(i=0;i<3;i=i+1)begin
        #1
        instr = instr_buffer[i];
        auto_test(lw_f,instr,std_res,bit_cmp_info);
        #1
        if(!check(lw_f,dut_res,bit_cmp_info,std_res))begin
            error_flag1 = 1;
            $display("lw control signal gen error! instr = %x,std_res=%b,control signal=%b",instr,std_res,dut_res);
        end
        else begin
            $display("lw control signal gen pass ! instr = %x,std_res=%b,control signal=%b",instr,std_res,dut_res);
        end
                // @(posedge clk);
    end 

    $display("=============================================");
    $display("        Test SW instr control signal gen");
    $display("=============================================");  
    for(i=3;i<6;i=i+1)begin
        #1
        instr = instr_buffer[i];
        auto_test(sw_f,instr,std_res,bit_cmp_info);
                #1
        if(!check(sw_f,dut_res,bit_cmp_info,std_res))begin
            error_flag2 = 1;
            $display("sw control signal gen error! instr = %x,std_res=%b,control signal=%b",instr,std_res,dut_res);
        end
        else begin
            $display("sw control signal gen pass ! instr = %x,std_res=%b,control signal=%b",instr,std_res,dut_res);
        end
    end 

    $display("=============================================");
    $display("        Test Beq instr control signal gen");
    $display("============================================="); 
    for(i=6;i<9;i=i+1)begin
        #1
        instr = instr_buffer[i];
        auto_test(beq_f,instr,std_res,bit_cmp_info);
                #1
        if(!check(beq_f,dut_res,bit_cmp_info,std_res))begin
            error_flag3 = 1;
            $display("beq control signal gen error! instr = %x,std_res=%b,control signal=%b",instr,std_res,dut_res);
        end
        else begin
            $display("beq control signal gen pass ! instr = %x,std_res=%b,control signal=%b",instr,std_res,dut_res);
        end
    end 
    $display("=============================================");
    $display("        Test R-type instr control signal gen");
    $display("============================================="); 
    for(i=9;i<13;i=i+1)begin
        #1
        instr = instr_buffer[i];
        auto_test(r_f,instr,std_res,bit_cmp_info);
                #1
        if(!check(r_f,dut_res,bit_cmp_info,std_res))begin
            error_flag4 = 1;
            $display("R-type control signal gen error! instr = %x,std_res=%b,control signal=%b",instr,std_res,dut_res);
        end
        else begin
            $display("R-type control signal gen pass ! instr = %x,std_res=%b,control signal=%b",instr,std_res,dut_res);
        end
    end 
    #10
    if(error_flag1 | error_flag2 | error_flag3 | error_flag4 )begin
    $display("--------------------------FAIL-----------------------------");
    $display("    ______    ___     ____    __ ");
    $display("   / ____/   /   |   /  _/   / / ");
    $display("  / /_      / /| |   / /    / /  ");
    $display(" / __/     / ___ | _/ /    / /___");
    $display("/_/       /_/  |_|/___/   /_____/");
    $display(">>>>>>>>>>>>>>> FAIL <<<<<<<<<<<<<"); 
    end
    else begin
    $display("--------------------------PASS-----------------------------");
    $display("    ____     ___    _____   _____ "); 
    $display("   / __ \\   /   |  / ___/  / ___/ ");    
    $display("  / /_/ /  / /| |  \\__ \\   \\__ \\  ");    
    $display(" / ____/  / ___ | ___/ /  ___/ /  ");    
    $display("/_/      /_/  |_|/____/  /____/   ");   
    $display(">>>>>>>>>>>>>>> PASS <<<<<<<<<<<<<");    
    end  
        #100
    $dumpfile("control_tb.vcd");
    $dumpvars();
    $finish();
end

task auto_test;
    input[3:0] F;
    input[31:0] instr;
    output reg[9:0] imm_res;
    output reg[10-1:0] tmp;
    reg[3:0] R_type_Alu_op_sel;
begin
    R_type_Alu_op_sel = {instr[30],instr[14:12]};
    if(F == 4'b0000)begin
        // lw type
        imm_res = 10'b111100_0010;
        tmp = 10'b11_1111_1111;
    end
    else if(F == 4'b0001)begin
        // sw type
        imm_res = 10'b1x0010_0010;
        tmp     = 10'b10_1111_1111;
    end
    else if(F == 4'b0010)begin
        // beq type
        imm_res = 10'b0x0001_0110;
        tmp     = 10'b10_1111_1111;
    end
    else if(F == 4'b0011)begin
        // R type
        case(R_type_Alu_op_sel)
        4'b0000:begin  //add
            imm_res = {10'b0010_00_0010};
        end
        4'b1000:begin  //sub
            imm_res = {10'b0010_00_0110};
        end
        4'b0111:begin  //and
            imm_res = {10'b0010_00_0000};
        end
        4'b0110:begin  //or
            imm_res = {10'b0010_00_0001};
        end
        default begin
            imm_res = {10'b0010_00_0010};
        end
        endcase
        tmp = 10'b11_1111_1111;
    end
    else begin
        imm_res = 32'h0;
        tmp = 10'b11_1111_1111;
    end
end
endtask

function check;
        input[3:0] F;
        input[10-1:0] usr_res;
        input[10-1:0] tmp;
        input[10-1:0] imm_res;
begin
    check = (tmp & usr_res) == (imm_res & tmp);
end
endfunction


endmodule //tb_imm_gen