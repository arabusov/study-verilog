module d_ff(
    input clk,
    input d,
    output q,
    output qbar
);

wire x, y;

nand u1(x, clk, d);
nand u2(y, clk, x);
nand u3(q, x, qbar);
nand u4(qbar, y, q);

endmodule
