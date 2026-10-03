library ieee;
use ieee.std_logic_1164.all;

entity pipeline_adder_8bit is
    port (
        clk  : in  std_logic;
        A    : in  std_logic_vector(7 downto 0);
        B    : in  std_logic_vector(7 downto 0);
        Cin  : in  std_logic;
        Sum  : out std_logic_vector(7 downto 0);
        Cout : out std_logic
    );
end entity;

architecture structural of pipeline_adder_8bit is

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

    signal c_mid : std_logic;

begin

    LOW_ADDER : pipeline_full_adder
        port map (
            clk  => clk,
            A    => A(3 downto 0),
            B    => B(3 downto 0),
            Cin  => Cin,
            Sum  => Sum(3 downto 0),
            Cout => c_mid
        );

    HIGH_ADDER : pipeline_full_adder
        port map (
            clk  => clk,
            A    => A(7 downto 4),
            B    => B(7 downto 4),
            Cin  => c_mid,
            Sum  => Sum(7 downto 4),
            Cout => Cout
        );

end architecture;