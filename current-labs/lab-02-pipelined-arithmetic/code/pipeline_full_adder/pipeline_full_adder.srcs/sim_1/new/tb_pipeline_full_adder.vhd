library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_pipeline_full_adder is
end entity;

architecture sim of tb_pipeline_full_adder is

    component pipeline_full_adder
        port (
            clk  : in  std_logic;
            A    : in  std_logic_vector(3 downto 0);
            B    : in  std_logic_vector(3 downto 0);
            Cin  : in  std_logic;
            Sum  : out std_logic_vector(3 downto 0);
            Cout : out std_logic
        );
    end component;

    signal clk  : std_logic := '0';
    signal A    : std_logic_vector(3 downto 0) := "0000";
    signal B    : std_logic_vector(3 downto 0) := "0000";
    signal Cin  : std_logic := '0';
    signal Sum  : std_logic_vector(3 downto 0);
    signal Cout : std_logic;

begin

    uut: pipeline_full_adder
        port map (
            clk  => clk,
            A    => A,
            B    => B,
            Cin  => Cin,
            Sum  => Sum,
            Cout => Cout
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

        for cin_val in 0 to 1 loop
            for a_val in 0 to 15 loop
                for b_val in 0 to 15 loop
                    A <= std_logic_vector(to_unsigned(a_val, 4));
                    B <= std_logic_vector(to_unsigned(b_val, 4));

                    if cin_val = 0 then
                        Cin <= '0';
                    else
                        Cin <= '1';
                    end if;

                    wait for 20 ns;
                end loop;
            end loop;
        end loop;

        A   <= "0000";
        B   <= "0000";
        Cin <= '0';

        wait for 100 ns;
        wait;
    end process;

end architecture;