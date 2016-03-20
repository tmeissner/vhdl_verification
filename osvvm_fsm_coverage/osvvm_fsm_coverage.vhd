library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library std;
  use std.env.all;

library osvvm;
  use osvvm.NamePkg.all ;
  use osvvm.TranscriptPkg.all ;
  use osvvm.OsvvmGlobalPkg.all ;
  use osvvm.AlertLogPkg.all ;
  use osvvm.RandomPkg.all ;
  use osvvm.CoveragePkg.all ;
  use osvvm.MemoryPkg.all ;



entity osvvm_fsm_coverage is
end entity osvvm_fsm_coverage;



architecture sim of osvvm_fsm_coverage is


  type t_fsm_state is (IDLE, ADDR, DATA);
  signal s_fsm_state : t_fsm_state;

  signal s_clk     : std_logic := '0';
  signal s_reset_n : std_logic := '0';

  shared variable sv_cover : CovPType;


  procedure fsm_covadd_states (name  : in    string;
                               prev  : in    t_fsm_state;
                               curr  : in    t_fsm_state;
                               covdb : inout CovPType) is
  begin
    covdb.AddCross(name,
                   GenBin(t_fsm_state'pos(prev)),
                   GenBin(t_fsm_state'pos(curr)));
    wait;
  end procedure fsm_covadd_states;


  procedure fsm_covadd_illegal (name  : in    string;
                                covdb : inout CovPType) is
  begin
    covdb.AddCross(ALL_ILLEGAL, ALL_ILLEGAL);
    wait;
  end procedure fsm_covadd_illegal;


  procedure fsm_covcollect (signal reset : in    std_logic;
                            signal clk   : in    std_logic;
                            signal state : in    t_fsm_state;
                                   covdb : inout CovPType) is
    variable v_state : t_fsm_state := t_fsm_state'left;
  begin
    wait until reset = '1' and rising_edge(clk);
    loop
      v_state := state;
      wait until rising_edge(s_clk);
      covdb.ICover((t_fsm_state'pos(v_state), t_fsm_state'pos(state)));
    end loop;
  end procedure fsm_covcollect;


begin


  s_clk     <= not(s_clk) after 5 ns;
  s_reset_n <= '1' after 20 ns;


  FsmP : process (s_reset_n, s_clk) is
  begin
    if (s_reset_n = '0') then
      s_fsm_state <= IDLE;
    elsif (rising_edge(s_clk)) then
      case s_fsm_state is
        when IDLE => s_fsm_state <= ADDR;
        when ADDR => s_fsm_state <= DATA;
        when DATA => s_fsm_state <= IDLE;
        when others =>
          null;
      end case;
    end if;
  end process FsmP;


  fsm_covadd_states ("IDLE->ADDR", IDLE, ADDR, sv_cover);
  fsm_covadd_states ("ADDR->DATA", ADDR, DATA, sv_cover);
  fsm_covadd_states ("DATA->IDLE", DATA, IDLE, sv_cover);
  fsm_covadd_illegal ("ILLEGAL", sv_cover);
  fsm_covcollect (s_reset_n, s_clk, s_fsm_state, sv_cover);


  FinishP : process is
  begin
    wait until s_clk'active;
    if (sv_cover.IsCovered) then
      Log("FSM full covered :)", ALWAYS);
      sv_cover.SetName("FSM state coverage report");
      sv_cover.WriteBin;
      stop(0);
    end if;
  end process FinishP;


  -- psl default clock is rising_edge(s_clk);

  -- psl IDLE_ADDR : assert always (s_fsm_state = IDLE) -> next (s_fsm_state = ADDR) abort not(s_reset_n);
  -- psl ADDR_DATA : assert always (s_fsm_state = ADDR) -> next (s_fsm_state = DATA) abort not(s_reset_n);
  -- psl DATA_IDLE : assert always (s_fsm_state = DATA) -> next (s_fsm_state = IDLE) abort not(s_reset_n);


end architecture sim;
