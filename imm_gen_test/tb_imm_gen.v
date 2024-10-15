`timescale 1ns/1ns

module tb_imm_gen ();

reg clk;
always#(5) clk = !clk;
reg[31:0]  instr;
reg[31:0]  std_res;
wire[31:0] dut_imm;
reg error_flag1 ;
reg error_flag2 ;
reg error_flag3 ;

reg[31:0] instr_buffer[8:0];

localparam lw_f  = 4'd0;
localparam sw_f  = 4'd1;
localparam beq_f = 4'd2;
integer i ;

imm_gen u_dut(
                .instr(instr),
                .imm(dut_imm)
);

// test lw、sw、beq

initial begin
    i           = 0;
    clk         = 0;
    instr       = 0;
    error_flag1 = 0;
    error_flag2 = 0;
    error_flag3 = 0;
    instr_buffer[0] = 32'h0080af03;    //0080af03          	lw	t5,8(ra)
    instr_buffer[1] = 32'hff80af03;    //ff80af03          	lw	t5,-8(ra)
    instr_buffer[2] = 32'h0200a283;    //0200a283          	lw	t0,32(ra)

    instr_buffer[3] = 32'h0020a223;    //0020a223          	sw	sp,4(ra)
    instr_buffer[4] = 32'hfe20aa23;    //fe20aa23          	sw	sp,-12(ra)
    instr_buffer[5] = 32'h0020a023;    //0020a023          	sw	sp,0(ra)

    instr_buffer[6] = 32'h00208463;    //00208463          	beq	ra,sp,7c <test_5+0x14>
    instr_buffer[7] = 32'h00208663;    //00208663          	beq	ra,sp,60 <test_4+0x18>
    instr_buffer[8] = 32'hfeb289e3;    //feb289e3          	beq	t0,a1,b54 <__adddf3+0x374>
    $display("=============================================");
    $display("          Initial Done! Start Test");
    $display("=============================================");
    $display("=============================================");
    $display("        Test LW instr imm gen");
    $display("============================================="); 
    //0080af03          	lw	t5,8(ra)
    //ff80af03          	lw	t5,-8(ra)
    //0200a283          	lw	t0,32(ra)
    for(i=0;i<3;i=i+1)begin
        #1
        instr = instr_buffer[i];
        auto_test(lw_f,instr,std_res);
        // $display("lw imm ! instr = %x,std_res=%x,imm=%x",instr,std_res,dut_imm);
        #1
        if(std_res != dut_imm)begin
            error_flag1 = 1;
            $display("lw imm gen error! instr = %x,std_res=%x,imm=%x",instr,std_res,dut_imm);
        end
        else begin
            $display("lw imm gen pass ! instr = %x,std_res=%x,imm=%x",instr,std_res,dut_imm);
        end
                // @(posedge clk);
    end 

    $display("=============================================");
    $display("        Test SW instr imm gen");
    $display("=============================================");  
    for(i=3;i<6;i=i+1)begin
        #1
        instr = instr_buffer[i];
        auto_test(sw_f,instr,std_res);
                #1
        if(std_res != dut_imm)begin
            error_flag2 = 1;
            $display("sw imm gen error! instr = %x,std_res=%x,imm=%x",instr,std_res,dut_imm);
        end
        else begin
            $display("sw imm gen pass ! instr = %x,std_res=%x,imm=%x",instr,std_res,dut_imm);
        end
    end 

    $display("=============================================");
    $display("        Test Beq instr imm gen");
    $display("============================================="); 
    for(i=6;i<9;i=i+1)begin
        #1
        instr = instr_buffer[i];
        auto_test(beq_f,instr,std_res);
                #1
        if(std_res != dut_imm)begin
            error_flag3 = 1;
            $display("beq imm gen error! instr = %x,std_res=%x,imm=%x",instr,std_res,dut_imm);
        end
        else begin
            $display("beq imm gen pass ! instr = %x,std_res=%x,imm=%x",instr,std_res,dut_imm);
        end
    end 
    #10
    if(error_flag1 | error_flag2 | error_flag3 )begin
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
    $display("   / __ \   /   |  / ___/  / ___/ ");    
    $display("  / /_/ /  / /| |  \__ \   \__ \  ");    
    $display(" / ____/  / ___ | ___/ /  ___/ /  ");    
    $display("/_/      /_/  |_|/____/  /____/   "); 
    $display(">>>>>>>>>>>>>>> PASS <<<<<<<<<<<<<");  
    end  
        #100
    $finish();
end

task auto_test;
    input[3:0] F;
    input[31:0] instr;
    output reg[31:0] imm_res;
begin
    if(F == 4'b0000)begin
        // lw type
        imm_res = {{20{instr[31]}},instr[31:20]};
    end
    else if(F == 4'b0001)begin
        // sw type
        imm_res = {{20{instr[31]}},instr[31:25],instr[11:7]};
    end
    else if(F == 4'b0010)begin
        // beq type
        imm_res = {         {19{instr[31]}} 
                              , instr[31] 
                              , instr[7] 
                              , instr[30:25] 
                              , instr[11:8]
                              , 1'b0
                              };
    end
    else begin
        imm_res = 32'h0;
    end
end
endtask

endmodule //tb_imm_gen

