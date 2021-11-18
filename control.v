`timescale  1ns/1ps
`default_nettype none

//
// Control 74hc595 shift register - 18-11-2021
// test setup - toggle between 'h55 and 'haa
//

module Control #(parameter N = 24) (
    input i_clk,          // system clock
    input i_ready,        // shifter ready?
    output [7:0] o_data,  // data 0..255
    output o_enable );    // start shifting

reg [7:0] r_data = 8'h55; // output data
reg r_enable = 0;         // start shifting   
reg [2:0] s_state = 0;    // state machine

assign o_data = r_data;
assign o_enable = r_enable;

//
// Timer ~600 mS
//
reg [N:0] r_timer = 0;
always @ (posedge i_clk)
    r_timer <= r_timer + 1;

wire w_timer;
assign w_timer = (r_timer == 0);

//
// Control ShiftReg with 8'h55 and 8'haa data
//
always @ (posedge i_clk) begin
    case  (s_state)
        0: begin // enable = 1 
            r_enable <= 1;
            s_state <= 1;
        end
        1: begin // enable = 0
            r_enable <= 0;
            s_state <= 2;
        end
        2: begin // if shifter ready go to 3
            if (i_ready)
                s_state <= 3;
            else
                s_state <= 2;
        end
        3: begin // if timeout go to 4
            if (w_timer)
                s_state <= 4;
            else
                s_state <= 3;
        end
        4: begin // toggle data 'h55 -> 'haa
            r_data <= ~r_data;
            s_state <= 0;
        end
    endcase
end

endmodule // Control
