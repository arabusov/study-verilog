NAME=i8284
OUT=i8284
PIN_DEF=ice40hx1k-evb.pcf
DEVICE=hx1k

$(OUT): $(NAME).v $(NAME)_tb.v
	iverilog -o $@ $^

inspect: test.vcd
	gtkwave test.vcd

test.vcd: $(OUT)
	./$(OUT)

synt: top.rpt top.bin

%.blif: top.v $(NAME).v
	yosys -p 'synth_ice40 -top top -blif $@' $^

%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d $(subst hx,,$(subst lp,,$(DEVICE))) -o $@ -p $^ -P vq100

%.bin: %.asc
	icepack $< $@

%.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

flash: top.bin
	sudo iceprogduino $<

clean:
	rm -f top.blif top.asc top.bin top.rpt
	rm -f test.vcd
	rm -f $(OUT)

.PHONY: flash clean

