module d_ff(
    input clk,
    input d,
    input enable,
    output q,
    output qbar
);

wire x, y;
wire a;

and u0(a, clk, enable);
nand u1(x, a, d);
nand u2(y, a, x);
nand u3(q, x, qbar);
nand u4(qbar, y, q);

endmodule
