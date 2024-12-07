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
// reg  [35:0] fish2_clock;
// reg  [35:0] fish3_clock;
// wire [9:0]  fish1_pos;
// wire [9:0]  fish2_pos;
// wire [9:0]  fish3_pos;
// wire        fish1_region;
// wire        fish2_region;
// wire        fish3_region;

wire [9:0]  vend_pos;
wire        vend_region;

wire [9:0]  drop_pos;
wire        drop_region;

// falling item var
wire [9:0]  water_pos;
wire        fall_water_region;

wire [9:0]  tea_pos;
wire        fall_tea_region;

wire [9:0]  juice_pos;
wire        fall_juice_region;

wire [9:0]  coke_pos;
wire        fall_coke_region;

// declare SRAM control signals
wire [20:0] sram_f1_addr;
wire [11:0] data_f1_in;
wire [11:0] data_f1_out;

// wire [20:0] sram_f2_addr;
// wire [11:0] data_f2_in;
// wire [11:0] data_f2_out;

// wire [20:0] sram_f3_addr;
// wire [11:0] data_f3_in;
// wire [11:0] data_f3_out;

// wire [20:0] sram_bg_addr;
// wire [11:0] data_bg_in;
// wire [11:0] data_bg_out;

wire [20:0] sram_vend_addr;
wire [11:0] data_vend_in;
wire [11:0] data_vend_out;

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
// reg  [20:0] pixel_f1_addr;
// reg  [20:0] pixel_f2_addr;
// reg  [20:0] pixel_f3_addr;
// reg  [20:0] pixel_bg_addr;

reg  [20:0] pixel_vend_addr;
reg  [20:0] pixel_drop_addr;
reg  [20:0] pixel_water_addr;
reg  [20:0] pixel_tea_addr;
reg  [20:0] pixel_juice_addr;
reg  [20:0] pixel_coke_addr;

// Declare the video buffer size
localparam VBUF_W = 320; // video buffer width
localparam VBUF_H = 240; // video buffer height

// Set parameters for the fish images
// localparam fish1_vpos   = 32; // Vertical location of the fish in the sea image.
// localparam FISH1_W      = 64; // Width of the fish.
// localparam FISH1_H      = 32; // Height of the fish.
// reg [20:0] fish1_addr[0:7];   // Address array for up to 8 fish images.

// // localparam fish2_vpos   = 40;
// localparam FISH2_W      = 64;
// localparam FISH2_H      = 44;
// reg [20:0] fish2_addr[0:3];

// // localparam fish3_vpos   = 128;
// localparam FISH3_W      = 64;
// localparam FISH3_H      = 72;
// reg [20:0] fish3_addr[0:3];

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

localparam TEA_W      = 18;
localparam TEA_H      = 27;
reg [20:0] tea_addr;

localparam JUICE_W      = 18;
localparam JUICE_H      = 27;
reg [20:0] juice_addr;

localparam COKE_W      = 18;
localparam COKE_H      = 27;
reg [20:0] coke_addr;

wire [3:0]  btn_level, btn_pressed;
reg  [3:0]  prev_btn_level;

// reg [2:0] speed_level[0:2];

// reg [2:0] current_fish = 3'd0;

reg [9:0] water_vpos;
reg [9:0] tea_vpos;
reg [9:0] juice_vpos;
reg [9:0] coke_vpos;
// reg [7:0] fish2_vpos = 8'd80; // Vertical position of fish2
// reg [7:0] fish3_vpos = 8'd120; // Vertical position of fish3
// Direction: 0 = left, 1 = right
// reg fish1_dir;
// reg fish2_dir;
// reg fish3_dir;

// reg [3:0] now;

// reg [4:0] pwm_counter;

