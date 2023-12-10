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

