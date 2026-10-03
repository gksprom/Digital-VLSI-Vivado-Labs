library ieee;
use ieee.std_logic_1164.all;

entity synchronous_half_adder is
    port (
        clk  : in  std_logic;
        A    : in  std_logic;
        B    : in  std_logic;
        Sum  : out std_logic;
        Cout : out std_logic
    );
end entity;

architecture behavioral of synchronous_half_adder is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            Sum  <= A xor B;
            Cout <= A and B;
        end if;
    end process;
end architecture;