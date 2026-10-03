library ieee;
use ieee.std_logic_1164.all;

entity pipeline_full_adder is
    port (
        clk  : in  std_logic;
        A    : in  std_logic_vector(3 downto 0);
        B    : in  std_logic_vector(3 downto 0);
        Cin  : in  std_logic;
        Sum  : out std_logic_vector(3 downto 0);
        Cout : out std_logic
    );
end entity;

architecture structural of pipeline_full_adder is

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

    signal s0, s1, s2, s3 : std_logic;
    signal c1, c2, c3, c4 : std_logic;

    signal a1_d1, a2_d1, a2_d2, a3_d1, a3_d2, a3_d3 : std_logic;
    signal b1_d1, b2_d1, b2_d2, b3_d1, b3_d2, b3_d3 : std_logic;

    signal s0_d1, s0_d2, s0_d3 : std_logic;
    signal s1_d1, s1_d2 : std_logic;
    signal s2_d1 : std_logic;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            a1_d1 <= A(1);
            b1_d1 <= B(1);

            a2_d1 <= A(2);
            a2_d2 <= a2_d1;

            b2_d1 <= B(2);
            b2_d2 <= b2_d1;

            a3_d1 <= A(3);
            a3_d2 <= a3_d1;
            a3_d3 <= a3_d2;

            b3_d1 <= B(3);
            b3_d2 <= b3_d1;
            b3_d3 <= b3_d2;

            s0_d1 <= s0;
            s0_d2 <= s0_d1;
            s0_d3 <= s0_d2;

            s1_d1 <= s1;
            s1_d2 <= s1_d1;

            s2_d1 <= s2;
        end if;
    end process;

    FA0: synchronous_adder
        port map (
            clk  => clk,
            A    => A(0),
            B    => B(0),
            Cin  => Cin,
            Sum  => s0,
            Cout => c1
        );

    FA1: synchronous_adder
        port map (
            clk  => clk,
            A    => a1_d1,
            B    => b1_d1,
            Cin  => c1,
            Sum  => s1,
            Cout => c2
        );

    FA2: synchronous_adder
        port map (
            clk  => clk,
            A    => a2_d2,
            B    => b2_d2,
            Cin  => c2,
            Sum  => s2,
            Cout => c3
        );

    FA3: synchronous_adder
        port map (
            clk  => clk,
            A    => a3_d3,
            B    => b3_d3,
            Cin  => c3,
            Sum  => s3,
            Cout => c4
        );

    Sum(0) <= s0_d3;
    Sum(1) <= s1_d2;
    Sum(2) <= s2_d1;
    Sum(3) <= s3;
    Cout   <= c4;

end architecture;
