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
reg  [31:0] water_drop_clock;
reg  [31:0] tea_drop_clock;
reg  [31:0] juice_drop_clock;
reg  [31:0] coke_drop_clock;
// vending machine item
wire [9:0]  vend_pos;
wire        vend_region;

wire [9:0]  vending_water_pos;
wire        vending_water_region;

wire [9:0]  vending_juice_pos;
wire        vending_juice_region;

wire [9:0]  vending_tea_pos;
wire        vending_tea_region;

wire [9:0]  vending_coke_pos;
wire        vending_coke_region;

wire [9:0]  drop_pos;
wire        drop_region;
// falling item var
wire [9:0]  drop_water_pos;
wire        fall_water_region;

wire [9:0]  drop_tea_pos;
wire        fall_tea_region;

wire [9:0]  drop_juice_pos;
wire        fall_juice_region;

wire [9:0]  drop_coke_pos;
wire        fall_coke_region;

// declare SRAM control signals
wire [20:0] sram_f1_addr;
wire [11:0] data_f1_in;
wire [11:0] data_f1_out;

wire [20:0] sram_vend_addr;
wire [11:0] data_vend_in;
wire [11:0] data_vend_out;
// drop item sram
wire [20:0] sram_water_addr;
wire [11:0] data_water_in;
wire [11:0] data_water_out;

wire [20:0] sram_tea_addr;
wire [11:0] data_tea_in;
wire [11:0] data_tea_out;

wire [20:0] sram_juice_addr;
wire [11:0] data_juice_in;
wire [11:0] data_juice_out;

wire [20:0] sram_coke_addr;
wire [11:0] data_coke_in;
wire [11:0] data_coke_out;

// vending item sram
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

wire        sram_we, sram_en;

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

reg  [20:0] pixel_drop_addr;
// drop
reg  [20:0] pixel_water_addr;
reg  [20:0] pixel_tea_addr;
reg  [20:0] pixel_juice_addr;
reg  [20:0] pixel_coke_addr;
// vending
reg  [20:0] pixel_water_addr2;
reg  [20:0] pixel_juice_addr2;
reg  [20:0] pixel_tea_addr2;
reg  [20:0] pixel_coke_addr2;
// Declare the video buffer size
localparam VBUF_W = 320; // video buffer width
localparam VBUF_H = 240; // video buffer height

// Set parameters for the images

localparam vend_vpos   = 10;
localparam VEND_W      = 100;
localparam VEND_H      = 170;
reg [20:0] vend_addr;

localparam drop_vpos   = 145;
localparam DROP_W      = 56;
localparam DROP_H      = 13;
reg [20:0] drop_addr;

localparam WATER_W      = 18;
localparam WATER_H      = 27;
reg [20:0] water_addr;

localparam TEA_W      = 22;
localparam TEA_H      = 18;
reg [20:0] tea_addr;

localparam JUICE_W      = 22;
localparam JUICE_H      = 27;
reg [20:0] juice_addr;

localparam COKE_W      = 12;
localparam COKE_H      = 24;
reg [20:0] coke_addr;

wire [3:0]  btn_level, btn_pressed;
reg  [3:0]  prev_btn_level;

reg [9:0] drop_water_vpos;
reg [9:0] drop_tea_vpos;
reg [9:0] drop_juice_vpos;
reg [9:0] drop_coke_vpos;

// Initializes the fish images starting addresses.
// Note: System Verilog has an easier way to initialize an array,
//       but we are using Verilog 2001 :(

localparam vending_water_vpos   = 42;
localparam vending_juice_vpos   = 50;
localparam vending_tea_vpos   = 105;
localparam vending_coke_vpos   = 107;

reg [20:0] water_addr2;
reg [20:0] juice_addr2;
reg [20:0] tea_addr2;
reg [20:0] coke_addr2;

initial begin
  water_addr2 = 0;
  juice_addr2 = WATER_W * WATER_H;
  tea_addr2 = 0;
  coke_addr2 = TEA_W * TEA_H;
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

sram #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(VEND_W*VEND_H), .FILE("images.mem"))
  ram_1 (.clk(clk), .we(sram_we), .en(sram_en),
          .addr_1(sram_vend_addr), .data_i_1(data_vend_in), .data_o_1(data_vend_out),
          .addr_2(sram_f1_addr), .data_i_2(data_f1_in), .data_o_2(data_f1_out));

