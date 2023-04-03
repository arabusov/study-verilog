/*
 * A simplified version of i8284 for a i8088 breadboard computer. Many
 * features of i8284 are not implemented. The only implemented so far are:
 *  - 33 % duty cycle clock of one third of the input frequency
 *  - RESET output of at least 4 CLK_4MHZ cycles duration
 */
module i8284(
    input wire  CLK_IN,
    input wire  RESN,
    output wire CLK_OUT,
    output wire RESET
);

reg [1:0]   clk_cntr = 0;
reg         clk_out_r = 0;

assign  CLK_OUT = clk_out_r;

always @ (posedge CLK_IN) begin
    if (clk_cntr == 2'b10) begin
        clk_cntr <= 2'b00;
        clk_out_r <= 1;
    end
    else begin
        clk_cntr <= clk_cntr + 1;
        clk_out_r <= 0;
    end
end

reg [3:0]   rst_cntr=0;
localparam [3:0] max_count = 3*4-1;
reg         rst_out_r=0;
reg [1:0]   rst_state=0;

assign RESET = rst_out_r;

always @ (posedge CLK_IN) begin
    case (rst_state)
        0: begin
            rst_out_r <= 0;
            if (~RESN)
                rst_state <= 1;
        end
        1: begin
            if (rst_cntr >= max_count) begin
                rst_state <= 2;
                rst_cntr <= 0;
                rst_out_r <= 0;
            end else begin
                rst_cntr <= rst_cntr + 1;
                rst_out_r <= 1;
            end
        end
        2: begin
            rst_out_r <= 0;
            if (RESN)
                rst_state <= 0;
        end
    endcase
end

endmodule // i8284
