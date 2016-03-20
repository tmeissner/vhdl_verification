.PHONY: sim compile clean wave


sim \
work/psl_test_endpoint \
work/psl_test_endpoint.ghw: work/psl_test_endpoint.o log
	@echo Run test ...
	@cd work; ghdl -r --std=08 -fpsl psl_test_endpoint \
	                  --psl-report=../log/psl_test_endpoint.json \
	                  --wave=../log/psl_test_endpoint.ghw \
	                  --stop-time=200ns


compile \
work/psl_test_endpoint.o: psl_test_endpoint.vhd work
	@echo "Analyse & elaborate test ..."
	cd work; ghdl -a --std=08 -fpsl ../psl_test_endpoint.vhd
	cd work; ghdl -e --std=08 -fpsl psl_test_endpoint


wave: work/psl_test_endpoint.ghw
	@echo Run waveform viewer ...
	@gtkwave log/psl_test_endpoint.ghw -S psl_test_endpoint.tcl &


work \
log:
	mkdir $@


clean:
	@echo Remove generated files ...
	@rm -rf work log
