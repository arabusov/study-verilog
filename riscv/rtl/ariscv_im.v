module im_m // instruction memory module
#(
        parameter   ADDR_W  =   32
    ,   parameter   INSTR_W =   32
    ,   parameter   ILLEGAL =   32'h0
)
(
        input       clk
    ,   input       arst
    ,   input       srst
    ,   input [(ADDR_W-1):0]        addr
    ,   output reg  ready
    ,   output reg [(INSTR_W-1):0]  instr
);

task reset; begin
    ready <= 0;
    instr <= ILLEGAL;
end
endtask

always @(arst) begin
    reset;
end

always @(posedge clk)
    if (srst)
        reset;

endmodule
