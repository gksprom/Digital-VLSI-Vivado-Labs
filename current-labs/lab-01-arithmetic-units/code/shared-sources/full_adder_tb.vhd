-------------------------------------------------------------------
-- FULL ADDER (STRUCTURAL) - TESTBENCH
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity full_adder_structural_tb is
end entity;

architecture tb of full_adder_structural_tb is

    ---------------------------------------------------------------
    -- COMPONENT
    ---------------------------------------------------------------
    component full_adder_structural is
        port (
            i_a     : in    std_logic;
            i_b     : in    std_logic;
            i_cin   : in    std_logic;
            o_s     : out   std_logic;
            o_cout  : out   std_logic
        );
    end component;

    ---------------------------------------------------------------
    -- SIGNALS
    ---------------------------------------------------------------
    signal i_a      : std_logic := '0';
    signal i_b      : std_logic := '0';
    signal i_cin    : std_logic := '0';
    signal o_s      : std_logic;
    signal o_cout   : std_logic;

    ---------------------------------------------------------------
    -- CONSTANTS
    ---------------------------------------------------------------
    constant TIME_DELAY : time := 10 ns;

begin

    DUT : full_adder_structural
        port map (
            i_a     => i_a,
            i_b     => i_b,
            i_cin   => i_cin,
            o_s     => o_s,
            o_cout  => o_cout
        );

    STIMULUS : process
    begin
        -----------------------------------------------------------
        -- 000
        -----------------------------------------------------------
        i_a <= '0'; i_b <= '0'; i_cin <= '0';
        wait for TIME_DELAY;
        assert (o_s = '0' and o_cout = '0')
        report "ERROR: wrong output for input 000"
        severity error;

        -----------------------------------------------------------
        -- 001
        -----------------------------------------------------------
        i_a <= '0'; i_b <= '0'; i_cin <= '1';
        wait for TIME_DELAY;
        assert (o_s = '1' and o_cout = '0')
        report "ERROR: wrong output for input 001"
        severity error;

        -----------------------------------------------------------
        -- 010
        -----------------------------------------------------------
        i_a <= '0'; i_b <= '1'; i_cin <= '0';
        wait for TIME_DELAY;
        assert (o_s = '1' and o_cout = '0')
        report "ERROR: wrong output for input 010"
        severity error;

        -----------------------------------------------------------
        -- 011
        -----------------------------------------------------------
        i_a <= '0'; i_b <= '1'; i_cin <= '1';
        wait for TIME_DELAY;
        assert (o_s = '0' and o_cout = '1')
        report "ERROR: wrong output for input 011"
        severity error;

        -----------------------------------------------------------
        -- 100
        -----------------------------------------------------------
        i_a <= '1'; i_b <= '0'; i_cin <= '0';
        wait for TIME_DELAY;
        assert (o_s = '1' and o_cout = '0')
        report "ERROR: wrong output for input 100"
        severity error;

        -----------------------------------------------------------
        -- 101
        -----------------------------------------------------------
        i_a <= '1'; i_b <= '0'; i_cin <= '1';
        wait for TIME_DELAY;
        assert (o_s = '0' and o_cout = '1')
        report "ERROR: wrong output for input 101"
        severity error;

        -----------------------------------------------------------
        -- 110
        -----------------------------------------------------------
        i_a <= '1'; i_b <= '1'; i_cin <= '0';
        wait for TIME_DELAY;
        assert (o_s = '0' and o_cout = '1')
        report "ERROR: wrong output for input 110"
        severity error;

        -----------------------------------------------------------
        -- 111
        -----------------------------------------------------------
        i_a <= '1'; i_b <= '1'; i_cin <= '1';
        wait for TIME_DELAY;
        assert (o_s = '1' and o_cout = '1')
        report "ERROR: wrong output for input 111"
        severity error;

        -----------------------------------------------------------
        -- END SIMULATION
        -----------------------------------------------------------
        report "FULL ADDER TEST COMPLETED SUCCESSFULLY"
        severity note;

        wait;
    end process;

end architecture;