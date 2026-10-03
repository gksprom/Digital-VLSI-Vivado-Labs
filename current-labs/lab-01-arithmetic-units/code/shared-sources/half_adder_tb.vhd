-------------------------------------------------------------------
-- HALF ADDER (DATAFLOW) - TESTBENCH
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity half_adder_dataflow_tb is
end entity;

architecture tb of half_adder_dataflow_tb is
    ---------------------------------------------------------------
    -- COMPONENT
    ---------------------------------------------------------------
    component half_adder_dataflow is
        port (
            i_a     : in    std_logic;
            i_b     : in    std_logic;
            o_s     : out   std_logic;
            o_c     : out   std_logic
        );
    end component;

    ---------------------------------------------------------------
    -- SIGNALS
    ---------------------------------------------------------------
    signal i_a      : std_logic := '0';
    signal i_b      : std_logic := '0';
    signal o_s      : std_logic;
    signal o_c      : std_logic;

    ---------------------------------------------------------------
    -- CONSTANTS
    ---------------------------------------------------------------
    constant TIME_DELAY : time := 10 ns;

begin

    DUT : half_adder_dataflow
        port map (
            i_a     => i_a,
            i_b     => i_b,
            o_s     => o_s,
            o_c     => o_c
        );

    STIMULUS : process
    begin
        -----------------------------------------------------------
        -- 00
        -----------------------------------------------------------
        i_a <= '0';
        i_b <= '0';
        wait for TIME_DELAY;

        assert (o_s = '0' and o_c = '0')
        report "ERROR: wrong output for input 00"
        severity error;

        -----------------------------------------------------------
        -- 01
        -----------------------------------------------------------
        i_a <= '0';
        i_b <= '1';
        wait for TIME_DELAY;

        assert (o_s = '1' and o_c = '0')
        report "ERROR: wrong output for input 01"
        severity error;

        -----------------------------------------------------------
        -- 10
        -----------------------------------------------------------
        i_a <= '1';
        i_b <= '0';
        wait for TIME_DELAY;

        assert (o_s = '1' and o_c = '0')
        report "ERROR: wrong output for input 10"
        severity error;

        -----------------------------------------------------------
        -- 11
        -----------------------------------------------------------
        i_a <= '1';
        i_b <= '1';
        wait for TIME_DELAY;

        assert (o_s = '0' and o_c = '1')
        report "ERROR: wrong output for input 11"
        severity error;

        -----------------------------------------------------------
        -- END SIMULATION
        -----------------------------------------------------------
        report "HALF ADDER TEST COMPLETED SUCCESSFULLY"
        severity note;

        wait;
    end process;

end architecture;