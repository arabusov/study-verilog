module sr_ff_tb;
reg R, S;
reg Clk;
wire Q, Nq;

initial
begin
    $monitor("time=%g R=%b S=%b Q=%b NQ=%b", $time, R, S, Q, Nq);
end

sr_ff dut(.clk(Clk),.r(R),.s(S),.q(Q),.nq(Nq));

always #1 Clk=~Clk;

initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0, sr_ff_tb);
    Clk=1'b0;
    R=1'b0; S=1'b0;
    #5 R=1'b1; S=1'b0;
    #5 R=1'b0; S=1'b1;
    #10 R=1'b0; S=1'b0;
    #5 R=1'b1; S=1'b0;
    #10 R=1'b0; S=1'b0;
    $finish;
end
endmodule // sr_ff_tb
