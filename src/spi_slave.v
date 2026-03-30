`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2026 22:24:00
// Design Name: 
// Module Name: spi_slave
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module spi_slave (
    input SCLK,
    input SS,
    input MOSI,
    input [7:0] data_in,
    output reg MISO,
    output reg [7:0] data_out
);

reg [7:0] shift_reg;
reg [2:0] bit_cnt;

// When slave selected → preload first bit
always @(negedge SS) begin
    shift_reg <= data_in;
    bit_cnt <= 7;
    MISO <= data_in[7];  // 🔥 CRITICAL FIX
end

// Sample MOSI on rising edge
always @(posedge SCLK) begin
    if (!SS) begin
        data_out[bit_cnt] <= MOSI;

        if (bit_cnt != 0)
            bit_cnt <= bit_cnt - 1;
    end
end

// Shift next MISO on falling edge
always @(negedge SCLK) begin
    if (!SS) begin
        MISO <= shift_reg[bit_cnt];
    end
end

endmodule