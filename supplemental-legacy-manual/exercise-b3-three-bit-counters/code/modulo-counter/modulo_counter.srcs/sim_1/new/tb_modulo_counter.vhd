library IEEE;
use IEEE.std_logic_1164.all;

entity tb_modulo_counter is
end entity;

architecture tb of tb_modulo_counter is

    --------------------------------------------------------------------
    -- COMPONENT
    --------------------------------------------------------------------
    component modulo_counter is
        port(
            clk      : in  std_logic;
            resetn   : in  std_logic;
            count_en : in  std_logic;
            modulo   : in  std_logic_vector(2 downto 0);
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
    signal modulo   : std_logic_vector(2 downto 0) := "111";
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
    DUT : modulo_counter
        port map(
            clk      => clk,
            resetn   => resetn,
            count_en => count_en,
            modulo   => modulo,
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
            wait for CLOCK_PERIOD/2;
            clk <= '1';
            wait for CLOCK_PERIOD/2;
        end loop;
    end process;

    --------------------------------------------------------------------
    -- STIMULUS
    --------------------------------------------------------------------
    STIMULUS : process
    begin
        -- Reset
        resetn   <= '0';
        count_en <= '0';
        modulo   <= "011";  -- wrap at 3
        wait for CLOCK_PERIOD;

        resetn <= '1';
        wait for CLOCK_PERIOD;

        -- Enable counting with modulo=3: 000 001 010 011 000 ...
        count_en <= '1';
        wait for 10 * CLOCK_PERIOD;

        -- Hold
        count_en <= '0';
        wait for 2 * CLOCK_PERIOD;

        -- Change modulo to 5 and count again: ... wrap at 5
        modulo <= "101";
        wait for CLOCK_PERIOD;

        count_en <= '1';
        wait for 12 * CLOCK_PERIOD;

        -- Hold again
        count_en <= '0';
        wait for 2 * CLOCK_PERIOD;

        -- Test modulo=7 (normal 3-bit wrap): 000..111..000...
        modulo <= "111";
        wait for CLOCK_PERIOD;

        count_en <= '1';
        wait for 10 * CLOCK_PERIOD;

        wait;
    end process;

end architecture;