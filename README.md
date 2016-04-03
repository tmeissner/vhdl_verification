# vhdl_verification

Examples and design pattern for VHDL verification. All examples run with GHDL, the open source VHDL simulator.
You have to use the latest version of GHDL, as the examples use features which where added to GHDL very recently.

### osvvm_fsm_coverage
Example to use OSVVMs CoveragePkg package to do FSM state coverage. State changes are used as BINS which are counted
in an object of type CovPType. The testbench accesses these state coverage data CoveragePkg procedures. So, the testbench
can react to the FSM coverage if necessary. Furthermore the state changes are checked by some PSL assertions.

### psl_endpoint_eval_in_vhdl
Example to show a recently feature added to GHDL which allows to evaluate PSL endpoints in VHDL code. It simply defines
an PSL endpoint and sets a boolean value dependent on the value of the PSL endpoint.

### psl_test_endpoint
This example was as test case to check the feature of evaluating PSL endpoints in VHDL, which was recently added to GHDL.
See GHDL issue [#45](https://github.com/tgingold/ghdl/issues/45) for details.