// Initializes the fish images starting addresses.
// Note: System Verilog has an easier way to initialize an array,
//       but we are using Verilog 2001 :(
// integer k;
// initial begin
//   for (k = 0; k < 8; k = k + 1) begin
//     fish1_addr[k] = VBUF_W * VBUF_H + FISH1_W * FISH1_H * k;
//   end
//   for (k = 0; k < 4; k = k + 1) begin
//     fish2_addr[k] = FISH2_W * FISH2_H * k;
//     fish3_addr[k] = FISH2_W * FISH2_H * 4 + FISH3_W * FISH3_H * k;
//   end
// end

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

// reg fish1_speed_chg;
// reg fish2_speed_chg;
// reg fish3_speed_chg;

// always @(posedge clk or negedge reset_n) begin
//   if (~reset_n) begin
//     speed_level[0] <= 3'd0;
//     speed_level[1] <= 3'd1;
//     speed_level[2] <= 3'd2;
//     current_fish <= 3'd0;
//     fish1_speed_chg <= 0;
//     fish2_speed_chg <= 0;
//     fish3_speed_chg <= 0;
//   end else begin
//     // Handle Speed Control (Button0)
//     if (btn_pressed[0]) begin
//       if (speed_level[current_fish] < 3'd4)
//         speed_level[current_fish] <= speed_level[current_fish] + 1'b1;
//       else
//         speed_level[current_fish] <= 3'd0;
//       if (current_fish == 3'd0)
//         fish1_speed_chg <= 1;
//       if (current_fish == 3'd1)
//         fish2_speed_chg <= 1;
//       if (current_fish == 3'd2)
//         fish3_speed_chg <= 1;
//     end

//     if (fish1_speed_chg)
//       fish1_speed_chg <= 0;
//     if (fish2_speed_chg)
//       fish2_speed_chg <= 0;
//     if (fish3_speed_chg)
//       fish3_speed_chg <= 0;
    
//     // Handle Fish Selection (Button3)
//     if (btn_pressed[3]) begin
//       if (current_fish < 3'd2)
//         current_fish <= current_fish + 1'b1;
//       else
//         current_fish <= 3'd0;
//     end
//   end
// end

// always @(posedge clk or negedge reset_n) begin
//   if (~reset_n) begin
//     // Reset to initial vertical positions
//     fish1_vpos <= 8'd40;
//     fish2_vpos <= 8'd80;
//     fish3_vpos <= 8'd120;
//   end else begin
//     // Handle Fish Raising (Button1)
//     if (btn_pressed[1]) begin
//       if (current_fish == 3'd0 && fish1_vpos > 8'd0)
//         fish1_vpos <= fish1_vpos - 8'd4;
//       if (current_fish == 3'd1 && fish2_vpos > 8'd0)
//         fish2_vpos <= fish2_vpos - 8'd4;
//       if (current_fish == 3'd2 && fish3_vpos > 8'd0)
//         fish3_vpos <= fish3_vpos - 8'd4;
//     end
    
//     // Handle Fish Lowering (Button2)
//     if (btn_pressed[2]) begin
//       if (current_fish == 3'd0 && fish1_vpos < (VBUF_H - FISH1_H))
//         fish1_vpos <= fish1_vpos + 8'd4;
//       if (current_fish == 3'd1 && fish2_vpos < (VBUF_H - FISH2_H))
//         fish2_vpos <= fish2_vpos + 8'd4;
//       if (current_fish == 3'd2 && fish3_vpos < (VBUF_H - FISH3_H))
//         fish3_vpos <= fish3_vpos + 8'd4;
//     end
//   end
// end

// always @(*) begin
//   if (current_fish == 3'd0) begin
//     now[2:0] = 3'b001;
//   end else if (current_fish == 3'd1) begin
//     now[2:0] = 3'b010;
//   end else if (current_fish == 3'd2) begin
//     now[2:0] = 3'b100;
//   end else begin
//     now[2:0] = 3'b000;
//   end

