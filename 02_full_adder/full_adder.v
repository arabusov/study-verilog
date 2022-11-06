module full_adder(a, b, ci, s, co);
input a, b, ci;
output s, co;
wire has, hac;

assign has=a^b;
assign hac=a&b;
assign s=has^ci;
assign co=hac|(ci&has);

endmodule // full_adder
