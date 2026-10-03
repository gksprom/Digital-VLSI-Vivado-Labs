library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir_top_tb is
end fir_top_tb;

architecture Behavioral of fir_top_tb is

    constant CLK_PERIOD : time := 10 ns;

    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';
    signal valid_in  : std_logic := '0';
    signal x         : std_logic_vector(7 downto 0) := (others => '0');
    signal y         : std_logic_vector(18 downto 0);
    signal valid_out : std_logic;

    type int_array is array (natural range <>) of integer;

    constant samples : int_array := (
        208, 231, 32, 233, 161, 24, 71, 140,
        245, 247, 40, 248, 245, 124, 204, 36,
        107, 234, 202, 245, 0, 0, 0, 0, 0, 0,0 ,0
    );

    constant expected : int_array := (
        208, 647, 1118, 1822, 2687, 3576, 4536, 5636,
        5109, 4414, 5319, 4631, 4603, 5771, 6696, 6965,
        6256, 5518, 6598, 6011
    );

begin

    uut : entity work.fir_top
        port map(
            clk       => clk,
            rst       => rst,
            valid_in  => valid_in,
            x         => x,
            y         => y,
            valid_out => valid_out
        );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    stim_process : process
    begin
        rst <= '1';
        valid_in <= '0';
        x <= (others => '0');

        wait for 150 ns;

        wait until falling_edge(clk);
        rst <= '0';

        wait until rising_edge(clk);
        wait until rising_edge(clk);

        for i in samples'range loop
            wait until falling_edge(clk);
            valid_in <= '1';
            x <= std_logic_vector(to_unsigned(samples(i), 8));

            wait until rising_edge(clk);

            wait until falling_edge(clk);
            valid_in <= '0';
            x <= (others => '0');

            for k in 1 to 7 loop
                wait until rising_edge(clk);
            end loop;
        end loop;

        wait for 100 ns;
        assert false report "End of simulation" severity note;
        wait;
    end process;

    check_process : process
        variable idx   : integer := 0;
        variable y_int : integer;
    begin
        wait until falling_edge(clk);

        if valid_out = '1' then
            y_int := to_integer(unsigned(y));

           -- assert y_int = expected(idx)
               -- report "Wrong output at index " & integer'image(idx) &
                 --      ". Expected = " & integer'image(expected(idx)) &
                   --    ", Got = " & integer'image(y_int)
                --severity error;

            idx := idx + 1;
        end if;
    end process;

end Behavioral;