//   case (speed_level[current_fish])
//     3'd0: now[3] = 1'b0;
//     3'd1: now[3] = (pwm_counter < 5) ? 1'b1 : 1'b0;
//     3'd2: now[3] = (pwm_counter < 10) ? 1'b1 : 1'b0;
//     3'd3: now[3] = (pwm_counter < 15) ? 1'b1 : 1'b0;
//     3'd4: now[3] = 1'b1;
//     default: now[3] = 1'b0;
//   endcase
// end


// assign usr_led = now;

// always @(posedge clk or negedge reset_n) begin
//     if (!reset_n)
//         pwm_counter <= 0;
//     else
//         pwm_counter <= (pwm_counter == 19) ? 0 : pwm_counter + 1;
// end

// ------------------------------------------------------------------------
// The following code describes an initialized SRAM memory block that
// stores a 320x240 12-bit seabed image, plus two 64x32 fish images.

sram #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(VEND_W*VEND_H), .FILE("images.mem"))
  ram_1 (.clk(clk), .we(sram_we), .en(sram_en),
          .addr_1(sram_vend_addr), .data_i_1(data_vend_in), .data_o_1(data_vend_out),
          .addr_2(sram_f1_addr), .data_i_2(data_f1_in), .data_o_2(data_f1_out));

sram #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(WATER_W*WATER_H + TEA_W*TEA_H), .FILE("images2.mem"))
  ram_2 (.clk(clk), .we(sram_we), .en(sram_en),
          .addr_1(sram_water_addr), .data_i_1(data_water_in), .data_o_1(data_water_out),
          .addr_2(sram_tea_addr), .data_i_2(data_tea_in), .data_o_2(data_tea_out));

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

assign sram_water_addr = pixel_water_addr;
assign data_water_in = 12'h000;
assign sram_tea_addr = pixel_tea_addr;
assign data_tea_in = 12'h000;
assign sram_juice_addr = pixel_juice_addr;
assign data_juice_in = 12'h000;
assign sram_coke_addr = pixel_coke_addr;
assign data_coke_in = 12'h000;
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
// reg [9:0] fish1_pos_reg;
// reg [9:0] fish2_pos_reg;
// reg [9:0] fish3_pos_reg;
// reg [10:0] fish1_wid;
// reg [10:0] fish2_wid;
// reg [10:0] fish3_wid;

// assign fish1_pos = fish1_pos_reg;
// assign fish2_pos = fish2_pos_reg;
// assign fish3_pos = fish3_pos_reg;

assign vend_pos = 220;
assign drop_pos = 176;
assign water_pos = 176; // right bound
assign tea_pos = 164; // right bound
assign juice_pos = 152; // right bound
assign coke_pos = 144; // right bound
// always @(*) begin
//   case (speed_level[0])
//     3'd0: begin
//       fish1_pos_reg = fish1_clock[31:22];
//       fish1_wid = fish1_clock[33:23];
//     end
//     3'd1: begin
//       fish1_pos_reg = fish1_clock[30:21];
//       fish1_wid = fish1_clock[32:22];
//     end
//     3'd2: begin
//       fish1_pos_reg = fish1_clock[29:20];
//       fish1_wid = fish1_clock[31:21];
//     end
//     3'd3: begin
//       fish1_pos_reg = fish1_clock[28:19];
//       fish1_wid = fish1_clock[30:20];
//     end
//     3'd4: begin
//       fish1_pos_reg = fish1_clock[27:18];
//       fish1_wid = fish1_clock[29:19];
//     end
//     default: begin
//       fish1_pos_reg = fish1_clock[31:22];
//       fish1_wid = fish1_clock[33:23];
//     end
//   endcase
// end

// always @(*) begin
//   case (speed_level[1])
//     3'd0: begin
//       fish2_pos_reg = fish2_clock[31:22];
//       fish2_wid = fish2_clock[33:23];
//     end
//     3'd1: begin
//       fish2_pos_reg = fish2_clock[30:21];
//       fish2_wid = fish2_clock[32:22];
//     end
//     3'd2: begin
//       fish2_pos_reg = fish2_clock[29:20];
//       fish2_wid = fish2_clock[31:21];
//     end
//     3'd3: begin
//       fish2_pos_reg = fish2_clock[28:19];
//       fish2_wid = fish2_clock[30:20];
//     end
//     3'd4: begin
//       fish2_pos_reg = fish2_clock[27:18];
//       fish2_wid = fish2_clock[29:19];
//     end
//     default: begin
//       fish2_pos_reg = fish2_clock[31:22];
//       fish2_wid = fish2_clock[33:23];
//     end
//   endcase
// end

