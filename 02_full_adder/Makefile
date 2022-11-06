NAME=full_adder
OUT=fa

inspect: test.vcd
	gtkwave test.vcd

test.vcd: $(OUT)
	./$(OUT)

$(OUT): $(NAME).v $(NAME)_tb.v
	iverilog -o $@ $^

clean:
	rm test.vcd
	rm $(OUT)
