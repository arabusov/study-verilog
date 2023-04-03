module top(
	input   CLK,
	input   BUT1,
    output  CLK_OUT,
    output  RESET,
    output  LED1,
    output  LED2
);

reg		[11:0]	clk_div;    	// 12 bit counter
wire            clk_13MHz;
wire            clk_24kHz;
assign          clk_13MHz = clk_div[2];      // 100 000 000 Hz / 8 = 13 MHz

assign          clk_24kHz = clk_div[11];	    // for debouncing
reg             rstn_r;
reg     [11:0]  rstn_cntr=0;
assign          LED2=~rstn_r;

always @ (posedge CLK) begin				//on 100Mhz clock increment clk_div
	clk_div <= clk_div + 12'b1;
end

always @ (posedge clk_24kHz) begin
    rstn_r <= BUT1;
end

i8284 sab8284(
    .CLK_IN(clk_13MHz),
    .RESN(rstn_r),
    .CLK_OUT(CLK_OUT),
    .RESET(RESET)
);

assign          LED1=RESET;

endmodule