// always @(*) begin
//   case (speed_level[2])
//     3'd0: begin
//       fish3_pos_reg = fish3_clock[31:22];
//       fish3_wid = fish3_clock[33:23];
//     end
//     3'd1: begin
//       fish3_pos_reg = fish3_clock[30:21];
//       fish3_wid = fish3_clock[32:22];
//     end
//     3'd2: begin
//       fish3_pos_reg = fish3_clock[29:20];
//       fish3_wid = fish3_clock[31:21];
//     end
//     3'd3: begin
//       fish3_pos_reg = fish3_clock[28:19];
//       fish3_wid = fish3_clock[30:20];
//     end
//     3'd4: begin
//       fish3_pos_reg = fish3_clock[27:18];
//       fish3_wid = fish3_clock[29:19];
//     end
//     default: begin
//       fish3_pos_reg = fish3_clock[31:22];
//       fish3_wid = fish3_clock[33:23];
//     end
//   endcase
// end

// water drop clock control
reg water_drop_speed;
always @(posedge clk) begin
  if(~reset_n) begin
    water_drop_clock <= 0;
  end
  else if (P == S_MAIN_DROP && remain_water_num > 0) begin
    if(water_drop_speed == 1 || water_vpos > 160) begin
      water_drop_clock <= 0;
    end
    else if(water_vpos > 160) begin
      water_drop_clock <= 0;
    end
    else begin
      water_drop_clock <= water_drop_clock + 4;
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
      water_vpos <= 10'd118;
    end else begin
      if (P == S_MAIN_DROP && remain_water_num > 0) begin
        if(water_vpos > 160) begin
          water_vpos <= 10'd118;
        end
        else begin
          water_vpos <= water_vpos + water_drop_speed;
        end
      end
      else begin
        water_vpos <= 10'd118;
      end
  end
end
// always @(posedge clk) begin
//   if (~reset_n) begin
//     fish1_clock <= 0;
//     fish2_clock <= 0;
//     fish3_clock <= 0;
//     fish1_dir <= 1;
//     fish2_dir <= 1;
//     fish3_dir <= 1;
//   end else begin
//     if (fish1_speed_chg) begin
//       fish1_clock <= 0;
//       fish1_dir <= 1;
//     end else begin
//       if (fish1_dir) begin
//         if (fish1_wid < VBUF_W)
//           fish1_clock <= fish1_clock + 1;
//         else begin
//           fish1_dir <= 0;
//           fish1_clock <= fish1_clock - 1;
//         end
//       end else begin
//         if (fish1_wid > FISH1_W)
//           fish1_clock <= fish1_clock - 1;
//         else begin
//           fish1_dir <= 1;
//           fish1_clock <= fish1_clock + 1;
//         end
//       end
//     end
//     if (fish2_speed_chg) begin
//       fish2_clock <= 0;
//       fish2_dir <= 1;
//     end else begin
//       if (fish2_dir) begin
//         if (fish2_wid < VBUF_W)
//           fish2_clock <= fish2_clock + 1;
//         else begin
//           fish2_dir <= 0;
//           fish2_clock <= fish2_clock - 1;
//         end
//       end else begin
//         if (fish2_wid > FISH2_W)
//           fish2_clock <= fish2_clock - 1;
//         else begin
//           fish2_dir <= 1;
//           fish2_clock <= fish2_clock + 1;
//         end
//       end
//     end
//     if (fish3_speed_chg) begin
//       fish3_clock <= 0;
//       fish3_dir <= 1;
//     end else begin
//       if (fish3_dir) begin
//         if (fish3_wid < VBUF_W)
//           fish3_clock <= fish3_clock + 1;
//         else begin
//           fish3_dir <= 0;
//           fish3_clock <= fish3_clock - 1;
//         end
//       end else begin
//         if (fish3_wid > FISH3_W)
//           fish3_clock <= fish3_clock - 1;
//         else begin
//           fish3_dir <= 1;
//           fish3_clock <= fish3_clock + 1;
//         end
//       end
//     end
//   end
// end
// End of the animation clock code.
// ------------------------------------------------------------------------

