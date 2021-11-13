`timescale  1ns/1ps
`default_nettype none

//
// Test bench 74hc595 shift register - 13-11-2021
//

module top_tb; 
   
reg r_clk = 0;

wire w_Ready;
wire w_Enable;
wire [7:0] w_Data;

ShiftReg dut1 (
    .i_clk(r_clk),
    .i_Data(w_Data),
    .i_Enable(w_Enable),
    .o_Ready(w_Ready),
    .o_RCLK(),
    .o_SRCLK(),
    .o_SER() );

Control #(.N(4)) dut2 (
    .i_clk(r_clk),
    .i_rdy(w_Ready),
    .o_data(w_Data),
    .o_en_in(w_Enable) );

always
    #10 r_clk <= !r_clk;
	
initial begin
    $dumpfile("top_tb.vcd");
    $dumpvars();
    #5000 $finish;  
end

endmodule
