module half_adder_tb;
reg i1, i2;
wire o1, o2;
initial
begin
    $monitor("time=%g A=%b B=%b S=%b C=%b", $time, i1, i2, o1, o2);
end

half_adder dut(.a(i1), .b(i2), .s(o1), .c(o2));
initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0,half_adder_tb);
    #5  i1=1'b0;    i2=1'b0;
    #5  i1=1'b0;    i2=1'b1;
    #5  i1=1'b1;    i2=1'b0;
    #5  i1=1'b1;    i2=1'b1;
end
endmodule
