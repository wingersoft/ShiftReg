all: *.v
	iverilog -o top_tb *.v
	vvp top_tb
	gtkwave top_tb.gtkw 2> /dev/null

clean:
	rm -f top_tb
	rm -f top_tb.vcd
