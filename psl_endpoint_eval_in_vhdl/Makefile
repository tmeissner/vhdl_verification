.PHONY: sim compile clean wave


sim \
work/psl_endpoint_eval_in_vhdl \
work/psl_endpoint_eval_in_vhdl.ghw: work/psl_endpoint_eval_in_vhdl.o log
	@echo Run test ...
	@cd work; ghdl -r --std=08 -fpsl psl_endpoint_eval_in_vhdl \
	                  --psl-report=../log/psl_endpoint_eval_in_vhdl.json \
	                  --wave=../log/psl_endpoint_eval_in_vhdl.ghw \
	                  --stop-time=200ns


compile \
work/psl_endpoint_eval_in_vhdl.o: psl_endpoint_eval_in_vhdl.vhd work
	@echo "Analyse & elaborate test ..."
	cd work; ghdl -a --std=08 -fpsl ../psl_endpoint_eval_in_vhdl.vhd
	cd work; ghdl -e --std=08 -fpsl psl_endpoint_eval_in_vhdl >& /dev/null


wave: work/psl_endpoint_eval_in_vhdl.ghw
	@echo Run waveform viewer ...
	@gtkwave log/psl_endpoint_eval_in_vhdl.ghw -S psl_endpoint_eval_in_vhdl.tcl &


work \
log:
	mkdir $@


clean:
	@echo Remove generated files ...
	@rm -rf work log
