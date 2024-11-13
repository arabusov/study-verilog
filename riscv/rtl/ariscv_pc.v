module pc_m
#(
        parameter   ADDR_W  = 32
    ,   parameter   RSTVAL  = 32'h0000_8000
)
(
        input       clk
    ,   input       arst
    ,   input       srst
    ,   input [ADDR_W-1:0]  PCNext
    ,   output reg [ADDR_W-1:0] pc
);

always @(arst)
    pc <= RSTVAL;

always @(posedge clk)
    if (srst)
        pc <= RSTVAL;
    else
        pc <= PCNext;

endmodule

module main;

reg clk, arst, srst;
reg [31:0] PCNext;
wire [31:0] pc;

pc_m pc_i(.clk(clk), .arst(arst), .srst(srst),
    .PCNext(PCNext), .pc(pc));

initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, pc_i);
    $monitor("clk = %b ARST = %b pc = %x", clk, arst, pc);
    clk <= 0;
    arst <= 1;
    srst <= 1;
    #1 PCNext <= pc;
    #4 arst <= 0; srst <= 0; PCNext <= PCNext;
end

always #1 clk <= ~clk;

always @(posedge clk) begin
    if (!arst && !srst)
        PCNext <= PCNext + 4;
    if (pc > 32'h8010)
        $finish;
end;
endmodule
