module sr_ff(clk, r,s,q,nq);
input clk;
input r, s;
output reg q, nq;

always@(posedge clk)
begin
    if (s == 1)
    begin
        q<=1;
    end
    else if (r == 1)
    begin
        q<=0;
    end
    else if (s == 0 & r == 0)
    begin
        q <= q;
        nq <= nq;
    end
    nq<= ~q;
end
endmodule // sr_ff