// vending item sram
sram #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(WATER_W*WATER_H+JUICE_W*JUICE_H), .FILE("images4.mem"))
  ram_4 (.clk(clk), .we(sram_we), .en(sram_en),
          .addr_1(sram_water_addr2), .data_i_1(data_water_in2), .data_o_1(data_water_out2),
          .addr_2(sram_juice_addr2), .data_i_2(data_juice_in2), .data_o_2(data_juice_out2));

sram #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(TEA_W*TEA_H+COKE_W*COKE_H), .FILE("images5.mem"))
  ram_5 (.clk(clk), .we(sram_we), .en(sram_en),
          .addr_1(sram_tea_addr2), .data_i_1(data_tea_in2), .data_o_1(data_tea_out2),
          .addr_2(sram_coke_addr2), .data_i_2(data_coke_in2), .data_o_2(data_coke_out2));

// dropping item sram
sram #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(WATER_W*WATER_H+JUICE_W*JUICE_H), .FILE("images7.mem"))
  ram_7 (.clk(clk), .we(sram_we), .en(sram_en),
          .addr_1(sram_water_addr), .data_i_1(data_water_in), .data_o_1(data_water_out),
          .addr_2(sram_juice_addr), .data_i_2(data_juice_in), .data_o_2(data_juice_out));

sram #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(TEA_W*TEA_H+COKE_W*COKE_H), .FILE("images8.mem"))
  ram_8 (.clk(clk), .we(sram_we), .en(sram_en),
          .addr_1(sram_tea_addr), .data_i_1(data_tea_in), .data_o_1(data_tea_out),
          .addr_2(sram_coke_addr), .data_i_2(data_coke_in), .data_o_2(data_coke_out));
// assign sram_we = usr_sw[0]; // In this demo, we do not write the SRAM. However, if
//                                   // you set 'sram_we' to 0, Vivado fails to synthesize
//                                   // ram0 as a BRAM -- this is a bug in Vivado.
// assign sram_en = 1;               // Here, we always enable the SRAM block.
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

// drop
assign sram_water_addr = pixel_water_addr;
assign data_water_in = 12'h000;
assign sram_juice_addr = pixel_juice_addr;
assign data_juice_in = 12'h000;
assign sram_tea_addr = pixel_tea_addr;
assign data_tea_in = 12'h000;
assign sram_coke_addr = pixel_coke_addr;
assign data_coke_in = 12'h000;
// vending
assign sram_water_addr2 = pixel_water_addr2;
assign data_water_in2 = 12'h000;
assign sram_juice_addr2 = pixel_juice_addr2;
assign data_juice_in2 = 12'h000;
assign sram_tea_addr2 = pixel_tea_addr2;
assign data_tea_in2 = 12'h000;
assign sram_coke_addr2 = pixel_coke_addr2;
assign data_coke_in2 = 12'h000;

// End of the SRAM memory block.
// ------------------------------------------------------------------------

// VGA color pixel generator
assign {VGA_RED, VGA_GREEN, VGA_BLUE} = rgb_reg;

// ------------------------------------------------------------------------
// An animation clock for the motion of the fish, upper bits of the
// fish clock is the x position of the fish on the VGA screen.
// Note that the fish will move one screen pixel every 2^20 clock cycles,
// or 10.49 msec

assign vend_pos = 220;
assign vending_water_pos = 88;
assign vending_juice_pos = 192;
assign vending_tea_pos = 92;
assign vending_coke_pos = 182;
assign drop_pos = 176;

assign drop_water_pos = water_pos_reg;
assign drop_tea_pos = tea_pos_reg; // right bound
assign drop_juice_pos = juice_pos_reg; // right bound
assign drop_coke_pos = coke_pos_reg; // right bound

// water drop clock control
reg water_drop_speed;
always @(posedge clk) begin
  if(~reset_n) begin
    water_drop_clock <= 0;
  end
  else if (P == S_MAIN_DROP && remain_water_num > 0) begin
    if(water_drop_speed == 1 || drop_water_vpos > 160) begin
      water_drop_clock <= 0;
    end
    else if(drop_water_vpos > 160) begin
      water_drop_clock <= 0;
    end
    else begin
      water_drop_clock <= water_drop_clock + 8;
    end
  end
  else begin
    water_drop_clock <= 0;
  end
