module top(
    input   CLK,
    input   BUT1,
    input   BUT2,
    output  LED1,
    output  LED2);

reg		[11:0]	clk_div;            // 12 bit counter
wire			clk_24KHz;          //signal with approx 24KHz clock
assign clk_24KHz = clk_div[11];     //100 000 000 Hz / 4096 = 24414 Hz

always @ (posedge CLK) begin        //on each positive edge of 100Mhz clock increment clk_div
	clk_div <= clk_div + 12'b1;
end

wire set, reset;
assign set=~BUT1;
assign reset=~BUT2;

sr_ff_lat des (
    .CLK(clk_24KHz),
    .SET(set),
    .RESET(reset),
    .Q(LED1),
    .QN(LED2)
);

endmodule                           // top
