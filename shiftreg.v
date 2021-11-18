`timescale  1ns/1ps
`default_nettype none

//
// 74hc595 shift register driver - 18-11-2021
//

module ShiftReg (
    input i_clk,        // system clock 48 Mhz
    input [7:0] i_Data, // data to shift out
    input i_Enable,     // enable shifter
    output o_Ready,     // shifter ready
    output o_RCLK,      // 74hc595 latch clock
    output o_SRCLK,     // 74hc595 serial clock
    output o_SER );     // 74hc595 serial out

reg r_RCLK            = 0;
reg r_SRCLK           = 0;
reg r_Ready           = 1;

reg [8:0] r_shifter   = 0; // shifter register
reg [3:0] r_shiftcnt  = 0; // shift counter 0..7
reg [3:0] s_state     = 0; // state 0..7

assign o_Ready        = r_Ready;
assign o_RCLK         = r_RCLK;
assign o_SRCLK        = r_SRCLK;
assign o_SER          = r_shifter[8];

//
// Shift state machine
//
always @ (posedge i_clk) begin
    case (s_state)
        0: begin // idle, wait for i_enable
            if (i_Enable == 1) begin
                r_shifter[7:0] <= i_Data;
                s_state        <= 1;
                r_shiftcnt     <= 0;
                r_Ready        <= 0;
            end
        end
        1: begin // shift left 1 position
            r_shifter <= r_shifter << 1;
            s_state   <= 2;
        end   
        2: begin // wait one clock cycle 
            s_state <= 3;
        end
        3: begin // SRCLK = 1
            r_SRCLK <= 1;
            s_state <= 4;
        end   
        4: begin // SRCLK = 0
            r_SRCLK <= 0;
            s_state <= 5;
        end
        5: begin // check of all shift out
            if (r_shiftcnt == 7) begin
                s_state <= 6;
            end else begin
                r_shiftcnt <= r_shiftcnt + 1;
                s_state <= 1;
            end
        end
        6: begin // RCLK = 1
            r_RCLK <= 1;
            s_state <= 7;
        end
        7: begin // RCLK = 0
            r_RCLK <= 0;
            s_state <= 8;
        end
        8: begin // Ready = 1
            r_Ready <= 1;
            s_state <= 0;
        end 
    endcase  
end

endmodule // ShifReg