end
// water drop speed control
always @(posedge clk) begin
  if(~reset_n) begin
    water_drop_speed <= 0;
  end
  else if (P == S_MAIN_DROP && remain_water_num > 0) begin
    if(water_drop_speed == 1) begin
      water_drop_speed <= 0;
    end
    else if(water_drop_clock[26:25] == 1) begin
      water_drop_speed <= 1;
    end
  end
  else begin
    water_drop_speed <= 0;
  end
end
// water drop vpos control
always @(posedge clk) begin
    if (~reset_n) begin
      drop_water_vpos <= 10'd118;
    end else begin
      if (P == S_MAIN_DROP && remain_water_num > 0) begin
        if(drop_water_vpos > 160) begin
          drop_water_vpos <= 10'd118;
        end
        else begin
          drop_water_vpos <= drop_water_vpos + water_drop_speed;
        end
      end
      else begin
        drop_water_vpos <= 10'd118;
      end
  end
end
// water random x control
reg [7:0] lfsr;
always @(posedge clk or negedge reset_n) begin
  if (~reset_n)
    lfsr <= 8'hA5;
  else
    lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5]};
end

wire [5:0] rand_val = lfsr[5:0];
wire [5:0] offset = rand_val % 51;
reg [9:0] water_pos_reg;
always @(posedge clk or negedge reset_n) begin
  if (~reset_n) begin
    water_pos_reg <= 141;
  end else if (drop_water_vpos > 160) begin
    water_pos_reg <= 126 + offset;
  end
end
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
// juice drop clock control
reg juice_drop_speed;
always @(posedge clk) begin
  if(~reset_n) begin
    juice_drop_clock <= 0;
  end
  else if (P == S_MAIN_DROP && remain_juice_num > 0 && remain_water_num == 0) begin
    if(juice_drop_speed == 1 || drop_juice_vpos > 160) begin
      juice_drop_clock <= 0;
    end
    else if(drop_juice_vpos > 160) begin
      juice_drop_clock <= 0;
    end
    else begin
      juice_drop_clock <= juice_drop_clock + 8;
    end
  end
  else begin
    juice_drop_clock <= 0;
  end
end
// juice drop speed control
always @(posedge clk) begin
  if(~reset_n) begin
    juice_drop_speed <= 0;
  end
  else if (P == S_MAIN_DROP && remain_juice_num > 0 && remain_water_num == 0) begin
    if(juice_drop_speed == 1) begin
      juice_drop_speed <= 0;
    end
    else if(juice_drop_clock[26:25] == 1) begin
      juice_drop_speed <= 1;
    end
  end
  else begin
    juice_drop_speed <= 0;
  end
end
// juice drop vpos control
always @(posedge clk) begin
    if (~reset_n) begin
      drop_juice_vpos <= 10'd118;
    end else begin
      if (P == S_MAIN_DROP && remain_juice_num > 0 && remain_water_num == 0) begin
        if(drop_juice_vpos > 160) begin
          drop_juice_vpos <= 10'd118;
        end
        else begin
          drop_juice_vpos <= drop_juice_vpos + juice_drop_speed;
        end
      end
      else begin
        drop_juice_vpos <= 10'd118;
      end
  end
end
// juice random x control
reg [9:0] juice_pos_reg;
always @(posedge clk or negedge reset_n) begin
  if (~reset_n) begin
    juice_pos_reg <= 176;
  end else if (drop_juice_vpos > 160) begin
    juice_pos_reg <= 126 + offset;
  end
end
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
// tea drop clock control
reg tea_drop_speed;
always @(posedge clk) begin
  if(~reset_n) begin
    tea_drop_clock <= 0;
  end
  else if (P == S_MAIN_DROP && remain_tea_num > 0 && remain_water_num == 0 && remain_juice_num == 0) begin
    if(tea_drop_speed == 1 || drop_tea_vpos > 160) begin
      tea_drop_clock <= 0;
    end
    else if(drop_tea_vpos > 160) begin
      tea_drop_clock <= 0;
    end
    else begin
      tea_drop_clock <= tea_drop_clock + 8;
    end
  end
  else begin
    tea_drop_clock <= 0;
  end
end
// tea drop speed control
always @(posedge clk) begin
  if(~reset_n) begin
    tea_drop_speed <= 0;
  end
  else if (P == S_MAIN_DROP && remain_tea_num > 0 && remain_water_num == 0 && remain_juice_num == 0) begin
    if(tea_drop_speed == 1) begin
      tea_drop_speed <= 0;
    end
    else if(tea_drop_clock[26:25] == 1) begin
      tea_drop_speed <= 1;
    end
  end
  else begin
    tea_drop_speed <= 0;
  end
