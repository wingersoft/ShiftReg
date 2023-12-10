## Driver for 74HC595 shift register

## requirements

* apio
* UpDuino v2.1 board

## verilog scripts

* `top.v` Top module.
* `top_tb.v` Test bench.
* `shiftreg.v` Shift register module.
* `control.v` Shift register controller module.
* `up5k.pcf` Pin assigment.
* `control.cmd` generate pdf for control.v
* `shiftreg.cmdf` generate pdf for shiftreg/v

## makefile
``` makefile
all: *.v
	iverilog -o top_tb top_tb.v shiftreg.v control.v
	vvp top_tb
	gtkwave top_tb.gtkw 2> /dev/null

pdf-shiftreg: shiftreg.v
	apio raw "yosys < shiftreg.cmd"
	cp ~/.yosys_show.pdf shiftreg.pdf

pdf-control: control.v
	apio raw "yosys < shiftreg.cmd"
	cp ~/.yosys_show.pdf control.pdf

clean:
	rm -f top_tb top_tb.vcd *.pdf
```
