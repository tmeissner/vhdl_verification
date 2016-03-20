OSVVM := OSVVM


.PHONY: sim compile clean wave


sim \
work/osvvm_fsm_coverage \
work/osvvm_fsm_coverage.ghw: work/osvvm_fsm_coverage.o log
	@echo Run test ...
	@cd work; ghdl -r --std=08 -fpsl osvvm_fsm_coverage \
                    --psl-report=../log/osvvm_fsm_coverage.json \
                    --wave=../log/osvvm_fsm_coverage.ghw \
                    --stop-time=200ns


work/osvvm/%.o: work/osvvm
	@echo "Analyse OSVVM library ..."
	@cd work; ghdl -a --std=08 --work=osvvm --workdir=osvvm ../$(OSVVM)/NamePkg.vhd
	@cd work; ghdl -a --std=08 --work=osvvm --workdir=osvvm ../$(OSVVM)/TranscriptPkg.vhd
	@cd work; ghdl -a --std=08 --work=osvvm --workdir=osvvm ../$(OSVVM)/OsvvmGlobalPkg.vhd
	@cd work; ghdl -a --std=08 --work=osvvm --workdir=osvvm ../$(OSVVM)/TextUtilPkg.vhd
	@cd work; ghdl -a --std=08 --work=osvvm --workdir=osvvm ../$(OSVVM)/AlertLogPkg.vhd
	@cd work; ghdl -a --std=08 --work=osvvm --workdir=osvvm ../$(OSVVM)/RandomBasePkg.vhd
	@cd work; ghdl -a --std=08 --work=osvvm --workdir=osvvm ../$(OSVVM)/SortListPkg_int.vhd
	@cd work; ghdl -a --std=08 --work=osvvm --workdir=osvvm ../$(OSVVM)/RandomPkg.vhd
	@cd work; ghdl -a --std=08 --work=osvvm --workdir=osvvm ../$(OSVVM)/MessagePkg.vhd
	@cd work; ghdl -a --std=08 --work=osvvm --workdir=osvvm ../$(OSVVM)/CoveragePkg.vhd
	@cd work; ghdl -a --std=08 --work=osvvm --workdir=osvvm ../$(OSVVM)/MemoryPkg.vhd


compile \
work/osvvm_fsm_coverage.o: osvvm_fsm_coverage.vhd work work/work work/osvvm/CoveragePkg.o
	@echo "Analyse & elaborate test ..."
	@cd work; ghdl -a --std=08 -fpsl --workdir=work -Posvvm ../osvvm_fsm_coverage.vhd
	@cd work; ghdl -e --std=08 -fpsl --workdir=work -Posvvm -o osvvm_fsm_coverage osvvm_fsm_coverage >& /dev/null


wave: work/osvvm_fsm_coverage.ghw
	@echo Run waveform viewer ...
	@gtkwave log/osvvm_fsm_coverage.ghw -S osvvm_fsm_coverage.tcl &


work \
work/osvvm \
work/work \
log:
	@mkdir $@


clean:
	@echo Remove generated files ...
	@rm -rf work log