end
// water drop vpos control
always @(posedge clk) begin
    if (~reset_n) begin
      drop_tea_vpos <= 10'd127;
    end else begin
      if (P == S_MAIN_DROP && remain_tea_num > 0 && remain_water_num == 0 && remain_juice_num == 0) begin
        if(drop_tea_vpos > 160) begin
          drop_tea_vpos <= 10'd127;
        end
        else begin
          drop_tea_vpos <= drop_tea_vpos + tea_drop_speed;
        end
      end
      else begin
        drop_tea_vpos <= 10'd127;
      end
  end
end
// tea random x control
reg [9:0] tea_pos_reg;
always @(posedge clk or negedge reset_n) begin
  if (~reset_n) begin
    tea_pos_reg <= 158;
  end else if (drop_tea_vpos > 160) begin
    tea_pos_reg <= 126 + offset;
  end
end
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
// coke drop clock control
reg coke_drop_speed;
always @(posedge clk) begin
  if(~reset_n) begin
    coke_drop_clock <= 0;
  end
  else if (P == S_MAIN_DROP && remain_coke_num > 0 && remain_water_num == 0 && remain_tea_num == 0 && remain_juice_num == 0) begin
    if(coke_drop_speed == 1 || drop_coke_vpos > 160) begin
      coke_drop_clock <= 0;
    end
    else if(drop_coke_vpos > 160) begin
      coke_drop_clock <= 0;
    end
    else begin
      coke_drop_clock <= coke_drop_clock + 8;
    end
  end
  else begin
    coke_drop_clock <= 0;
  end
end
// coke drop speed control
always @(posedge clk) begin
  if(~reset_n) begin
    coke_drop_speed <= 0;
  end
  else if (P == S_MAIN_DROP && remain_coke_num > 0 && remain_water_num == 0 && remain_tea_num == 0 && remain_juice_num == 0) begin
    if(coke_drop_speed == 1) begin
      coke_drop_speed <= 0;
    end
    else if(coke_drop_clock[26:25] == 1) begin
      coke_drop_speed <= 1;
    end
  end
  else begin
    coke_drop_speed <= 0;
  end
end
// coke drop vpos control
always @(posedge clk) begin
    if (~reset_n) begin
      drop_coke_vpos <= 10'd121;
    end else begin
      if (P == S_MAIN_DROP && remain_coke_num > 0 && remain_water_num == 0 && remain_tea_num == 0 && remain_juice_num == 0) begin
        if(drop_coke_vpos > 160) begin
          drop_coke_vpos <= 10'd121;
        end
        else begin
          drop_coke_vpos <= drop_coke_vpos + coke_drop_speed;
        end
      end
      else begin
        drop_coke_vpos <= 10'd121;
      end
  end
end
// juice random x control
reg [9:0] coke_pos_reg;
always @(posedge clk or negedge reset_n) begin
  if (~reset_n) begin
    coke_pos_reg <= 137;
  end else if (drop_coke_vpos > 160) begin
    coke_pos_reg <= 126 + offset;
  end
end
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

assign vending_water_region =
          pixel_y >= (vending_water_vpos<<1) && pixel_y < (vending_water_vpos + WATER_H)<<1 &&
          (pixel_x + 35) >= vending_water_pos && pixel_x < vending_water_pos + 1;

assign vending_juice_region =
          pixel_y >= (vending_juice_vpos<<1) && pixel_y < (vending_juice_vpos + JUICE_H)<<1 &&
          (pixel_x + 43) >= vending_juice_pos && pixel_x < vending_juice_pos + 1;

assign vending_tea_region =
          pixel_y >= (vending_tea_vpos<<1) && pixel_y < (vending_tea_vpos + TEA_H)<<1 &&
          (pixel_x + 43) >= vending_tea_pos && pixel_x < vending_tea_pos + 1;

assign vending_coke_region =
          pixel_y >= (vending_coke_vpos<<1) && pixel_y < (vending_coke_vpos + COKE_H)<<1 &&
          (pixel_x + 23) >= vending_coke_pos && pixel_x < vending_coke_pos + 1;

assign drop_region =
          pixel_y >= (drop_vpos<<1) && pixel_y < (drop_vpos+DROP_H)<<1 &&
          (pixel_x + 111) >= drop_pos && pixel_x < drop_pos + 1;

