# Makefile
VCS = vcs -full64 -sverilog -ntb_opts uvm -timescale=1ns/1ps
INC = +incdir+./UVM

all: compile sim

compile:
	$(VCS) $(INC) ./UVM/fifo_if.sv fifo_sync.sv ./UVM/fifo_pkg.sv ./UVM/tb_top.sv -o simv

sim:
	./simv +UVM_TESTNAME=fifo_test

clean:
	rm -rf simv* csrc ucli.key vc_hdrs.h
