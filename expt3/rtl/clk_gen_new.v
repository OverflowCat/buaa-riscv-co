
module clk_gen_new (
    input  wire clk_in,
    input  wire rst_n_in,
    input  wire debug_sw0,//select clk for debug
    input  wire key_in, //key is high when key is not be pushed
    output wire rst_n,
    output wire clk
);

//----> 异步复位（Async Reset） 同步释放（Sync Release）
reg reg1,reg2;
always@(posedge clk_in or negedge rst_n_in )begin
    if(!rst_n_in)begin
        reg1<=1'b0;
        reg2<=1'b0;
   end
  else begin
        reg1<=1'b1;
        reg2<=reg1;
    end
end
assign rst_n = reg2;


localparam idle     = 2'b00; // equal to output low
localparam pre_high = 2'b01;
localparam high     = 2'b10;
localparam pre_low  = 2'b11;

localparam press_threshold = 24'd150;          // for simulation
//localparam press_threshold = 24'd1000000;          // for implemention 

wire       key_is_pressed = key_in == 1'b0;
reg[2 -1:0] nowstate,nextstate;
reg[24-1:0] cnt;
wire        state_turn_high = (cnt >= press_threshold ) & (nowstate == pre_high);
wire        state_turn_low  = (cnt >= press_threshold ) & (nowstate == pre_low );

//FSM-I
always@(posedge clk_in or negedge rst_n)begin
    if(!rst_n)begin
        nowstate <= idle;
    end
    else begin
        nowstate <= nextstate;
    end
end

//FSM-II
always@(*)begin
    case(nowstate)
    idle:begin
        nextstate = key_is_pressed ? pre_high : idle;
    end
    pre_high:begin
        nextstate = key_is_pressed ? (state_turn_high ? high : pre_high  ) : idle ;
    end
    high:begin
        nextstate = key_is_pressed ? high : pre_low ;
    end
    pre_low:begin
        nextstate = key_is_pressed ? high : (state_turn_low ? idle : pre_low) ;
    end
    default:begin
        nextstate = idle;
    end
    endcase

end

//FSM-III
always@(posedge clk_in or negedge rst_n)begin
    if(!rst_n)begin
        cnt <= 24'h0;
    end
    else begin
        case(nowstate)
        idle:begin
            cnt <= 24'h0;
        end
        pre_high:begin
            cnt <= cnt + 1'b1;
        end
        high:begin
            cnt <= 24'h0;
        end
        pre_low:begin
            cnt <= cnt + 1'b1;
        end
        endcase
    end
end

wire clk_press;
assign clk_press = (nowstate == pre_low) | (nowstate == high) ;

//wire clk_250ms;
//clk_div #(2500000) divpart(.clk(clk_in),.rstn(1),.clk_out(clk_250ms));

assign clk = (debug_sw0)?clk_press:clk_in;

endmodule