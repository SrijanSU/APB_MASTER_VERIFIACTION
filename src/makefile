QUESTA := /home/share/questa.csh
SHELL := /bin/csh
TEST ?= regression_test
V ?= UVM_LOW

.ONESHELL:	
all:
	source $(QUESTA)
	make clean
	make compile
	make simulate
	vcover report -html apb_master_coverage.ucdb -htmldir $(TEST)/covReport -details

clean:
	rm -rf work/ transcript vsim.wlf wave.vcd vsim_stacktrace.vstf 
	rm .nco* 
	rm .makefile*
	rm -rf covReport apb_master_coverage.ucdb 
	find . -maxdepth 1 -type d -regex '.*_test$$' -exec rm -rf {} +
	rm apb_master.log simulation.log
	rm apb_master_coverage.ucdb
	clear
	clear
	clear

compile:
	@echo "\t\t\t\t...............................COMPILING CODE..............................."
	source $(QUESTA)
	vlog +define+UVM_NO_DPI testbench.sv "+incdir+/tools/mentor/questasim_10.6c/questasim/uvm-1.1d/../verilog_src/uvm-1.1d/src"

wave:
	make compile
	@echo "\t\t\t\t\t...............GENERATING WAVEFORM FOR TEST = $(TEST)..............."
	vsim -novopt work.top +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(V)

simulate:
	@echo "\t\t\t\t...........................SIMULATING TEST = $(TEST) WITH VERBOSITY = $(V)..........................."
	vsim -vopt work.top -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll apb_master_coverage.ucdb; run -all; exit" +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(V)

view:
	firefox ./$(TEST)/covReport/index.html