// ------------------------------------------------------------------------
// Video frame buffer address generation unit (AGU) with scaling control
// Note that the width x height of the fish image is 64x32, when scaled-up
// on the screen, it becomes 128x64. 'pos' specifies the right edge of the
// fish image.
// assign fish_region =
//            pixel_y >= (FISH_VPOS<<1) && pixel_y < (FISH_VPOS+FISH_H)<<1 &&
//            (pixel_x + 127) >= pos && pixel_x < pos + 1;
// assign fish1_region =
//           pixel_y >= (fish1_vpos<<1) && pixel_y < (fish1_vpos+FISH1_H)<<1 &&
//           (pixel_x + 127) >= fish1_pos && pixel_x < fish1_pos + 1;

// assign fish2_region =
//           pixel_y >= (fish2_vpos<<1) && pixel_y < (fish2_vpos+FISH2_H)<<1 &&
//           (pixel_x + 127) >= fish2_pos && pixel_x < fish2_pos + 1;

// assign fish3_region =
//           pixel_y >= (fish3_vpos<<1) && pixel_y < (fish3_vpos+FISH3_H)<<1 &&
//           (pixel_x + 127) >= fish3_pos && pixel_x < fish3_pos + 1;

assign vend_region =
          pixel_y >= (vend_vpos<<1) && pixel_y < (vend_vpos+VEND_H)<<1 &&
          (pixel_x + 199) >= vend_pos && pixel_x < vend_pos + 1;

assign drop_region =
          pixel_y >= (drop_vpos<<1) && pixel_y < (drop_vpos+DROP_H)<<1 &&
          (pixel_x + 111) >= drop_pos && pixel_x < drop_pos + 1;

assign fall_water_region =
          pixel_y >= (water_vpos<<1) && 
          pixel_y < ((water_vpos + WATER_H)<<1) &&
          (pixel_x + 35) >= water_pos && pixel_x < (water_pos + 1);

assign fall_tea_region =
          pixel_y >= (tea_vpos<<1) && 
          pixel_y < ((tea_vpos + TEA_H)<<1) &&
          (pixel_x + 43) >= tea_pos && pixel_x < (tea_pos + 1);

assign fall_juice_region =
          pixel_y >= (juice_vpos<<1) && 
          pixel_y < ((juice_vpos + JUICE_H)<<1) &&
          (pixel_x + 43) >= juice_pos && pixel_x < (juice_pos + 1);

assign fall_coke_region =
          pixel_y >= (coke_vpos<<1) && 
          pixel_y < ((coke_vpos + COKE_H)<<1) &&
          (pixel_x + 23) >= coke_pos && pixel_x < (coke_pos + 1);
