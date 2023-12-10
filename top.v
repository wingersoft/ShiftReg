`timescale  1ns/1ps
`default_nettype none

//
// Test Shift register, clk 48 Mhz - 14-11-2021
//

module top (
    output o_led_blue,
    output o_led_green,
    output o_led_red,   
    output o_RCLK,
    output o_SRCLK,
    output o_SER );

// internal clock 48 Mhz
wire clk;
SB_HFOSC inthosc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

// RGB led all off
assign o_led_blue = 1'b1;
assign o_led_green = 1'b1;
assign o_led_red = 1'b1;

// connections between ShiftReg and Control  
wire w_Ready;
wire w_Enable;
wire [7:0] w_Data;

// instantiate ShiftReg
ShiftReg SR (
    .i_clk(clk),
    .i_Data(w_Data),
    .i_Enable(w_Enable),
    .o_Ready(w_Ready),
    .o_RCLK(o_RCLK),
    .o_SRCLK(o_SRCLK),
    .o_SER(o_SER) );

// instantiate Control
Control #(.N(48_000_000)) CONT (
    .i_clk(clk),
    .i_ready(w_Ready),
    .o_data(w_Data),
    .o_enable(w_Enable) );
    
endmodule // top
