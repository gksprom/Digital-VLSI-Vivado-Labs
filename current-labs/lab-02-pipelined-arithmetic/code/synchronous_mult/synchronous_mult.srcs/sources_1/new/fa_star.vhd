library ieee;
use ieee.std_logic_1164.all;

entity fa_star is
    port (
        clk   : in  std_logic;
        a_in  : in  std_logic;
        b_in  : in  std_logic;
        s_in  : in  std_logic;
        c_in  : in  std_logic;
        a_out : out std_logic;
        b_out : out std_logic;
        s_out : out std_logic;
        c_out : out std_logic
    );
end entity;

architecture structural of fa_star is
    signal pp   : std_logic;
    signal a_d1, a_d2 : std_logic;
    signal b_d1 : std_logic;
    signal s_r, c_r : std_logic;
begin
    pp <= a_in and b_in;

    U_FA : entity work.synchronous_adder
        port map (
            clk  => clk,
            A    => pp,
            B    => s_in,
            Cin  => c_in,
            Sum  => s_r,
            Cout => c_r
        );

    process(clk)
    begin
        if rising_edge(clk) then
            a_d1 <= a_in;
            a_d2 <= a_d1;
            b_d1 <= b_in;
        end if;
    end process;

    a_out <= a_d2;
    b_out <= b_d1;
    s_out <= s_r;
    c_out <= c_r;
end architecture;