assign fall_water_region =
          pixel_y >= (drop_water_vpos<<1) && 
          pixel_y < ((drop_water_vpos + WATER_H)<<1) &&
          (pixel_x + 35) >= drop_water_pos && pixel_x < (drop_water_pos + 1);

assign fall_tea_region =
          pixel_y >= (drop_tea_vpos<<1) && 
          pixel_y < ((drop_tea_vpos + TEA_H)<<1) &&
          (pixel_x + 43) >= drop_tea_pos && pixel_x < (drop_tea_pos + 1);

assign fall_juice_region =
          pixel_y >= (drop_juice_vpos<<1) && 
          pixel_y < ((drop_juice_vpos + JUICE_H)<<1) &&
          (pixel_x + 43) >= drop_juice_pos && pixel_x < (drop_juice_pos + 1);

assign fall_coke_region =
          pixel_y >= (drop_coke_vpos<<1) && 
          pixel_y < ((drop_coke_vpos + COKE_H)<<1) &&
          (pixel_x + 23) >= drop_coke_pos && pixel_x < (drop_coke_pos + 1);

always @ (posedge clk) begin
  if (~reset_n)
    pixel_vend_addr <= 0;
  else begin
    if (vend_region) begin
      pixel_vend_addr <= ((pixel_y>>1) - vend_vpos)*VEND_W +
                    ((pixel_x +(VEND_W*2-1)-vend_pos)>>1);
    end

    if (fall_water_region) begin
      pixel_water_addr <= ((pixel_y>>1) - drop_water_vpos)*WATER_W +
                    ((pixel_x + (WATER_W*2-1) - drop_water_pos)>>1);
    end
    if (fall_tea_region) begin
      pixel_tea_addr <= ((pixel_y>>1) - drop_tea_vpos)*TEA_W +
                    ((pixel_x + (TEA_W*2-1) - drop_tea_pos)>>1);
    end
    if (fall_juice_region) begin
      pixel_juice_addr <= juice_addr2 + ((pixel_y>>1) - drop_juice_vpos)*JUICE_W +
                    ((pixel_x + (JUICE_W*2-1) - drop_juice_pos)>>1);
    end
    if (fall_coke_region) begin
      pixel_coke_addr <= coke_addr2 + ((pixel_y>>1) - drop_coke_vpos)*COKE_W +
                    ((pixel_x + (COKE_W*2-1) - drop_coke_pos)>>1);
    end
    if (vending_water_region) begin
      pixel_water_addr2 <= ((pixel_y>>1)-vending_water_vpos)*WATER_W +
                    ((pixel_x +(WATER_W*2-1)-vending_water_pos)>>1);
    end
    if (vending_juice_region) begin
      pixel_juice_addr2 <= juice_addr2+((pixel_y>>1)-vending_juice_vpos)*JUICE_W +
                    ((pixel_x +(JUICE_W*2-1)-vending_juice_pos)>>1);
    end
    if (vending_tea_region) begin
      pixel_tea_addr2 <= ((pixel_y>>1)-vending_tea_vpos)*TEA_W +
                    ((pixel_x +(TEA_W*2-1)-vending_tea_pos)>>1);
    end
    if (vending_coke_region) begin
      pixel_coke_addr2 <= coke_addr2+((pixel_y>>1)-vending_coke_vpos)*COKE_W +
                    ((pixel_x +(COKE_W*2-1)-vending_coke_pos)>>1);
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
    if (drop_region && fall_water_region && data_water_out != 12'h0f0)
      rgb_next = data_water_out;
    else if (drop_region && fall_tea_region && data_tea_out != 12'h0f0)
      rgb_next = data_tea_out;
    else if (drop_region && fall_juice_region && data_juice_out != 12'h0f0)
      rgb_next = data_juice_out;
    else if (drop_region && fall_coke_region && data_coke_out != 12'h0f0)
      rgb_next = data_coke_out;

    else if (vending_water_region && data_water_out2 != 12'h0f0)
      rgb_next = data_water_out2;
    else if (vending_juice_region && data_juice_out2 != 12'h0f0)
      rgb_next = data_juice_out2;
    else if (vending_tea_region && data_tea_out2 != 12'h0f0)
      rgb_next = data_tea_out2;
    else if (vending_coke_region && data_coke_out2 != 12'h0f0)
      rgb_next = data_coke_out2;

    else if (vend_region && data_vend_out != 12'h0f0)
      rgb_next = data_vend_out;
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
        P_next = (btn_pressed[3]) ? S_MAIN_DROP : S_MAIN_PAY;
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

// End of the main controller

// ------------------------------------------------------------------------
// S_MAIN_INIT
always @(posedge clk) begin
  if (P == S_MAIN_INIT) init_counter <= init_counter + 1;
  else init_counter <= 0;
end
// ------------------------------------------------------------------------

localparam WATER_VALUE = 9,
           JUICE_VALUE = 5,
           TEA_VALUE = 4,
           COKE_VALUE = 1;

// S_MAIN_BUY
reg [8:0] total_amount; // item value
reg [3:0] water_num, tea_num, juice_num, coke_num; // we have how many coin
reg [3:0] used_water_num, used_tea_num, used_juice_num, used_coke_num; // we have used how many coin
reg [1:0] item_pointer;
localparam [1:0] CHOOSE_WATER = 2'd0,
                 CHOOSE_JUICE = 2'd1,
                 CHOOSE_TEA   = 2'd2,
                 CHOOSE_coke  = 2'd3;

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
    water_num <= 9;
    tea_num <= 9;
    juice_num <= 9;
    coke_num <= 9;
    used_water_num <= 0;
    used_tea_num <= 0;
    used_juice_num <= 0;
    used_coke_num <= 0;
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
          CHOOSE_coke: begin
            if(used_coke_num < coke_num)
              used_coke_num <= used_coke_num + 1;
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
          CHOOSE_coke: begin
            if(used_coke_num > 0)
              used_coke_num <= used_coke_num - 1;
          end
        endcase
      end
    end
    else if (btn_pressed[3]) begin
      total_amount <= used_water_num * WATER_VALUE + used_tea_num * TEA_VALUE+
                      used_juice_num * JUICE_VALUE + used_coke_num * COKE_VALUE;
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
    mach_coin_one    <= 4'd9;
    mach_coin_five   <= 4'd9;
    mach_coin_ten    <= 4'd9;
    mach_coin_hundred<= 4'd9;
    coin_one <= 9;
    coin_five <= 9;
    coin_ten <= 9;
    coin_hundred <= 9;
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
reg [3:0] what_item_fall;
reg [3:0] remain_water_num, 
          remain_tea_num, 
          remain_juice_num, 
          remain_coke_num; 
          // how many item remain to fall
localparam [1:0] FALL_WATER = 2'd0,
                 FALL_TEA = 2'd1,
                 FALL_JUICE = 2'd2,
                 FALL_COKE = 2'd3;

// judge whether the item touched the bottom
always @(posedge clk) begin
  if(~reset_n) begin
    remain_water_num <= 0;
    remain_tea_num <= 0;
    remain_juice_num <= 0;
    remain_coke_num <= 0;
  end
  // set remain constant
  else if (P == S_MAIN_PAY && P_next == S_MAIN_DROP) begin
    remain_water_num <= used_water_num;
    remain_tea_num <= used_tea_num;
    remain_juice_num <= used_juice_num;
    remain_coke_num <= used_coke_num;
  end
  // remain constant minus
  else if (P == S_MAIN_DROP) begin
    if(drop_water_vpos > 160 || drop_tea_vpos > 160 || drop_juice_vpos > 160 || drop_coke_vpos > 160) begin
      case(what_item_fall)
      FALL_WATER: begin
        remain_water_num = remain_water_num - 1;
      end
      FALL_TEA: begin
        remain_tea_num = remain_tea_num - 1;
      end
      FALL_JUICE: begin
        remain_juice_num = remain_juice_num - 1;
      end
      FALL_COKE: begin
        remain_coke_num = remain_coke_num - 1;
      end
      endcase
    end
  end
end

// control what item to fall
// need modify: item image
always @(posedge clk) begin
  if(~reset_n) begin
    what_item_fall <= 0;
  end
  else if (P == S_MAIN_DROP) begin
    if (remain_water_num > 0) begin
      // use water image to fall
      what_item_fall <= FALL_WATER;
    end
    else if (remain_juice_num > 0) begin
      // use tea image to fall
      what_item_fall <= FALL_JUICE;
    end
    else if (remain_tea_num > 0) begin
      // use juice image to fall
      what_item_fall <= FALL_TEA;
    end
    else if (remain_coke_num > 0) begin
      // use coke image to fall
      what_item_fall <= FALL_COKE;
    end
  end
end

// ------------------------------------------------------------------------

// ------------------------------------------------------------------------
// S_MAIN_ERROR

// ------------------------------------------------------------------------

endmodule
