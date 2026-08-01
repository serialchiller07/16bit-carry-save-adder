`timescale 1ns / 1ps
module edge_detect(
    input  clk,
    input  level,
    output pulse
);
    reg prev = 0;
    always @(posedge clk) prev <= level;
    assign pulse = level & ~prev;
endmodule