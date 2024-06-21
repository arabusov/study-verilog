module be8_tb;

reg clk, rst;
wire [7:0] data;
wire [7:0] addr;
reg ready;
wire rw;

be8 proc(.clk(clk), .rst(rst),
    .data(data), .addr(addr), .ready(ready),
    .rw(rw));
ram8x16 mem(.d(data), .a(addr), .we(rw), .clk(clk));
initial $readmemh("mem.txt", mem.mem, 4'h0, 4'hf);

integer i;
always #1 clk = !clk;
initial begin
    $dumpfile("show_be8_tb.vcd");
    $dumpvars(0, clk);
    $dumpvars(0, rst);
    $dumpvars(0, proc);
    $dumpvars(0, mem);
    $dumpvars(0, mem.mem[4'he]);
    $display("your program:");
    for (i = 4'h0; i <= 4'hf; i++) begin
        $display(mem.mem[i]);
    end
    clk = 0;
    rst = 1;
    ready = 1;
    #5;
    rst = 0;
    while (addr < 8'hff && ~proc.carry) begin
        #1;
    end
    $finish ;
end

endmodule
