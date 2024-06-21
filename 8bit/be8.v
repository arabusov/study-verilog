module alu(
    input [3:0] exe
    , input [7:0] a
    , input [7:0] b
    , input cin
    , output reg [7:0] out
    , output reg cout
    );
    always @(*) begin
        case (exe)
            0: { cout, out } = a + b + cin;
            default: { cout, out } = { cin, 8'h00 };
        endcase
    end
endmodule

module addr_mux(
    input [2:0] state
    , input [7:0] ar
    , input [7:0] pc
    , output [7:0] addr
    );
    assign addr = ( (state[1] == 1'b1) ? ar : pc );
endmodule

module be8(
    input clk
    , input rst
    , inout [7:0] data
    , input ready
    , output reg rw
    , output [7:0] addr
    );
    reg [2:0] state;
    reg [7:0] instr;

    reg [7:0] pc;
    reg [7:0] ar;
    reg [7:0] a;
    reg [7:0] b;
    reg carry;
    wire cout;
    wire [7:0] alu_out;

    alu alu_inst(.exe(4'b0000),
        .a(a), .b(b), .cin(carry), .cout(cout), .out(alu_out));
    addr_mux am(.state(state), .ar(ar), .pc(pc), .addr(addr));

    always @rst begin
        if (rst) begin
            assign state = 0;
            assign instr = 0;
            assign pc = 8'hf0;
            assign ar = pc;
            assign rw = 0;
            assign a = 0;
            assign b = 0;
            assign carry = 0;
        end else begin
            deassign state;
            deassign instr;
            deassign pc;
            deassign ar;
            deassign rw;
            deassign a;
            deassign b;
            deassign carry;
        end
    end
    assign data = ( (rw == 1) ? a : { 8{1'bz} } ); 

    always @(negedge clk & ready &~rst) begin
        case (state)
            0: begin instr <= data; state <= 1; pc <= pc + 1; end
            1: begin
                case (instr[2:0])
                    0: begin
                        {carry, a} <= {cout, alu_out};
                        instr <= data; // fetch next instruction immediately
                        state <= 1;
                        pc <= pc + 1;
                    end
                    1: begin
                        b <= a;
                        a <= b;
                        instr <= data; // fetch next instruction immediately
                        state <= 1;
                        pc <= pc + 1;
                    end
                    4: begin            // make absolute jump
                        pc <= data;
                        state <= 0;
                    end
                    default: begin
                        ar <= data;
                        state <= 2;
                    end
                endcase
            end
            2: begin
                pc <= pc + 1;
                case (instr[1:0])
                    2: begin a <= data; state <= 0; end
                    3: begin rw <= 1; state <= 3; end
                endcase
            end
            3: begin
                rw <= 0; state <= 0;
            end
        endcase
    end
endmodule

module ram8x256(d, a, we, clk);
    inout [7:0] d;
    input [7:0] a;
    input we;
    input clk;

    reg [7:0] mem [0:255];

    assign d = ( we ? 8'bzzzzzzzz : mem[a] );
    always @(negedge clk)
        if (we)
            mem[a] <= d;
endmodule

module main;

reg clk, rst;
wire [7:0] data;
wire [7:0] addr;
reg ready;
wire rw;

be8 proc(.clk(clk), .rst(rst),
    .data(data), .addr(addr), .ready(ready),
    .rw(rw));
ram8x256 mem(.d(data), .a(addr), .we(rw), .clk(clk));
initial $readmemh("mem.txt", mem.mem, 8'hf0, 8'hff);

integer i;
always #1 clk = !clk;
initial begin
    $dumpfile("show_be8_tb.vcd");
    $dumpvars(0, clk);
    $dumpvars(0, rst);
    $dumpvars(0, proc);
    $dumpvars(0, mem);
    $display("your program:");
    for (i = 8'hf0; i <= 8'hff; i++) begin
        $display(mem.mem[i]);
    end
    clk = 0;
    rst = 1;
    ready = 1;
    #1;
    rst = 0;
    while (addr < 8'hff && ~proc.carry) begin
        #1;
    end
    $finish ;
end

endmodule
