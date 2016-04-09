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



entity osvvm_fsm_psl_coverage is
end entity osvvm_fsm_psl_coverage;



architecture sim of osvvm_fsm_psl_coverage is


  type t_fsm_state is (IDLE, ADDR, DATA);
  signal s_fsm_state : t_fsm_state;

  signal s_clk     : std_logic := '0';
  signal s_reset_n : std_logic := '0';

  signal s_state_cover : unsigned(2 downto 0);

  shared variable sv_cover : CovPType;


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


  -- psl endpoint E_IDLE_ADDR is {s_fsm_state = IDLE; s_fsm_state = ADDR}@s_clk'active;
  -- psl endpoint E_ADDR_DATA is {s_fsm_state = ADDR; s_fsm_state = DATA}@s_clk'active;
  -- psl endpoint E_DATA_IDLE is {s_fsm_state = DATA; s_fsm_state = IDLE}@s_clk'active;


  EndpointRegP : process is
  begin
    s_state_cover <= (others => '0');
    if (E_IDLE_ADDR) then
      s_state_cover(0) <= '1';
    end if;
    if (E_ADDR_DATA) then
      s_state_cover(1) <= '1';
    end if;
    if (E_DATA_IDLE) then
      s_state_cover(2) <= '1';
    end if;
    wait until rising_edge(s_clk);
  end process;


  sv_cover.AddBins("IDLE->ADDR", GenBin(1));
  sv_cover.AddBins("ADDR->DATA", GenBin(2));
  sv_cover.AddBins("DATA->IDLE", GenBin(4));
  sv_cover.AddBins(ALL_ILLEGAL);


  CovCollectP : process is
  begin
    wait until s_reset_n = '1' and rising_edge(s_clk);
    -- we have to wait another cycle because endpoints are delayed by one cycle
    -- if we don't wait, we get an illegal BIN hit in second cycle after released reset
    wait until rising_edge(s_clk);
    loop
      wait until rising_edge(s_clk);
      sv_cover.ICover(to_integer(s_state_cover));
    end loop;
  end process CovCollectP; 


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

  -- psl IDLE_ADDR : assert always (s_fsm_state = IDLE and s_reset_n = '1') -> next (s_fsm_state = ADDR) abort not(s_reset_n)
  --  report "FSM error: IDLE should be followed by ADDR state";

  -- psl ADDR_DATA : assert always (s_fsm_state = ADDR and s_reset_n = '1') -> next (s_fsm_state = DATA) abort not(s_reset_n);
  --  report "FSM error: ADDR should be followed by DATA state";

  -- psl DATA_IDLE : assert always (s_fsm_state = DATA and s_reset_n = '1') -> next (s_fsm_state = IDLE) abort not(s_reset_n);
  --  report "FSM error: DATA should be followed by IDLE state";


end architecture sim;
