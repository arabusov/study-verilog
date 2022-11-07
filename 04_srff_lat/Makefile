NAME=sr_ff_lat
OUT=sr_lat
PIN_DEF = ice40hx1k-evb.pcf
DEVICE = hx1k

$(OUT): $(NAME).v $(NAME)_tb.v
	iverilog -o $@ $^

inspect: test.vcd
	gtkwave test.vcd

test.vcd: $(OUT)
	./$(OUT)

synt: $(NAME).rpt $(NAME).bin

%.blif: %.v
	yosys -p 'synth_ice40 -top top -blif $@' $<

%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d $(subst hx,,$(subst lp,,$(DEVICE))) -o $@ -p $^ -P vq100

%.bin: %.asc
	icepack $< $@

%.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

flash: $(NAME).bin
	sudo iceprogduino $<

clean:
	rm -f $(NAME).blif $(NAME).asc $(NAME).bin
	rm -f test.vcd
	rm -f $(OUT)

.PHONY: flash clean

