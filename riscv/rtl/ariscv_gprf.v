module rf_m
#(
        parameter   NREG    = 32
    ,   parameter   MSB     = 4
    ,   parameter   XLEN    = 32
    ,   parameter   ZERO    = 32'b0
    ,   parameter   RSTVAL  = ZERO
    ,   parameter   HIMP    = {32{1'bz}}
)
(
        input       clk
    ,   input       srst
    ,   input       arst
    ,   input       we3
    ,   input [MSB:0] a1
    ,   input [MSB:0] a2
    ,   input [MSB:0] a3
    ,   input [(XLEN-1):0]  wd3
    ,   output [(XLEN-1):0] rd1
    ,   output [(XLEN-1):0] rd2
);

reg [(XLEN-1):0] regs[0:(NREG-2)];

assign rd1 = (a1 >= 1) ? regs[a1-1] : ZERO;
assign rd2 = (a2 >= 1) ? regs[a2-1] : ZERO;

integer i;

always @(arst)
    for (i= 1; i < (NREG - 1); i++) begin
        regs[i-1] <= arst;
    end

always @(posedge clk)
    if (srst) begin
        for (i = 1; i < (NREG-1); i++) begin
            regs[i-1] <= RSTVAL;
        end
    end else if (we3)
        if (a3 >= 1)
            regs[a3-1] <= wd3;
endmodule

module rf_tb
#(
        parameter   MSB     = 4
    ,   parameter   XLEN    = 32
);
reg clk, srst, arst, we3;
reg [MSB:0] a1, a2, a3;
reg [(XLEN-1):0] wd3;
wire [(XLEN-1):0] rd1, rd2;

rf_m rf_i(
        .clk(clk)
    ,   .arst(arst)
    ,   .srst(srst)
    ,   .we3(we3)
    ,   .a1(a1)
    ,   .a2(a2)
    ,   .a3(a3)
    ,   .rd1(rd1)
    ,   .rd2(rd2)
    ,   .wd3(wd3)
    );
    integer i;
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, rf_i);
        $monitor("clk = %b ARST = %b WE3 = %b WD3 = %x", clk, arst, srst, we3, wd3);
        clk = 0;
        arst = 1;
        srst = 1;
        we3 = 0;
        wd3 = 32'hcafebabe;
        a1 <= 0;
        a2 <= 0;
        a3 <= 0;
        #4 arst = 0; srst = 0;
        #4 we3 = 1;
        for (i = 0; i <= 32; i++) begin
            a3 <= i;
            #2 we3 <= 0; a1 <= a3;
            #2 a1 <= a2; a2 <= a3; wd3++; we3 <= 1;
        end
        #4 a1 = 3; a2 = 1; a3 = 2;
        #2 $finish;
    end

    always #1 clk = ~clk;
endmodule
