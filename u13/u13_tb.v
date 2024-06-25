module ram8x16(d, a, we, clk);
    inout [7:0] d;
    input [15:0] a;
    input we;
    input clk;

    wire [7:0] out;

    reg [7:0] mem [0:15];
    reg [7:0] zp [0:15];

    assign out = (a < 16'h100 ? zp[a[3:0]] : mem[a[3:0]] );
    assign d = ( we ? 16'bzzzzzzzzzzzzzzzz : out );
    always @(posedge clk)
        if (we)
            if (a < 16'h100)
                zp[a[3:0]] <= d;
            else
                mem[a[3:0]] <= d;
endmodule

module u13_tb;

reg clk, rst;
reg
wire [7:0] data;
wire [15:0] addr;
wire rw;

u13 proc(.clk(clk), .rst(rst),
    .data(data), .addr(addr),
    .rw(rw));
ram8x16 mem(.d(data), .a(addr), .we(rw), .clk(clk));
initial $readmemh("mem.txt", mem.mem, 4'h0, 4'hf);

integer i;
always #1 clk = !clk;
initial begin
    $dumpfile("show_u13_tb.vcd");
    $dumpvars(0, clk);
    $dumpvars(0, rst);
    $dumpvars(0, proc);
    $dumpvars(0, mem);
    $dumpvars(0, mem.zp[4'h0]);
    $display("your program:");
    for (i = 4'h0; i <= 4'hf; i++) begin
        $display(mem.mem[i]);
    end
    clk = 0;
    rst = 1;
    #5;
    rst = 0;
    while (addr < 16'hfffe && ~proc.carry) begin
        #1;
    end
    $finish ;
end

endmodule
