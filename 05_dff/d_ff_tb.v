module d_ff_tb;
reg clk, d;
wire q, qbar;

d_ff u0(
    .clk(clk),
    .d(d),
    .q(q),
    .qbar(qbar)
);

initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,d_ff_tb); 
    $monitor("clk = %b D = %b Q = %b Qbar = %b", clk, d, q, qbar);
    clk=0;
    d=0;
    #6 d=1;
    #6 d=0;
    #6 $finish;
end

always #2 clk = ~clk;

endmodule // d_ff_tb
