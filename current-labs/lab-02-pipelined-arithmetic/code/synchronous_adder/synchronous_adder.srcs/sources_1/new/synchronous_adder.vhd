library ieee;
use ieee.std_logic_1164.all;

entity synchronous_adder is
    port (
        clk  : in  std_logic;
        A    : in  std_logic;
        B    : in  std_logic;
        Cin  : in  std_logic;
        Sum  : out std_logic;
        Cout : out std_logic
    );
end entity;

architecture behavioral of synchronous_adder is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            Sum  <= A xor B xor Cin;
            Cout <= (A and B) or (A and Cin) or (B and Cin);
        end if;
    end process;
end architecture;