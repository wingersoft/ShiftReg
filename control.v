`timescale  1ns/1ps
`default_nettype none

//
// Control 74hc595 shift register - 09-11-2021
// test setup - toggle between 'h55 and 'haa
//

module Control #(parameter N = 24) (
    input i_clk,
    input i_rdy,
    output [7:0] o_data,
    output o_en_in );

reg [7:0] r_data = 8'h55;
reg r_en_in = 0;
reg [2:0] r_state = 0;

assign o_data = r_data;
assign o_en_in = r_en_in;

//
// Divide system clk to ~1 sec
//
reg [N:0] r_counter = 0;
always @ (posedge i_clk)
    r_counter <= r_counter + 1;

wire w_timer;
assign w_timer = &r_counter;

//
// Control ShiftReg with 8'h55 and 8'haa data
//
always @ (posedge i_clk) begin
    case  (r_state)
        0: begin
            r_en_in <= 1;
            r_state <= 1;
        end
        1: begin
            r_en_in <= 0;
            r_state <= 2;
        end
        2: begin
            if (i_rdy)
                r_state <= 3;
            else
                r_state <= 2;
        end
        3: begin
            if (w_timer)
                r_state <= 4;
            else
                r_state <= 3;
        end
        4: begin
            r_data <= ~r_data;
            r_state <= 0;
        end
    endcase
end

endmodule // Control
