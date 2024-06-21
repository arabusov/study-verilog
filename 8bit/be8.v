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

    assign data = ( (rw == 1) ? a : { 8{1'bz} } ); 

    always @(posedge clk) begin
        if (rst) begin
            state <= 0;
            instr <= 0;
            pc <= 8'hf0;
            ar <= pc;
            rw <= 0;
            a <= 0;
            b <= 0;
            carry <= 0;
        end else case (state)
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
                    3: begin            // Store A
                        ar <= data;
                        rw <= 1;
                        state <= 3;
                        pc <= pc + 1;
                    end
                    2: begin            // Load A
                        ar <= data;
                        state <= 2;
                        pc <= pc + 1;
                    end
                endcase
            end
            2: begin        // Seems to be a typical von Neumann bottleneck
                a <= data;
                state <= 0;
            end
            3: begin        // for both read and write
                rw <= 0;
                state <= 0;
            end
        endcase
    end
endmodule

module ram8x16(d, a, we, clk);
    inout [7:0] d;
    input [7:0] a;
    input we;
    input clk;

    reg [7:0] mem [0:16];

    assign d = ( we ? 8'bzzzzzzzz : mem[a[3:0]] );
    always @(posedge clk)
        if (we)
            mem[a[3:0]] <= d;
endmodule
