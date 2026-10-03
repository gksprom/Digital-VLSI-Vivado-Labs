library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sliding_4bit_register is
end entity;

architecture tb of tb_sliding_4bit_register is

    --------------------------------------------------------------------
    -- COMPONENT
    --------------------------------------------------------------------
    component sliding_4bit_register is
        port (
            clk : in std_logic;
            rst : in std_logic;
            pl  : in std_logic;
            en  : in std_logic;
            dir : in std_logic;
            si  : in std_logic;
            din : in std_logic_vector(3 downto 0);
            so  : out std_logic
        );
    end component;

    --------------------------------------------------------------------
    -- SIGNALS
    --------------------------------------------------------------------
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal pl  : std_logic := '0';
    signal en  : std_logic := '0';
    signal dir : std_logic := '0';
    signal si  : std_logic := '0';
    signal din : std_logic_vector(3 downto 0) := (others => '0');
    signal so  : std_logic;

    --------------------------------------------------------------------
    -- CONSTANTS
    --------------------------------------------------------------------
    constant CLOCK_PERIOD : time := 10 ns;

begin

    --------------------------------------------------------------------
    -- DUT
    --------------------------------------------------------------------
    DUT : sliding_4bit_register
        port map (
            clk => clk,
            rst => rst,
            pl  => pl,
            en  => en,
            dir => dir,
            si  => si,
            din => din,
            so  => so
        );

    --------------------------------------------------------------------
    -- CLOCK
    --------------------------------------------------------------------
    CLOCK_PROC : process
    begin
        while true loop
            clk <= '0';
            wait for CLOCK_PERIOD / 2;
            clk <= '1';
            wait for CLOCK_PERIOD / 2;
        end loop;
    end process;

    --------------------------------------------------------------------
    -- STIMULUS
    --------------------------------------------------------------------
    STIMULUS : process
    begin
        -- reset active-low
        rst <= '0';
        pl  <= '0';
        en  <= '0';
        dir <= '0';
        si  <= '0';
        din <= "0000";
        wait for CLOCK_PERIOD;

        rst <= '1';
        wait for CLOCK_PERIOD;

        -- parallel load 1011
        pl  <= '1';
        din <= "1011";
        wait for CLOCK_PERIOD;

        pl  <= '0';
        wait for CLOCK_PERIOD;

        -- right shift, serial in = 0
        dir <= '0';
        en  <= '1';
        si  <= '0';
        wait for CLOCK_PERIOD;

        -- right shift, serial in = 1
        si  <= '1';
        wait for CLOCK_PERIOD;

        -- right shift, serial in = 0
        si  <= '0';
        wait for CLOCK_PERIOD;

        en <= '0';
        wait for CLOCK_PERIOD;

        -- parallel load 1100
        pl  <= '1';
        din <= "1100";
        wait for CLOCK_PERIOD;

        pl  <= '0';
        wait for CLOCK_PERIOD;

        -- left shift, serial in = 1
        dir <= '1';
        en  <= '1';
        si  <= '1';
        wait for CLOCK_PERIOD;

        -- left shift, serial in = 0
        si  <= '0';
        wait for CLOCK_PERIOD;

        -- left shift, serial in = 1
        si  <= '1';
        wait for CLOCK_PERIOD;

        en <= '0';
        wait for CLOCK_PERIOD;

        -- final reset
        rst <= '0';
        wait for CLOCK_PERIOD;

        rst <= '1';
        wait for CLOCK_PERIOD;

        wait;
    end process;

end architecture;