`timescale 1ns / 1ps
module debouncer #(
    parameter STABLE_COUNT = 20_000
)(
    input      clk,
    input      noisy,
    output reg clean = 0
);
    reg [14:0] count = 0;
    reg        sync0 = 0, sync1 = 0;

    always @(posedge clk) begin
        sync0 <= noisy;
        sync1 <= sync0;
    end

    always @(posedge clk) begin
        if (sync1 == clean)
            count <= 0;
        else begin
            count <= count + 1;
            if (count == STABLE_COUNT - 1) begin
                clean <= sync1;
                count <= 0;
            end
        end
    end
endmodule