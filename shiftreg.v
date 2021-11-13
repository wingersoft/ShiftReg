`timescale  1ns/1ps
`default_nettype none

//
// 74hc595 shift register driver - 12-11-2021
//

module ShiftReg (
    input i_clk,
    input [7:0] i_Data,
    input i_Enable,
    output o_Ready,
    output o_RCLK,
    output o_SRCLK,
    output o_SER_OUT );

reg r_RCLK            = 0;
reg r_SRCLK           = 0;
reg r_Ready           = 1;

reg [8:0] r_shift     = 0;
reg [3:0] r_state     = 0;
reg [3:0] r_cnt       = 0;
reg [3:0] r_shiftcnt  = 0;

localparam DURATION   = 2;

wire o_SER_OUT;
assign o_SER_OUT = r_shift[8];

assign o_RCLK    = r_RCLK;
assign o_SRCLK   = r_SRCLK;
assign o_Ready   = r_Ready;

always @ (posedge i_clk) begin
    case (r_state)
        0: begin
            if (i_Enable == 1) begin
                r_shift[7:0]   <= i_Data;
                r_state        <= 1;
                r_shiftcnt     <= 0;
                r_Ready        <= 0;
            end
        end
        1: begin
            r_shift[8:1]  <= r_shift[7:0];
            r_shift[0]    <= 0;
            r_state       <= 2;
        end   
        2: begin
            r_cnt <= DURATION - 1;
            r_state <= 3;
        end
        3: begin
            if (r_cnt == 0) begin
                r_cnt <= DURATION - 1;
                r_SRCLK <= 1;
                r_state <= 4;
            end else begin
                r_cnt <= r_cnt - 1;
                r_state <= 3;
            end
        end   
        4: begin
            if (r_cnt == 0) begin
                r_SRCLK <= 0;
                r_cnt <= DURATION - 1;
                r_state <= 5;
            end else begin
                r_cnt <= r_cnt - 1;
                r_state <= 4;
            end
        end
        5: begin
            if (r_cnt == 0) begin
                r_state <= 6;
            end else begin
                r_cnt <= r_cnt - 1;
                r_state <= 5;
            end
        end
        6: begin
            if (r_shiftcnt == 7) begin
                r_cnt <= DURATION - 1;
                r_RCLK <= 1;
                r_state <= 7;
            end else begin
                r_shiftcnt <= r_shiftcnt + 1;
                r_state <= 1;
            end
        end
        7: begin
            if (r_cnt == 0) begin
                r_RCLK <= 0;
                r_state <= 8;
            end else begin
                r_cnt <= r_cnt - 1;
                r_state <= 7;
            end
        end
        8: begin
            r_Ready <= 1;
            r_state <= 0;
        end 
    endcase  
end

endmodule