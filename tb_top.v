`timescale 1ns / 1ps

module tb_top;

    reg         clk  = 0;
    reg         btnC = 0;
    reg         btnU = 0;
    reg  [15:0] sw   = 0;

    wire [15:0] led;

    // DUT
    top_fpga dut(
        .clk(clk),
        .btnC(btnC),
        .btnU(btnU),
        .sw(sw),
        .led(led)
    );

    // 100 MHz clock
    always #5 clk = ~clk;

    // Speed up simulation
    defparam dut.db_C.STABLE_COUNT = 5;
    defparam dut.db_U.STABLE_COUNT = 5;

    task press_btn;
        input which;
        begin
            if(which == 0)
                btnC = 1;
            else
                btnU = 1;

            repeat(30) @(posedge clk);

            if(which == 0)
                btnC = 0;
            else
                btnU = 0;

            repeat(30) @(posedge clk);
        end
    endtask

    task load_operand;
        input [15:0] value;
        begin
            sw = value;
            repeat(10) @(posedge clk);
            press_btn(0);
        end
    endtask

    initial begin

        $display("\n==================================");
        $display("      CSA FPGA TESTBENCH");
        $display("==================================\n");

        $display("RESETTING...");
        press_btn(1);

        // TEST 1
        $display("\nTEST 1 : 5 + 3 + 2");

        load_operand(16'd5);
        load_operand(16'd3);
        load_operand(16'd2);

        repeat(20) @(posedge clk);

        $display("Expected = 10");
        $display("Result   = %0d", led);

        press_btn(0);

        // TEST 2
        $display("\nTEST 2 : 100 + 200 + 300");

        load_operand(16'd100);
        load_operand(16'd200);
        load_operand(16'd300);

        repeat(20) @(posedge clk);

        $display("Expected = 600");
        $display("Result   = %0d", led);

        press_btn(0);

        // TEST 3
        $display("\nTEST 3 : 1 + 1 + 1 + cin");

        load_operand(16'd1);
        load_operand(16'd1);
        load_operand(16'd1);

        repeat(20) @(posedge clk);

        $display("Expected = 4");
        $display("Result   = %0d", led);

        press_btn(0);

        // TEST 4
        $display("\nTEST 4 : 0 + 0 + 0");

        load_operand(16'd0);
        load_operand(16'd0);
        load_operand(16'd0);

        repeat(20) @(posedge clk);

        $display("Expected = 0");
        $display("Result   = %0d", led);

        press_btn(0);

        // TEST 5
        $display("\nTEST 5 : 60000 + 60000 + 60000");

        load_operand(16'd60000);
        load_operand(16'd60000);
        load_operand(16'd60000);

        repeat(20) @(posedge clk);

        $display("Expected = 180000");
        $display("Result   = %0d", led);

        press_btn(0);

        // TEST 6
        $display("\nTEST 6 : FFFF + FFFF + FFFF + cin");

        load_operand(16'hFFFF);
        load_operand(16'hFFFF);
        load_operand(16'hFFFF);

        repeat(20) @(posedge clk);

        $display("Expected = 196606");
        $display("Result   = %0d", led);

        $display("\n==================================");
        $display("       SIMULATION FINISHED");
        $display("==================================\n");

        #100;
        $finish;
    end

endmodule