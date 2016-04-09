set signals [list]
lappend signals "top.osvvm_fsm_psl_coverage.s_reset_n"
lappend signals "top.osvvm_fsm_psl_coverage.s_clk"
lappend signals "top.osvvm_fsm_psl_coverage.s_fsm_state"
lappend signals "top.osvvm_fsm_psl_coverage.s_state_cover"
set num_added [ gtkwave::addSignalsFromList $signals ]
