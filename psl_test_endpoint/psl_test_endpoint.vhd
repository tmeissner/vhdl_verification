library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.env.all;


entity psl_test_endpoint is
end entity psl_test_endpoint;


architecture test of psl_test_endpoint is


  signal s_rst_n : std_logic := '0';
  signal s_clk   : std_logic := '0';
  signal s_write : std_logic;
  signal s_read  : std_logic;


begin


  s_rst_n <= '1' after 100 ns;
  s_clk   <= not s_clk after 10 ns;


  TestP : process is
  begin
    report "RUNNING psl_test_endpoint test case";
    report "==========================================";
    s_write <= '0';  -- named assertion should hit
    s_read  <= '0';
    wait until s_rst_n = '1' and rising_edge(s_clk);
    s_write <= '1';
    wait until rising_edge(s_clk);
    s_read  <= '1';  -- assertion should hit
    wait until rising_edge(s_clk);
    s_write <= '0';
    s_read  <= '0';
    wait until rising_edge(s_clk);
    --stop(0);
    wait;
  end process TestP;


  -- psl default clock is rising_edge(s_clk);
  -- psl endpoint E_TEST0 is {not(s_write); s_write};
  -- psl endpoint E_TEST1 is {s_write; s_write and not(s_read)};
  -- psl sequence abc_seq is {not(s_write); s_write};

  -- ASSERT0 should be passed, but not failed
  -- ASSERT1 should be failed
  -- ASSERT2 should not be passed

  -- psl ASSERT0 : assert always {E_TEST0} |=> {s_read} report  "ASSERT0";
  -- psl ASSERT1 : assert always {E_TEST0} |-> {s_read} report  "ASSERT1";
  -- psl ASSERT2 : assert always {E_TEST1} |-> {s_read} report  "ASSERT2";

  -- COVERAGE0..COVERAGE2 should all hit @ same time
  -- COVERAGE3 should never hit

  -- psl COVERAGE0 : cover {not(s_write); s_write} report "COVERED0";
  -- psl COVERAGE1 : cover {abc_seq} report "COVERED1";
  -- psl COVERAGE2 : cover {E_TEST0} report "COVERED2";
  -- psl COVERAGE3 : cover {E_TEST1} report "COVERED3";


end architecture test;
