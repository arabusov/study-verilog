module top(
    input   CLK,
    input   BUT1,
    input   BUT2,
    output  LED1,
    output  LED2);
reg q_r, qn_r;

reg		[11:0]	clk_div;			// 12 bit counter

wire			clk_24KHz;			//signal with approx 24KHz clock

assign clk_24KHz = clk_div[11];				//100 000 000 Hz / 4096 = 24414 Hz

assign LED1=q_r;
assign LED2=qn_r;

always @ (posedge CLK) begin				//on each positive edge of 100Mhz clock increment clk_div
	clk_div <= clk_div + 12'b1;
end


always @ (posedge clk_24KHz)
begin
    q_r <= q_r;
    qn_r <= qn_r;

    if (BUT1 == 0)
    begin
        q_r<=1;
        qn_r<=0;
    end
    else if (BUT2 == 0)
    begin
        q_r<=0;
        qn_r<=1;
    end
end
endmodule // sr_ff
