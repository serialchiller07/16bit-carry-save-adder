`timescale 1ns / 1ps
module carrysave(
    input  [15:0] a, b, c,
    input         cin,
    output [15:0] sum,
    output        cout,
    output        carry
);
    wire [15:0] s, co;
    wire [15:0] ctemp;
    genvar i;

    // Stage 1: compress a+b+c → save-sum s[] and save-carry co[]
    generate
        for (i = 0; i < 16; i = i + 1) begin : stage1
            FA fa1(.a(a[i]), .b(b[i]), .cin(c[i]),
                   .sum(s[i]), .cout(co[i]));
        end
    endgenerate

    // Stage 2
    // FIX: was "assign sum[0] = s[0]" - cin was entering at f1 (bit1, weight 2)
    //      but cin has weight 1, so it must be absorbed here at bit 0
    FA f0 (s[0],  cin,    1'b0,      sum[0],  ctemp[0]);

    // Block 0
    FA f1 (s[1],  co[0],  ctemp[0],  sum[1],  ctemp[1]);
    FA f2 (s[2],  co[1],  ctemp[1],  sum[2],  ctemp[2]);
    FA f3 (s[3],  co[2],  ctemp[2],  sum[3],  ctemp[3]);
    FA f4 (co[3], s[4],   ctemp[3],  sum[4],  ctemp[4]);

    // Block 1
    FA f5 (s[5],  co[4],  ctemp[4],  sum[5],  ctemp[5]);
    FA f6 (s[6],  co[5],  ctemp[5],  sum[6],  ctemp[6]);
    FA f7 (s[7],  co[6],  ctemp[6],  sum[7],  ctemp[7]);
    FA f8 (co[7], s[8],   ctemp[7],  sum[8],  ctemp[8]);

    // Block 2
    FA f9 (s[9],  co[8],  ctemp[8],  sum[9],  ctemp[9]);
    FA f10(s[10], co[9],  ctemp[9],  sum[10], ctemp[10]);
    FA f11(s[11], co[10], ctemp[10], sum[11], ctemp[11]);
    FA f12(co[11],s[12],  ctemp[11], sum[12], ctemp[12]);

    // Block 3
    FA f13(s[13], co[12], ctemp[12], sum[13], ctemp[13]);
    FA f14(s[14], co[13], ctemp[13], sum[14], ctemp[14]);
    FA f15(s[15], co[14], ctemp[14], sum[15], ctemp[15]);
    FA f16(co[15],1'b0,   ctemp[15], cout,    carry);

endmodule