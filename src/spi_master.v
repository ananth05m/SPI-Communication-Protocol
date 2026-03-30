`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2026 22:23:03
// Design Name: 
// Module Name: spi_master
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
module spi_master (
    input clk,
    input rst,
    input start,
    input [7:0] data_in,
    input MISO,
    output reg MOSI,
    output reg SCLK,
    output reg SS,
    output reg [7:0] data_out,
    output reg done
);

reg [7:0] shift_reg;
reg [2:0] bit_cnt;
reg [3:0] clk_div;   // slow down SPI clock
reg spi_clk_en;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        SCLK <= 0;
        SS <= 1;
        MOSI <= 0;
        done <= 0;
        spi_clk_en <= 0;
        clk_div <= 0;
    end else begin
        if (start && !spi_clk_en) begin
            SS <= 0;
            shift_reg <= data_in;
            bit_cnt <= 7;
            spi_clk_en <= 1;
            done <= 0;
        end

        if (spi_clk_en) begin
            clk_div <= clk_div + 1;

            if (clk_div == 2) begin
                SCLK <= ~SCLK; // generate SPI clock
                clk_div <= 0;

                if (SCLK == 0) begin
                    // Falling edge → change data
                    MOSI <= shift_reg[bit_cnt];
                end else begin
                    // Rising edge → sample data
                    data_out[bit_cnt] <= MISO;

                    if (bit_cnt == 0) begin
                        spi_clk_en <= 0;
                        SS <= 1;
                        done <= 1;
                        SCLK <= 0;
                    end else begin
                        bit_cnt <= bit_cnt - 1;
                    end
                end
            end
        end
    end
end

endmodule
