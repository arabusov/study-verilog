module i8284_tb;
reg clk, rstn;
wire clk_out, reset_out;

initial
begin
    $monitor("time=%g CLK_IN=%b CLK_OUT=%b RSTN=%b RESET=%b", $time,
        clk, clk_out, rstn, reset_out);
end

i8284 sab8284(
    .CLK_IN(clk),
    .RESN(rstn),
    .CLK_OUT(clk_out),
    .RESET(reset_out)
);

always #1 clk=~clk;

initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0, i8284_tb);
    clk=0;
    rstn=1;
    #14 rstn=0;
    #2  rstn=1;
    #43 rstn=0;
    #4  rstn=1;
    #37 rstn=1;
    $finish;
end
endmodule // i8284_tb
