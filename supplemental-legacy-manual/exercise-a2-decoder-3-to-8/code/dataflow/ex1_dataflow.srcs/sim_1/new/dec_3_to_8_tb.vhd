library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dec_3_to_8_tb is
end entity;

architecture tb of dec_3_to_8_tb is

    --------------------------------------------------------------------
    -- COMPONENT
    --------------------------------------------------------------------
    component dec_3_to_8 is
        port (
            enc : in  std_logic_vector(3-1 downto 0);
            dec : out std_logic_vector(8-1 downto 0)
        );
    end component;

    --------------------------------------------------------------------
    -- SIGNALS
    --------------------------------------------------------------------
    signal enc : std_logic_vector(3-1 downto 0) := (others => '0');
    signal dec : std_logic_vector(8-1 downto 0);

    --------------------------------------------------------------------
    -- CONSTANTS
    --------------------------------------------------------------------
    constant DELAY : time := 10 ns;

begin

    --------------------------------------------------------------------
    -- DUT
    --------------------------------------------------------------------
    DUT : dec_3_to_8
        port map (
            enc => enc,
            dec => dec
        );

    --------------------------------------------------------------------
    -- STIMULUS
    --------------------------------------------------------------------
    STIMULUS : process
    begin
        enc <= "000";
        wait for DELAY;

        enc <= "001";
        wait for DELAY;

        enc <= "010";
        wait for DELAY;

        enc <= "011";
        wait for DELAY;

        enc <= "100";
        wait for DELAY;

        enc <= "101";
        wait for DELAY;

        enc <= "110";
        wait for DELAY;

        enc <= "111";
        wait for DELAY;

        wait;
    end process;

end architecture;