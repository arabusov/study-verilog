module alu(
    input   cin
    , input [MSBEXE:0] exe
    , input [7:0] a
    , input [7:0] b
    , output reg cout
    , output reg [7:0] c
    );
    parameter MSBEXE = 4;
    always @(*)
        case (exe)
            0: {cout, c} = a + b + cin;
            default: {cout, c} = {cin, a};
        endcase
endmodule

module u13(
    input clk
    , input rst
    , inout [7:0] data
    , output reg [15:0] addr
    , output reg rw
    );
    reg [15:0] pc;

    parameter MSBEXE = 4;
    reg [MSBEXE:0] alu_exe;
    reg [2:0] state;
    parameter FETCH_STATE   = 0;
    parameter DECODE_STATE  = 1;
    parameter ZP_STATE      = 2;
    parameter ABS1_STATE    = 3;
    parameter ABS2_STATE    = 4;

    always @(posedge clk) begin
        if (rst)
            reset;
        else begin
            case (state)
                FETCH_STATE: fetch;
                DECODE_STATE: decode;
                ZP_STATE: zp;
                ABS1_STATE: abs1_t;
                ABS2_STATE: abs2_t;
            endcase
        end
    end

    parameter RST_ADDR = 16'hfff0;

    reg [7:0] instr;

    task reset;
        begin
            a <= 0;
            rw <= 0;
            addr <= RST_ADDR;
            pc <= RST_ADDR;
            state <= FETCH_STATE;
            carry <= 0;
        end
    endtask

    task fetch;
        begin
            advance;
            instr <= data;
            state <= DECODE_STATE;
        end
    endtask

    task advance;
        begin
            pc <= pc + 1;
            addr <= pc + 1;
        end
    endtask

    wire [3:0] ih, il;
    assign {ih, il} = instr;

    parameter NOP   = 8'hea;
    parameter JMP   = 8'h6c;

    // Main instructions
    parameter ADC   = 4'h6;
    parameter STA   = 4'h8;
    parameter LDA   = 4'ha;

    // Addressing modes
    parameter IMMED = 4'h9;
    parameter ZP    = 4'h5;

    reg [7:0] a;
    reg carry;
    reg [7:0] addr_lo;
    wire cout;
    wire [7:0] c;

    alu i_alu(.exe(alu_exe), .a(a), .b(data), .c(c), .cin(carry), .cout(cout));

    task decode;
        begin
            if (instr == NOP) fetch;
            else if (instr == JMP) abs1_t;
            else begin
                case (il)
                    ZP: begin
                        state <= ZP_STATE;
                        addr <= { 8'h00, data };
                    end
                    IMMED: begin
                        casez (ih)
                            ADC: alu_t;
                            LDA: lda_t;
                            default: fetch;
                        endcase
                    end
                    default: fetch;
                endcase
            end
            case (ih)
                ADC: alu_exe <= 0;
                STA: rw <= 1;
            endcase
        end
    endtask

    task zp;
        casez (ih)
            ADC: alu_t;
            LDA: lda_t;
            STA: sta_t;
        endcase
    endtask

    task abs1_t;
        begin
            addr_lo <= data;
            state <= ABS2_STATE;
            advance;
        end
    endtask

    task abs2_t;
        jmp_t;
    endtask
            
    task lda_t;
        begin
            a <= data;
            state <= FETCH_STATE;
            advance;
        end
    endtask

    assign data = ( (rw == 1) ? a : { 8{1'bz} } ); 

    task sta_t;
        begin
            rw <= 0;
            state <= FETCH_STATE;
            advance;
        end
    endtask

    task alu_t;
        begin
            {carry, a} <= {cout, c};
            fetch;
        end
    endtask

    task jmp_t;
        begin
            pc <= { data, addr_lo };
            addr <= { data, addr_lo };
            state <= FETCH_STATE;
        end
    endtask
endmodule
