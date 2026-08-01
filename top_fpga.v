`timescale 1ns / 1ps

module top_fpga(
    input         clk,
    input         btnC,
    input         btnU,
    input  [15:0] sw,
    output [15:0] led
);

    localparam LOAD_A  = 2'b00;
    localparam LOAD_B  = 2'b01;
    localparam LOAD_C  = 2'b10;
    localparam COMPUTE = 2'b11;

    reg [1:0]  state   = LOAD_A;
    reg [15:0] a_reg   = 0;
    reg [15:0] b_reg   = 0;
    reg [15:0] c_reg   = 0;
    reg        cin_reg = 0;

    wire btnC_clean;
    wire btnU_clean;
    wire btnC_pulse;
    wire btnU_pulse;

    debouncer #(.STABLE_COUNT(20000)) db_C (
        .clk(clk),
        .noisy(btnC),
        .clean(btnC_clean)
    );

    debouncer #(.STABLE_COUNT(20000)) db_U (
        .clk(clk),
        .noisy(btnU),
        .clean(btnU_clean)
    );

    edge_detect ed_C (
        .clk(clk),
        .level(btnC_clean),
        .pulse(btnC_pulse)
    );

    edge_detect ed_U (
        .clk(clk),
        .level(btnU_clean),
        .pulse(btnU_pulse)
    );

    always @(posedge clk) begin

        if (btnU_pulse) begin
            state   <= LOAD_A;
            a_reg   <= 16'd0;
            b_reg   <= 16'd0;
            c_reg   <= 16'd0;
            cin_reg <= 1'b0;
        end

        else if (btnC_pulse) begin

            case(state)

                LOAD_A: begin
                    a_reg <= sw;
                    state <= LOAD_B;
                end

                LOAD_B: begin
                    b_reg <= sw;
                    state <= LOAD_C;
                end

                LOAD_C: begin
                    c_reg   <= sw;
                    cin_reg <= sw[0];
                    state   <= COMPUTE;
                end

                COMPUTE: begin
                    state <= LOAD_A;
                end

            endcase
        end
    end

    wire [15:0] sum;
    wire        cout;
    wire        carry;

    carrysave csa (
        .a(a_reg),
        .b(b_reg),
        .c(c_reg),
        .cin(cin_reg),
        .sum(sum),
        .cout(cout),
        .carry(carry)
    );

    assign led =
        (state == COMPUTE) ? sum :
        {sw[15:2], state};

endmodule