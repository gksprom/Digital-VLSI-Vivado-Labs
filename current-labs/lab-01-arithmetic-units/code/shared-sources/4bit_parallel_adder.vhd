-------------------------------------------------------------------
-- 4-BIT PARALLEL ADDER (STRUCTURAL)
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity parallel_adder_4bit_structural is
    port (
        i_a     : in    std_logic_vector(4-1 downto 0);
        i_b     : in    std_logic_vector(4-1 downto 0);
        i_cin   : in    std_logic;
        o_s     : out   std_logic_vector(4-1 downto 0);
        o_cout  : out   std_logic
    );
end entity;

architecture structural_arch of parallel_adder_4bit_structural is

    component full_adder_structural is
        port (
            i_a     : in    std_logic;
            i_b     : in    std_logic;
            i_cin   : in    std_logic;
            o_s     : out   std_logic;
            o_cout  : out   std_logic
        );
    end component;

    signal w_c1    : std_logic;
    signal w_c2    : std_logic;
    signal w_c3    : std_logic;

begin

    FA_0 : full_adder_structural
        port map (
            i_a     => i_a(0),
            i_b     => i_b(0),
            i_cin   => i_cin,
            o_s     => o_s(0),
            o_cout  => w_c1
        );

    FA_1 : full_adder_structural
        port map (
            i_a     => i_a(1),
            i_b     => i_b(1),
            i_cin   => w_c1,
            o_s     => o_s(1),
            o_cout  => w_c2
        );

    FA_2 : full_adder_structural
        port map (
            i_a     => i_a(2),
            i_b     => i_b(2),
            i_cin   => w_c2,
            o_s     => o_s(2),
            o_cout  => w_c3
        );

    FA_3 : full_adder_structural
        port map (
            i_a     => i_a(3),
            i_b     => i_b(3),
            i_cin   => w_c3,
            o_s     => o_s(3),
            o_cout  => o_cout
        );

end structural_arch;