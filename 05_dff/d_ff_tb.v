module d_ff_tb;
reg clk, d, enable;
wire q, qbar;

d_ff u0(
    .clk(clk),
    .d(d),
    .enable(enable),
    .q(q),
    .qbar(qbar)
);

initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,d_ff_tb); 
    $monitor("clk = %b EN = %b D = %b Q = %b", clk, enable, d, q);
    clk=0;
    d=0;
    enable=0;
    #6 d=1;
    #6 d=0;
    #6 enable=1;
    #6 d=1;
    #6 enable=0;
    #6 d=1;
    #6 d=0;
    #6 enable=1;
    #6 $finish;
end

always #2 clk = ~clk;

endmodule // d_ff_tb