// always @ (posedge clk) begin
// if (~reset_n) begin
//     pixel_f1_addr <= 0;
//     pixel_f2_addr <= 0;
//     pixel_f3_addr <= 0;
//   end
//   else begin
//     if (fish1_region) begin
//       if (fish1_dir)
//         pixel_f1_addr <= fish1_addr[fish1_clock[25:23]] +
//                       ((pixel_y>>1)-fish1_vpos)*FISH1_W +
//                       ((pixel_x +(FISH1_W*2-1)-fish1_pos)>>1);
//       else
//         pixel_f1_addr <= fish1_addr[fish1_clock[25:23]] +
//                       ((pixel_y >> 1) - fish1_vpos) * FISH1_W +
//                       (FISH1_W - ((pixel_x +(FISH1_W*2-1)-fish1_pos)>>1) - 1);
//     end
//     if (fish2_region) begin
//       if (fish2_dir)
//         pixel_f2_addr <= fish2_addr[fish2_clock[25:24]] +
//                       ((pixel_y>>1)-fish2_vpos)*FISH2_W +
//                       ((pixel_x +(FISH2_W*2-1)-fish2_pos)>>1);
//       else
//         pixel_f2_addr <= fish2_addr[fish2_clock[25:24]] +
//                       ((pixel_y >> 1) - fish2_vpos) * FISH2_W +
//                       (FISH2_W - ((pixel_x +(FISH2_W*2-1)-fish2_pos)>>1) - 1);
//     end
//     if (fish3_region) begin
//       if (~fish3_dir)
//         pixel_f3_addr <= fish3_addr[fish3_clock[25:24]] +
//                       ((pixel_y>>1)-fish3_vpos)*FISH3_W +
//                       ((pixel_x +(FISH3_W*2-1)-fish3_pos)>>1);
//       else
//         pixel_f3_addr <= fish3_addr[fish3_clock[25:24]] +
//                       ((pixel_y >> 1) - fish3_vpos) * FISH3_W +
//                       (FISH3_W - ((pixel_x +(FISH3_W*2-1)-fish3_pos)>>1) - 1);
//     end
//   end
// end

// always @ (posedge clk) begin
//   if (~reset_n)
//     pixel_bg_addr <= 0;
//   else
//     pixel_bg_addr <= (pixel_y >> 1) * VBUF_W + (pixel_x >> 1);
// end

always @ (posedge clk) begin
  if (~reset_n)
    pixel_vend_addr <= 0;
  else begin
    if (vend_region) begin
      pixel_vend_addr <= ((pixel_y>>1) - vend_vpos)*VEND_W +
                    ((pixel_x +(VEND_W*2-1)-vend_pos)>>1);
    end
    if (fall_water_region) begin
      pixel_water_addr <= ((pixel_y>>1) - water_vpos)*WATER_W +
                    ((pixel_x + (WATER_W*2-1) - water_pos)>>1);
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
    if (fall_water_region && data_water_out != 12'h0f0)
      rgb_next = data_water_out;
    else if (drop_region)
      rgb_next = 12'hf00;
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
        // P_next = (btn_pressed[3]) ? S_MAIN_CALC : S_MAIN_PAY;
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
           coke_VALUE = 20;

// S_MAIN_BUY
reg [8:0] total_amount; // item value
reg [3:0] water_num, tea_num, juice_num, coke_num; // we have how many coin
reg [3:0] used_water_num, used_tea_num, used_juice_num, used_coke_num; // we have used how many coin
reg [1:0] item_pointer;
localparam [1:0] CHOOSE_WATER = 2'd0,
                 CHOOSE_TEA = 2'd1,
                 CHOOSE_JUICE = 2'd2,
                 CHOOSE_coke = 2'd3;

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
                      used_juice_num * JUICE_VALUE + used_coke_num * coke_VALUE;
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
                 FALL_coke = 2'd3;

// judge whether the item touched the bottom
// need modify: initial drop y, bottom location
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
    if(water_vpos > 160) begin
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
      FALL_coke: begin
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
    else if (remain_tea_num > 0) begin
      // use tea image to fall
      what_item_fall <= FALL_TEA;
    end
    else if (remain_juice_num > 0) begin
      // use juice image to fall
      what_item_fall <= FALL_JUICE;
    end
    else if (remain_coke_num > 0) begin
      // use coke image to fall
      what_item_fall <= FALL_coke;
    end
  end
end

// reset falling
always @(posedge clk) begin
  
end

// ------------------------------------------------------------------------

// ------------------------------------------------------------------------
// S_MAIN_ERROR

// ------------------------------------------------------------------------

endmodule
