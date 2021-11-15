`timescale  1ns/1ps
`default_nettype none

//
// Test bench 74hc595 shift register - 14-11-2021
//

module top_tb; 

wire w_Ready;
wire w_Enable;
wire [7:0] w_Data;

// instantiate ShiftReg
ShiftReg dut1 (
    .i_clk(r_clk),
    .i_Data(w_Data),
    .i_Enable(w_Enable),
    .o_Ready(w_Ready),
    .o_RCLK(),
    .o_SRCLK(),
    .o_SER() );

// instantiate Control
Control #(.N(4)) dut2 (
    .i_clk(r_clk),
    .i_ready(w_Ready),
    .o_data(w_Data),
    .o_enable(w_Enable) );

// clock 20 nsec
reg r_clk = 0;
always
    #10 r_clk <= !r_clk;
	
initial begin
    $dumpfile("top_tb.vcd");
    $dumpvars();
    #2500 $finish;  
end

endmodule // top_tb
