`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Dept. of Computer Science, National Chiao Tung University
// Engineer: Chun-Jen Tsai 
// 
// Create Date: 2018/12/11 16:04:41
// Design Name: 
// Module Name: lab9
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: A circuit that show the animation of a fish swimming in a seabed
//              scene on a screen through the VGA interface of the Arty I/O card.
// 
// Dependencies: vga_sync, clk_divider, sram 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module lab10(
  input  clk,
  input  reset_n,
  input  [3:0] usr_btn,
  input  [3:0] usr_sw,
  output [3:0] usr_led,
  
  // VGA specific I/O ports
  output VGA_HSYNC,
  output VGA_VSYNC,
  output [3:0] VGA_RED,
  output [3:0] VGA_GREEN,
  output [3:0] VGA_BLUE
);

// Declare system variables
wire [9:0]  vend_pos;
wire        vend_region;

wire [9:0]  water_pos2;
wire        water_region2;

wire [9:0]  juice_pos2;
wire        juice_region2;

wire [9:0]  tea_pos2;
wire        tea_region2;

wire [9:0]  coke_pos2;
wire        coke_region2;

wire [9:0]  drop_pos;
wire        drop_region;

wire [9:0]  block1_pos;
wire        block1_region;

wire [9:0]  block2_pos;
wire        block2_region;

wire [9:0]  block3_pos;
wire        block3_region;

wire [9:0]  block4_pos;
wire        block4_region;

wire [9:0]  select_top_pos;
wire        select_top_region;

wire [9:0]  select_pos1;
wire        select_region1;

wire [9:0]  select_pos2;
wire        select_region2;

wire [9:0]  money_top_pos;
wire        money_top_region;

wire [9:0]  money_pos1;
wire        money_region1;

wire [9:0]  money_pos2;
wire        money_region2;

wire [9:0]  sm_block_pos;
wire        sm_block_region;

wire [9:0]  rest_pos;
wire        rest_region;

wire [9:0]  num0_1_pos;
wire        num0_1_region;

wire [9:0]  num0_2_pos;
wire        num0_2_region;

wire [9:0]  num0_3_pos;
wire        num0_3_region;

wire [9:0]  num0_4_pos;
wire        num0_4_region;

wire [9:0]  num1_1_pos;
wire        num1_1_region;

wire [9:0]  num1_2_pos;
wire        num1_2_region;

wire [9:0]  num1_3_pos;
wire        num1_3_region;

wire [9:0]  num1_4_pos;
wire        num1_4_region;

wire [9:0]  num1_5_pos;
wire        num1_5_region;

wire [9:0]  num1_6_pos;
wire        num1_6_region;

wire [9:0]  num1_7_pos;
wire        num1_7_region;

wire [9:0]  num1_8_pos;
wire        num1_8_region;

wire [9:0]  num2_1_pos;
wire        num2_1_region;

wire [9:0]  num2_2_pos;
wire        num2_2_region;

wire [9:0]  num2_3_pos;
wire        num2_3_region;

wire [9:0]  num2_4_pos;
wire        num2_4_region;

wire [9:0]  num2_5_pos;
wire        num2_5_region;

wire [9:0]  num2_6_pos;
wire        num2_6_region;

wire [9:0]  num2_7_pos;
wire        num2_7_region;

wire [9:0]  num2_8_pos;
wire        num2_8_region;

wire [9:0]  num3_1_pos;
wire        num3_1_region;

wire [9:0]  num3_2_pos;
wire        num3_2_region;

wire [9:0]  num3_3_pos;
wire        num3_3_region;

wire [9:0]  num3_4_pos;
wire        num3_4_region;

wire [9:0]  num4_1_pos;
wire        num4_1_region;

wire [9:0]  num4_2_pos;
wire        num4_2_region;

wire [9:0]  num4_3_pos;
wire        num4_3_region;

wire [9:0]  num4_4_pos;
wire        num4_4_region;

wire [9:0]  slash1_1_pos;
wire        slash1_1_region;

wire [9:0]  slash1_2_pos;
wire        slash1_2_region;

wire [9:0]  slash1_3_pos;
wire        slash1_3_region;

wire [9:0]  slash1_4_pos;
wire        slash1_4_region;

wire [9:0]  slash2_1_pos;
wire        slash2_1_region;

wire [9:0]  slash2_2_pos;
wire        slash2_2_region;

wire [9:0]  slash2_3_pos;
wire        slash2_3_region;

wire [9:0]  slash2_4_pos;
wire        slash2_4_region;

wire [20:0] sram_vend_addr;
wire [11:0] data_vend_in;
wire [11:0] data_vend_out;

wire [20:0] sram_water_addr2;
wire [11:0] data_water_in2;
wire [11:0] data_water_out2;

wire [20:0] sram_juice_addr2;
wire [11:0] data_juice_in2;
wire [11:0] data_juice_out2;

wire [20:0] sram_tea_addr2;
wire [11:0] data_tea_in2;
wire [11:0] data_tea_out2;

wire [20:0] sram_coke_addr2;
wire [11:0] data_coke_in2;
wire [11:0] data_coke_out2;

wire [20:0] sram_num_addr;
wire [11:0] data_num_in;
wire [11:0] data_num_out;

wire [20:0] sram_money_top_addr;
wire [11:0] data_money_top_in;
wire [11:0] data_money_top_out;

wire [20:0] sram_money_addr;
wire [11:0] data_money_in;
wire [11:0] data_money_out;

wire [20:0] sram_select_top_addr;
wire [11:0] data_select_top_in;
wire [11:0] data_select_top_out;

wire [20:0] sram_select_addr;
wire [11:0] data_select_in;
wire [11:0] data_select_out;

wire [20:0] sram_rest_addr;
wire [11:0] data_rest_in;
wire [11:0] data_rest_out;

wire [20:0] sram_slash_addr;
wire [11:0] data_slash_in;
wire [11:0] data_slash_out;

wire sram_we, sram_en;

// General VGA control signals
wire vga_clk;         // 50MHz clock for VGA control
wire video_on;        // when video_on is 0, the VGA controller is sending
                      // synchronization signals to the display device.
  
wire pixel_tick;      // when pixel tick is 1, we must update the RGB value
                      // based for the new coordinate (pixel_x, pixel_y)
  
wire [9:0] pixel_x;   // x coordinate of the next pixel (between 0 ~ 639) 
wire [9:0] pixel_y;   // y coordinate of the next pixel (between 0 ~ 479)
  
reg  [11:0] rgb_reg;  // RGB value for the current pixel
reg  [11:0] rgb_next; // RGB value for the next pixel
  
// Application-specific VGA signals
reg  [20:0] pixel_vend_addr;
reg  [20:0] pixel_water_addr2;
reg  [20:0] pixel_juice_addr2;
reg  [20:0] pixel_tea_addr2;
reg  [20:0] pixel_coke_addr2;
reg  [20:0] pixel_drop_addr;

reg  [20:0] pixel_num_addr;
reg  [20:0] pixel_slash_addr;

reg  [20:0] pixel_select_top_addr;
reg  [20:0] pixel_select_addr;
reg  [20:0] pixel_money_top_addr;
reg  [20:0] pixel_money_addr;

reg  [20:0] pixel_rest_addr;

// Declare the video buffer size
localparam VBUF_W = 320; // video buffer width
localparam VBUF_H = 240; // video buffer height

localparam vend_vpos   = 10;
localparam VEND_W      = 100;
localparam VEND_H      = 170;
reg [20:0] vend_addr;

localparam drop_vpos   = 145;
localparam DROP_W      = 56;
localparam DROP_H      = 13;

localparam block1_vpos  = 10;
localparam block2_vpos  = 67;
localparam block3_vpos  = 124;
localparam block4_vpos  = 181;
localparam BLOCK_W      = 190;
localparam BLOCK_H      = 50;

localparam select_top_vpos  = 10;
localparam select_vpos1  = 20;
localparam select_vpos2  = 191;
localparam money_top_vpos  = 67;
localparam money_vpos1  = 77;
localparam money_vpos2  = 134;

reg [20:0] select_top_addr;
reg [20:0] select_addr;
reg [20:0] money_top_addr;
reg [20:0] money_addr;

initial begin
  select_top_addr = 0;
  select_addr = 10*BLOCK_W;
  money_top_addr = 0;
  money_addr = 10*BLOCK_W;
end

localparam sm_block_vpos  = 190;
localparam SM_BLOCK_W      = 100;
localparam SM_BLOCK_H      = 40;

localparam rest_vpos  = 190;

localparam num0_1_vpos  = 190+30;
localparam num0_2_vpos  = 190+30;
localparam num0_3_vpos  = 190+30;
localparam num0_4_vpos  = 190+30;

localparam num1_1_vpos  = 50;
localparam num1_2_vpos  = 50;
localparam num1_3_vpos  = 50;
localparam num1_4_vpos  = 50;
localparam num1_5_vpos  = 50;
localparam num1_6_vpos  = 50;
localparam num1_7_vpos  = 50;
localparam num1_8_vpos  = 50;
localparam num2_1_vpos  = 107;
localparam num2_2_vpos  = 107;
localparam num2_3_vpos  = 107;
localparam num2_4_vpos  = 107;
localparam num2_5_vpos  = 107;
localparam num2_6_vpos  = 107;
localparam num2_7_vpos  = 107;
localparam num2_8_vpos  = 107;
localparam num3_1_vpos  = 164;
localparam num3_2_vpos  = 164;
localparam num3_3_vpos  = 164;
localparam num3_4_vpos  = 164;
localparam num4_1_vpos  = 221;
localparam num4_2_vpos  = 221;
localparam num4_3_vpos  = 221;
localparam num4_4_vpos  = 221;
localparam NUM_W      = 7;
localparam NUM_H      = 9;

localparam slash1_1_vpos  = 50;
localparam slash1_2_vpos  = 50;
localparam slash1_3_vpos  = 50;
localparam slash1_4_vpos  = 50;
localparam slash2_1_vpos  = 107;
localparam slash2_2_vpos  = 107;
localparam slash2_3_vpos  = 107;
localparam slash2_4_vpos  = 107;

reg [20:0] zero_addr;
reg [20:0] one_addr;
reg [20:0] two_addr;
reg [20:0] three_addr;
reg [20:0] four_addr;
reg [20:0] five_addr;
reg [20:0] six_addr;
reg [20:0] seven_addr;
reg [20:0] eight_addr;
reg [20:0] nine_addr;
reg [20:0] slash_addr;
initial begin
  zero_addr = VEND_W*VEND_H;
  one_addr = VEND_W*VEND_H+NUM_W * NUM_H;
  two_addr = VEND_W*VEND_H+NUM_W * NUM_H * 2;
  three_addr = VEND_W*VEND_H+NUM_W * NUM_H * 3;
  four_addr = VEND_W*VEND_H+NUM_W * NUM_H * 4;
  five_addr = VEND_W*VEND_H+NUM_W * NUM_H * 5;
  six_addr = VEND_W*VEND_H+NUM_W * NUM_H * 6;
  seven_addr = VEND_W*VEND_H+NUM_W * NUM_H * 7;
  eight_addr = VEND_W*VEND_H+NUM_W * NUM_H * 8;
  nine_addr = VEND_W*VEND_H+NUM_W * NUM_H * 9;
  slash_addr = SM_BLOCK_H*SM_BLOCK_W;
end

wire [3:0]  btn_level, btn_pressed;
reg  [3:0]  prev_btn_level;

localparam water_vpos2   = 42;
localparam WATER_W2 = 18;
localparam WATER_H2 = 27;
localparam juice_vpos2   = 50;
localparam JUICE_W2 = 22;
localparam JUICE_H2 = 27;
localparam tea_vpos2   = 105;
localparam TEA_W2 = 22;
localparam TEA_H2 = 18;
localparam coke_vpos2   = 107;
localparam COKE_W2 = 12;
localparam COKE_H2 = 24;

reg [20:0]water_addr2;
reg [20:0]juice_addr2;
reg [20:0]tea_addr2;
reg [20:0]coke_addr2;
initial begin
  water_addr2 = 0;
  juice_addr2 = WATER_W2 * WATER_H2;
  tea_addr2 = 0;
  coke_addr2 = TEA_W2 * TEA_H2;
end
// Instiantiate the VGA sync signal generator
vga_sync vs0(
  .clk(vga_clk), .reset(~reset_n), .oHS(VGA_HSYNC), .oVS(VGA_VSYNC),
  .visible(video_on), .p_tick(pixel_tick),
  .pixel_x(pixel_x), .pixel_y(pixel_y)
);

clk_divider#(2) clk_divider0(
  .clk(clk),
  .reset(~reset_n),
  .clk_out(vga_clk)
);

debounce btn_db0(
  .clk(clk),
  .btn_input(usr_btn[0]),
  .btn_output(btn_level[0])
);

debounce btn_db1(
  .clk(clk),
  .btn_input(usr_btn[1]),
  .btn_output(btn_level[1])
);

debounce btn_db2(
  .clk(clk),
  .btn_input(usr_btn[2]),
  .btn_output(btn_level[2])
);

debounce btn_db3(
  .clk(clk),
  .btn_input(usr_btn[3]),
  .btn_output(btn_level[3])
);

always @(posedge clk) begin
  if (~reset_n)
    prev_btn_level <= 4'b0000;
  else
    prev_btn_level <= btn_level;
end

assign btn_pressed = (btn_level & ~prev_btn_level);

// ------------------------------------------------------------------------
// The following code describes an initialized SRAM memory block that
// stores a 320x240 12-bit seabed image, plus two 64x32 fish images.

// wire [20:0] sram_tmp_addr;
// wire [11:0] data_tmp_in;
// wire [11:0] data_tmp_out;

sram #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(VEND_W*VEND_H+NUM_W * NUM_H * 10), .FILE("images.mem"))
  ram_1 (.clk(clk), .we(sram_we), .en(sram_en),
          .addr_1(sram_vend_addr), .data_i_1(data_vend_in), .data_o_1(data_vend_out),
          .addr_2(sram_num_addr), .data_i_2(data_num_in), .data_o_2(data_num_out));

sram #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(BLOCK_W*BLOCK_H), .FILE("images2.mem"))
  ram_2 (.clk(clk), .we(sram_we), .en(sram_en),
         .addr_1(sram_select_top_addr), .data_i_1(data_select_top_in), .data_o_1(data_select_top_out),
         .addr_2(sram_select_addr), .data_i_2(data_select_in), .data_o_2(data_select_out));

sram #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(BLOCK_W*BLOCK_H), .FILE("images3.mem"))
  ram_3 (.clk(clk), .we(sram_we), .en(sram_en),
         .addr_1(sram_money_top_addr), .data_i_1(data_money_top_in), .data_o_1(data_money_top_out),
         .addr_2(sram_money_addr), .data_i_2(data_money_in), .data_o_2(data_money_out));

sram #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(WATER_W2*WATER_H2+JUICE_W2*JUICE_H2), .FILE("images4.mem"))
  ram_4 (.clk(clk), .we(sram_we), .en(sram_en),
          .addr_1(sram_water_addr2), .data_i_1(data_water_in2), .data_o_1(data_water_out2),
          .addr_2(sram_juice_addr2), .data_i_2(data_juice_in2), .data_o_2(data_juice_out2));


sram #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(TEA_W2*TEA_H2+COKE_W2*COKE_H2), .FILE("images5.mem"))
  ram_5 (.clk(clk), .we(sram_we), .en(sram_en),
          .addr_1(sram_tea_addr2), .data_i_1(data_tea_in2), .data_o_1(data_tea_out2),
          .addr_2(sram_coke_addr2), .data_i_2(data_coke_in2), .data_o_2(data_coke_out2));

sram #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(SM_BLOCK_H*SM_BLOCK_W+NUM_H*NUM_W), .FILE("images6.mem"))
  ram_6 (.clk(clk), .we(sram_we), .en(sram_en),
          .addr_1(sram_rest_addr), .data_i_1(data_rest_in), .data_o_1(data_rest_out),
          .addr_2(sram_slash_addr), .data_i_2(data_slash_in), .data_o_2(data_slash_out));


assign sram_we = usr_sw[3]; // In this demo, we do not write the SRAM. However, if
                                  // you set 'sram_we' to 0, Vivado fails to synthesize
                                  // ram0 as a BRAM -- this is a bug in Vivado.
assign sram_en = 1;               // Here, we always enable the SRAM block.
// assign sram_f1_addr = pixel_f1_addr;
// assign data_f1_in = 12'h000; // SRAM is read-only so we tie inputs to zeros.

// assign sram_f2_addr = pixel_f2_addr;
// assign data_f2_in = 12'h000;

// assign sram_f3_addr = pixel_f3_addr;
// assign data_f3_in = 12'h000;

// assign sram_bg_addr = pixel_bg_addr;
// assign data_bg_in = 12'h000;

assign sram_vend_addr = pixel_vend_addr;
assign data_vend_in = 12'h000;

assign sram_water_addr2 = pixel_water_addr2;
assign data_water_in2 = 12'h000;
assign sram_juice_addr2 = pixel_juice_addr2;
assign data_juice_in2 = 12'h000;
assign sram_tea_addr2 = pixel_tea_addr2;
assign data_tea_in2 = 12'h000;
assign sram_coke_addr2 = pixel_coke_addr2;
assign data_coke_in2 = 12'h000;

assign sram_select_top_addr = pixel_select_top_addr;
assign data_select_top_in = 12'h000;
assign sram_select_addr = pixel_select_addr;
assign data_select_in = 12'h000;
assign sram_money_top_addr = pixel_money_top_addr;
assign data_money_top_in = 12'h000;
assign sram_money_addr = pixel_money_addr;
assign data_money_in = 12'h000;

assign sram_num_addr = pixel_num_addr;
assign data_num_in = 12'h000;

assign sram_rest_addr = pixel_rest_addr;
assign data_rest_in = 12'h000;

assign sram_slash_addr = pixel_slash_addr;
assign data_slash_in = 12'h000;

// End of the SRAM memory block.
// ------------------------------------------------------------------------

// VGA color pixel generator
assign {VGA_RED, VGA_GREEN, VGA_BLUE} = rgb_reg;

// ------------------------------------------------------------------------
// An animation clock for the motion of the fish, upper bits of the
// fish clock is the x position of the fish on the VGA screen.
// Note that the fish will move one screen pixel every 2^20 clock cycles,
// or 10.49 msec
// assign pos = fish_clock[31:20]; // the x position of the right edge of the fish image
                                   // in the 640x480 VGA screen

assign vend_pos = 220;
assign water_pos2 = 88;
assign juice_pos2 = 192;
assign tea_pos2 = 92;
assign coke_pos2 = 182;
assign drop_pos = 176;
assign block1_pos = 620;
assign block2_pos = 620;
assign block3_pos = 620;
assign block4_pos = 620;
assign sm_block_pos = 220;

assign select_top_pos = 620;
assign select_pos1 = 620;
assign select_pos2 = 620;
assign money_top_pos = 620;
assign money_pos1 = 620;
assign money_pos2 = 620;

assign num1_1_pos = 235+44;
assign num1_2_pos = 235+84;
assign num1_3_pos = 235+124;
assign num1_4_pos = 235+164;
assign num1_5_pos = 235+204;
assign num1_6_pos = 235+244;
assign num1_7_pos = 235+284;
assign num1_8_pos = 235+324;
assign num2_1_pos = 235+44;
assign num2_2_pos = 235+84;
assign num2_3_pos = 235+124;
assign num2_4_pos = 235+164;
assign num2_5_pos = 235+204;
assign num2_6_pos = 235+244;
assign num2_7_pos = 235+284;
assign num2_8_pos = 235+324;
assign num3_1_pos = 235+64;
assign num3_2_pos = 235+144;
assign num3_3_pos = 235+224;
assign num3_4_pos = 235+304;
assign num4_1_pos = 235+64;
assign num4_2_pos = 235+144;
assign num4_3_pos = 235+224;
assign num4_4_pos = 235+304;

//left-top
// 15x30 30x30 45x30 75x30
assign rest_pos = 220;
assign num0_1_pos = 20+40;
assign num0_2_pos = 20+70;
assign num0_3_pos = 20+110;
assign num0_4_pos = 20+170;

assign slash1_1_pos = 235+64;
assign slash1_2_pos = 235+144;
assign slash1_3_pos = 235+224;
assign slash1_4_pos = 235+304;

assign slash2_1_pos = 235+64;
assign slash2_2_pos = 235+144;
assign slash2_3_pos = 235+224;
assign slash2_4_pos = 235+304;

// End of the animation clock code.
// ------------------------------------------------------------------------

// ------------------------------------------------------------------------
// Video frame buffer address generation unit (AGU) with scaling control
// Note that the width x height of the fish image is 64x32, when scaled-up
// on the screen, it becomes 128x64. 'pos' specifies the right edge of the
// fish image.

assign vend_region =
          pixel_y >= (vend_vpos<<1) && pixel_y < (vend_vpos+VEND_H)<<1 &&
          (pixel_x + 199) >= vend_pos && pixel_x < vend_pos + 1;

assign water_region2 =
          pixel_y >= (water_vpos2<<1) && pixel_y < (water_vpos2+WATER_H2)<<1 &&
          (pixel_x + 35) >= water_pos2 && pixel_x < water_pos2 + 1;

assign juice_region2 =
          pixel_y >= (juice_vpos2<<1) && pixel_y < (juice_vpos2+JUICE_H2)<<1 &&
          (pixel_x + 43) >= juice_pos2 && pixel_x < juice_pos2 + 1;

assign tea_region2 =
          pixel_y >= (tea_vpos2<<1) && pixel_y < (tea_vpos2+TEA_H2)<<1 &&
          (pixel_x + 43) >= tea_pos2 && pixel_x < tea_pos2 + 1;

assign coke_region2 =
          pixel_y >= (coke_vpos2<<1) && pixel_y < (coke_vpos2+COKE_H2)<<1 &&
          (pixel_x + 23) >= coke_pos2 && pixel_x < coke_pos2 + 1;

assign drop_region =
          pixel_y >= (drop_vpos<<1) && pixel_y < (drop_vpos+DROP_H)<<1 &&
          (pixel_x + 111) >= drop_pos && pixel_x < drop_pos + 1;

assign rest_region =
          pixel_y >= (rest_vpos<<1) && pixel_y < (rest_vpos+SM_BLOCK_H)<<1 &&
          (pixel_x + 199) >= sm_block_pos && pixel_x < sm_block_pos + 1;

assign num0_1_region =
          pixel_y >= (num0_1_vpos<<1) && pixel_y < (num0_1_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num0_1_pos && pixel_x < num0_1_pos + 1;

assign num0_2_region =
          pixel_y >= (num0_2_vpos<<1) && pixel_y < (num0_2_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num0_2_pos && pixel_x < num0_2_pos + 1;

assign num0_3_region =
          pixel_y >= (num0_3_vpos<<1) && pixel_y < (num0_3_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num0_3_pos && pixel_x < num0_3_pos + 1;

assign num0_4_region =
          pixel_y >= (num0_4_vpos<<1) && pixel_y < (num0_4_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num0_4_pos && pixel_x < num0_4_pos + 1;

assign num1_1_region =
          pixel_y >= (num1_1_vpos<<1) && pixel_y < (num1_1_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num1_1_pos && pixel_x < num1_1_pos + 1;

assign num1_2_region =
          pixel_y >= (num1_2_vpos<<1) && pixel_y < (num1_2_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num1_2_pos && pixel_x < num1_2_pos + 1;

assign num1_3_region =
          pixel_y >= (num1_3_vpos<<1) && pixel_y < (num1_3_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num1_3_pos && pixel_x < num1_3_pos + 1;

assign num1_4_region =
          pixel_y >= (num1_4_vpos<<1) && pixel_y < (num1_4_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num1_4_pos && pixel_x < num1_4_pos + 1;

assign num1_5_region =
          pixel_y >= (num1_5_vpos<<1) && pixel_y < (num1_5_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num1_5_pos && pixel_x < num1_5_pos + 1;

assign num1_6_region =
          pixel_y >= (num1_6_vpos<<1) && pixel_y < (num1_6_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num1_6_pos && pixel_x < num1_6_pos + 1;

assign num1_7_region =
          pixel_y >= (num1_7_vpos<<1) && pixel_y < (num1_7_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num1_7_pos && pixel_x < num1_7_pos + 1;

assign num1_8_region =
          pixel_y >= (num1_8_vpos<<1) && pixel_y < (num1_8_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num1_8_pos && pixel_x < num1_8_pos + 1;

assign num2_1_region =
          pixel_y >= (num2_1_vpos<<1) && pixel_y < (num2_1_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num2_1_pos && pixel_x < num2_1_pos + 1;

assign num2_2_region =
          pixel_y >= (num2_2_vpos<<1) && pixel_y < (num2_2_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num2_2_pos && pixel_x < num2_2_pos + 1;

assign num2_3_region =
          pixel_y >= (num2_3_vpos<<1) && pixel_y < (num2_3_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num2_3_pos && pixel_x < num2_3_pos + 1;

assign num2_4_region =
          pixel_y >= (num2_4_vpos<<1) && pixel_y < (num2_4_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num2_4_pos && pixel_x < num2_4_pos + 1;

assign num2_5_region =
          pixel_y >= (num2_5_vpos<<1) && pixel_y < (num2_5_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num2_5_pos && pixel_x < num2_5_pos + 1;

assign num2_6_region =
          pixel_y >= (num2_6_vpos<<1) && pixel_y < (num2_6_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num2_6_pos && pixel_x < num2_6_pos + 1;

assign num2_7_region =
          pixel_y >= (num2_7_vpos<<1) && pixel_y < (num2_7_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num2_7_pos && pixel_x < num2_7_pos + 1;

assign num2_8_region =
          pixel_y >= (num2_8_vpos<<1) && pixel_y < (num2_8_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num2_8_pos && pixel_x < num2_8_pos + 1;

assign num3_1_region =
          pixel_y >= (num3_1_vpos<<1) && pixel_y < (num3_1_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num3_1_pos && pixel_x < num3_1_pos + 1;

assign num3_2_region =
          pixel_y >= (num3_2_vpos<<1) && pixel_y < (num3_2_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num3_2_pos && pixel_x < num3_2_pos + 1;

assign num3_3_region =
          pixel_y >= (num3_3_vpos<<1) && pixel_y < (num3_3_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num3_3_pos && pixel_x < num3_3_pos + 1;

assign num3_4_region =
          pixel_y >= (num3_4_vpos<<1) && pixel_y < (num3_4_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num3_4_pos && pixel_x < num3_4_pos + 1;

assign num4_1_region =
          pixel_y >= (num4_1_vpos<<1) && pixel_y < (num4_1_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num4_1_pos && pixel_x < num4_1_pos + 1;

assign num4_2_region =
          pixel_y >= (num4_2_vpos<<1) && pixel_y < (num4_2_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num4_2_pos && pixel_x < num4_2_pos + 1;

assign num4_3_region =
          pixel_y >= (num4_3_vpos<<1) && pixel_y < (num4_3_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num4_3_pos && pixel_x < num4_3_pos + 1;

assign num4_4_region =
          pixel_y >= (num4_4_vpos<<1) && pixel_y < (num4_4_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= num4_4_pos && pixel_x < num4_4_pos + 1;

assign slash1_1_region =
          pixel_y >= (slash1_1_vpos<<1) && pixel_y < (slash1_1_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= slash1_1_pos && pixel_x < slash1_1_pos + 1;

assign slash1_2_region =
          pixel_y >= (slash1_2_vpos<<1) && pixel_y < (slash1_2_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= slash1_2_pos && pixel_x < slash1_2_pos + 1;

assign slash1_3_region =
          pixel_y >= (slash1_3_vpos<<1) && pixel_y < (slash1_3_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= slash1_3_pos && pixel_x < slash1_3_pos + 1;

assign slash1_4_region =
          pixel_y >= (slash1_4_vpos<<1) && pixel_y < (slash1_4_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= slash1_4_pos && pixel_x < slash1_4_pos + 1;

assign slash2_1_region =
          pixel_y >= (slash2_1_vpos<<1) && pixel_y < (slash2_1_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= slash2_1_pos && pixel_x < slash2_1_pos + 1;

assign slash2_2_region =
          pixel_y >= (slash2_2_vpos<<1) && pixel_y < (slash2_2_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= slash2_2_pos && pixel_x < slash2_2_pos + 1;

assign slash2_3_region =
          pixel_y >= (slash2_3_vpos<<1) && pixel_y < (slash2_3_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= slash2_3_pos && pixel_x < slash2_3_pos + 1;

assign slash2_4_region =
          pixel_y >= (slash2_4_vpos<<1) && pixel_y < (slash2_4_vpos+NUM_H)<<1 &&
          (pixel_x + 13) >= slash2_4_pos && pixel_x < slash2_4_pos + 1;

assign select_top_region =
          pixel_y >= (select_top_vpos<<1) && pixel_y < (select_top_vpos+10)<<1 &&
          (pixel_x + 379) >= select_top_pos && pixel_x < select_top_pos + 1;

assign select_region1 =
          pixel_y >= (select_vpos1<<1) && pixel_y < (select_vpos1+40)<<1 &&
          (pixel_x + 379) >= select_pos1 && pixel_x < select_pos1 + 1;

assign select_region2 =
          pixel_y >= (select_vpos2<<1) && pixel_y < (select_vpos2+40)<<1 &&
          (pixel_x + 379) >= select_pos2 && pixel_x < select_pos2 + 1;

assign money_top_region =
          pixel_y >= (money_top_vpos<<1) && pixel_y < (money_top_vpos+10)<<1 &&
          (pixel_x + 379) >= money_top_pos && pixel_x < money_top_pos + 1;

assign money_region1 =
          pixel_y >= (money_vpos1<<1) && pixel_y < (money_vpos1+40)<<1 &&
          (pixel_x + 379) >= money_pos1 && pixel_x < money_pos1 + 1;

assign money_region2 =
          pixel_y >= (money_vpos2<<1) && pixel_y < (money_vpos2+40)<<1 &&
          (pixel_x + 379) >= money_pos2 && pixel_x < money_pos2 + 1;

assign block1_region =
    (
        (pixel_y == (block1_vpos << 1)) &&
        ((pixel_x + 379) >= block1_pos && pixel_x < block1_pos + 1)
    ) ||
    (
        (pixel_y == ((block1_vpos + BLOCK_H) << 1) - 1) &&
        ((pixel_x + 379) >= block1_pos && pixel_x < block1_pos + 1)
    ) ||
    (
        (pixel_x == block1_pos) &&
        (pixel_y >= (block1_vpos << 1) && pixel_y < (block1_vpos + BLOCK_H) << 1)
    ) ||
    (
        (pixel_x == block1_pos - 2 * BLOCK_W + 1) &&
        (pixel_y >= (block1_vpos << 1) && pixel_y < (block1_vpos + BLOCK_H) << 1)
    );

assign block2_region =
    (
        (pixel_y == (block2_vpos << 1)) &&
        ((pixel_x + 379) >= block2_pos && pixel_x < block2_pos + 1)
    ) ||
    (
        (pixel_y == ((block2_vpos + BLOCK_H) << 1) - 1) &&
        ((pixel_x + 379) >= block2_pos && pixel_x < block2_pos + 1)
    ) ||
    (
        (pixel_x == block2_pos) &&
        (pixel_y >= (block2_vpos << 1) && pixel_y < (block2_vpos + BLOCK_H) << 1)
    ) ||
    (
        (pixel_x == block2_pos - 2 * BLOCK_W + 1) &&
        (pixel_y >= (block2_vpos << 1) && pixel_y < (block2_vpos + BLOCK_H) << 1)
    );

assign block3_region =
    (
        (pixel_y == (block3_vpos << 1)) &&
        ((pixel_x + 379) >= block3_pos && pixel_x < block3_pos + 1)
    ) ||
    (
        (pixel_y == ((block3_vpos + BLOCK_H) << 1) - 1) &&
        ((pixel_x + 379) >= block3_pos && pixel_x < block3_pos + 1)
    ) ||
    (
        (pixel_x == block3_pos) &&
        (pixel_y >= (block3_vpos << 1) && pixel_y < (block3_vpos + BLOCK_H) << 1)
    ) ||
    (
        (pixel_x == block3_pos - 2 * BLOCK_W + 1) &&
        (pixel_y >= (block3_vpos << 1) && pixel_y < (block3_vpos + BLOCK_H) << 1)
    );

assign block4_region =
    (
        (pixel_y == (block4_vpos << 1)) &&
        ((pixel_x + 379) >= block4_pos && pixel_x < block4_pos + 1)
    ) ||
    (
        (pixel_y == ((block4_vpos + BLOCK_H) << 1) - 1) &&
        ((pixel_x + 379) >= block4_pos && pixel_x < block4_pos + 1)
    ) ||
    (
        (pixel_x == block4_pos) &&
        (pixel_y >= (block4_vpos << 1) && pixel_y < (block4_vpos + BLOCK_H) << 1)
    ) ||
    (
        (pixel_x == block4_pos - 2 * BLOCK_W + 1) &&
        (pixel_y >= (block4_vpos << 1) && pixel_y < (block4_vpos + BLOCK_H) << 1)
    );

assign sm_block_region =
    (
        (pixel_y == (sm_block_vpos << 1)) &&
        ((pixel_x + 199) >= sm_block_pos && pixel_x < sm_block_pos + 1)
    ) ||
    (
        (pixel_y == ((sm_block_vpos + SM_BLOCK_H) << 1) - 1) &&
        ((pixel_x + 199) >= sm_block_pos && pixel_x < sm_block_pos + 1)
    ) ||
    (
        (pixel_x == sm_block_pos) &&
        (pixel_y >= (sm_block_vpos << 1) && pixel_y < (sm_block_vpos + SM_BLOCK_H) << 1)
    ) ||
    (
        (pixel_x == sm_block_pos - 2 * SM_BLOCK_W + 1) &&
        (pixel_y >= (sm_block_vpos << 1) && pixel_y < (sm_block_vpos + SM_BLOCK_H) << 1)
    );

function [20:0] select_base_addr;
  input [3:0] tmp_val;
  begin
    case(tmp_val)
      4'd0: select_base_addr = zero_addr;
      4'd1: select_base_addr = one_addr;
      4'd2: select_base_addr = two_addr;
      4'd3: select_base_addr = three_addr;
      4'd4: select_base_addr = four_addr;
      4'd5: select_base_addr = five_addr;
      4'd6: select_base_addr = six_addr;
      4'd7: select_base_addr = seven_addr;
      4'd8: select_base_addr = eight_addr;
      4'd9: select_base_addr = nine_addr;
      default: select_base_addr = zero_addr;
    endcase
  end
endfunction



always @ (posedge clk) begin
  if (~reset_n)
    pixel_vend_addr <= 0;
  else begin
    if (vend_region) begin
      pixel_vend_addr <= ((pixel_y>>1)-vend_vpos)*VEND_W +
                    ((pixel_x +(VEND_W*2-1)-vend_pos)>>1);
    end
    if (water_region2) begin
      pixel_water_addr2 <= ((pixel_y>>1)-water_vpos2)*WATER_W2 +
                    ((pixel_x +(WATER_W2*2-1)-water_pos2)>>1);
    end
    if (juice_region2) begin
      pixel_juice_addr2 <= juice_addr2+((pixel_y>>1)-juice_vpos2)*JUICE_W2 +
                    ((pixel_x +(JUICE_W2*2-1)-juice_pos2)>>1);
    end
    if (tea_region2) begin
      pixel_tea_addr2 <= ((pixel_y>>1)-tea_vpos2)*TEA_W2 +
                    ((pixel_x +(TEA_W2*2-1)-tea_pos2)>>1);
    end
    if (coke_region2) begin
      pixel_coke_addr2 <= coke_addr2+((pixel_y>>1)-coke_vpos2)*COKE_W2 +
                    ((pixel_x +(COKE_W2*2-1)-coke_pos2)>>1);
    end

    if (select_top_region) begin
      pixel_select_top_addr <= select_top_addr + ((pixel_y >> 1) - select_top_vpos) * BLOCK_W +
                            ((pixel_x + (BLOCK_W * 2 - 1) - select_top_pos) >> 1);
    end
    if (select_region1) begin
      pixel_select_addr <= select_addr + ((pixel_y >> 1) - select_vpos1) * BLOCK_W +
                            ((pixel_x + (BLOCK_W * 2 - 1) - select_pos1) >> 1);
    end
    if (select_region2) begin
      pixel_select_addr <= select_addr + 
                            ((pixel_y >> 1) - select_vpos2) * BLOCK_W +
                            ((pixel_x + (BLOCK_W * 2 - 1) - select_pos2) >> 1);
    end

    if (money_top_region) begin
      pixel_money_top_addr <= money_top_addr+((pixel_y >> 1) - money_top_vpos) * BLOCK_W +
                            ((pixel_x + (BLOCK_W * 2 - 1) - money_top_pos) >> 1);
    end
    if (money_region1) begin
      pixel_money_addr <= money_addr + ((pixel_y >> 1) - money_vpos1) * BLOCK_W +
                            ((pixel_x + (BLOCK_W * 2 - 1) - money_pos1) >> 1);
    end
    if (money_region2) begin
      pixel_money_addr <= money_addr + ((pixel_y >> 1) - money_vpos2) * BLOCK_W +
                            ((pixel_x + (BLOCK_W * 2 - 1) - money_pos2) >> 1);
    end

    if (rest_region) begin
      pixel_rest_addr <=  ((pixel_y >> 1) - rest_vpos) * SM_BLOCK_W +
                            ((pixel_x + (SM_BLOCK_W * 2 - 1) - sm_block_pos) >> 1);
    end
    
    if (num0_1_region) begin
      pixel_num_addr <= select_base_addr(mach_coin_one) + 
                            ((pixel_y >> 1) - num0_1_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num0_1_pos) >> 1);
    end

    if (num0_2_region) begin
      pixel_num_addr <= select_base_addr(mach_coin_five) + 
                            ((pixel_y >> 1) - num0_2_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num0_2_pos) >> 1);
    end

    if (num0_3_region) begin
      pixel_num_addr <= select_base_addr(mach_coin_ten) + 
                            ((pixel_y >> 1) - num0_3_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num0_3_pos) >> 1);
    end

    if (num0_4_region) begin
      pixel_num_addr <= select_base_addr(mach_coin_hundred) + 
                            ((pixel_y >> 1) - num0_4_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num0_4_pos) >> 1);
    end

    if (num1_1_region) begin
      pixel_num_addr <= select_base_addr(used_water_num) + 
                            ((pixel_y >> 1) - num1_1_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num1_1_pos) >> 1);
    end
    if (num1_2_region) begin
      pixel_num_addr <= select_base_addr(water_num) + 
                            ((pixel_y >> 1) - num1_2_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num1_2_pos) >> 1);
    end
    if (num1_3_region) begin
      pixel_num_addr <= select_base_addr(used_juice_num) + 
                            ((pixel_y >> 1) - num1_3_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num1_3_pos) >> 1);
    end
    if (num1_4_region) begin
      pixel_num_addr <= select_base_addr(juice_num) + 
                            ((pixel_y >> 1) - num1_4_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num1_4_pos) >> 1);
    end
    if (num1_5_region) begin
      pixel_num_addr <= select_base_addr(used_tea_num) + 
                            ((pixel_y >> 1) - num1_5_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num1_5_pos) >> 1);
    end
    if (num1_6_region) begin
      pixel_num_addr <= select_base_addr(tea_num) + 
                            ((pixel_y >> 1) - num1_6_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num1_6_pos) >> 1);
    end
    if (num1_7_region) begin
      pixel_num_addr <= select_base_addr(used_cola_num) + 
                            ((pixel_y >> 1) - num1_7_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num1_7_pos) >> 1);
    end
    if (num1_8_region) begin
      pixel_num_addr <= select_base_addr(cola_num) + 
                            ((pixel_y >> 1) - num1_8_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num1_8_pos) >> 1);
    end
    if (num2_1_region) begin
      pixel_num_addr <= select_base_addr(used_coin_one) + 
                            ((pixel_y >> 1) - num2_1_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num2_1_pos) >> 1);
    end
    if (num2_2_region) begin
      pixel_num_addr <= select_base_addr(coin_one) + 
                            ((pixel_y >> 1) - num2_2_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num2_2_pos) >> 1);
    end
    if (num2_3_region) begin
      pixel_num_addr <= select_base_addr(used_coin_five) + 
                            ((pixel_y >> 1) - num2_3_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num2_3_pos) >> 1);
    end
    if (num2_4_region) begin
      pixel_num_addr <= select_base_addr(coin_five) + 
                            ((pixel_y >> 1) - num2_4_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num2_4_pos) >> 1);
    end
    if (num2_5_region) begin
      pixel_num_addr <= select_base_addr(used_coin_ten) + 
                            ((pixel_y >> 1) - num2_5_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num2_5_pos) >> 1);
    end
    if (num2_6_region) begin
      pixel_num_addr <= select_base_addr(coin_ten) + 
                            ((pixel_y >> 1) - num2_6_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num2_6_pos) >> 1);
    end
    if (num2_7_region) begin
      pixel_num_addr <= select_base_addr(used_coin_hundred) + 
                            ((pixel_y >> 1) - num2_7_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num2_7_pos) >> 1);
    end
    if (num2_8_region) begin
      pixel_num_addr <= select_base_addr(coin_hundred) + 
                            ((pixel_y >> 1) - num2_8_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num2_8_pos) >> 1);
    end
    if (num3_1_region) begin
      pixel_num_addr <= select_base_addr(ret_coin_one) + 
                            ((pixel_y >> 1) - num3_1_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num3_1_pos) >> 1);
    end
    if (num3_2_region) begin
      pixel_num_addr <= select_base_addr(ret_coin_five) + 
                            ((pixel_y >> 1) - num3_2_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num3_2_pos) >> 1);
    end
    if (num3_3_region) begin
      pixel_num_addr <= select_base_addr(ret_coin_ten) + 
                            ((pixel_y >> 1) - num3_3_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num3_3_pos) >> 1);
    end
    if (num3_4_region) begin
      pixel_num_addr <= select_base_addr(ret_coin_hundred) + 
                            ((pixel_y >> 1) - num3_4_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - num3_4_pos) >> 1);
    end
    // if (num4_1_region) begin
    //   pixel_num_addr <= select_base_addr() + 
    //                         ((pixel_y >> 1) - num4_1_vpos) * NUM_W +
    //                         ((pixel_x + (NUM_W * 2 - 1) - num4_1_pos) >> 1);
    // end
    // if (num4_2_region) begin
    //   pixel_num_addr <= select_base_addr() +
    //                         ((pixel_y >> 1) - num4_2_vpos) * NUM_W +
    //                         ((pixel_x + (NUM_W * 2 - 1) - num4_2_pos) >> 1);
    // end
    // if (num4_3_region) begin
    //   pixel_num_addr <= select_base_addr() +
    //                         ((pixel_y >> 1) - num4_3_vpos) * NUM_W +
    //                         ((pixel_x + (NUM_W * 2 - 1) - num4_3_pos) >> 1);
    // end
    // if (num4_4_region) begin
    //   pixel_num_addr <= select_base_addr() +
    //                         ((pixel_y >> 1) - num4_4_vpos) * NUM_W +
    //                         ((pixel_x + (NUM_W * 2 - 1) - num4_4_pos) >> 1);
    // end
    if (slash1_1_region) begin
      pixel_slash_addr <= slash_addr + ((pixel_y >> 1) - slash1_1_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - slash1_1_pos) >> 1);
    end
    if (slash1_2_region) begin
      pixel_slash_addr <= slash_addr + ((pixel_y >> 1) - slash1_2_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - slash1_2_pos) >> 1);
    end
    if (slash1_3_region) begin
      pixel_slash_addr <= slash_addr + ((pixel_y >> 1) - slash1_3_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - slash1_3_pos) >> 1);
    end
    if (slash1_4_region) begin
      pixel_slash_addr <= slash_addr + ((pixel_y >> 1) - slash1_4_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - slash1_4_pos) >> 1);
    end
    if (slash2_1_region) begin
      pixel_slash_addr <= slash_addr + ((pixel_y >> 1) - slash2_1_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - slash2_1_pos) >> 1);
    end
    if (slash2_2_region) begin
      pixel_slash_addr <= slash_addr + ((pixel_y >> 1) - slash2_2_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - slash2_2_pos) >> 1);
    end
    if (slash2_3_region) begin
      pixel_slash_addr <= slash_addr + ((pixel_y >> 1) - slash2_3_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - slash2_3_pos) >> 1);
    end
    if (slash2_4_region) begin
      pixel_slash_addr <= slash_addr + ((pixel_y >> 1) - slash2_4_vpos) * NUM_W +
                            ((pixel_x + (NUM_W * 2 - 1) - slash2_4_pos) >> 1);
    end
  end
end

// End of the AGU code.
// ------------------------------------------------------------------------

// ------------------------------------------------------------------------
// Send the video data in the sram to the VGA controller
always @(posedge clk) begin
  if (pixel_tick) rgb_reg <= rgb_next;
end

always @(*) begin
  if (~video_on)
    rgb_next = 12'h000; // Synchronization period, must set RGB values to zero.
  else
    // if (drop_region)
    //   rgb_next = 12'hf00;
    if (water_region2 && data_water_out2 != 12'h0f0)
      rgb_next = data_water_out2;
    else if (juice_region2 && data_juice_out2 != 12'h0f0)
      rgb_next = data_juice_out2;
    else if (tea_region2 && data_tea_out2 != 12'h0f0)
      rgb_next = data_tea_out2;
    else if (coke_region2 && data_coke_out2 != 12'h0f0)
      rgb_next = data_coke_out2;
    else if (vend_region && data_vend_out != 12'h0f0)
      rgb_next = data_vend_out;
      // rgb_next = 12'hf00;
    // else if (fish2_region && data_f2_out != 12'h0f0)
    //   rgb_next = data_f2_out;
    // else if (fish3_region && data_f3_out != 12'h0f0)
    //   rgb_next = data_f3_out;
    // if (vend_region)
    //   // rgb_next = data_vend_out;
    //   rgb_next = 12'hf00;
    else if (num0_1_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num0_2_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num0_3_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num0_4_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;

    else if (num1_1_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num1_2_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num1_3_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num1_4_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num1_5_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num1_6_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num1_7_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num1_8_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num2_1_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num2_2_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num2_3_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num2_4_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num2_5_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num2_6_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num2_7_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num2_8_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num3_1_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num3_2_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num3_3_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num3_4_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num4_1_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num4_2_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num4_3_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    else if (num4_4_region && data_num_out != 12'h0f0)
      rgb_next = data_num_out;
    
    else if (slash1_1_region && data_slash_out != 12'h0f0)
      rgb_next = data_slash_out;
    else if (slash1_2_region && data_slash_out != 12'h0f0)
      rgb_next = data_slash_out;
    else if (slash1_3_region && data_slash_out != 12'h0f0)
      rgb_next = data_slash_out;
    else if (slash1_4_region && data_slash_out != 12'h0f0)
      rgb_next = data_slash_out;
    else if (slash2_1_region && data_slash_out != 12'h0f0)
      rgb_next = data_slash_out;
    else if (slash2_2_region && data_slash_out != 12'h0f0)
      rgb_next = data_slash_out;
    else if (slash2_3_region && data_slash_out != 12'h0f0)
      rgb_next = data_slash_out;
    else if (slash2_4_region && data_slash_out != 12'h0f0)
      rgb_next = data_slash_out;

    else if (block1_region)
      rgb_next = 12'h555;
    else if (block2_region)
      rgb_next = 12'h555;
    else if (block3_region)
      rgb_next = 12'h555;
    else if (block4_region)
      rgb_next = 12'h555;
    
    else if (rest_region && data_rest_out != 12'h0f0)
      rgb_next = data_rest_out;

    else if (select_top_region && data_select_top_out != 12'h0f0)
      rgb_next = data_select_top_out;
    else if (select_region1 && data_select_out != 12'h0f0)
      rgb_next = data_select_out;
    else if (select_region2 && data_select_out != 12'h0f0)
      rgb_next = data_select_out;
    else if (money_top_region && data_money_top_out != 12'h0f0)
      rgb_next = data_money_top_out;
    else if (money_region1 && data_money_out != 12'h0f0)
      rgb_next = data_money_out;
    else if (money_region2 && data_money_out != 12'h0f0)
      rgb_next = data_money_out;

    else if (sm_block_region)
      rgb_next = 12'h555;
    else
      rgb_next = 12'hed5;
  
end
// End of the video data display code.
// ------------------------------------------------------------------------

localparam [3:0] 
  S_MAIN_INIT         = 4'd0,
  S_MAIN_BUY          = 4'd1,
  S_MAIN_PAY          = 4'd2,
  S_MAIN_CALC         = 4'd3,
  S_MAIN_DROP         = 4'd4,
  S_MAIN_ERROR        = 4'd5;

reg [3:0] P, P_next;
localparam INIT_DELAY = 100_000; // 1 msec @ 100 MHz
reg [$clog2(INIT_DELAY):0] init_counter;

assign usr_led = P;

reg calc_done;
reg [1:0] refund_valid;

// ------------------------------------------------------------------------
// FSM of the main controller
always @(posedge clk) begin
  if (~reset_n) begin
    // P <= S_MAIN_ADDR; // read samples at 000 first
    P <= S_MAIN_INIT;
  end
  else begin
    P <= P_next;
  end
end

always @(*) begin // FSM next-state logic
  case (P)
      S_MAIN_INIT:
        P_next = (init_counter < INIT_DELAY) ? S_MAIN_BUY : S_MAIN_INIT;
      S_MAIN_BUY:
        P_next = (btn_pressed[3]) ? S_MAIN_PAY : S_MAIN_BUY;
      S_MAIN_PAY:
        P_next = (btn_pressed[3]) ? S_MAIN_CALC : S_MAIN_PAY;
      S_MAIN_CALC: begin
        if (calc_done) begin
          if (refund_valid == 2'b10) begin
            P_next = S_MAIN_DROP;
          end else begin
            P_next = S_MAIN_ERROR;
          end
        end else begin
          P_next = S_MAIN_CALC;
        end
      end
      S_MAIN_DROP:
        P_next = (btn_pressed[3]) ? S_MAIN_INIT : S_MAIN_DROP;
      S_MAIN_ERROR:
        P_next = (btn_pressed[3]) ? S_MAIN_INIT : S_MAIN_ERROR;
      default:
        P_next = S_MAIN_INIT;
  endcase
end

// FSM ouput logic: Fetch the data bus of sram[] for display
// always @(posedge clk) begin
//   if (~reset_n) begin
//     user_data <= 8'b0;
//   end
//   else if (sram_en && !sram_we) user_data <= data_out;
// end
// End of the main controller

// ------------------------------------------------------------------------
// S_MAIN_INIT
always @(posedge clk) begin
  if (P == S_MAIN_INIT) init_counter <= init_counter + 1;
  else init_counter <= 0;
end
// ------------------------------------------------------------------------

localparam WATER_VALUE = 3,
           TEA_VALUE = 5,
           JUICE_VALUE = 10,
           COLA_VALUE = 20;

// S_MAIN_BUY
reg [8:0] total_amount; // item value
reg [3:0] water_num, tea_num, juice_num, cola_num; // we have how many coin
reg [3:0] used_water_num, used_tea_num, used_juice_num, used_cola_num; // we have used how many coin
reg [1:0] item_pointer;
localparam [1:0] CHOOSE_WATER = 2'd0,
                 CHOOSE_TEA = 2'd1,
                 CHOOSE_JUICE = 2'd2,
                 CHOOSE_COLA = 2'd3;

// choose what item
always @(posedge clk) begin
  if (~reset_n)begin
    item_pointer = 0;
  end
  else if (P == S_MAIN_BUY) begin
    if (btn_pressed[1]) begin
      item_pointer = item_pointer - 1;
    end
    else if (btn_pressed[0]) begin
      item_pointer = item_pointer + 1;
    end
  end
end
// add or minus item
// calculate total amount
always @(posedge clk) begin
  if (~reset_n)begin
    water_num <= 8;
    tea_num <= 7;
    juice_num <= 6;
    cola_num <= 9;
    used_water_num <= 0;
    used_tea_num <= 0;
    used_juice_num <= 0;
    used_cola_num <= 0;
    total_amount <= 0;
  end
  else if (P == S_MAIN_BUY) begin 
    if (btn_pressed[2]) begin
      if(usr_sw[0]) begin
        // add item
        case(item_pointer)
          CHOOSE_WATER: begin
            if(used_water_num < water_num)
              used_water_num <= used_water_num + 1;
          end
          CHOOSE_TEA: begin
            if(used_tea_num < tea_num)
              used_tea_num <= used_tea_num + 1;
          end
          CHOOSE_JUICE: begin
            if(used_juice_num < juice_num)
              used_juice_num <= used_juice_num + 1;
          end
          CHOOSE_COLA: begin
            if(used_cola_num < cola_num)
              used_cola_num <= used_cola_num + 1;
          end
        endcase
      end
      else begin
        // minus item
        case(item_pointer)
          CHOOSE_WATER: begin
            if(used_water_num > 0)
              used_water_num <= used_water_num - 1;
          end
          CHOOSE_TEA: begin
            if(used_tea_num > 0)
              used_tea_num <= used_tea_num - 1;
          end
          CHOOSE_JUICE: begin
            if(used_juice_num > 0)
              used_juice_num <= used_juice_num - 1;
          end
          CHOOSE_COLA: begin
            if(used_cola_num > 0)
              used_cola_num <= used_cola_num - 1;
          end
        endcase
      end
    end
    else if (btn_pressed[3]) begin
      total_amount <= used_water_num * WATER_VALUE + used_tea_num * TEA_VALUE+
                      used_juice_num * JUICE_VALUE + used_cola_num * COLA_VALUE;
    end
  end
end
// ------------------------------------------------------------------------

// ------------------------------------------------------------------------
// S_MAIN_PAY
reg [3:0] coin_one, coin_five, coin_ten, coin_hundred; // we have how many coin
reg [3:0] used_coin_one, used_coin_five, used_coin_ten, used_coin_hundred; // we have used how many coin
reg [1:0] coin_pointer; // choose what coin to pay
localparam [1:0] CHOOSE_ONE = 2'd0,
                 CHOOSE_FIVE = 2'd1,
                 CHOOSE_TEN = 2'd2,
                 CHOOSE_HUNDRED = 2'd3;

always @(posedge clk) begin
  if (~reset_n)begin
    coin_pointer = 0;
  end
  else if (P == S_MAIN_PAY) begin
    if (btn_pressed[1]) begin
      coin_pointer <= coin_pointer - 1;
    end
    else if (btn_pressed[0]) begin
      coin_pointer <= coin_pointer + 1;
    end
  end
end

always @(posedge clk) begin
  if (~reset_n)begin
    used_coin_one <= 0;
    used_coin_five <= 0;
    used_coin_ten <= 0;
    used_coin_hundred <= 0;
  end
  else if (P == S_MAIN_PAY) begin
    if (btn_pressed[2]) begin
      if(usr_sw[0]) begin
        // add coin
        case(coin_pointer)
          CHOOSE_ONE: begin
            if(used_coin_one < coin_one)
              used_coin_one <= used_coin_one + 1;
          end
          CHOOSE_FIVE: begin
            if(used_coin_five < coin_five)
              used_coin_five <= used_coin_five + 1;
          end
          CHOOSE_TEN: begin
            if(used_coin_ten < coin_ten)
              used_coin_ten <= used_coin_ten + 1;
          end
          CHOOSE_HUNDRED: begin
            if(used_coin_hundred < coin_hundred)
              used_coin_hundred <= used_coin_hundred + 1;
          end
        endcase
      end
      else begin
        // minus coin
        case(coin_pointer)
          CHOOSE_ONE: begin
            if(used_coin_one > 0)
              used_coin_one <= used_coin_one - 1;
          end
          CHOOSE_FIVE: begin
            if(used_coin_five > 0)
              used_coin_five <= used_coin_five - 1;
          end
          CHOOSE_TEN: begin
            if(used_coin_ten > 0)
              used_coin_ten <= used_coin_ten - 1;
          end
          CHOOSE_HUNDRED: begin
            if(used_coin_hundred > 0)
              used_coin_hundred <= used_coin_hundred - 1;
          end
        endcase
      end
    end
  end
end
// ------------------------------------------------------------------------

// ------------------------------------------------------------------------
// S_MAIN_CALC

reg [7:0] used_total;
reg [3:0] mach_coin_one, mach_coin_five, mach_coin_ten, mach_coin_hundred;
reg [3:0] ret_coin_one, ret_coin_five, ret_coin_ten, ret_coin_hundred;
reg [8:0] refund;

always @ (posedge clk) begin
  if (~reset_n) begin
    ret_coin_one     <= 4'd0;
    ret_coin_five    <= 4'd0;
    ret_coin_ten     <= 4'd0;
    ret_coin_hundred <= 4'd0;
    refund_valid     <= 2'b00;
    calc_done        <= 1'b0;
    coin_one <= 7;
    coin_five <= 4;
    coin_ten <= 6;
    coin_hundred <= 8;
  end else begin
    used_total = used_coin_one * 1 + used_coin_five * 5 + 
                used_coin_ten * 10 + used_coin_hundred * 100;
                    
    if (used_total >= total_amount) begin
        refund = used_total - total_amount;
        
        // Initialize refund coins
        ret_coin_hundred = 4'd0;
        ret_coin_ten     = 4'd0;
        ret_coin_five    = 4'd0;
        ret_coin_one     = 4'd0;
        
        // Calculate hundreds
        if (refund >= 100 && mach_coin_hundred > 0) begin
            ret_coin_hundred = (refund / 100) > mach_coin_hundred ? mach_coin_hundred : (refund / 100);
            refund = refund - ret_coin_hundred * 100;
        end
        
        // Calculate tens
        if (refund >= 10 && mach_coin_ten > 0) begin
            ret_coin_ten = (refund / 10) > mach_coin_ten ? mach_coin_ten : (refund / 10);
            refund = refund - ret_coin_ten * 10;
        end
        
        // Calculate fives
        if (refund >= 5 && mach_coin_five > 0) begin
            ret_coin_five = (refund / 5) > mach_coin_five ? mach_coin_five : (refund / 5);
            refund = refund - ret_coin_five * 5;
        end
        
        // Calculate ones
        if (refund >= 1 && mach_coin_one > 0) begin
            ret_coin_one = (refund / 1) > mach_coin_one ? mach_coin_one : (refund / 1);
            refund = refund - ret_coin_one * 1;
        end
        
        // Check if refund was successfully calculated
        if (refund == 0) begin
            refund_valid <= 2'b10;
            // Update machine coins
            mach_coin_hundred <= mach_coin_hundred - ret_coin_hundred + used_coin_hundred;
            mach_coin_ten     <= mach_coin_ten - ret_coin_ten + used_coin_ten;
            mach_coin_five    <= mach_coin_five - ret_coin_five + used_coin_five;
            mach_coin_one     <= mach_coin_one - ret_coin_one + used_coin_one;
            coin_hundred      <= coin_hundred - used_coin_hundred + ret_coin_hundred;
            coin_ten          <= coin_ten - used_coin_ten + ret_coin_ten;
            coin_five         <= coin_five - used_coin_five + ret_coin_five;
            coin_one          <= coin_one - used_coin_one + ret_coin_one;
            calc_done <= 1'b1;
        end else begin
            // Not enough coins to provide exact refund
            ret_coin_hundred = 4'd0;
            ret_coin_ten     = 4'd0;
            ret_coin_five    = 4'd0;
            ret_coin_one     = 4'd0;
            refund_valid     <= 2'b01;
            calc_done <= 1'b1;
        end
    end else begin
        // Not enough money inserted
        ret_coin_hundred = 4'd0;
        ret_coin_ten     = 4'd0;
        ret_coin_five    = 4'd0;
        ret_coin_one     = 4'd0;
        refund_valid     <= 2'b00;
        calc_done <= 1'b1;
    end
  end
end

// ------------------------------------------------------------------------

// ------------------------------------------------------------------------
// S_MAIN_DROP

// ------------------------------------------------------------------------

// ------------------------------------------------------------------------
// S_MAIN_ERROR

// ------------------------------------------------------------------------

endmodule
