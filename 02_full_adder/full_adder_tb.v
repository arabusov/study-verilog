module full_adder_tb;
reg [2:0] counter;
wire A, B, Ci;
assign A=counter[0];
assign B=counter[1];
assign Ci=counter[2];
wire S, Co;

initial
begin
    $monitor("time=%g A=%b B=%b Ci=%b", $time, A, B, Ci);
end

full_adder dut(.a(A),.b(B),.ci(Ci),.s(S),.co(Co));

initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0,full_adder_tb);
    counter=3'b000;
    repeat (8)
        #5 counter=counter+1;
end
endmodule
