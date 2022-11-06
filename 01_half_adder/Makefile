inspect: test.vcd
	gtkwave test.vcd

test.vcd: ha
	./ha

ha: half_adder.v half_adder_tb.v
	iverilog -o $@ $^

clean:
	rm test.vcd
	rm ha
