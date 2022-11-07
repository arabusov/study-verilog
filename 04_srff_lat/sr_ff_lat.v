module sr_ff_lat(
    input wire CLK,
    input wire SET,
    input wire RESET,
    output wire Q,
    output wire QN
);

reg q_r, qn_r;

assign Q=q_r;
assign QN=qn_r;

always @ (posedge CLK)
begin
    q_r <= q_r;
    qn_r <= qn_r;

    if (SET == 1)
    begin
        q_r<=1;
        qn_r<=0;
    end
    else if (RESET == 1)
    begin
        q_r<=0;
        qn_r<=1;
    end
end
endmodule // sr_ff_lat
