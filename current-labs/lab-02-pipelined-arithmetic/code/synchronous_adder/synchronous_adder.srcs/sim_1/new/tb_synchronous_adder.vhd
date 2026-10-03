library ieee;
use ieee.std_logic_1164.all;

entity tb_synchronous_adder is
end entity;

architecture sim of tb_synchronous_adder is

    component synchronous_adder
        port (
            clk  : in  std_logic;
            A    : in  std_logic;
            B    : in  std_logic;
            Cin  : in  std_logic;
            Sum  : out std_logic;
            Cout : out std_logic
        );
    end component;

    signal clk  : std_logic := '0';
    signal A    : std_logic := '0';
    signal B    : std_logic := '0';
    signal Cin  : std_logic := '0';
    signal Sum  : std_logic;
    signal Cout : std_logic;

    begin 

        uut: synchronous_adder
            port map(
                clk =>clk,
                A=> A,
                B=> B,
                Cin=>Cin,
                Sum=>Sum,
                Cout=>Cout
            );
        clk_process: process
        begin
            while true loop
                clk <= '0';
                wait for 10 ns;
                clk <= '1';
                wait for 10 ns;
            end loop;
    end process;

        stim_proc: process
        begin
            A <= '0'; B <= '0'; Cin <= '0';
            wait for 20 ns;
            assert (Sum = '0' and Cout = '0') report "Error at 000" severity error;

            A <= '0'; B <= '0'; Cin <= '1';
            wait for 20 ns;
            assert (Sum = '1' and Cout = '0') report "Error at 001" severity error;

            A <= '0'; B <= '1'; Cin <= '0';
            wait for 20 ns;
            assert (Sum = '1' and Cout = '0') report "Error at 010" severity error;

            A <= '0'; B <= '1'; Cin <= '1';
            wait for 20 ns;
            assert (Sum = '0' and Cout = '1') report "Error at 011" severity error;

            A <= '1'; B <= '0'; Cin <= '0';
            wait for 20 ns;
            assert (Sum = '1' and Cout = '0') report "Error at 100" severity error;

            A <= '1'; B <= '0'; Cin <= '1';
            wait for 20 ns;
            assert (Sum = '0' and Cout = '1') report "Error at 101" severity error;

            A <= '1'; B <= '1'; Cin <= '0';
            wait for 20 ns;
            assert (Sum = '0' and Cout = '1') report "Error at 110" severity error;

            A <= '1'; B <= '1'; Cin <= '1';
            wait for 20 ns;
            assert (Sum = '1' and Cout = '1') report "Error at 111" severity error;

        wait;
    end process;

end architecture;