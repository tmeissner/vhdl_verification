set signals [list]
lappend signals "top.osvvm_fsm_coverage.s_reset_n"
lappend signals "top.osvvm_fsm_coverage.s_clk"
lappend signals "top.osvvm_fsm_coverage.s_fsm_state"
set num_added [ gtkwave::addSignalsFromList $signals ]
