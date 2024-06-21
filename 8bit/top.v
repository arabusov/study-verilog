module top(
    input   CLK,
    input   BUT1,
    input   BUT2,
    output  LED1,
    output  LED2);

reg		[11:0]	clk_div;            // 12 bit counter
wire			clk_24KHz;          //signal with approx 24KHz clock
assign clk_24KHz = clk_div[11];     //100 000 000 Hz / 4096 = 24414 Hz

always @ (negedge CLK) begin        //on each positive edge of 100Mhz clock increment clk_div
	clk_div <= clk_div + 12'b1;
end

wire set, reset;
assign set=~BUT1;
assign reset=~BUT2;

wire [7:0] data;
wire [7:0] addr;
wire ready, rw;

assign LED1 = addr[0];
assign LED2 = addr[1];
assign ready = 1;

be8 proc(.clk(CLK), .rst(reset),
    .data(data), .addr(addr), .ready(ready),
    .rw(rw));
ram8x16 mem(.d(data), .a(addr), .we(rw), .clk(CLK));

endmodule                           // top
