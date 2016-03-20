set signals [list]
lappend signals "top.psl_test_endpoint.s_rst_n"
lappend signals "top.psl_test_endpoint.s_clk"
lappend signals "top.psl_test_endpoint.s_write"
lappend signals "top.psl_test_endpoint.s_read"
set num_added [ gtkwave::addSignalsFromList $signals ]
