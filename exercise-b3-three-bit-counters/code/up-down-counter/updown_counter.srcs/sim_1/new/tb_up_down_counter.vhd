library IEEE;
use IEEE.std_logic_1164.all;

entity tb_up_down_counter is
end entity;

architecture tb of tb_up_down_counter is

    --------------------------------------------------------------------
    -- COMPONENT
    --------------------------------------------------------------------
    component up_down_counter is
        port (
            clk      : in  std_logic;
            resetn   : in  std_logic;
            count_en : in  std_logic;
            dir      : in  std_logic;
            sum      : out std_logic_vector(2 downto 0);
            cout     : out std_logic
        );
    end component;

    --------------------------------------------------------------------
    -- SIGNALS
    --------------------------------------------------------------------
    signal clk      : std_logic := '0';
    signal resetn   : std_logic := '1';
    signal count_en : std_logic := '0';
    signal dir      : std_logic := '1';
    signal sum      : std_logic_vector(2 downto 0);
    signal cout     : std_logic;

    --------------------------------------------------------------------
    -- CONSTANTS
    --------------------------------------------------------------------
    constant CLOCK_PERIOD : time := 10 ns;

begin

    --------------------------------------------------------------------
    -- DUT
    --------------------------------------------------------------------
    DUT : up_down_counter
        port map (
            clk      => clk,
            resetn   => resetn,
            count_en => count_en,
            dir      => dir,
            sum      => sum,
            cout     => cout
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
        -- asynchronous active-low reset
        resetn <= '0';
        count_en <= '0';
        dir <= '1';
        wait for CLOCK_PERIOD;

        resetn <= '1';
        wait for CLOCK_PERIOD;

        ----------------------------------------------------------------
        -- COUNT UP : 0 → 5
        ----------------------------------------------------------------
        count_en <= '1';
        dir <= '1';
        wait for 5 * CLOCK_PERIOD;

        ----------------------------------------------------------------
        -- COUNT DOWN : 5 → 3
        ----------------------------------------------------------------
        dir <= '0';
        wait for 2 * CLOCK_PERIOD;

        ----------------------------------------------------------------
        -- COUNT UP : 3 → 7
        ----------------------------------------------------------------
        dir <= '1';
        wait for 4 * CLOCK_PERIOD;

        ----------------------------------------------------------------
        -- COUNT DOWN : 7 → 3
        ----------------------------------------------------------------
        dir <= '0';
        wait for 4 * CLOCK_PERIOD;

        ----------------------------------------------------------------
        -- COUNT UP : 3 → 5
        ----------------------------------------------------------------
        dir <= '1';
        wait for 2 * CLOCK_PERIOD;

        ----------------------------------------------------------------
        -- COUNT DOWN : 5 → 0
        ----------------------------------------------------------------
        dir <= '0';
        wait for 5 * CLOCK_PERIOD;

        ----------------------------------------------------------------
        -- HOLD
        ----------------------------------------------------------------
        count_en <= '0';
        wait for 2 * CLOCK_PERIOD;

        ----------------------------------------------------------------
        -- RESET AGAIN
        ----------------------------------------------------------------
        resetn <= '0';
        wait for CLOCK_PERIOD;

        resetn <= '1';
        wait for CLOCK_PERIOD;

        wait;
    end process;

end tb;